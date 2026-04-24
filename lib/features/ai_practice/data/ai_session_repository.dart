import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/api_endpoints.dart';
import '../../../shared/models/ai_session.dart';
import '../../../shared/providers/core_providers.dart';

/// AI session repository provider
final aiSessionRepositoryProvider = Provider<AiSessionRepository>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return AiSessionRepository(dio: apiClient.dio);
});

/// Paginated AI session history response
class PaginatedAiSessionHistory {
  final List<AiSession> sessions;
  final int page;
  final int limit;
  final int total;
  final int totalPages;

  const PaginatedAiSessionHistory({
    required this.sessions,
    required this.page,
    required this.limit,
    required this.total,
    required this.totalPages,
  });

  bool get hasMore => page < totalPages;

  factory PaginatedAiSessionHistory.fromApiResponse(Map<String, dynamic> response) {
    final pagination = response['pagination'] as Map<String, dynamic>;
    return PaginatedAiSessionHistory(
      sessions: (response['data'] as List<dynamic>)
          .map((e) => AiSession.fromJson(e as Map<String, dynamic>))
          .toList(),
      page: pagination['page'] as int,
      limit: pagination['limit'] as int,
      total: pagination['total'] as int,
      totalPages: pagination['pages'] as int,
    );
  }
}

/// Request for starting an AI session
class StartSessionRequest {
  final AiSessionMode mode;
  final String? topic;
  final String? scenario;

  const StartSessionRequest({
    required this.mode,
    this.topic,
    this.scenario,
  });

  Map<String, dynamic> toJson() => {
        'mode': mode.apiValue,
        if (topic != null) 'topic': topic,
        if (scenario != null) 'scenario': scenario,
      };
}

/// Request for POST /api/ai/session/start (called after WebSocket connects)
class SessionStartRequest {
  final String sessionId;
  final AiSessionMode mode;
  final String? topic;
  final String? scenario;

  const SessionStartRequest({
    required this.sessionId,
    required this.mode,
    this.topic,
    this.scenario,
  });

  Map<String, dynamic> toJson() => {
        'sessionId': sessionId,
        'mode': mode.apiValue,
        if (topic != null) 'topic': topic,
        if (scenario != null) 'scenario': scenario,
      };
}

/// Request for ending an AI session
class EndSessionRequest {
  final String sessionId;
  final List<AiMessage> messages;
  final List<Correction> corrections;
  final SessionStats stats;
  final int durationSeconds;

  const EndSessionRequest({
    required this.sessionId,
    required this.messages,
    required this.corrections,
    required this.stats,
    required this.durationSeconds,
  });

  Map<String, dynamic> toJson() => {
        'sessionId': sessionId,
        'messages': messages.map((m) => m.toJson()).toList(),
        'corrections': corrections.map((c) => c.toJson()).toList(),
        'stats': stats.toJson(),
        'durationSeconds': durationSeconds,
      };
}

/// Repository for AI session operations
class AiSessionRepository {
  final Dio _dio;

  AiSessionRepository({required Dio dio}) : _dio = dio;

  /// POST /api/ai/session/start — called after WebSocket connects.
  /// Returns normally on success; throws on failure (caller ignores errors).
  Future<void> startSession(SessionStartRequest request) async {
    try {
      await _dio.post(
        ApiEndpoints.aiSessionStart,
        data: request.toJson(),
      );
    } on DioException catch (e) {
      throw e.error ?? e;
    }
  }

  /// GET /api/ai/sessions — paginated history with optional mode filter.
  Future<PaginatedAiSessionHistory> getSessions({
    int page = 1,
    int limit = 20,
    AiSessionMode? mode,
  }) async {
    try {
      final response = await _dio.get(
        ApiEndpoints.aiSessions,
        queryParameters: {
          'page': page,
          'limit': limit,
          if (mode != null) 'mode': mode.apiValue,
        },
      );
      return PaginatedAiSessionHistory.fromApiResponse(response.data);
    } on DioException catch (e) {
      throw e.error ?? e;
    }
  }

  /// GET /api/ai/sessions/:id — single session detail.
  Future<AiSession> getSessionById(String id) async {
    try {
      final response = await _dio.get(ApiEndpoints.aiSessionDetails(id));
      return AiSession.fromJson(response.data['data'] as Map<String, dynamic>);
    } on DioException catch (e) {
      throw e.error ?? e;
    }
  }

  /// Request ephemeral key to start a new AI session
  Future<EphemeralKeyResponse> getSessionToken({
    required AiSessionMode mode,
    String? topic,
    String? scenario,
  }) async {
    try {
      final response = await _dio.post(
        ApiEndpoints.aiSessionToken,
        data: StartSessionRequest(
          mode: mode,
          topic: topic,
          scenario: scenario,
        ).toJson(),
      );

      return _parseEphemeralKeyResponse(response.data);
    } on DioException catch (e) {
      throw e.error ?? e;
    }
  }

  /// Refresh ephemeral key for long sessions
  Future<EphemeralKeyResponse> refreshSessionToken(String sessionId) async {
    try {
      final response = await _dio.post(
        ApiEndpoints.aiSessionRefreshToken,
        data: {'sessionId': sessionId},
      );

      return _parseEphemeralKeyResponse(
        response.data,
        fallbackSessionId: sessionId,
      );
    } on DioException catch (e) {
      throw e.error ?? e;
    }
  }

  /// Parse and validate an [EphemeralKeyResponse] from a raw API response map.
  /// Throws a [FormatException] with a clear message instead of a cryptic
  /// `type 'Null' is not a subtype of type 'String'` cast error when required
  /// string fields are absent in the server response.
  ///
  /// [fallbackSessionId] supplies a session id when the server omits it —
  /// the refresh-token endpoint does not echo `sessionId` back because the
  /// client already provided it in the request.
  EphemeralKeyResponse _parseEphemeralKeyResponse(
    dynamic responseBody, {
    String? fallbackSessionId,
  }) {
    final data = responseBody is Map ? responseBody['data'] : null;
    if (data == null || data is! Map<String, dynamic>) {
      throw FormatException(
        'Session token response is missing the "data" field or has unexpected shape',
      );
    }
    final key = data['ephemeralKey'];
    if (key == null || key is! String) {
      throw FormatException(
        'Session token response missing or non-string "ephemeralKey"',
      );
    }
    final sid = data['sessionId'];
    final normalized = Map<String, dynamic>.from(data);
    if (sid is! String) {
      if (fallbackSessionId == null) {
        throw FormatException(
          'Session token response missing or non-string "sessionId"',
        );
      }
      normalized['sessionId'] = fallbackSessionId;
    }
    return EphemeralKeyResponse.fromJson(normalized);
  }

  /// End AI session and save conversation data
  Future<void> endSession(EndSessionRequest request) async {
    try {
      await _dio.post(
        ApiEndpoints.aiSessionEnd,
        data: request.toJson(),
      );
    } on DioException catch (e) {
      throw e.error ?? e;
    }
  }

  /// Get AI usage stats (remaining time, etc.)
  Future<AiUsageInfo> getUsageInfo() async {
    try {
      final response = await _dio.get(ApiEndpoints.aiUsage);
      return AiUsageInfo.fromJson(response.data['data']);
    } on DioException catch (e) {
      throw e.error ?? e;
    }
  }

  /// Fetch paginated AI session history
  Future<PaginatedAiSessionHistory> getSessionHistory({
    int page = 1,
    int limit = 20,
  }) async {
    try {
      final response = await _dio.get(
        ApiEndpoints.aiSessions,
        queryParameters: {
          'page': page,
          'limit': limit,
        },
      );

      return PaginatedAiSessionHistory.fromApiResponse(response.data);
    } on DioException catch (e) {
      throw e.error ?? e;
    }
  }

  /// Fetch single session details
  Future<AiSession> getSessionDetails(String sessionId) async {
    try {
      final response = await _dio.get(ApiEndpoints.aiSessionDetails(sessionId));
      return AiSession.fromJson(response.data['data']);
    } on DioException catch (e) {
      throw e.error ?? e;
    }
  }

  /// Get available topics for topic-based discussions
  Future<List<TopicCategory>> getTopics() async {
    try {
      final response = await _dio.get(ApiEndpoints.aiTopics);
      return (response.data['data'] as List<dynamic>)
          .map((e) => TopicCategory.fromJson(e as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw e.error ?? e;
    }
  }

  /// Get available scenarios for roleplay
  Future<List<Scenario>> getScenarios() async {
    try {
      final response = await _dio.get(ApiEndpoints.aiScenarios);
      return (response.data['data'] as List<dynamic>)
          .map((e) => Scenario.fromJson(e as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw e.error ?? e;
    }
  }
}
