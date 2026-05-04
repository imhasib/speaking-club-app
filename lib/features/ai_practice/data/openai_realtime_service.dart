import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import '../../../shared/models/ai_session.dart';
import 'correction_parser.dart';

/// Factory that creates a [WebSocketChannel] for a given URI and protocols.
/// Injected so tests can supply a fake channel without hitting the network.
typedef WebSocketChannelFactory = WebSocketChannel Function(
  Uri uri,
  List<String> protocols,
);

/// OpenAI Realtime API event types
class OpenAIEventTypes {
  static const String sessionUpdate = 'session.update';
  static const String sessionCreated = 'session.created';
  static const String sessionUpdated = 'session.updated';
  static const String conversationItemCreate = 'conversation.item.create';
  static const String conversationItemCreated = 'conversation.item.created';
  static const String responseCreate = 'response.create';
  static const String responseCreated = 'response.created';
  static const String responseTextDelta = 'response.text.delta';
  static const String responseTextDone = 'response.text.done';
  static const String responseDone = 'response.done';
  static const String error = 'error';
}

/// OpenAI Realtime API connection state
enum OpenAIConnectionState {
  disconnected,
  connecting,
  connected,
  error,
}

/// Callback types for OpenAI events
typedef OnTextDelta = void Function(String delta);
typedef OnTextComplete = void Function(String fullText);
typedef OnCorrectionFound = void Function(Correction correction);
typedef OnError = void Function(String error);
typedef OnConnectionStateChange = void Function(OpenAIConnectionState state);

/// Service for connecting to OpenAI Realtime API
class OpenAIRealtimeService {
  static const String _baseUrl = 'wss://api.openai.com/v1/realtime';
  static const String _model = 'gpt-4o-mini-realtime-preview';

  final WebSocketChannelFactory _channelFactory;

  OpenAIRealtimeService({WebSocketChannelFactory? channelFactory})
      : _channelFactory = channelFactory ??
            ((uri, protocols) =>
                WebSocketChannel.connect(uri, protocols: protocols));

  WebSocketChannel? _channel;
  StreamSubscription? _subscription;
  OpenAIConnectionState _connectionState = OpenAIConnectionState.disconnected;

  // Callbacks
  OnTextDelta? onTextDelta;
  OnTextComplete? onTextComplete;
  OnCorrectionFound? onCorrectionFound;
  OnError? onError;
  OnConnectionStateChange? onConnectionStateChange;

  // Response accumulator
  final StringBuffer _currentResponse = StringBuffer();
  bool _responseTextHandled = false;

  // Whether the current response buffer may contain a correction marker that
  // has not yet been fully received.  While true, delta events are buffered
  // instead of being forwarded directly to [onTextDelta].
  bool _pendingMarkerCheck = true;

  /// Current connection state
  OpenAIConnectionState get connectionState => _connectionState;

  /// Whether currently connected
  bool get isConnected => _connectionState == OpenAIConnectionState.connected;

  /// Connect to OpenAI Realtime API with ephemeral key
  Future<void> connect({
    required String ephemeralKey,
    required AiSessionMode mode,
    AiPersona persona = AiPersona.emma,
    String? topic,
    String? scenario,
  }) async {
    if (_connectionState == OpenAIConnectionState.connecting ||
        _connectionState == OpenAIConnectionState.connected) {
      debugPrint('OpenAI: Already connected or connecting');
      return;
    }

    _setConnectionState(OpenAIConnectionState.connecting);

    try {
      final uri = Uri.parse('$_baseUrl?model=$_model');

      _channel = _channelFactory(uri, [
        'realtime',
        'openai-insecure-api-key.$ephemeralKey',
        'openai-beta.realtime-v1',
      ]);

      // Wait for connection
      await _channel!.ready;

      _subscription = _channel!.stream.listen(
        _handleMessage,
        onError: _handleError,
        onDone: _handleDone,
      );

      // Configure session BEFORE signalling connected so the greeting
      // response.create is always sent after session.update.
      await _configureSession(
        mode: mode,
        persona: persona,
        topic: topic,
        scenario: scenario,
      );

      _setConnectionState(OpenAIConnectionState.connected);
    } catch (e) {
      debugPrint('OpenAI: Connection error: $e');
      _setConnectionState(OpenAIConnectionState.error);
      onError?.call('Failed to connect: $e');
    }
  }

  /// Disconnect from OpenAI Realtime API
  Future<void> disconnect() async {
    _subscription?.cancel();
    _subscription = null;
    await _channel?.sink.close();
    _channel = null;
    _setConnectionState(OpenAIConnectionState.disconnected);
    debugPrint('OpenAI: Disconnected');
  }

  /// Send user message to OpenAI
  void sendMessage(String text) {
    if (!isConnected) {
      debugPrint('OpenAI: Cannot send message - not connected');
      return;
    }

    // Clear previous response
    _currentResponse.clear();

    // Create conversation item
    _sendEvent({
      'type': OpenAIEventTypes.conversationItemCreate,
      'item': {
        'type': 'message',
        'role': 'user',
        'content': [
          {'type': 'input_text', 'text': text}
        ],
      },
    });

    // Trigger response generation
    _sendEvent({
      'type': OpenAIEventTypes.responseCreate,
    });
  }

  /// Trigger AI to send initial greeting (no user message needed)
  void triggerInitialGreeting() {
    if (!isConnected) {
      debugPrint('OpenAI: Cannot trigger greeting - not connected');
      return;
    }

    debugPrint('OpenAI: Triggering initial greeting');
    _currentResponse.clear();
    _responseTextHandled = false;

    // Just trigger response - the system prompt instructs AI to greet first
    _sendEvent({
      'type': OpenAIEventTypes.responseCreate,
    });
  }

  /// Configure session with system prompt based on mode
  Future<void> _configureSession({
    required AiSessionMode mode,
    required AiPersona persona,
    String? topic,
    String? scenario,
  }) async {
    final systemPrompt = _buildSystemPrompt(
      mode: mode,
      persona: persona,
      topic: topic,
      scenario: scenario,
    );

    _sendEvent({
      'type': OpenAIEventTypes.sessionUpdate,
      'session': {
        'modalities': ['text'],
        'instructions': systemPrompt,
        'temperature': 0.7,
        'max_response_output_tokens': 150,
      },
    });
  }

  /// Build system prompt based on mode and persona
  String _buildSystemPrompt({
    required AiSessionMode mode,
    required AiPersona persona,
    String? topic,
    String? scenario,
  }) {
    final personaName = persona.displayName;

    switch (mode) {
      case AiSessionMode.freeChat:
        return '''
You are $personaName, a friendly and patient English tutor. You're having a voice conversation with someone practicing their English.

Guidelines:
- Keep responses concise (1-3 sentences) for natural conversation flow
- Ask follow-up questions to encourage the user to speak more
- If you notice a grammar mistake, gently correct it in a supportive way
- Adapt your vocabulary complexity to match the user's level
- Be encouraging and positive
- Stay on topic but allow natural conversation tangents
- Remember context from earlier in the conversation

Start by greeting the user warmly and asking how they're doing today.
''';

      case AiSessionMode.topic:
        return '''
You are $personaName, a friendly English tutor. You're having a conversation about "$topic" with your student.

Guidelines:
- Keep responses concise (1-3 sentences) for natural conversation flow
- Ask questions related to the topic to encourage discussion
- If you notice a grammar mistake, gently correct it naturally in your response
- Adapt your vocabulary complexity to match the user's level
- Be encouraging and positive
- Guide the conversation but let the user express their thoughts

Start by introducing the topic and asking an opening question about it.
''';

      case AiSessionMode.scenario:
        return '''
You are playing the role of $scenario in a roleplay scenario.

Guidelines:
- Stay in character throughout the conversation
- Keep responses concise and natural for the scenario
- If you notice English mistakes, gently correct them in character
- Make the scenario feel realistic
- At natural breakpoints, you may offer helpful phrases the user could use

Start by setting the scene and initiating the roleplay scenario.
''';
    }
  }

  /// Send event to OpenAI
  void _sendEvent(Map<String, dynamic> event) {
    if (_channel == null) return;

    final json = jsonEncode(event);
    debugPrint('OpenAI TX: ${event['type']}');
    _channel!.sink.add(json);
  }

  /// Handle incoming message from OpenAI
  void _handleMessage(dynamic message) {
    try {
      final data = jsonDecode(message as String) as Map<String, dynamic>;
      final type = data['type'] as String?;

      debugPrint('OpenAI RX: $type');

      switch (type) {
        case OpenAIEventTypes.sessionCreated:
        case OpenAIEventTypes.sessionUpdated:
          debugPrint('OpenAI: Session configured');
          break;

        case OpenAIEventTypes.conversationItemCreated:
          debugPrint('OpenAI: Conversation item created');
          break;

        case OpenAIEventTypes.responseCreated:
          debugPrint('OpenAI: Response generation started');
          _responseTextHandled = false;
          _pendingMarkerCheck = true;
          break;

        case OpenAIEventTypes.responseTextDelta:
          final delta = data['delta'] as String? ?? '';
          _currentResponse.write(delta);
          _handleDelta(delta);
          break;

        case OpenAIEventTypes.responseTextDone:
          final fullText = _currentResponse.toString();
          _handleTextComplete(fullText);
          _currentResponse.clear();
          _responseTextHandled = true;
          break;

        case OpenAIEventTypes.responseDone:
          debugPrint('OpenAI: Response complete');
          final responseData = data['response'] as Map<String, dynamic>?;
          final status = responseData?['status'] as String?;

          // Check if response failed
          if (status == 'failed') {
            final statusDetails = responseData?['status_details'] as Map<String, dynamic>?;
            final errorData = statusDetails?['error'] as Map<String, dynamic>?;
            final errorMessage = errorData?['message'] as String? ?? 'Response generation failed';
            debugPrint('OpenAI: Response failed: $errorMessage');
            onError?.call(errorMessage);
            break;
          }

          // If we didn't receive streaming text events, extract text from response.done
          if (!_responseTextHandled && _currentResponse.isEmpty) {
            final output = responseData?['output'] as List<dynamic>?;
            if (output != null && output.isNotEmpty) {
              for (final item in output) {
                if (item is Map<String, dynamic> && item['type'] == 'message') {
                  final content = item['content'] as List<dynamic>?;
                  if (content != null) {
                    for (final part in content) {
                      if (part is Map<String, dynamic> && part['type'] == 'text') {
                        final text = part['text'] as String?;
                        if (text != null && text.isNotEmpty) {
                          debugPrint('OpenAI: Extracted text from response.done: $text');
                          _handleTextComplete(text);
                        }
                      }
                    }
                  }
                }
              }
            }
          }
          break;

        case OpenAIEventTypes.error:
          final errorData = data['error'] as Map<String, dynamic>?;
          final errorMessage = errorData?['message'] as String? ?? 'Unknown error';
          debugPrint('OpenAI Error: $errorMessage');
          onError?.call(errorMessage);
          break;

        default:
          debugPrint('OpenAI: Unhandled event type: $type');
      }
    } catch (e) {
      debugPrint('OpenAI: Error parsing message: $e');
    }
  }

  /// Handle a streaming delta event.
  ///
  /// If the buffer starts with `[CORRECTION:` and the marker is not yet fully
  /// closed, we hold off forwarding deltas to [onTextDelta] so TTS does not
  /// speak the marker text.  Once the marker is closed (or if no marker is
  /// present) we forward immediately.
  void _handleDelta(String delta) {
    final buffer = _currentResponse.toString();

    if (_pendingMarkerCheck) {
      if (CorrectionParser.bufferMayHaveMarker(buffer)) {
        if (CorrectionParser.markerIsClosed(buffer)) {
          // Marker is now fully buffered — don't forward any delta; the full
          // cleaned text will be forwarded via [_handleTextComplete].
          _pendingMarkerCheck = false;
        }
        // Still accumulating the marker — do not forward delta.
        return;
      } else {
        // Buffer does not start with a marker — safe to stream immediately.
        _pendingMarkerCheck = false;
        onTextDelta?.call(delta);
      }
    } else {
      onTextDelta?.call(delta);
    }
  }

  /// Handle the fully-accumulated response text.
  ///
  /// Runs the text through [CorrectionParser], emits any found [Correction]
  /// via [onCorrectionFound], and calls [onTextComplete] with the cleaned text.
  void _handleTextComplete(String fullText) {
    final result = CorrectionParser.parse(fullText);

    if (result.correction != null) {
      debugPrint('OpenAI: Correction found: ${result.correction}');
      onCorrectionFound?.call(result.correction!);
    }

    final cleaned = result.cleanedText;
    if (cleaned.isNotEmpty) {
      onTextComplete?.call(cleaned);
    }
  }

  /// Handle WebSocket error
  void _handleError(dynamic error) {
    debugPrint('OpenAI WebSocket error: $error');
    _setConnectionState(OpenAIConnectionState.error);
    onError?.call('WebSocket error: $error');
  }

  /// Handle WebSocket close
  void _handleDone() {
    debugPrint('OpenAI: WebSocket closed');
    _setConnectionState(OpenAIConnectionState.disconnected);
  }

  /// Update connection state and notify
  void _setConnectionState(OpenAIConnectionState state) {
    _connectionState = state;
    onConnectionStateChange?.call(state);
  }

  /// Dispose resources
  void dispose() {
    disconnect();
    onTextDelta = null;
    onTextComplete = null;
    onCorrectionFound = null;
    onError = null;
    onConnectionStateChange = null;
  }
}
