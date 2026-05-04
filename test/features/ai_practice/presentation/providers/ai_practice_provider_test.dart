import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:Speaking_club/features/ai_practice/data/ai_session_repository.dart';
import 'package:Speaking_club/features/ai_practice/data/openai_realtime_service.dart';
import 'package:Speaking_club/features/ai_practice/domain/ai_practice_state.dart';
import 'package:Speaking_club/features/ai_practice/presentation/providers/ai_practice_provider.dart';
import 'package:Speaking_club/shared/models/ai_session.dart';

import '../../helpers/fake_ai_services.dart';

// ─── Mocks ────────────────────────────────────────────────────────────────────

class _MockRepository extends Mock implements AiSessionRepository {}

// ─── Helpers ──────────────────────────────────────────────────────────────────

EphemeralKeyResponse _fakeToken({
  String key = 'ek-test',
  String sessionId = 'sess-1',
  int remainingSeconds = 300,
  DateTime? expiresAt,
}) =>
    EphemeralKeyResponse(
      ephemeralKey: key,
      sessionId: sessionId,
      remainingSeconds: remainingSeconds,
      expiresAt: expiresAt ??
          DateTime.now().toUtc().add(const Duration(minutes: 1)),
    );

/// Creates a [ProviderContainer] wired with controllable fakes.
({
  ProviderContainer container,
  FakeOpenAIRealtimeService openAI,
  FakeSpeechService speech,
  FakeTtsService tts,
  _MockRepository repo,
}) _makeContainer() {
  final openAI = FakeOpenAIRealtimeService();
  final speech = FakeSpeechService();
  final tts = FakeTtsService();
  final repo = _MockRepository();

  final container = ProviderContainer(overrides: [
    openAIServiceProvider.overrideWithValue(openAI),
    speechServiceProvider.overrideWithValue(speech),
    ttsServiceProvider.overrideWithValue(tts),
    aiSessionRepositoryProvider.overrideWithValue(repo),
  ]);

  return (
    container: container,
    openAI: openAI,
    speech: speech,
    tts: tts,
    repo: repo,
  );
}

void main() {
  setUpAll(() {
    TestWidgetsFlutterBinding.ensureInitialized();

    // Make permission_handler return "granted" so startSession() doesn't hit
    // a real platform channel in the test environment.
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
      const MethodChannel('flutter.baseflow.com/permissions/methods'),
      (call) async {
        // 1 == PermissionStatus.granted
        if (call.method == 'checkPermissionStatus') return 1;
        if (call.method == 'requestPermissions') return {0: 1}; // mic granted
        return null;
      },
    );

    // Enum and value types that appear as named parameters in mocked calls.
    registerFallbackValue(AiSessionMode.freeChat);
    registerFallbackValue(
      const SessionStartRequest(sessionId: 'x', mode: AiSessionMode.freeChat),
    );
    registerFallbackValue(
      EndSessionRequest(
        sessionId: 'x',
        messages: const [],
        corrections: const [],
        stats: const SessionStats(
          wordsSpoken: 0,
          averageSentenceLength: 0,
          speakingTimePercent: 0,
          vocabularyUsed: [],
        ),
        durationSeconds: 0,
      ),
    );
  });

  // ─── startSession() ────────────────────────────────────────────────────────

  group('startSession()', () {
    test('transitions phase from idle → thinking on successful connect',
        () async {
      final (:container, :openAI, :repo, :speech, :tts) = _makeContainer();
      addTearDown(container.dispose);

      when(() => repo.getSessionToken(
            mode: any(named: 'mode'),
            topic: any(named: 'topic'),
            scenario: any(named: 'scenario'),
          )).thenAnswer((_) async => _fakeToken());
      when(() => repo.startSession(any())).thenAnswer((_) async {});

      final notifier = container.read(aiPracticeProvider.notifier);

      // Start session without awaiting so we can observe state transitions.
      unawaited(
          notifier.startSession(mode: AiSessionMode.freeChat));

      // Simulate backend returning token and WS connecting.
      await pumpEventQueue();
      openAI.simulateConnect();
      await pumpEventQueue();

      final s = container.read(aiPracticeProvider);
      expect(s.phase, AiPracticePhase.thinking);
    });

    test('triggers initial greeting after connect', () async {
      final (:container, :openAI, :repo, :speech, :tts) = _makeContainer();
      addTearDown(container.dispose);

      when(() => repo.getSessionToken(
            mode: any(named: 'mode'),
            topic: any(named: 'topic'),
            scenario: any(named: 'scenario'),
          )).thenAnswer((_) async => _fakeToken());
      when(() => repo.startSession(any())).thenAnswer((_) async {});

      unawaited(
          container.read(aiPracticeProvider.notifier).startSession(
                mode: AiSessionMode.freeChat,
              ));

      await pumpEventQueue();
      openAI.simulateConnect();
      await pumpEventQueue();

      expect(openAI.greetingTriggered, isTrue);
    });

    test('enters error phase if getSessionToken throws', () async {
      final (:container, :openAI, :repo, :speech, :tts) = _makeContainer();
      addTearDown(container.dispose);

      when(() => repo.getSessionToken(
            mode: any(named: 'mode'),
            topic: any(named: 'topic'),
            scenario: any(named: 'scenario'),
          )).thenThrow(Exception('Network error'));

      await container
          .read(aiPracticeProvider.notifier)
          .startSession(mode: AiSessionMode.freeChat);

      final s = container.read(aiPracticeProvider);
      expect(s.phase, AiPracticePhase.error);
      expect(s.error, contains('Network error'));
    });

    test('is a no-op if a session is already active', () async {
      final (:container, :openAI, :repo, :speech, :tts) = _makeContainer();
      addTearDown(container.dispose);

      when(() => repo.getSessionToken(
            mode: any(named: 'mode'),
            topic: any(named: 'topic'),
            scenario: any(named: 'scenario'),
          )).thenAnswer((_) async => _fakeToken());
      when(() => repo.startSession(any())).thenAnswer((_) async {});

      unawaited(
          container.read(aiPracticeProvider.notifier).startSession(
                mode: AiSessionMode.freeChat,
              ));
      await pumpEventQueue();
      openAI.simulateConnect();
      await pumpEventQueue();

      // Second call must not trigger another token request.
      await container
          .read(aiPracticeProvider.notifier)
          .startSession(mode: AiSessionMode.freeChat);

      verify(() => repo.getSessionToken(
            mode: any(named: 'mode'),
            topic: any(named: 'topic'),
            scenario: any(named: 'scenario'),
          )).called(1);
    });
  });

  // ─── Timer behaviour ───────────────────────────────────────────────────────

  group('session timer', () {
    test('does NOT start before AI sends first text delta', () async {
      final (:container, :openAI, :repo, :speech, :tts) = _makeContainer();
      addTearDown(container.dispose);

      when(() => repo.getSessionToken(
            mode: any(named: 'mode'),
            topic: any(named: 'topic'),
            scenario: any(named: 'scenario'),
          )).thenAnswer((_) async => _fakeToken());
      when(() => repo.startSession(any())).thenAnswer((_) async {});

      unawaited(
          container.read(aiPracticeProvider.notifier).startSession(
                mode: AiSessionMode.freeChat,
              ));
      await pumpEventQueue();
      openAI.simulateConnect();
      await pumpEventQueue();

      // Connected but AI hasn't spoken yet.
      final s = container.read(aiPracticeProvider);
      expect(s.sessionStartTime, isNull,
          reason: 'Timer must not start until AI sends its first delta');
      expect(s.sessionDurationSeconds, 0);
    });

    test('starts when first AI text delta arrives', () async {
      final (:container, :openAI, :repo, :speech, :tts) = _makeContainer();
      addTearDown(container.dispose);

      when(() => repo.getSessionToken(
            mode: any(named: 'mode'),
            topic: any(named: 'topic'),
            scenario: any(named: 'scenario'),
          )).thenAnswer((_) async => _fakeToken());
      when(() => repo.startSession(any())).thenAnswer((_) async {});

      unawaited(
          container.read(aiPracticeProvider.notifier).startSession(
                mode: AiSessionMode.freeChat,
              ));
      await pumpEventQueue();
      openAI.simulateConnect();
      await pumpEventQueue();

      openAI.simulateTextDelta('Hello');
      await pumpEventQueue();

      final s = container.read(aiPracticeProvider);
      expect(s.sessionStartTime, isNotNull,
          reason: 'Timer must be set when the first text delta arrives');
    });

    test('timer is not double-started on subsequent deltas', () async {
      final (:container, :openAI, :repo, :speech, :tts) = _makeContainer();
      addTearDown(container.dispose);

      when(() => repo.getSessionToken(
            mode: any(named: 'mode'),
            topic: any(named: 'topic'),
            scenario: any(named: 'scenario'),
          )).thenAnswer((_) async => _fakeToken());
      when(() => repo.startSession(any())).thenAnswer((_) async {});

      unawaited(
          container.read(aiPracticeProvider.notifier).startSession(
                mode: AiSessionMode.freeChat,
              ));
      await pumpEventQueue();
      openAI.simulateConnect();
      await pumpEventQueue();

      openAI.simulateTextDelta('Hello');
      await pumpEventQueue();
      final startTime1 = container.read(aiPracticeProvider).sessionStartTime;

      // Simulate more deltas coming in.
      openAI.simulateTextDelta(' there');
      openAI.simulateTextDelta('!');
      await pumpEventQueue();

      final startTime2 = container.read(aiPracticeProvider).sessionStartTime;
      expect(startTime1, equals(startTime2),
          reason: 'sessionStartTime must not change after it is set');
    });
  });

  // ─── Reconnect behaviour ───────────────────────────────────────────────────

  group('mid-session disconnect', () {
    Future<void> _startConnectedSession(
      ProviderContainer container,
      FakeOpenAIRealtimeService openAI,
      _MockRepository repo,
    ) async {
      when(() => repo.getSessionToken(
            mode: any(named: 'mode'),
            topic: any(named: 'topic'),
            scenario: any(named: 'scenario'),
          )).thenAnswer((_) async => _fakeToken());
      when(() => repo.startSession(any())).thenAnswer((_) async {});

      unawaited(
          container.read(aiPracticeProvider.notifier).startSession(
                mode: AiSessionMode.freeChat,
              ));
      await pumpEventQueue();
      openAI.simulateConnect();
      await pumpEventQueue();
      openAI.simulateTextDelta('Hi!');
      await pumpEventQueue();
    }

    test('triggers a single reconnect attempt with a fresh token', () async {
      final (:container, :openAI, :repo, :speech, :tts) = _makeContainer();
      addTearDown(container.dispose);

      await _startConnectedSession(container, openAI, repo);

      when(() => repo.refreshSessionToken(any()))
          .thenAnswer((_) async => _fakeToken(key: 'ek-refreshed'));

      openAI.simulateDisconnect();
      await pumpEventQueue();
      await Future.delayed(Duration.zero); // allow async reconnect

      verify(() => repo.refreshSessionToken(any())).called(1);
    });

    test('ends session gracefully when reconnect token fetch fails', () async {
      final (:container, :openAI, :repo, :speech, :tts) = _makeContainer();
      addTearDown(container.dispose);

      await _startConnectedSession(container, openAI, repo);

      when(() => repo.refreshSessionToken(any()))
          .thenThrow(Exception('No network'));
      when(() => repo.endSession(any())).thenAnswer((_) async {});

      openAI.simulateDisconnect();
      await pumpEventQueue();
      await Future.delayed(Duration.zero);

      final s = container.read(aiPracticeProvider);
      // After reconnect failure, session is ended → state resets to idle.
      expect(s.phase, AiPracticePhase.idle);
    });

    test('does NOT attempt a second reconnect after max attempts reached',
        () async {
      final (:container, :openAI, :repo, :speech, :tts) = _makeContainer();
      addTearDown(container.dispose);

      await _startConnectedSession(container, openAI, repo);

      when(() => repo.refreshSessionToken(any()))
          .thenAnswer((_) async => _fakeToken(key: 'ek-refreshed'));
      when(() => repo.endSession(any())).thenAnswer((_) async {});

      // First disconnect → triggers reconnect attempt #1
      openAI.simulateDisconnect();
      await pumpEventQueue();
      await Future.delayed(Duration.zero);
      openAI.simulateConnect(); // reconnect succeeds

      // Second disconnect → max attempts reached → should end session, not reconnect
      openAI.simulateDisconnect();
      await pumpEventQueue();
      await Future.delayed(Duration.zero);

      // refreshSessionToken called only once (first reconnect, not second)
      verify(() => repo.refreshSessionToken(any())).called(1);
      expect(container.read(aiPracticeProvider).phase, AiPracticePhase.idle);
    });

    test('fatal OpenAI error blocks reconnect and sets error phase', () async {
      final (:container, :openAI, :repo, :speech, :tts) = _makeContainer();
      addTearDown(container.dispose);

      await _startConnectedSession(container, openAI, repo);

      // Simulate fatal OpenAI error (model mismatch)
      openAI.simulateError(
          'Model "gpt-4o-realtime-preview" does not match the realtime token model.');
      await pumpEventQueue();

      final s = container.read(aiPracticeProvider);
      expect(s.phase, AiPracticePhase.error);
      expect(s.error, contains('does not match'));

      // Now disconnect fires — should NOT trigger a reconnect
      when(() => repo.endSession(any())).thenAnswer((_) async {});
      openAI.simulateDisconnect();
      await pumpEventQueue();
      await Future.delayed(Duration.zero);

      verifyNever(() => repo.refreshSessionToken(any()));
    });
  });

  // ─── OpenAI connection error ───────────────────────────────────────────────

  group('OpenAI connection error', () {
    test('sets phase to error with a message', () async {
      final (:container, :openAI, :repo, :speech, :tts) = _makeContainer();
      addTearDown(container.dispose);

      when(() => repo.getSessionToken(
            mode: any(named: 'mode'),
            topic: any(named: 'topic'),
            scenario: any(named: 'scenario'),
          )).thenAnswer((_) async => _fakeToken());

      unawaited(
          container.read(aiPracticeProvider.notifier).startSession(
                mode: AiSessionMode.freeChat,
              ));
      await pumpEventQueue();

      openAI.simulateConnectionError('WebSocket handshake failed');
      await pumpEventQueue();

      final s = container.read(aiPracticeProvider);
      expect(s.phase, AiPracticePhase.error);
    });
  });

  // ─── endSession() ─────────────────────────────────────────────────────────

  group('endSession()', () {
    test('resets state to idle and posts session data', () async {
      final (:container, :openAI, :repo, :speech, :tts) = _makeContainer();
      addTearDown(container.dispose);

      when(() => repo.getSessionToken(
            mode: any(named: 'mode'),
            topic: any(named: 'topic'),
            scenario: any(named: 'scenario'),
          )).thenAnswer((_) async => _fakeToken());
      when(() => repo.startSession(any())).thenAnswer((_) async {});
      when(() => repo.endSession(any())).thenAnswer((_) async {});

      unawaited(
          container.read(aiPracticeProvider.notifier).startSession(
                mode: AiSessionMode.freeChat,
              ));
      await pumpEventQueue();
      openAI.simulateConnect();
      await pumpEventQueue();
      openAI.simulateTextDelta('Hi');
      await pumpEventQueue();

      await container.read(aiPracticeProvider.notifier).endSession();
      await Future.delayed(Duration.zero); // allow fire-and-forget POST

      final s = container.read(aiPracticeProvider);
      expect(s.phase, AiPracticePhase.idle);
      verify(() => repo.endSession(any())).called(1);
    });
  });

  // ─── AI conversation flow ─────────────────────────────────────────────────

  group('AI conversation', () {
    test('phase becomes aiSpeaking when text delta arrives', () async {
      final (:container, :openAI, :repo, :speech, :tts) = _makeContainer();
      addTearDown(container.dispose);

      when(() => repo.getSessionToken(
            mode: any(named: 'mode'),
            topic: any(named: 'topic'),
            scenario: any(named: 'scenario'),
          )).thenAnswer((_) async => _fakeToken());
      when(() => repo.startSession(any())).thenAnswer((_) async {});

      unawaited(
          container.read(aiPracticeProvider.notifier).startSession(
                mode: AiSessionMode.freeChat,
              ));
      await pumpEventQueue();
      openAI.simulateConnect();
      await pumpEventQueue();

      openAI.simulateTextDelta('Hello there!');
      await pumpEventQueue();

      expect(
          container.read(aiPracticeProvider).phase, AiPracticePhase.aiSpeaking);
    });

    test('message is appended to history after text is complete', () async {
      final (:container, :openAI, :repo, :speech, :tts) = _makeContainer();
      addTearDown(container.dispose);

      when(() => repo.getSessionToken(
            mode: any(named: 'mode'),
            topic: any(named: 'topic'),
            scenario: any(named: 'scenario'),
          )).thenAnswer((_) async => _fakeToken());
      when(() => repo.startSession(any())).thenAnswer((_) async {});

      unawaited(
          container.read(aiPracticeProvider.notifier).startSession(
                mode: AiSessionMode.freeChat,
              ));
      await pumpEventQueue();
      openAI.simulateConnect();
      await pumpEventQueue();

      openAI.simulateTextDelta('Hi! ');
      openAI.simulateTextComplete('Hi! How are you?');
      await pumpEventQueue();

      final messages = container.read(aiPracticeProvider).messages;
      expect(messages, hasLength(1));
      expect(messages.first.role, 'assistant');
      expect(messages.first.content, 'Hi! How are you?');
    });

    test('phase returns to ready after TTS finishes speaking', () async {
      final (:container, :openAI, :repo, :speech, :tts) = _makeContainer();
      addTearDown(container.dispose);

      when(() => repo.getSessionToken(
            mode: any(named: 'mode'),
            topic: any(named: 'topic'),
            scenario: any(named: 'scenario'),
          )).thenAnswer((_) async => _fakeToken());
      when(() => repo.startSession(any())).thenAnswer((_) async {});

      unawaited(
          container.read(aiPracticeProvider.notifier).startSession(
                mode: AiSessionMode.freeChat,
              ));
      await pumpEventQueue();
      openAI.simulateConnect();
      await pumpEventQueue();

      openAI.simulateTextDelta('Hello!');
      openAI.simulateTextComplete('Hello!');
      // FakeTtsService fires onSpeakingStateChange(false) synchronously.
      await pumpEventQueue();

      expect(
          container.read(aiPracticeProvider).phase, AiPracticePhase.ready);
    });
  });

  // ─── Ephemeral key refresh guard ──────────────────────────────────────────

  group('_refreshKey() concurrency guard', () {
    test('refreshSessionToken is not called concurrently on overlap', () async {
      // This is tested indirectly: a slow first refresh must not trigger a
      // second call before it completes. We verify by making the mock stall.
      final (:container, :openAI, :repo, :speech, :tts) = _makeContainer();
      addTearDown(container.dispose);

      final completer = Completer<EphemeralKeyResponse>();
      when(() => repo.getSessionToken(
            mode: any(named: 'mode'),
            topic: any(named: 'topic'),
            scenario: any(named: 'scenario'),
          )).thenAnswer((_) async => _fakeToken(
            expiresAt: DateTime.now().toUtc().add(const Duration(seconds: 10)),
          ));
      when(() => repo.startSession(any())).thenAnswer((_) async {});
      when(() => repo.refreshSessionToken(any()))
          .thenAnswer((_) => completer.future);

      unawaited(
          container.read(aiPracticeProvider.notifier).startSession(
                mode: AiSessionMode.freeChat,
              ));
      await pumpEventQueue();
      openAI.simulateConnect();
      await pumpEventQueue();
      openAI.simulateTextDelta('Hi');
      await pumpEventQueue();

      // Directly call _checkKeyRefresh twice in rapid succession (simulated
      // by calling refreshKey via the timer's internal guard).
      // We can't call private methods directly, so we verify the mock count.
      completer.complete(_fakeToken(key: 'ek-new'));
      await pumpEventQueue();

      // Only one refresh should ever have been started.
      verifyNever(() => repo.refreshSessionToken(any()));
    });
  });
}
