import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:speaking_club/features/mistakes/data/mistake_models.dart';
import 'package:speaking_club/features/mistakes/data/mistakes_repository.dart';
import 'package:speaking_club/features/mistakes/presentation/providers/mistakes_provider.dart';

class _MockRepo extends Mock implements MistakesRepository {}

Mistake _m({
  String id = 'm1',
  MistakeCategory category = MistakeCategory.grammar,
  bool fixed = false,
  bool savedToVocab = false,
}) =>
    Mistake(
      id: id,
      category: category,
      wrong: 'wrong',
      right: 'right',
      explanation: 'because',
      createdAt: DateTime(2024, 6, 1),
      isFixed: fixed,
      savedToVocab: savedToVocab,
    );

MistakesPage _page({
  List<Mistake>? mistakes,
  String? cursor,
  int thisWeek = 10,
  int fixed = 5,
}) =>
    MistakesPage(
      mistakes: mistakes ?? [_m()],
      summary: MistakesSummary(thisWeek: thisWeek, fixed: fixed),
      cursor: cursor,
    );

({ProviderContainer container, _MockRepo repo}) _make() {
  final repo = _MockRepo();
  final container = ProviderContainer(
    overrides: [mistakesRepositoryProvider.overrideWithValue(repo)],
  );
  return (container: container, repo: repo);
}

void main() {
  setUpAll(() {
    registerFallbackValue(MistakeCategory.grammar);
  });

  group('initial state', () {
    test('starts empty', () {
      final (:container, repo: _) = _make();
      addTearDown(container.dispose);

      final state = container.read(mistakesProvider);
      expect(state.mistakes, isEmpty);
      expect(state.isLoading, isFalse);
      expect(state.cursor, isNull);
    });
  });

  group('load', () {
    test('populates list, summary and cursor on success', () async {
      final (:container, :repo) = _make();
      addTearDown(container.dispose);

      when(() => repo.fetchMistakes(
            category: any(named: 'category'),
            fixed: any(named: 'fixed'),
          )).thenAnswer((_) async => _page(cursor: 'next'));

      await container.read(mistakesProvider.notifier).load();

      final state = container.read(mistakesProvider);
      expect(state.mistakes, hasLength(1));
      expect(state.summary.thisWeek, 10);
      expect(state.cursor, 'next');
      expect(state.hasMore, isTrue);
    });

    test('sets error on failure', () async {
      final (:container, :repo) = _make();
      addTearDown(container.dispose);

      when(() => repo.fetchMistakes(
            category: any(named: 'category'),
            fixed: any(named: 'fixed'),
          )).thenThrow(Exception('fail'));

      await container.read(mistakesProvider.notifier).load();

      final state = container.read(mistakesProvider);
      expect(state.hasError, isTrue);
      expect(state.isLoading, isFalse);
    });
  });

  group('setCategory', () {
    test('clears list and reloads with new category', () async {
      final (:container, :repo) = _make();
      addTearDown(container.dispose);

      when(() => repo.fetchMistakes(
            category: any(named: 'category'),
            fixed: any(named: 'fixed'),
          )).thenAnswer((_) async => _page());

      await container
          .read(mistakesProvider.notifier)
          .setCategory(MistakeCategory.vocabulary);

      expect(container.read(mistakesProvider).category,
          MistakeCategory.vocabulary);
      verify(() => repo.fetchMistakes(
            category: MistakeCategory.vocabulary,
            fixed: null,
          )).called(1);
    });
  });

  group('loadMore', () {
    test('appends and updates cursor', () async {
      final (:container, :repo) = _make();
      addTearDown(container.dispose);

      when(() => repo.fetchMistakes(
            category: any(named: 'category'),
            fixed: any(named: 'fixed'),
          )).thenAnswer((_) async => _page(
            mistakes: [_m(id: 'a')],
            cursor: 'cur',
          ));
      await container.read(mistakesProvider.notifier).load();

      when(() => repo.fetchMistakes(
            category: any(named: 'category'),
            fixed: any(named: 'fixed'),
            cursor: any(named: 'cursor'),
          )).thenAnswer((_) async => _page(
            mistakes: [_m(id: 'b')],
            cursor: null,
          ));
      await container.read(mistakesProvider.notifier).loadMore();

      final state = container.read(mistakesProvider);
      expect(state.mistakes.map((m) => m.id), ['a', 'b']);
      expect(state.cursor, isNull);
      expect(state.hasMore, isFalse);
    });

    test('skips when there is no cursor', () async {
      final (:container, :repo) = _make();
      addTearDown(container.dispose);

      when(() => repo.fetchMistakes(
            category: any(named: 'category'),
            fixed: any(named: 'fixed'),
          )).thenAnswer((_) async => _page(cursor: null));
      await container.read(mistakesProvider.notifier).load();

      await container.read(mistakesProvider.notifier).loadMore();

      verify(() => repo.fetchMistakes(
            category: any(named: 'category'),
            fixed: any(named: 'fixed'),
          )).called(1);
      verifyNever(() => repo.fetchMistakes(
            category: any(named: 'category'),
            fixed: any(named: 'fixed'),
            cursor: any(named: 'cursor'),
          ));
    });
  });

  group('optimistic actions', () {
    test('markFixed flips flag immediately', () async {
      final (:container, :repo) = _make();
      addTearDown(container.dispose);

      when(() => repo.fetchMistakes(
            category: any(named: 'category'),
            fixed: any(named: 'fixed'),
          )).thenAnswer((_) async => _page());
      await container.read(mistakesProvider.notifier).load();

      when(() => repo.markFixed(any())).thenAnswer((_) async {});
      await container.read(mistakesProvider.notifier).markFixed('m1');

      expect(container.read(mistakesProvider).mistakes.first.isFixed, isTrue);
    });

    test('markFixed rolls back on failure', () async {
      final (:container, :repo) = _make();
      addTearDown(container.dispose);

      when(() => repo.fetchMistakes(
            category: any(named: 'category'),
            fixed: any(named: 'fixed'),
          )).thenAnswer((_) async => _page());
      await container.read(mistakesProvider.notifier).load();

      when(() => repo.markFixed(any())).thenThrow(Exception('boom'));
      await container.read(mistakesProvider.notifier).markFixed('m1');

      expect(container.read(mistakesProvider).mistakes.first.isFixed, isFalse);
    });

    test('saveToVocab sets savedToVocab and rolls back on failure', () async {
      final (:container, :repo) = _make();
      addTearDown(container.dispose);

      when(() => repo.fetchMistakes(
            category: any(named: 'category'),
            fixed: any(named: 'fixed'),
          )).thenAnswer((_) async => _page());
      await container.read(mistakesProvider.notifier).load();

      when(() => repo.saveToVocab(any())).thenThrow(Exception('boom'));
      await container.read(mistakesProvider.notifier).saveToVocab('m1');

      expect(
        container.read(mistakesProvider).mistakes.first.savedToVocab,
        isFalse,
      );
    });
  });
}
