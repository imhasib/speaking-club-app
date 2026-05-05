import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:Speaking_club/features/history/data/call_history_repository.dart';
import 'package:Speaking_club/features/history/domain/call_history_state.dart';
import 'package:Speaking_club/features/history/presentation/providers/call_history_provider.dart';
import 'package:Speaking_club/shared/models/call.dart';

class _MockCallHistoryRepository extends Mock implements CallHistoryRepository {}

// ── Fixtures ───────────────────────────────────────────────────────────────

CallParticipant _participant() => const CallParticipant(id: 'u1', name: 'Alice');

Call _call({String id = 'c1'}) => Call(
      id: id,
      participants: [_participant()],
      initiatedBy: _participant(),
      startedAt: DateTime(2024, 6, 1),
      status: CallStatus.completed,
    );

PaginatedCallHistory _page({
  List<Call>? calls,
  int page = 1,
  int totalPages = 1,
  int total = 1,
}) =>
    PaginatedCallHistory(
      calls: calls ?? [_call()],
      page: page,
      limit: 20,
      total: total,
      totalPages: totalPages,
    );

// ── Container factory ──────────────────────────────────────────────────────

({
  ProviderContainer container,
  _MockCallHistoryRepository repo,
}) _makeContainer() {
  final repo = _MockCallHistoryRepository();
  final container = ProviderContainer(
    overrides: [
      callHistoryRepositoryProvider.overrideWithValue(repo),
    ],
  );
  return (container: container, repo: repo);
}

void main() {
  // ── initial state ──────────────────────────────────────────────────────────

  group('initial state', () {
    test('has default empty values', () {
      final (:container, repo: _) = _makeContainer();
      addTearDown(container.dispose);

      final state = container.read(callHistoryProvider);
      expect(state.calls, isEmpty);
      expect(state.isLoading, isFalse);
      expect(state.hasError, isFalse);
      expect(state.currentPage, 1);
    });
  });

  // ── loadCallHistory ────────────────────────────────────────────────────────

  group('loadCallHistory', () {
    test('sets loading then populates state on success', () async {
      final (:container, :repo) = _makeContainer();
      addTearDown(container.dispose);

      final states = <CallHistoryState>[];
      container.listen(callHistoryProvider, (_, s) => states.add(s));

      when(() => repo.getCallHistory(page: 1))
          .thenAnswer((_) async => _page(total: 3, totalPages: 1));

      await container.read(callHistoryProvider.notifier).loadCallHistory();

      expect(states.any((s) => s.isLoading), isTrue,
          reason: 'Should emit loading state');

      final finalState = container.read(callHistoryProvider);
      expect(finalState.isLoading, isFalse);
      expect(finalState.calls, hasLength(1));
      expect(finalState.totalCalls, 3);
      expect(finalState.currentPage, 1);
    });

    test('sets error state on repository failure', () async {
      final (:container, :repo) = _makeContainer();
      addTearDown(container.dispose);

      when(() => repo.getCallHistory(page: 1))
          .thenThrow(Exception('network error'));

      await container.read(callHistoryProvider.notifier).loadCallHistory();

      final state = container.read(callHistoryProvider);
      expect(state.isLoading, isFalse);
      expect(state.hasError, isTrue);
      expect(state.errorMessage, contains('network error'));
    });

    test('skips duplicate call when isLoading is already true', () async {
      final (:container, :repo) = _makeContainer();
      addTearDown(container.dispose);

      final completer = <Future<void>>[];
      when(() => repo.getCallHistory(page: 1)).thenAnswer((_) async {
        await Future.delayed(const Duration(milliseconds: 50));
        return _page();
      });

      // First call starts loading
      final first =
          container.read(callHistoryProvider.notifier).loadCallHistory();
      // Second call while still loading should be a no-op
      final second =
          container.read(callHistoryProvider.notifier).loadCallHistory();
      completer.addAll([first, second]);

      await Future.wait(completer);

      // Repository should only be called once
      verify(() => repo.getCallHistory(page: 1)).called(1);
    });
  });

  // ── loadMore ───────────────────────────────────────────────────────────────

  group('loadMore', () {
    test('appends new calls when more pages exist', () async {
      final (:container, :repo) = _makeContainer();
      addTearDown(container.dispose);

      // Setup initial state with 2 pages
      when(() => repo.getCallHistory(page: 1)).thenAnswer(
        (_) async =>
            _page(calls: [_call(id: 'c1')], totalPages: 2, total: 2),
      );
      await container.read(callHistoryProvider.notifier).loadCallHistory();

      when(() => repo.getCallHistory(page: 2)).thenAnswer(
        (_) async =>
            _page(calls: [_call(id: 'c2')], page: 2, totalPages: 2, total: 2),
      );

      await container.read(callHistoryProvider.notifier).loadMore();

      final state = container.read(callHistoryProvider);
      expect(state.calls, hasLength(2));
      expect(state.calls.map((c) => c.id), containsAll(['c1', 'c2']));
      expect(state.currentPage, 2);
      expect(state.isLoadingMore, isFalse);
    });

    test('skips when isLoadingMore is already true', () async {
      final (:container, :repo) = _makeContainer();
      addTearDown(container.dispose);

      // Set initial state with more pages
      when(() => repo.getCallHistory(page: 1)).thenAnswer(
        (_) async => _page(totalPages: 3, total: 3),
      );
      await container.read(callHistoryProvider.notifier).loadCallHistory();

      when(() => repo.getCallHistory(page: 2)).thenAnswer((_) async {
        await Future.delayed(const Duration(milliseconds: 50));
        return _page(page: 2, totalPages: 3);
      });

      final first = container.read(callHistoryProvider.notifier).loadMore();
      final second = container.read(callHistoryProvider.notifier).loadMore();

      await Future.wait([first, second]);

      verify(() => repo.getCallHistory(page: 2)).called(1);
    });

    test('skips when no more pages', () async {
      final (:container, :repo) = _makeContainer();
      addTearDown(container.dispose);

      when(() => repo.getCallHistory(page: 1)).thenAnswer(
        (_) async => _page(totalPages: 1, total: 1),
      );
      await container.read(callHistoryProvider.notifier).loadCallHistory();

      await container.read(callHistoryProvider.notifier).loadMore();

      // Only the initial loadCallHistory call should have been made
      verify(() => repo.getCallHistory(page: 1)).called(1);
      verifyNever(() => repo.getCallHistory(page: 2));
    });

    test('sets error state on failure', () async {
      final (:container, :repo) = _makeContainer();
      addTearDown(container.dispose);

      when(() => repo.getCallHistory(page: 1)).thenAnswer(
        (_) async => _page(totalPages: 2, total: 2),
      );
      await container.read(callHistoryProvider.notifier).loadCallHistory();

      when(() => repo.getCallHistory(page: 2))
          .thenThrow(Exception('page 2 failed'));

      await container.read(callHistoryProvider.notifier).loadMore();

      final state = container.read(callHistoryProvider);
      expect(state.hasError, isTrue);
      expect(state.isLoadingMore, isFalse);
    });
  });

  // ── refresh ────────────────────────────────────────────────────────────────

  group('refresh', () {
    test('resets state and reloads from page 1', () async {
      final (:container, :repo) = _makeContainer();
      addTearDown(container.dispose);

      // Initial load
      when(() => repo.getCallHistory(page: 1)).thenAnswer(
        (_) async => _page(calls: [_call(id: 'old')]),
      );
      await container.read(callHistoryProvider.notifier).loadCallHistory();

      // Refresh with different data
      when(() => repo.getCallHistory(page: 1)).thenAnswer(
        (_) async => _page(calls: [_call(id: 'new')], total: 5),
      );

      await container.read(callHistoryProvider.notifier).refresh();

      final state = container.read(callHistoryProvider);
      expect(state.calls.first.id, 'new');
      expect(state.totalCalls, 5);
    });
  });

  // ── clearError ─────────────────────────────────────────────────────────────

  group('clearError', () {
    test('clears hasError and errorMessage', () async {
      final (:container, :repo) = _makeContainer();
      addTearDown(container.dispose);

      when(() => repo.getCallHistory(page: 1)).thenThrow(Exception('fail'));
      await container.read(callHistoryProvider.notifier).loadCallHistory();

      expect(container.read(callHistoryProvider).hasError, isTrue);

      container.read(callHistoryProvider.notifier).clearError();

      final state = container.read(callHistoryProvider);
      expect(state.hasError, isFalse);
      expect(state.errorMessage, isNull);
    });
  });
}
