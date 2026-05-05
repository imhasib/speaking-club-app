import 'package:flutter_test/flutter_test.dart';
import 'package:Speaking_club/features/history/domain/call_history_state.dart';
import 'package:Speaking_club/shared/models/call.dart';

// ── Test fixtures ──────────────────────────────────────────────────────────

CallParticipant _participant({String id = 'u1', String name = 'Alice'}) =>
    CallParticipant(id: id, name: name);

Call _callAt(DateTime startedAt, {String id = 'c1'}) => Call(
      id: id,
      participants: [_participant(), _participant(id: 'u2', name: 'Bob')],
      initiatedBy: _participant(),
      startedAt: startedAt,
      status: CallStatus.completed,
    );

void main() {
  // ── hasMore ────────────────────────────────────────────────────────────────

  group('hasMore', () {
    test('is true when current page is less than total pages', () {
      const state = CallHistoryState(currentPage: 1, totalPages: 3);
      expect(state.hasMore, isTrue);
    });

    test('is false when on last page', () {
      const state = CallHistoryState(currentPage: 3, totalPages: 3);
      expect(state.hasMore, isFalse);
    });

    test('is false when total pages is 0', () {
      const state = CallHistoryState(currentPage: 1, totalPages: 0);
      expect(state.hasMore, isFalse);
    });

    test('is false when current page exceeds total pages', () {
      const state = CallHistoryState(currentPage: 5, totalPages: 3);
      expect(state.hasMore, isFalse);
    });
  });

  // ── isInitialized ──────────────────────────────────────────────────────────

  group('isInitialized', () {
    test('is true when totalCalls > 0', () {
      const state = CallHistoryState(totalCalls: 5);
      expect(state.isInitialized, isTrue);
    });

    test('is true when calls is empty and not loading', () {
      const state = CallHistoryState(isLoading: false);
      expect(state.isInitialized, isTrue);
    });

    test('is false when calls is empty and isLoading is true', () {
      const state = CallHistoryState(isLoading: true);
      expect(state.isInitialized, isFalse);
    });
  });

  // ── groupedCalls ───────────────────────────────────────────────────────────

  group('groupedCalls', () {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day, 12, 0);
    final yesterday = today.subtract(const Duration(days: 1));
    final threeDaysAgo = today.subtract(const Duration(days: 3));
    final tenDaysAgo = today.subtract(const Duration(days: 10));

    test('places call from today in DateGroup.today', () {
      final state = CallHistoryState(calls: [_callAt(today)]);
      final grouped = state.groupedCalls;

      expect(grouped.containsKey(DateGroup.today), isTrue);
      expect(grouped[DateGroup.today], hasLength(1));
    });

    test('places call from yesterday in DateGroup.yesterday', () {
      final state = CallHistoryState(calls: [_callAt(yesterday)]);
      final grouped = state.groupedCalls;

      expect(grouped.containsKey(DateGroup.yesterday), isTrue);
      expect(grouped[DateGroup.yesterday], hasLength(1));
    });

    test('places call from this week in DateGroup.thisWeek', () {
      final state = CallHistoryState(calls: [_callAt(threeDaysAgo)]);
      final grouped = state.groupedCalls;

      expect(grouped.containsKey(DateGroup.thisWeek), isTrue);
      expect(grouped[DateGroup.thisWeek], hasLength(1));
    });

    test('places call older than one week in DateGroup.older', () {
      final state = CallHistoryState(calls: [_callAt(tenDaysAgo)]);
      final grouped = state.groupedCalls;

      expect(grouped.containsKey(DateGroup.older), isTrue);
      expect(grouped[DateGroup.older], hasLength(1));
    });

    test('returns empty map when calls list is empty', () {
      const state = CallHistoryState();
      expect(state.groupedCalls, isEmpty);
    });

    test('removes empty groups from result', () {
      final state = CallHistoryState(calls: [_callAt(today)]);
      final grouped = state.groupedCalls;

      expect(grouped.containsKey(DateGroup.yesterday), isFalse);
      expect(grouped.containsKey(DateGroup.thisWeek), isFalse);
      expect(grouped.containsKey(DateGroup.older), isFalse);
    });

    test('distributes calls across multiple groups correctly', () {
      final state = CallHistoryState(calls: [
        _callAt(today, id: 'c1'),
        _callAt(yesterday, id: 'c2'),
        _callAt(tenDaysAgo, id: 'c3'),
      ]);
      final grouped = state.groupedCalls;

      expect(grouped[DateGroup.today], hasLength(1));
      expect(grouped[DateGroup.yesterday], hasLength(1));
      expect(grouped[DateGroup.older], hasLength(1));
      expect(grouped.containsKey(DateGroup.thisWeek), isFalse);
    });

    test('places multiple calls from same group together', () {
      final state = CallHistoryState(calls: [
        _callAt(today, id: 'c1'),
        _callAt(today, id: 'c2'),
      ]);
      final grouped = state.groupedCalls;

      expect(grouped[DateGroup.today], hasLength(2));
    });
  });

  // ── DateGroup.label ────────────────────────────────────────────────────────

  group('DateGroup label', () {
    test('today returns "Today"', () {
      expect(DateGroup.today.label, 'Today');
    });

    test('yesterday returns "Yesterday"', () {
      expect(DateGroup.yesterday.label, 'Yesterday');
    });

    test('thisWeek returns "This Week"', () {
      expect(DateGroup.thisWeek.label, 'This Week');
    });

    test('older returns "Older"', () {
      expect(DateGroup.older.label, 'Older');
    });
  });

  // ── copyWith and equality ──────────────────────────────────────────────────

  group('copyWith', () {
    test('produces new state with updated fields', () {
      const initial = CallHistoryState();
      final updated = initial.copyWith(
        isLoading: true,
        currentPage: 2,
        totalCalls: 50,
      );

      expect(updated.isLoading, isTrue);
      expect(updated.currentPage, 2);
      expect(updated.totalCalls, 50);
      expect(updated.calls, isEmpty);
    });

    test('clears error state when reset', () {
      const errored = CallHistoryState(
        hasError: true,
        errorMessage: 'Oops',
      );
      final cleared =
          errored.copyWith(hasError: false, errorMessage: null);

      expect(cleared.hasError, isFalse);
      expect(cleared.errorMessage, isNull);
    });
  });
}
