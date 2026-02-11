import 'dart:async';
import 'dart:developer' as dev;

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../shared/models/ai_session.dart';
import '../../data/ai_session_repository.dart';
import '../../data/openai_realtime_service.dart';
import '../../data/speech_service.dart';
import '../../data/tts_service.dart';
import '../../domain/ai_practice_state.dart';

/// OpenAI Realtime Service provider
final openAIServiceProvider = Provider<OpenAIRealtimeService>((ref) {
  final service = OpenAIRealtimeService();
  ref.onDispose(() => service.dispose());
  return service;
});

/// Speech Service provider
final speechServiceProvider = Provider<SpeechService>((ref) {
  final service = SpeechService();
  ref.onDispose(() => service.dispose());
  return service;
});

/// TTS Service provider
final ttsServiceProvider = Provider<TtsService>((ref) {
  final service = TtsService();
  ref.onDispose(() => service.dispose());
  return service;
});

/// AI Practice provider for session management
final aiPracticeProvider =
    NotifierProvider<AiPracticeNotifier, AiPracticeState>(
        AiPracticeNotifier.new);

/// AI Practice notifier for session state management
class AiPracticeNotifier extends Notifier<AiPracticeState> {
  OpenAIRealtimeService get _openAI => ref.read(openAIServiceProvider);
  SpeechService get _speech => ref.read(speechServiceProvider);
  TtsService get _tts => ref.read(ttsServiceProvider);
  AiSessionRepository get _repository => ref.read(aiSessionRepositoryProvider);

  Timer? _durationTimer;
  Timer? _keyRefreshTimer;
  String? _currentEphemeralKey;
  DateTime? _keyExpiresAt;

  @override
  AiPracticeState build() {
    _setupCallbacks();

    ref.onDispose(() {
      _cleanup();
    });

    return const AiPracticeState();
  }

  void _setupCallbacks() {
    // OpenAI callbacks
    _openAI.onConnectionStateChange = _onOpenAIConnectionChange;
    _openAI.onTextDelta = _onTextDelta;
    _openAI.onTextComplete = _onTextComplete;
    _openAI.onError = _onOpenAIError;

    // Speech callbacks
    _speech.onResult = _onSpeechResult;
    _speech.onError = _onSpeechError;
    _speech.onListeningStateChange = _onListeningStateChange;

    // TTS callbacks
    _tts.onSpeakingStateChange = _onTtsSpeakingChange;
  }

  void _cleanup() {
    _durationTimer?.cancel();
    _keyRefreshTimer?.cancel();
    _openAI.disconnect();
    _speech.stopListening();
    _tts.stop();
  }

  // === OpenAI Callbacks ===

  void _onOpenAIConnectionChange(OpenAIConnectionState connectionState) {
    state = state.copyWith(openAIConnectionState: connectionState);

    if (connectionState == OpenAIConnectionState.connected &&
        state.phase == AiPracticePhase.connecting) {
      // Connected successfully, start session
      state = state.copyWith(
        phase: AiPracticePhase.thinking,
        sessionStartTime: DateTime.now(),
        currentSpeaker: Speaker.none,
      );
      _startDurationTimer();
      dev.log('AI Practice: Session started, triggering AI greeting');

      // Trigger AI to send initial greeting
      _openAI.triggerInitialGreeting();
    } else if (connectionState == OpenAIConnectionState.error) {
      state = state.copyWith(
        phase: AiPracticePhase.error,
        error: 'Failed to connect to AI',
      );
    }
  }

  void _onTextDelta(String delta) {
    // Accumulate AI response text for streaming display
    state = state.copyWith(
      currentAiText: state.currentAiText + delta,
      phase: AiPracticePhase.aiSpeaking,
      currentSpeaker: Speaker.ai,
    );
  }

  void _onTextComplete(String fullText) {
    // AI response complete, add to messages and speak
    final message = AiMessage(
      role: 'assistant',
      content: fullText,
      timestamp: DateTime.now(),
    );

    state = state.copyWith(
      messages: [...state.messages, message],
      currentAiText: '',
    );

    // Speak the response
    _tts.speak(fullText);
  }

  void _onOpenAIError(String error) {
    dev.log('AI Practice: OpenAI error: $error');
    state = state.copyWith(error: error);
  }

  // === Speech Callbacks ===

  void _onSpeechResult(String text, bool isFinal) {
    state = state.copyWith(
      currentUserText: text,
      speechState: _speech.state,
    );

    if (isFinal && text.isNotEmpty) {
      // User finished speaking, send to AI
      _sendUserMessage(text);
    }
  }

  void _onSpeechError(String error) {
    dev.log('AI Practice: Speech error: $error');
    state = state.copyWith(
      phase: AiPracticePhase.ready,
      speechState: _speech.state,
      error: error,
    );
  }

  void _onListeningStateChange(bool isListening) {
    if (isListening) {
      state = state.copyWith(
        phase: AiPracticePhase.listening,
        currentSpeaker: Speaker.user,
        speechState: _speech.state,
      );
    } else if (state.phase == AiPracticePhase.listening) {
      // Finished listening, waiting for result
      state = state.copyWith(speechState: _speech.state);
    }
  }

  // === TTS Callbacks ===

  void _onTtsSpeakingChange(bool isSpeaking) {
    state = state.copyWith(
      ttsState: _tts.state,
      currentSpeaker: isSpeaking ? Speaker.ai : Speaker.none,
    );

    if (!isSpeaking && state.phase == AiPracticePhase.aiSpeaking) {
      // AI finished speaking, automatically start listening for user
      dev.log('AI Practice: AI finished speaking, auto-starting listening');
      state = state.copyWith(phase: AiPracticePhase.ready);

      // Auto-start listening after a brief delay
      Future.delayed(const Duration(milliseconds: 300), () {
        if (state.isInConversation && !_tts.isSpeaking) {
          startListening();
        }
      });
    }
  }

  // === Duration Timer ===

  void _startDurationTimer() {
    _durationTimer?.cancel();
    _durationTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (state.isActive) {
        final newDuration = state.sessionDurationSeconds + 1;
        final newRemaining = state.remainingDailySeconds - 1;

        state = state.copyWith(
          sessionDurationSeconds: newDuration,
          remainingDailySeconds: newRemaining,
        );

        // Check time limits
        if (newRemaining <= 0) {
          _onTimeLimitReached();
        } else if (newRemaining == 60) {
          // 1 minute warning
          state = state.copyWith(error: 'Only 1 minute remaining');
        }

        // Check if ephemeral key needs refresh (every 50s)
        _checkKeyRefresh();
      }
    });
  }

  void _onTimeLimitReached() {
    dev.log('AI Practice: Time limit reached');
    endSession();
  }

  void _checkKeyRefresh() {
    if (_keyExpiresAt == null || _currentEphemeralKey == null) return;

    final secondsUntilExpiry =
        _keyExpiresAt!.difference(DateTime.now()).inSeconds;
    if (secondsUntilExpiry < 15) {
      _refreshKey();
    }
  }

  Future<void> _refreshKey() async {
    if (state.sessionId == null) return;

    try {
      dev.log('AI Practice: Refreshing ephemeral key');
      final response = await _repository.refreshSessionToken(state.sessionId!);
      _currentEphemeralKey = response.ephemeralKey;
      _keyExpiresAt = response.expiresAt;
      dev.log('AI Practice: Key refreshed successfully');
    } catch (e) {
      dev.log('AI Practice: Failed to refresh key: $e');
    }
  }

  // === Public Actions ===

  /// Start a new AI practice session
  Future<void> startSession({
    required AiSessionMode mode,
    String? topic,
    String? scenario,
  }) async {
    if (state.isActive) {
      dev.log('AI Practice: Session already active');
      return;
    }

    dev.log('AI Practice: Starting session - mode: ${mode.name}');

    state = state.copyWith(
      phase: AiPracticePhase.initializing,
      mode: mode,
      topic: topic,
      scenario: scenario,
      messages: [],
      corrections: [],
      currentUserText: '',
      currentAiText: '',
      sessionDurationSeconds: 0,
      wordsSpoken: 0,
      error: null,
    );

    try {
      // Initialize STT and TTS
      await _speech.initialize();
      await _tts.initialize();

      // Request ephemeral key from backend
      state = state.copyWith(phase: AiPracticePhase.requestingToken);

      final tokenResponse = await _repository.getSessionToken(
        mode: mode,
        topic: topic,
        scenario: scenario,
      );

      state = state.copyWith(
        sessionId: tokenResponse.sessionId,
        remainingDailySeconds: tokenResponse.remainingSeconds,
      );

      _currentEphemeralKey = tokenResponse.ephemeralKey;
      _keyExpiresAt = tokenResponse.expiresAt;

      // Connect to OpenAI Realtime API
      state = state.copyWith(phase: AiPracticePhase.connecting);

      await _openAI.connect(
        ephemeralKey: tokenResponse.ephemeralKey,
        mode: mode,
        topic: topic,
        scenario: scenario,
      );
    } catch (e) {
      dev.log('AI Practice: Failed to start session: $e');
      state = state.copyWith(
        phase: AiPracticePhase.error,
        error: 'Failed to start session: $e',
      );
    }
  }

  /// Send a user message to the AI
  void _sendUserMessage(String text) {
    if (!state.isInConversation || text.isEmpty) return;

    // Add to messages
    final message = AiMessage(
      role: 'user',
      content: text,
      timestamp: DateTime.now(),
    );

    // Count words
    final wordCount = text.split(RegExp(r'\s+')).length;

    state = state.copyWith(
      messages: [...state.messages, message],
      currentUserText: '',
      phase: AiPracticePhase.thinking,
      currentSpeaker: Speaker.none,
      wordsSpoken: state.wordsSpoken + wordCount,
    );

    // Send to OpenAI
    _openAI.sendMessage(text);
  }

  /// Start listening for user speech
  Future<void> startListening() async {
    if (!state.canSpeak) return;

    // Stop TTS if speaking
    if (_tts.isSpeaking) {
      await _tts.stop();
    }

    await _speech.startListening();
  }

  /// Stop listening
  Future<void> stopListening() async {
    await _speech.stopListening();
  }

  /// End the current session
  Future<void> endSession() async {
    if (!state.isActive) return;

    dev.log('AI Practice: Ending session');
    state = state.copyWith(phase: AiPracticePhase.ending);

    _durationTimer?.cancel();
    _keyRefreshTimer?.cancel();

    // Stop listening/speaking
    await _speech.stopListening();
    await _tts.stop();
    await _openAI.disconnect();

    // Send session data to backend
    if (state.sessionId != null) {
      try {
        await _repository.endSession(EndSessionRequest(
          sessionId: state.sessionId!,
          messages: state.messages,
          corrections: state.corrections,
          stats: SessionStats(
            wordsSpoken: state.wordsSpoken,
            averageSentenceLength: _calculateAverageSentenceLength(),
            speakingTimePercent: _calculateSpeakingTimePercent(),
            vocabularyUsed: _extractVocabulary(),
          ),
          durationSeconds: state.sessionDurationSeconds,
        ));
      } catch (e) {
        dev.log('AI Practice: Failed to save session: $e');
      }
    }

    state = const AiPracticeState();
  }

  /// Toggle mute
  void toggleMute() {
    state = state.copyWith(isMuted: !state.isMuted);
  }

  /// Toggle speaker
  void toggleSpeaker() {
    state = state.copyWith(isSpeakerOn: !state.isSpeakerOn);
    // TODO: Actually toggle audio output
  }

  /// Clear error and reset to idle if in error state
  void clearError() {
    if (state.phase == AiPracticePhase.error) {
      state = const AiPracticeState(); // Reset to initial idle state
    } else {
      state = state.copyWith(error: null);
    }
  }

  // === Stats Calculation ===

  int _calculateAverageSentenceLength() {
    final userMessages =
        state.messages.where((m) => m.role == 'user').toList();
    if (userMessages.isEmpty) return 0;

    final totalWords = userMessages.fold<int>(
      0,
      (sum, m) => sum + m.content.split(RegExp(r'\s+')).length,
    );
    return totalWords ~/ userMessages.length;
  }

  int _calculateSpeakingTimePercent() {
    // Rough estimate based on user message count vs total
    final userMessages =
        state.messages.where((m) => m.role == 'user').length;
    final totalMessages = state.messages.length;
    if (totalMessages == 0) return 0;
    return ((userMessages / totalMessages) * 100).round();
  }

  List<String> _extractVocabulary() {
    final words = <String>{};
    for (final message in state.messages.where((m) => m.role == 'user')) {
      words.addAll(
        message.content
            .toLowerCase()
            .split(RegExp(r'[^a-zA-Z]+'))
            .where((w) => w.length > 2),
      );
    }
    return words.take(50).toList();
  }
}

/// Mode selection provider for loading topics/scenarios
final modeSelectionProvider =
    NotifierProvider<ModeSelectionNotifier, ModeSelectionState>(
        ModeSelectionNotifier.new);

/// Mode selection notifier
class ModeSelectionNotifier extends Notifier<ModeSelectionState> {
  AiSessionRepository get _repository => ref.read(aiSessionRepositoryProvider);

  @override
  ModeSelectionState build() {
    return ModeSelectionState.initial();
  }

  /// Load topics, scenarios, and usage info
  Future<void> loadData() async {
    if (state.isLoading) return;

    state = state.copyWith(isLoading: true, error: null);

    try {
      // Load all data in parallel, using defaults for topics/scenarios on failure
      final topicsFuture = _repository.getTopics().catchError((e) {
        dev.log('Failed to load topics, using defaults: $e');
        return _defaultTopicCategories;
      });

      final scenariosFuture = _repository.getScenarios().catchError((e) {
        dev.log('Failed to load scenarios, using defaults: $e');
        return _defaultScenarios;
      });

      final usageFuture = _repository.getUsageInfo();

      final results = await Future.wait([
        topicsFuture,
        scenariosFuture,
        usageFuture,
      ]);

      state = state.copyWith(
        isLoading: false,
        topicCategories: results[0] as List<TopicCategory>,
        scenarios: results[1] as List<Scenario>,
        usageInfo: results[2] as AiUsageInfo,
      );
    } catch (e) {
      // If only usage info fails, still show UI with defaults
      dev.log('Failed to load usage info: $e');
      state = state.copyWith(
        isLoading: false,
        topicCategories: _defaultTopicCategories,
        scenarios: _defaultScenarios,
        error: 'Failed to load usage info',
      );
    }
  }

  /// Refresh usage info only
  Future<void> refreshUsageInfo() async {
    try {
      final usageInfo = await _repository.getUsageInfo();
      state = state.copyWith(usageInfo: usageInfo);
    } catch (e) {
      dev.log('Failed to refresh usage info: $e');
    }
  }
}

// =============================================================================
// Default Topics and Scenarios (used when API is unavailable)
// =============================================================================

/// Default topic categories for offline/fallback use
const List<TopicCategory> _defaultTopicCategories = [
  TopicCategory(
    id: 'everyday',
    name: 'Everyday Life',
    icon: '\u{1F3E0}',
    topics: [
      Topic(
        id: 'daily_routine',
        name: 'Daily Routine',
        description: 'Discuss morning habits, work schedule, evening activities',
      ),
      Topic(
        id: 'hobbies',
        name: 'Hobbies & Interests',
        description: 'Share what you enjoy doing in your free time',
      ),
      Topic(
        id: 'food_cooking',
        name: 'Food & Cooking',
        description: 'Talk about recipes, restaurants, cuisine preferences',
      ),
    ],
  ),
  TopicCategory(
    id: 'travel',
    name: 'Travel & Places',
    icon: '\u{2708}',
    topics: [
      Topic(
        id: 'travel_experiences',
        name: 'Travel Experiences',
        description: 'Share memorable trips and destinations',
      ),
      Topic(
        id: 'dream_destinations',
        name: 'Dream Destinations',
        description: 'Discuss places you want to visit',
      ),
      Topic(
        id: 'local_attractions',
        name: 'Local Attractions',
        description: 'Describe interesting places in your area',
      ),
    ],
  ),
  TopicCategory(
    id: 'work',
    name: 'Work & Career',
    icon: '\u{1F4BC}',
    topics: [
      Topic(
        id: 'job_description',
        name: 'Your Job',
        description: 'Explain what you do at work',
      ),
      Topic(
        id: 'career_goals',
        name: 'Career Goals',
        description: 'Discuss your professional aspirations',
      ),
      Topic(
        id: 'workplace_culture',
        name: 'Workplace Culture',
        description: 'Talk about office environment and colleagues',
      ),
    ],
  ),
  TopicCategory(
    id: 'technology',
    name: 'Technology',
    icon: '\u{1F4BB}',
    topics: [
      Topic(
        id: 'gadgets',
        name: 'Gadgets & Devices',
        description: 'Discuss phones, computers, smart home devices',
      ),
      Topic(
        id: 'social_media',
        name: 'Social Media',
        description: 'Talk about online platforms and digital life',
      ),
      Topic(
        id: 'future_tech',
        name: 'Future Technology',
        description: 'Explore AI, VR, and emerging tech trends',
      ),
    ],
  ),
  TopicCategory(
    id: 'health',
    name: 'Health & Wellness',
    icon: '\u{2764}',
    topics: [
      Topic(
        id: 'fitness',
        name: 'Fitness & Exercise',
        description: 'Discuss workout routines and staying active',
      ),
      Topic(
        id: 'mental_health',
        name: 'Mental Wellbeing',
        description: 'Talk about stress management and self-care',
      ),
      Topic(
        id: 'nutrition',
        name: 'Healthy Eating',
        description: 'Discuss diet, nutrition, and food choices',
      ),
    ],
  ),
];

/// Default scenarios for offline/fallback use
const List<Scenario> _defaultScenarios = [
  Scenario(
    id: 'job_interview',
    name: 'Job Interview',
    description: 'Practice answering common interview questions',
    aiRole: 'Hiring Manager',
    userRole: 'Job Applicant',
    instructions: 'Answer questions professionally and highlight your skills',
  ),
  Scenario(
    id: 'restaurant',
    name: 'Restaurant Ordering',
    description: 'Practice ordering food and asking about the menu',
    aiRole: 'Waiter/Waitress',
    userRole: 'Customer',
    instructions: 'Order food, ask about ingredients, request modifications',
  ),
  Scenario(
    id: 'hotel_checkin',
    name: 'Hotel Check-in',
    description: 'Practice checking in at a hotel',
    aiRole: 'Hotel Receptionist',
    userRole: 'Guest',
    instructions: 'Check in, ask about amenities, request room service',
  ),
  Scenario(
    id: 'doctor_visit',
    name: "Doctor's Appointment",
    description: 'Practice describing symptoms and asking health questions',
    aiRole: 'Doctor',
    userRole: 'Patient',
    instructions: 'Describe symptoms clearly and ask about treatment options',
  ),
  Scenario(
    id: 'shopping',
    name: 'Shopping for Clothes',
    description: 'Practice asking about sizes, prices, and making purchases',
    aiRole: 'Store Assistant',
    userRole: 'Shopper',
    instructions: 'Ask about products, try on clothes, negotiate prices',
  ),
  Scenario(
    id: 'airport',
    name: 'Airport & Flying',
    description: 'Practice airport interactions and flight-related conversations',
    aiRole: 'Airport Staff',
    userRole: 'Traveler',
    instructions: 'Check in for flight, go through security, ask about boarding',
  ),
  Scenario(
    id: 'bank',
    name: 'Bank Visit',
    description: 'Practice banking transactions and financial conversations',
    aiRole: 'Bank Teller',
    userRole: 'Customer',
    instructions: 'Open account, make transactions, ask about services',
  ),
  Scenario(
    id: 'phone_call',
    name: 'Making a Phone Call',
    description: 'Practice professional phone etiquette',
    aiRole: 'Customer Service',
    userRole: 'Caller',
    instructions: 'Make inquiries, resolve issues, leave messages',
  ),
];
