import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:speech_to_text/speech_recognition_error.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';

/// Callback types for speech events
typedef OnSpeechResult = void Function(String text, bool isFinal);
typedef OnSpeechError = void Function(String error);
typedef OnListeningStateChange = void Function(bool isListening);

/// Speech recognition state
enum SpeechState {
  idle,
  initializing,
  ready,
  listening,
  error,
}

/// Service for on-device speech-to-text
class SpeechService {
  final SpeechToText _speech = SpeechToText();
  SpeechState _state = SpeechState.idle;
  bool _isInitialized = false;
  String _currentLocale = 'en_US';

  // Callbacks
  OnSpeechResult? onResult;
  OnSpeechError? onError;
  OnListeningStateChange? onListeningStateChange;

  /// Current speech state
  SpeechState get state => _state;

  /// Whether currently listening
  bool get isListening => _state == SpeechState.listening;

  /// Whether speech is available
  bool get isAvailable => _isInitialized && _speech.isAvailable;

  /// Available locales
  Future<List<LocaleName>> get locales async {
    if (!_isInitialized) return [];
    return await _speech.locales();
  }

  /// Current locale ID
  String get currentLocale => _currentLocale;

  /// Initialize speech recognition
  Future<bool> initialize() async {
    if (_isInitialized) return true;

    _setState(SpeechState.initializing);

    try {
      _isInitialized = await _speech.initialize(
        onError: _handleError,
        onStatus: _handleStatus,
        debugLogging: kDebugMode,
      );

      if (_isInitialized) {
        _setState(SpeechState.ready);
        debugPrint('Speech: Initialized successfully');
      } else {
        _setState(SpeechState.error);
        debugPrint('Speech: Initialization failed');
      }

      return _isInitialized;
    } catch (e) {
      debugPrint('Speech: Initialization error: $e');
      _setState(SpeechState.error);
      onError?.call('Failed to initialize speech recognition: $e');
      return false;
    }
  }

  /// Start listening for speech
  Future<void> startListening({String? localeId}) async {
    if (!_isInitialized) {
      final initialized = await initialize();
      if (!initialized) return;
    }

    if (_state == SpeechState.listening) {
      debugPrint('Speech: Already listening');
      return;
    }

    _currentLocale = localeId ?? 'en_US';

    try {
      await _speech.listen(
        onResult: _handleResult,
        localeId: _currentLocale,
        listenMode: ListenMode.dictation,
        pauseFor: const Duration(seconds: 4),
        cancelOnError: false,
        partialResults: true,
      );

      _setState(SpeechState.listening);
      onListeningStateChange?.call(true);
      debugPrint('Speech: Started listening');
    } catch (e) {
      debugPrint('Speech: Start listening error: $e');
      _setState(SpeechState.error);
      onError?.call('Failed to start listening: $e');
    }
  }

  /// Stop listening
  Future<void> stopListening() async {
    if (_state != SpeechState.listening) return;

    try {
      await _speech.stop();
      _setState(SpeechState.ready);
      onListeningStateChange?.call(false);
      debugPrint('Speech: Stopped listening');
    } catch (e) {
      debugPrint('Speech: Stop listening error: $e');
    }
  }

  /// Cancel listening (discard current result)
  Future<void> cancelListening() async {
    if (_state != SpeechState.listening) return;

    try {
      await _speech.cancel();
      _setState(SpeechState.ready);
      onListeningStateChange?.call(false);
      debugPrint('Speech: Cancelled listening');
    } catch (e) {
      debugPrint('Speech: Cancel listening error: $e');
    }
  }

  /// Set locale for speech recognition
  void setLocale(String localeId) {
    _currentLocale = localeId;
  }

  /// Handle speech recognition result
  void _handleResult(SpeechRecognitionResult result) {
    debugPrint(
        'Speech: Result: "${result.recognizedWords}" (final: ${result.finalResult})');
    onResult?.call(result.recognizedWords, result.finalResult);

    if (result.finalResult) {
      _setState(SpeechState.ready);
      onListeningStateChange?.call(false);
    }
  }

  /// Handle speech recognition error
  void _handleError(SpeechRecognitionError error) {
    debugPrint('Speech: Error: ${error.errorMsg}');

    // Soft errors: the user was simply silent. Don't surface to the UI —
    // emit an empty final result so the conversation auto-restarts the
    // listener instead of stopping mid-flow.
    if (error.errorMsg == 'error_no_match' ||
        error.errorMsg == 'error_speech_timeout') {
      _setState(SpeechState.ready);
      onListeningStateChange?.call(false);
      onResult?.call('', true);
      return;
    }

    String userMessage;
    switch (error.errorMsg) {
      case 'error_audio':
        userMessage = 'Audio error. Please check your microphone.';
        break;
      case 'error_permission':
        userMessage = 'Microphone permission denied.';
        break;
      default:
        userMessage = 'Speech recognition error: ${error.errorMsg}';
    }

    onError?.call(userMessage);
    _setState(SpeechState.ready);
    onListeningStateChange?.call(false);
  }

  /// Handle speech recognition status
  void _handleStatus(String status) {
    debugPrint('Speech: Status: $status');

    switch (status) {
      case 'listening':
        _setState(SpeechState.listening);
        break;
      case 'done':
      case 'notListening':
        if (_state == SpeechState.listening) {
          _setState(SpeechState.ready);
          onListeningStateChange?.call(false);
        }
        break;
    }
  }

  /// Update state
  void _setState(SpeechState newState) {
    _state = newState;
  }

  /// Dispose resources
  void dispose() {
    _speech.cancel();
    onResult = null;
    onError = null;
    onListeningStateChange = null;
  }
}
