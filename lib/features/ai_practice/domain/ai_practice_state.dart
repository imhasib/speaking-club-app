import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../shared/models/ai_session.dart';
import '../data/openai_realtime_service.dart';
import '../data/speech_service.dart';
import '../data/tts_service.dart';

part 'ai_practice_state.freezed.dart';

/// AI practice session phase
enum AiPracticePhase {
  /// No active session
  idle,

  /// Initializing services (STT, TTS)
  initializing,

  /// Requesting ephemeral key from backend
  requestingToken,

  /// Connecting to OpenAI WebSocket
  connecting,

  /// Connected and ready for conversation
  ready,

  /// User is speaking (STT active)
  listening,

  /// Waiting for AI response
  thinking,

  /// AI is responding (TTS active)
  aiSpeaking,

  /// Session ending
  ending,

  /// Error state
  error,
}

/// Who is currently speaking
enum Speaker {
  none,
  user,
  ai,
}

/// AI practice session state
@freezed
sealed class AiPracticeState with _$AiPracticeState {
  const AiPracticeState._();

  const factory AiPracticeState({
    @Default(AiPracticePhase.idle) AiPracticePhase phase,

    // Session info
    String? sessionId,
    @Default(AiSessionMode.freeChat) AiSessionMode mode,
    @Default(AiPersona.emma) AiPersona persona,
    String? topic,
    String? scenario,

    // Connection states
    @Default(OpenAIConnectionState.disconnected)
    OpenAIConnectionState openAIConnectionState,
    @Default(SpeechState.idle) SpeechState speechState,
    @Default(TtsState.idle) TtsState ttsState,

    // Conversation
    @Default([]) List<AiMessage> messages,
    @Default('') String currentUserText,
    @Default('') String currentAiText,
    @Default(Speaker.none) Speaker currentSpeaker,

    // Session timing
    DateTime? sessionStartTime,
    @Default(0) int sessionDurationSeconds,
    @Default(300) int remainingDailySeconds, // 5 min default

    // Corrections collected during session
    @Default([]) List<Correction> corrections,

    // Stats (calculated on end)
    @Default(0) int wordsSpoken,

    // Audio controls
    @Default(false) bool isMuted,
    @Default(true) bool isSpeakerOn,

    // TTS availability (false when TTS init failed)
    @Default(true) bool ttsAvailable,

    // Error
    String? error,

    // Whether the current error is a persistent STT failure (show manual retry)
    @Default(false) bool sttPersistentError,
  }) = _AiPracticeState;

  /// Whether session is active
  bool get isActive =>
      phase != AiPracticePhase.idle && phase != AiPracticePhase.error;

  /// Whether session is in connecting phases
  bool get isConnecting =>
      phase == AiPracticePhase.initializing ||
      phase == AiPracticePhase.requestingToken ||
      phase == AiPracticePhase.connecting;

  /// Whether user can speak
  bool get canSpeak =>
      phase == AiPracticePhase.ready || phase == AiPracticePhase.listening;

  /// Whether in a conversational state
  bool get isInConversation =>
      phase == AiPracticePhase.ready ||
      phase == AiPracticePhase.listening ||
      phase == AiPracticePhase.thinking ||
      phase == AiPracticePhase.aiSpeaking;

  /// Format session duration as string (e.g., "00:05" or "05:30")
  String get formattedDuration {
    final minutes = sessionDurationSeconds ~/ 60;
    final seconds = sessionDurationSeconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  /// Format remaining daily time
  String get formattedRemaining {
    final minutes = remainingDailySeconds ~/ 60;
    final seconds = remainingDailySeconds % 60;
    return '$minutes:${seconds.toString().padLeft(2, '0')}';
  }

  /// Whether user has time remaining
  bool get hasTimeRemaining => remainingDailySeconds > 0;

  /// Whether time is low (less than 1 minute)
  bool get isTimeLow => remainingDailySeconds < 60 && remainingDailySeconds > 0;

  /// Get status text for UI
  String get statusText {
    switch (phase) {
      case AiPracticePhase.idle:
        return 'Ready to start';
      case AiPracticePhase.initializing:
        return 'Initializing...';
      case AiPracticePhase.requestingToken:
        return 'Connecting to server...';
      case AiPracticePhase.connecting:
        return 'Connecting to AI...';
      case AiPracticePhase.ready:
        return 'Tap to speak';
      case AiPracticePhase.listening:
        return 'Listening...';
      case AiPracticePhase.thinking:
        return '${persona.displayName} is thinking...';
      case AiPracticePhase.aiSpeaking:
        return '${persona.displayName} is speaking';
      case AiPracticePhase.ending:
        return 'Ending session...';
      case AiPracticePhase.error:
        return error ?? 'An error occurred';
    }
  }
}

/// State for mode selection screen
@freezed
sealed class ModeSelectionState with _$ModeSelectionState {
  const factory ModeSelectionState({
    @Default(false) bool isLoading,
    @Default([]) List<TopicCategory> topicCategories,
    @Default([]) List<Scenario> scenarios,
    AiUsageInfo? usageInfo,
    String? error,
  }) = _ModeSelectionState;

  factory ModeSelectionState.initial() => const ModeSelectionState();
}
