import 'dart:async';
import 'dart:convert';
import 'dart:developer' as dev;

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

import '../../../core/config/env.dart';
import '../../../core/constants/api_endpoints.dart';
import '../../../core/constants/app_constants.dart';
import '../../../shared/models/ai_session.dart';

/// Sealed event types emitted by the SSE stream from `/api/ai/chat/stream`.
sealed class AiEvent {
  const AiEvent();
}

/// A streamed text chunk from the assistant.
class DeltaEvent extends AiEvent {
  final String content;
  const DeltaEvent(this.content);
}

/// A grammar/vocabulary correction surfaced inline in the response.
class CorrectionEvent extends AiEvent {
  final String original;
  final String corrected;
  final String explanation;

  const CorrectionEvent({
    required this.original,
    required this.corrected,
    required this.explanation,
  });

  Correction toCorrection() => Correction(
        original: original,
        corrected: corrected,
        explanation: explanation,
      );
}

/// Final event signalling end-of-response with token bookkeeping.
class DoneEvent extends AiEvent {
  final int totalTokens;
  final String? finishReason;
  const DoneEvent({required this.totalTokens, this.finishReason});
}

/// Server-side error during streaming. The client should treat as fatal for
/// the current message but the session can continue if the user retries.
class ErrorEvent extends AiEvent {
  final String code;
  final String message;
  const ErrorEvent({required this.code, required this.message});
}

/// Daily quota has been exhausted — the session must end.
class QuotaExhaustedEvent extends AiEvent {
  final DateTime? resetsAt;
  const QuotaExhaustedEvent({this.resetsAt});
}

/// HTTP/SSE-based AI chat service for the free tier.
///
/// Uses `package:http`'s streaming send API instead of a dedicated EventSource
/// package because Dart's EventSource implementations don't support custom
/// headers (we need `Authorization: Bearer <jwt>`).
///
/// Owns a 30s heartbeat timer that posts to `/api/ai/usage/heartbeat` once
/// the first message is sent and stops on session end / dispose / error.
class HttpAiService {
  HttpAiService({
    required FlutterSecureStorage secureStorage,
    String? baseUrl,
    http.Client? client,
  })  : _secureStorage = secureStorage,
        _baseUrl = baseUrl ?? Env.apiBaseUrl,
        _client = client ?? http.Client();

  final FlutterSecureStorage _secureStorage;
  final String _baseUrl;
  final http.Client _client;

  http.Client? _activeClient;
  StreamSubscription<String>? _streamSub;

  Timer? _heartbeatTimer;
  String? _heartbeatSessionId;
  int _heartbeatTickIndex = 0;

  bool _disposed = false;

  /// Send a chat message and stream typed [AiEvent]s back.
  ///
  /// [history] should already be capped to the last 20 messages by the caller.
  /// The first call to [sendMessage] also starts the 30s heartbeat timer for
  /// the supplied [sessionId]; subsequent calls reuse the running timer.
  Stream<AiEvent> sendMessage({
    required String sessionId,
    required String message,
    required List<AiMessage> history,
  }) {
    final controller = StreamController<AiEvent>();

    () async {
      // Cancel any in-flight request before starting a new one.
      await _cancelInFlight();

      _ensureHeartbeat(sessionId);

      final token =
          await _secureStorage.read(key: AppConstants.accessTokenKey);
      if (token == null) {
        controller.add(const ErrorEvent(
          code: 'unauthenticated',
          message: 'No access token found',
        ));
        await controller.close();
        return;
      }

      final uri = Uri.parse('$_baseUrl${ApiEndpoints.aiChatStream}');
      final request = http.Request('POST', uri)
        ..headers['Authorization'] = 'Bearer $token'
        ..headers['Content-Type'] = 'application/json'
        ..headers['Accept'] = 'text/event-stream'
        ..body = jsonEncode({
          'sessionId': sessionId,
          'message': message,
          'history': history
              .map((m) => {'role': m.role, 'content': m.content})
              .toList(),
        });

      // Use a per-request client so dispose() can abort just this request.
      final perRequestClient = http.Client();
      _activeClient = perRequestClient;

      try {
        final response = await perRequestClient.send(request);

        if (response.statusCode == 429) {
          controller.add(const QuotaExhaustedEvent());
          await controller.close();
          return;
        }
        if (response.statusCode >= 400) {
          controller.add(ErrorEvent(
            code: 'http_${response.statusCode}',
            message: 'Server returned ${response.statusCode}',
          ));
          await controller.close();
          return;
        }

        final lines = response.stream
            .transform(utf8.decoder)
            .transform(const LineSplitter());

        String? eventName;
        final dataBuffer = StringBuffer();
        // Defensive: server should split correction markers but if a delta
        // arrives mid-marker we accumulate until the closing `]` or until a
        // safe boundary, then forward.
        final markerBuffer = StringBuffer();

        _streamSub = lines.listen(
          (line) {
            if (line.isEmpty) {
              // End of an event — dispatch.
              final name = eventName;
              if (name != null && dataBuffer.isNotEmpty) {
                _dispatchEvent(
                  controller,
                  name,
                  dataBuffer.toString(),
                  markerBuffer,
                );
              }
              eventName = null;
              dataBuffer.clear();
              return;
            }
            if (line.startsWith(':')) {
              // SSE comment / keep-alive — ignore.
              return;
            }
            if (line.startsWith('event:')) {
              eventName = line.substring(6).trim();
            } else if (line.startsWith('data:')) {
              if (dataBuffer.isNotEmpty) dataBuffer.write('\n');
              dataBuffer.write(line.substring(5).trimLeft());
            }
          },
          onDone: () {
            // Flush any trailing buffered marker as a delta — better to surface
            // it than to drop characters.
            if (markerBuffer.isNotEmpty) {
              controller.add(DeltaEvent(markerBuffer.toString()));
              markerBuffer.clear();
            }
            if (!controller.isClosed) controller.close();
          },
          onError: (Object e, StackTrace st) {
            controller.add(ErrorEvent(
              code: 'stream_error',
              message: e.toString(),
            ));
            if (!controller.isClosed) controller.close();
          },
          cancelOnError: true,
        );
      } catch (e) {
        controller.add(ErrorEvent(
          code: 'request_failed',
          message: e.toString(),
        ));
        if (!controller.isClosed) await controller.close();
      } finally {
        // Caller handles dispose; clear active client when stream finishes
        // naturally so dispose() doesn't try to close an already-closed one.
        if (_activeClient == perRequestClient) {
          // intentionally don't close it here — the response.stream may still
          // be draining via the subscription, and closing prematurely cancels.
        }
      }
    }();

    return controller.stream;
  }

  void _dispatchEvent(
    StreamController<AiEvent> controller,
    String name,
    String data,
    StringBuffer markerBuffer,
  ) {
    try {
      final decoded = jsonDecode(data);
      switch (name) {
        case 'delta':
          if (decoded is Map<String, dynamic>) {
            final content = (decoded['content'] as String?) ?? '';
            _emitDelta(controller, content, markerBuffer);
          }
          break;
        case 'correction':
          if (decoded is Map<String, dynamic>) {
            // Flush any pending marker buffer before emitting the correction —
            // the server has already separated it but be defensive.
            if (markerBuffer.isNotEmpty) {
              controller.add(DeltaEvent(markerBuffer.toString()));
              markerBuffer.clear();
            }
            controller.add(CorrectionEvent(
              original: (decoded['original'] as String?) ?? '',
              corrected: (decoded['corrected'] as String?) ?? '',
              explanation: (decoded['explanation'] as String?) ?? '',
            ));
          }
          break;
        case 'done':
          if (markerBuffer.isNotEmpty) {
            controller.add(DeltaEvent(markerBuffer.toString()));
            markerBuffer.clear();
          }
          if (decoded is Map<String, dynamic>) {
            controller.add(DoneEvent(
              totalTokens: (decoded['totalTokens'] as num?)?.toInt() ?? 0,
              finishReason: decoded['finishReason'] as String?,
            ));
          } else {
            controller.add(const DoneEvent(totalTokens: 0));
          }
          break;
        case 'error':
          if (decoded is Map<String, dynamic>) {
            controller.add(ErrorEvent(
              code: (decoded['code'] as String?) ?? 'unknown',
              message: (decoded['message'] as String?) ?? 'Unknown error',
            ));
          }
          break;
        case 'quota_exhausted':
          DateTime? resetsAt;
          if (decoded is Map<String, dynamic> && decoded['resetsAt'] != null) {
            resetsAt = DateTime.tryParse(decoded['resetsAt'] as String);
          }
          controller.add(QuotaExhaustedEvent(resetsAt: resetsAt));
          break;
      }
    } catch (e) {
      dev.log('HttpAiService: failed to parse event $name: $e');
    }
  }

  /// Defensive marker buffering: if a delta starts with `[CORRECTION:`, hold
  /// it until we see `]` so we never emit a partial marker as visible text.
  void _emitDelta(
    StreamController<AiEvent> controller,
    String content,
    StringBuffer markerBuffer,
  ) {
    if (markerBuffer.isNotEmpty) {
      markerBuffer.write(content);
      final buffered = markerBuffer.toString();
      if (buffered.contains(']')) {
        // Marker completed — emit as a single delta. The notifier's existing
        // CorrectionParser will strip it if it was a real marker.
        controller.add(DeltaEvent(buffered));
        markerBuffer.clear();
      }
      return;
    }
    if (content.startsWith('[CORRECTION:') && !content.contains(']')) {
      markerBuffer.write(content);
      return;
    }
    controller.add(DeltaEvent(content));
  }

  void _ensureHeartbeat(String sessionId) {
    if (_heartbeatTimer != null && _heartbeatSessionId == sessionId) return;

    _heartbeatTimer?.cancel();
    _heartbeatSessionId = sessionId;
    _heartbeatTickIndex = 0;

    _heartbeatTimer = Timer.periodic(const Duration(seconds: 30), (_) {
      _sendHeartbeat();
    });
  }

  Future<void> _sendHeartbeat() async {
    if (_disposed || _heartbeatSessionId == null) return;

    final tickIndex = ++_heartbeatTickIndex;
    final sessionId = _heartbeatSessionId!;

    try {
      final token =
          await _secureStorage.read(key: AppConstants.accessTokenKey);
      if (token == null) return;

      final uri = Uri.parse('$_baseUrl${ApiEndpoints.aiUsageHeartbeat}');
      final response = await _client
          .post(
            uri,
            headers: {
              'Authorization': 'Bearer $token',
              'Content-Type': 'application/json',
              'Accept': 'application/json',
            },
            body: jsonEncode({
              'sessionId': sessionId,
              'elapsedSeconds': 30,
              'tickIndex': tickIndex,
            }),
          )
          .timeout(const Duration(seconds: 10));

      if (response.statusCode >= 400) {
        dev.log(
          'HttpAiService: heartbeat returned ${response.statusCode} (non-fatal)',
        );
      }
    } catch (e) {
      // Network blips on a heartbeat must never crash the session.
      dev.log('HttpAiService: heartbeat failed (non-fatal): $e');
    }
  }

  Future<void> _cancelInFlight() async {
    try {
      await _streamSub?.cancel();
    } catch (_) {}
    _streamSub = null;

    final c = _activeClient;
    _activeClient = null;
    if (c != null) {
      try {
        c.close();
      } catch (_) {}
    }
  }

  /// Stop the heartbeat. Call when the session ends but the service may be
  /// reused for another session afterward.
  void stopHeartbeat() {
    _heartbeatTimer?.cancel();
    _heartbeatTimer = null;
    _heartbeatSessionId = null;
    _heartbeatTickIndex = 0;
  }

  /// Aborts any in-flight request, stops the heartbeat, and releases the
  /// shared HTTP client.
  Future<void> dispose() async {
    if (_disposed) return;
    _disposed = true;
    stopHeartbeat();
    await _cancelInFlight();
    try {
      _client.close();
    } catch (_) {}
  }
}
