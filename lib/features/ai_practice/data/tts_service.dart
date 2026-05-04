import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_tts/flutter_tts.dart';

/// Callback types for TTS events
typedef OnSpeakingStateChange = void Function(bool isSpeaking);
typedef OnSpeakProgress = void Function(String text, int start, int end);

/// TTS state
enum TtsState {
  idle,
  speaking,
  paused,
  error,
}

/// Service for on-device text-to-speech
class TtsService {
  // Lazily created so test subclasses that override all methods never
  // instantiate FlutterTts (which requires the Flutter binding).
  FlutterTts? _ttsInstance;
  final FlutterTts? _injectedTts;
  FlutterTts get _tts => _injectedTts ?? (_ttsInstance ??= FlutterTts());

  TtsState _state = TtsState.idle;

  TtsService({FlutterTts? tts}) : _injectedTts = tts;
  bool _isInitialized = false;

  // Settings
  double _speechRate = 0.5; // Slower for learners (0.0 - 1.0)
  double _volume = 1.0;
  double _pitch = 1.0;
  String _language = 'en-US';

  // Queue for pending speech
  final List<String> _speechQueue = [];
  bool _isProcessingQueue = false;

  // Callbacks
  OnSpeakingStateChange? onSpeakingStateChange;
  OnSpeakProgress? onProgress;

  /// Current TTS state
  TtsState get state => _state;

  /// Whether currently speaking
  bool get isSpeaking => _state == TtsState.speaking;

  /// Current speech rate
  double get speechRate => _speechRate;

  /// Initialize TTS
  Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      // Set up TTS
      await _tts.setLanguage(_language);
      await _tts.setSpeechRate(_speechRate);
      await _tts.setVolume(_volume);
      await _tts.setPitch(_pitch);

      // Platform-specific setup
      if (Platform.isIOS) {
        await _tts.setSharedInstance(true);
        await _tts.setIosAudioCategory(
          IosTextToSpeechAudioCategory.ambient,
          [
            IosTextToSpeechAudioCategoryOptions.allowBluetooth,
            IosTextToSpeechAudioCategoryOptions.allowBluetoothA2DP,
            IosTextToSpeechAudioCategoryOptions.mixWithOthers,
          ],
          IosTextToSpeechAudioMode.voicePrompt,
        );
      }

      // Set up callbacks
      _tts.setStartHandler(() {
        _setState(TtsState.speaking);
        onSpeakingStateChange?.call(true);
      });

      _tts.setCompletionHandler(() {
        _setState(TtsState.idle);
        onSpeakingStateChange?.call(false);
        _processNextInQueue();
      });

      _tts.setCancelHandler(() {
        _setState(TtsState.idle);
        onSpeakingStateChange?.call(false);
      });

      _tts.setErrorHandler((error) {
        debugPrint('TTS Error: $error');
        _setState(TtsState.error);
        onSpeakingStateChange?.call(false);
        _processNextInQueue();
      });

      _tts.setProgressHandler((text, start, end, word) {
        onProgress?.call(text, start, end);
      });

      _isInitialized = true;
      debugPrint('TTS: Initialized successfully');
    } catch (e) {
      debugPrint('TTS: Initialization error: $e');
    }
  }

  /// Speak text
  Future<void> speak(String text) async {
    if (!_isInitialized) {
      await initialize();
    }

    if (text.isEmpty) return;

    // Add to queue and process
    _speechQueue.add(text);
    await _processQueue();
  }

  /// Speak text immediately, interrupting any current speech
  Future<void> speakImmediately(String text) async {
    if (!_isInitialized) {
      await initialize();
    }

    if (text.isEmpty) return;

    // Clear queue and stop current speech
    _speechQueue.clear();
    await stop();

    // Speak immediately
    await _tts.speak(text);
  }

  /// Stop speaking
  Future<void> stop() async {
    _speechQueue.clear();
    _isProcessingQueue = false;
    await _tts.stop();
    _setState(TtsState.idle);
    onSpeakingStateChange?.call(false);
  }

  /// Pause speaking (iOS only)
  Future<void> pause() async {
    if (Platform.isIOS) {
      await _tts.pause();
      _setState(TtsState.paused);
    }
  }

  /// Set speech rate (0.0 - 1.0)
  Future<void> setSpeechRate(double rate) async {
    _speechRate = rate.clamp(0.0, 1.0);
    await _tts.setSpeechRate(_speechRate);
  }

  /// Set volume (0.0 - 1.0)
  Future<void> setVolume(double volume) async {
    _volume = volume.clamp(0.0, 1.0);
    await _tts.setVolume(_volume);
  }

  /// Set pitch (0.5 - 2.0)
  Future<void> setPitch(double pitch) async {
    _pitch = pitch.clamp(0.5, 2.0);
    await _tts.setPitch(_pitch);
  }

  /// Set language
  Future<void> setLanguage(String language) async {
    _language = language;
    await _tts.setLanguage(_language);
  }

  /// Get available languages
  Future<List<String>> getAvailableLanguages() async {
    final languages = await _tts.getLanguages;
    return languages.cast<String>();
  }

  /// Get available voices
  Future<List<Map<String, String>>> getAvailableVoices() async {
    final voices = await _tts.getVoices;
    return voices.cast<Map<String, String>>();
  }

  /// Set specific voice
  Future<void> setVoice(Map<String, String> voice) async {
    await _tts.setVoice(voice);
  }

  /// Process the speech queue
  Future<void> _processQueue() async {
    if (_isProcessingQueue || _speechQueue.isEmpty) return;

    _isProcessingQueue = true;

    while (_speechQueue.isNotEmpty) {
      final text = _speechQueue.removeAt(0);
      await _tts.speak(text);

      // Wait for speech to complete
      await _waitForCompletion();
    }

    _isProcessingQueue = false;
  }

  /// Process next item in queue
  void _processNextInQueue() {
    if (_speechQueue.isNotEmpty) {
      _processQueue();
    }
  }

  /// Wait for current speech to complete
  Future<void> _waitForCompletion() async {
    while (_state == TtsState.speaking) {
      await Future.delayed(const Duration(milliseconds: 100));
    }
  }

  /// Update state
  void _setState(TtsState newState) {
    _state = newState;
  }

  /// Dispose resources
  void dispose() {
    (_injectedTts ?? _ttsInstance)?.stop();
    onSpeakingStateChange = null;
    onProgress = null;
  }
}
