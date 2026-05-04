import 'dart:async';

import 'package:Speaking_club/features/ai_practice/data/openai_realtime_service.dart';
import 'package:Speaking_club/features/ai_practice/data/speech_service.dart';
import 'package:Speaking_club/features/ai_practice/data/tts_service.dart';
import 'package:Speaking_club/shared/models/ai_session.dart';

// ─── OpenAI service fake ──────────────────────────────────────────────────────

/// Controllable fake for [OpenAIRealtimeService].
///
/// Tests drive state by calling [simulateConnect], [simulateTextDelta], etc.
class FakeOpenAIRealtimeService extends OpenAIRealtimeService {
  OpenAIConnectionState _state = OpenAIConnectionState.disconnected;

  bool connectCalled = false;
  bool disconnectCalled = false;
  bool greetingTriggered = false;
  final List<String> sentMessages = [];

  @override
  bool get isConnected => _state == OpenAIConnectionState.connected;

  @override
  OpenAIConnectionState get connectionState => _state;

  @override
  Future<void> connect({
    required String ephemeralKey,
    required AiSessionMode mode,
    AiPersona persona = AiPersona.emma,
    String? topic,
    String? scenario,
  }) async {
    connectCalled = true;
    // Test controls connection state via simulateConnect/simulateDisconnect.
  }

  @override
  Future<void> disconnect() async {
    disconnectCalled = true;
    _emit(OpenAIConnectionState.disconnected);
  }

  @override
  void triggerInitialGreeting() => greetingTriggered = true;

  @override
  void sendMessage(String text) => sentMessages.add(text);

  @override
  void dispose() {}

  // ─── Test helpers ─────────────────────────────────────────────────────────

  void simulateConnect() {
    _state = OpenAIConnectionState.connected;
    _emit(OpenAIConnectionState.connected);
  }

  void simulateDisconnect() {
    _state = OpenAIConnectionState.disconnected;
    _emit(OpenAIConnectionState.disconnected);
  }

  void simulateConnectionError(String message) {
    _state = OpenAIConnectionState.error;
    _emit(OpenAIConnectionState.error);
    onError?.call(message);
  }

  /// Simulate an application-level OpenAI error (e.g. model mismatch).
  /// Does NOT change connection state — the WS stays "connected" until the
  /// server closes it separately.
  void simulateError(String message) => onError?.call(message);

  void simulateTextDelta(String delta) => onTextDelta?.call(delta);
  void simulateTextComplete(String text) => onTextComplete?.call(text);

  void _emit(OpenAIConnectionState s) => onConnectionStateChange?.call(s);
}

// ─── Speech service fake ──────────────────────────────────────────────────────

/// A [SpeechService] that never touches the platform speech-to-text plugin.
///
/// Overrides every method that would call platform channels; tests drive
/// behaviour via [simulateResult] and [simulateError].
class FakeSpeechService extends SpeechService {
  FakeSpeechService() : super(); // SpeechToText is now lazy – never called.

  @override
  Future<bool> initialize() async => true;

  @override
  Future<void> startListening({String? localeId}) async {
    onListeningStateChange?.call(true);
  }

  @override
  Future<void> stopListening() async {
    onListeningStateChange?.call(false);
  }

  @override
  Future<void> cancelListening() async {}

  @override
  void dispose() {}

  // Helpers
  void simulateResult(String text, {bool isFinal = true}) =>
      onResult?.call(text, isFinal);

  void simulateError(String error) => onError?.call(error);
}

// ─── TTS service fake ─────────────────────────────────────────────────────────

/// A [TtsService] that never touches the platform TTS plugin.
///
/// [speak] fires [onSpeakingStateChange] synchronously (start then finish) so
/// tests don't need async gaps for TTS completion.
class FakeTtsService extends TtsService {
  final List<String> spoken = [];

  FakeTtsService() : super(); // FlutterTts is now lazy – never called.

  @override
  Future<void> initialize() async {}

  @override
  Future<void> speak(String text) async {
    spoken.add(text);
    onSpeakingStateChange?.call(true);
    onSpeakingStateChange?.call(false); // finish immediately
  }

  @override
  Future<void> stop() async => onSpeakingStateChange?.call(false);

  @override
  bool get isSpeaking => false;

  @override
  TtsState get state => TtsState.idle;

  @override
  void dispose() {}
}
