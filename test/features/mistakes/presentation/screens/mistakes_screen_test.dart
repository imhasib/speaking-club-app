import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:speaking_club/features/mistakes/data/mistake_models.dart';
import 'package:speaking_club/features/mistakes/data/mistakes_repository.dart';
import 'package:speaking_club/features/mistakes/presentation/screens/mistakes_screen.dart';

class _MockRepo extends Mock implements MistakesRepository {}

Mistake _m({
  String id = 'm1',
  MistakeCategory category = MistakeCategory.grammar,
}) =>
    Mistake(
      id: id,
      category: category,
      wrong: 'I goed home',
      right: 'I went home',
      explanation: 'past tense',
      sessionLabel: 'Free Chat · May 09',
      createdAt: DateTime(2024, 6, 1),
    );

Widget _wrap(Widget child, _MockRepo repo) {
  return ProviderScope(
    overrides: [mistakesRepositoryProvider.overrideWithValue(repo)],
    child: MaterialApp(home: child),
  );
}

void main() {
  setUpAll(() {
    registerFallbackValue(MistakeCategory.grammar);
  });

  testWidgets('shows loading indicator while initial fetch is in flight',
      (tester) async {
    final repo = _MockRepo();
    when(() => repo.fetchMistakes(
          category: any(named: 'category'),
          fixed: any(named: 'fixed'),
        )).thenAnswer((_) async {
      await Future.delayed(const Duration(milliseconds: 200));
      return MistakesPage(
        mistakes: [_m()],
        summary: const MistakesSummary(thisWeek: 1, fixed: 0),
      );
    });

    await tester.pumpWidget(_wrap(const MistakesScreen(), repo));
    await tester.pump();

    expect(find.byKey(const Key('mistakes_loading')), findsOneWidget);
    await tester.pumpAndSettle();
  });

  testWidgets('renders mistakes after a successful load', (tester) async {
    final repo = _MockRepo();
    when(() => repo.fetchMistakes(
          category: any(named: 'category'),
          fixed: any(named: 'fixed'),
        )).thenAnswer((_) async => MistakesPage(
          mistakes: [
            _m(id: 'a', category: MistakeCategory.grammar),
            _m(id: 'b', category: MistakeCategory.vocabulary),
          ],
          summary: const MistakesSummary(thisWeek: 2, fixed: 1, trend: -23),
        ));

    await tester.pumpWidget(_wrap(const MistakesScreen(), repo));
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('mistake_a')), findsOneWidget);
    expect(find.byKey(const Key('mistake_b')), findsOneWidget);
    // Summary numbers are exercised at the Appium / page-object level.
  });

  testWidgets('shows empty state when list is empty', (tester) async {
    final repo = _MockRepo();
    when(() => repo.fetchMistakes(
          category: any(named: 'category'),
          fixed: any(named: 'fixed'),
        )).thenAnswer((_) async => const MistakesPage(
          mistakes: [],
          summary: MistakesSummary(),
        ));

    await tester.pumpWidget(_wrap(const MistakesScreen(), repo));
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('mistakes_empty')), findsOneWidget);
    expect(find.text('No mistakes yet'), findsOneWidget);
  });

  testWidgets('shows error state and retries on tap', (tester) async {
    final repo = _MockRepo();
    when(() => repo.fetchMistakes(
          category: any(named: 'category'),
          fixed: any(named: 'fixed'),
        )).thenThrow(Exception('boom'));

    await tester.pumpWidget(_wrap(const MistakesScreen(), repo));
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('mistakes_error')), findsOneWidget);

    // After fixing the mock, hitting retry should populate the list.
    when(() => repo.fetchMistakes(
          category: any(named: 'category'),
          fixed: any(named: 'fixed'),
        )).thenAnswer((_) async => MistakesPage(
          mistakes: [_m()],
          summary: const MistakesSummary(thisWeek: 1, fixed: 0),
        ));

    await tester.tap(find.text('Retry'));
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('mistake_m1')), findsOneWidget);
  });
}
