import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:speaking_club/features/mistakes/data/mistake_models.dart';
import 'package:speaking_club/features/mistakes/data/mistakes_repository.dart';

class _MockDio extends Mock implements Dio {}

Response<T> _ok<T>(T data) => Response<T>(
      data: data,
      statusCode: 200,
      requestOptions: RequestOptions(path: ''),
    );

Map<String, dynamic> _mistakeJson({
  String id = 'm1',
  String category = 'grammar',
  bool fixed = false,
  bool savedToVocab = false,
}) =>
    {
      'id': id,
      'category': category,
      'wrong': 'I goed home',
      'right': 'I went home',
      'explanation': 'Past tense of go is went',
      'sessionLabel': 'Free Chat · May 09',
      'sessionId': 's1',
      'createdAt': '2024-06-01T10:00:00.000Z',
      'isFixed': fixed,
      'savedToVocab': savedToVocab,
    };

Map<String, dynamic> _page({
  List<Map<String, dynamic>>? mistakes,
  String? cursor,
  int thisWeek = 12,
  int fixed = 8,
}) =>
    {
      'items': mistakes ?? [_mistakeJson()],
      'summary': {
        'thisWeek': thisWeek,
        'fixed': fixed,
        'trend': '↓ 23%',
      },
      'nextCursor': cursor,
    };

void main() {
  late _MockDio dio;
  late MistakesRepository repo;

  setUpAll(() {
    registerFallbackValue(<String, dynamic>{});
  });

  setUp(() {
    dio = _MockDio();
    repo = MistakesRepository(dio: dio);
  });

  group('MistakesPage.fromApiResponse', () {
    test('parses mistakes, summary and cursor', () {
      final result = MistakesPage.fromApiResponse(_page(cursor: 'next-1'));
      expect(result.mistakes, hasLength(1));
      expect(result.mistakes.first.id, 'm1');
      expect(result.mistakes.first.category, MistakeCategory.grammar);
      expect(result.summary.thisWeek, 12);
      expect(result.summary.fixed, 8);
      expect(result.cursor, 'next-1');
    });

    test('handles empty list + null cursor', () {
      final result = MistakesPage.fromApiResponse(
        _page(mistakes: const [], cursor: null),
      );
      expect(result.mistakes, isEmpty);
      expect(result.cursor, isNull);
    });
  });

  group('fetchMistakes', () {
    test('passes filters and limit as query params', () async {
      when(() => dio.get(
            any(),
            queryParameters: any(named: 'queryParameters'),
          )).thenAnswer((_) async => _ok(_page()));

      await repo.fetchMistakes(
        category: MistakeCategory.grammar,
        fixed: false,
        cursor: 'abc',
        limit: 30,
      );

      final captured = verify(() => dio.get(
            any(),
            queryParameters: captureAny(named: 'queryParameters'),
          )).captured.first as Map<String, dynamic>;

      expect(captured['category'], 'grammar');
      expect(captured['fixed'], false);
      expect(captured['cursor'], 'abc');
      expect(captured['limit'], 30);
    });

    test('omits filters when null', () async {
      when(() => dio.get(
            any(),
            queryParameters: any(named: 'queryParameters'),
          )).thenAnswer((_) async => _ok(_page()));

      await repo.fetchMistakes();

      final captured = verify(() => dio.get(
            any(),
            queryParameters: captureAny(named: 'queryParameters'),
          )).captured.first as Map<String, dynamic>;

      expect(captured.containsKey('category'), isFalse);
      expect(captured.containsKey('fixed'), isFalse);
      expect(captured.containsKey('cursor'), isFalse);
      expect(captured['limit'], 20);
    });

    test('returns parsed MistakesPage on success', () async {
      when(() => dio.get(
            any(),
            queryParameters: any(named: 'queryParameters'),
          )).thenAnswer((_) async => _ok(_page(thisWeek: 7, fixed: 3)));

      final result = await repo.fetchMistakes();
      expect(result.summary.thisWeek, 7);
      expect(result.summary.fixed, 3);
    });

    test('unwraps DioException inner error', () async {
      final inner = Exception('network');
      when(() => dio.get(
            any(),
            queryParameters: any(named: 'queryParameters'),
          )).thenThrow(DioException(
        requestOptions: RequestOptions(path: ''),
        error: inner,
      ));

      await expectLater(
        () => repo.fetchMistakes(),
        throwsA(same(inner)),
      );
    });
  });

  group('markFixed / saveToVocab', () {
    test('markFixed calls POST /mistakes/:id/mark-fixed', () async {
      when(() => dio.post(any())).thenAnswer((_) async => _ok(null));
      await repo.markFixed('m1');
      verify(() => dio.post('/mistakes/m1/mark-fixed')).called(1);
    });

    test('saveToVocab calls POST /mistakes/:id/save-to-vocab', () async {
      when(() => dio.post(any())).thenAnswer((_) async => _ok(null));
      await repo.saveToVocab('m1');
      verify(() => dio.post('/mistakes/m1/save-to-vocab')).called(1);
    });

    test('markFixed surfaces DioException inner error', () async {
      final inner = Exception('boom');
      when(() => dio.post(any())).thenThrow(DioException(
        requestOptions: RequestOptions(path: ''),
        error: inner,
      ));
      await expectLater(() => repo.markFixed('x'), throwsA(same(inner)));
    });
  });
}
