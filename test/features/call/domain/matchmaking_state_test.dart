import 'package:flutter_test/flutter_test.dart';
import 'package:Speaking_club/features/call/domain/matchmaking_state.dart';

void main() {
  // ── computed boolean properties ────────────────────────────────────────────

  group('isWaiting', () {
    test('is true only when phase is waiting', () {
      expect(const MatchmakingState(phase: MatchmakingPhase.waiting).isWaiting,
          isTrue);
      for (final phase in MatchmakingPhase.values
          .where((p) => p != MatchmakingPhase.waiting)) {
        expect(MatchmakingState(phase: phase).isWaiting, isFalse,
            reason: 'Phase $phase should not be waiting');
      }
    });
  });

  group('isIdle', () {
    test('is true only when phase is idle', () {
      expect(const MatchmakingState().isIdle, isTrue);
      expect(const MatchmakingState(phase: MatchmakingPhase.waiting).isIdle,
          isFalse);
      expect(const MatchmakingState(phase: MatchmakingPhase.matched).isIdle,
          isFalse);
    });
  });

  group('isMatched', () {
    test('is true only when phase is matched', () {
      expect(const MatchmakingState(phase: MatchmakingPhase.matched).isMatched,
          isTrue);
      expect(const MatchmakingState().isMatched, isFalse);
    });
  });

  group('hasError', () {
    test('is true only when phase is error', () {
      expect(const MatchmakingState(phase: MatchmakingPhase.error).hasError,
          isTrue);
      expect(const MatchmakingState().hasError, isFalse);
    });
  });

  // ── formattedWaitTime ──────────────────────────────────────────────────────

  group('formattedWaitTime', () {
    test('returns "00:00" at zero seconds', () {
      expect(const MatchmakingState(waitingSeconds: 0).formattedWaitTime,
          '00:00');
    });

    test('returns "00:45" for 45 seconds', () {
      expect(const MatchmakingState(waitingSeconds: 45).formattedWaitTime,
          '00:45');
    });

    test('returns "01:00" for exactly 60 seconds', () {
      expect(const MatchmakingState(waitingSeconds: 60).formattedWaitTime,
          '01:00');
    });

    test('returns "02:30" for 150 seconds', () {
      expect(const MatchmakingState(waitingSeconds: 150).formattedWaitTime,
          '02:30');
    });

    test('returns "10:00" for 600 seconds', () {
      expect(const MatchmakingState(waitingSeconds: 600).formattedWaitTime,
          '10:00');
    });

    test('pads minutes and seconds with leading zeros', () {
      expect(const MatchmakingState(waitingSeconds: 65).formattedWaitTime,
          '01:05');
    });
  });

  // ── copyWith ───────────────────────────────────────────────────────────────

  group('copyWith', () {
    test('updates phase', () {
      const state = MatchmakingState();
      final updated = state.copyWith(phase: MatchmakingPhase.waiting);
      expect(updated.phase, MatchmakingPhase.waiting);
      expect(updated.waitingSeconds, 0);
    });

    test('updates waitingSeconds', () {
      const state = MatchmakingState(phase: MatchmakingPhase.waiting);
      final updated = state.copyWith(waitingSeconds: 30);
      expect(updated.waitingSeconds, 30);
    });

    test('clears error', () {
      const state = MatchmakingState(
        phase: MatchmakingPhase.error,
        error: 'Not connected',
      );
      final cleared = state.copyWith(phase: MatchmakingPhase.idle, error: null);
      expect(cleared.hasError, isFalse);
      expect(cleared.error, isNull);
    });
  });

  // ── equality ───────────────────────────────────────────────────────────────

  group('equality', () {
    test('two default states are equal', () {
      expect(const MatchmakingState(), equals(const MatchmakingState()));
    });

    test('states with different phases are not equal', () {
      expect(
        const MatchmakingState(phase: MatchmakingPhase.idle),
        isNot(equals(const MatchmakingState(phase: MatchmakingPhase.waiting))),
      );
    });
  });
}
