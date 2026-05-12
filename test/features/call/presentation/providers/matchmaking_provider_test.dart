import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:speaking_club/features/call/domain/matchmaking_state.dart';
import 'package:speaking_club/features/call/presentation/providers/matchmaking_provider.dart';
import 'package:speaking_club/features/realtime/data/socket_service.dart';

import '../../../../helpers/fake_socket_service.dart';

ProviderContainer _makeContainer({bool socketConnected = true}) {
  final socket = FakeSocketService(isConnected: socketConnected);
  return ProviderContainer(
    overrides: [
      socketServiceProvider.overrideWithValue(socket),
    ],
  );
}

void main() {
  setUpAll(() {
    WidgetsFlutterBinding.ensureInitialized();
  });

  // ── initial state ──────────────────────────────────────────────────────────

  group('initial state', () {
    test('is idle with zero waiting seconds', () {
      final container = _makeContainer();
      addTearDown(container.dispose);

      final state = container.read(matchmakingProvider);
      expect(state.phase, MatchmakingPhase.idle);
      expect(state.waitingSeconds, 0);
      expect(state.error, isNull);
    });
  });

  // ── joinQueue ──────────────────────────────────────────────────────────────

  group('joinQueue', () {
    test('transitions to waiting when socket is connected', () async {
      final container = _makeContainer(socketConnected: true);
      addTearDown(container.dispose);

      container.read(matchmakingProvider.notifier).joinQueue();
      await pumpEventQueue();

      final state = container.read(matchmakingProvider);
      expect(state.phase, MatchmakingPhase.waiting);
      expect(state.joinedAt, isNotNull);
    });

    test('calls joinMatchmaking on socket service', () async {
      final socket = FakeSocketService(isConnected: true);
      final container = ProviderContainer(overrides: [
        socketServiceProvider.overrideWithValue(socket),
      ]);
      addTearDown(container.dispose);

      container.read(matchmakingProvider.notifier).joinQueue();

      expect(socket.joinMatchmakingCalls, 1);
    });

    test('transitions to error when socket is not connected', () {
      final container = _makeContainer(socketConnected: false);
      addTearDown(container.dispose);

      container.read(matchmakingProvider.notifier).joinQueue();

      final state = container.read(matchmakingProvider);
      expect(state.phase, MatchmakingPhase.error);
      expect(state.error, isNotNull);
    });

    test('increments waitingSeconds via internal timer', () async {
      final container = _makeContainer(socketConnected: true);
      addTearDown(container.dispose);

      container.read(matchmakingProvider.notifier).joinQueue();

      // Advance fake async time
      await Future.delayed(const Duration(seconds: 2));
      await pumpEventQueue();

      expect(container.read(matchmakingProvider).waitingSeconds,
          greaterThanOrEqualTo(1));
    });
  });

  // ── leaveQueue ─────────────────────────────────────────────────────────────

  group('leaveQueue', () {
    test('resets to idle when currently waiting', () {
      final socket = FakeSocketService(isConnected: true);
      final container = ProviderContainer(overrides: [
        socketServiceProvider.overrideWithValue(socket),
      ]);
      addTearDown(container.dispose);

      container.read(matchmakingProvider.notifier).joinQueue();
      expect(container.read(matchmakingProvider).isWaiting, isTrue);

      container.read(matchmakingProvider.notifier).leaveQueue();

      final state = container.read(matchmakingProvider);
      expect(state.phase, MatchmakingPhase.idle);
    });

    test('calls leaveMatchmaking on socket', () {
      final socket = FakeSocketService(isConnected: true);
      final container = ProviderContainer(overrides: [
        socketServiceProvider.overrideWithValue(socket),
      ]);
      addTearDown(container.dispose);

      container.read(matchmakingProvider.notifier).joinQueue();
      container.read(matchmakingProvider.notifier).leaveQueue();

      expect(socket.leaveMatchmakingCalls, 1);
    });

    test('is a no-op when not in waiting state', () {
      final socket = FakeSocketService(isConnected: true);
      final container = ProviderContainer(overrides: [
        socketServiceProvider.overrideWithValue(socket),
      ]);
      addTearDown(container.dispose);

      // Never joined queue, so still idle
      container.read(matchmakingProvider.notifier).leaveQueue();

      expect(socket.leaveMatchmakingCalls, 0);
      expect(container.read(matchmakingProvider).isIdle, isTrue);
    });
  });

  // ── onMatchFound ───────────────────────────────────────────────────────────

  group('onMatchFound', () {
    test('transitions to matched phase', () {
      final container = _makeContainer(socketConnected: true);
      addTearDown(container.dispose);

      container.read(matchmakingProvider.notifier).joinQueue();
      container.read(matchmakingProvider.notifier).onMatchFound();

      expect(container.read(matchmakingProvider).phase,
          MatchmakingPhase.matched);
    });
  });

  // ── reset ──────────────────────────────────────────────────────────────────

  group('reset', () {
    test('resets to default idle state from any phase', () {
      final container = _makeContainer(socketConnected: true);
      addTearDown(container.dispose);

      container.read(matchmakingProvider.notifier).joinQueue();
      container.read(matchmakingProvider.notifier).onMatchFound();
      expect(container.read(matchmakingProvider).isMatched, isTrue);

      container.read(matchmakingProvider.notifier).reset();

      final state = container.read(matchmakingProvider);
      expect(state.phase, MatchmakingPhase.idle);
      expect(state.waitingSeconds, 0);
      expect(state.joinedAt, isNull);
    });

    test('cancels waiting timer so seconds stop incrementing', () async {
      final container = _makeContainer(socketConnected: true);
      addTearDown(container.dispose);

      container.read(matchmakingProvider.notifier).joinQueue();
      container.read(matchmakingProvider.notifier).reset();

      final secondsBefore =
          container.read(matchmakingProvider).waitingSeconds;
      await Future.delayed(const Duration(seconds: 2));
      await pumpEventQueue();

      expect(container.read(matchmakingProvider).waitingSeconds, secondsBefore);
    });
  });

  // ── clearError ─────────────────────────────────────────────────────────────

  group('clearError', () {
    test('resets to idle and clears error message', () {
      final container = _makeContainer(socketConnected: false);
      addTearDown(container.dispose);

      container.read(matchmakingProvider.notifier).joinQueue();
      expect(container.read(matchmakingProvider).hasError, isTrue);

      container.read(matchmakingProvider.notifier).clearError();

      final state = container.read(matchmakingProvider);
      expect(state.phase, MatchmakingPhase.idle);
      expect(state.error, isNull);
    });
  });
}
