import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:speaking_club/features/vocab/data/vocab_models.dart';
import 'package:speaking_club/features/vocab/data/vocab_repository.dart';

class _MockDio extends Mock implements Dio {}

Response<T> _ok<T>(T data) => Response<T>(
      data: data,
      statusCode: 200,
      requestOptions: RequestOptions(path: ''),
    );

Map<String, dynamic> _summaryJson() => {
      'stats': {
        'uniqueWords': 412,
        'correctUsagePct': 86,
        'sessions': 23,
        'totalHours': 2.4,
        'weeklyNewWords': 34,
        'usageTrend': '↑ 4% vs last',
      },
      'rarelyUsed': [
        {'word': 'nonetheless', 'count': 1},
      ],
      'needsImprovement': [
        {
          'word': 'amount',
          'misuses': 2,
          'example': 'I have a big amount of friends.',
          'correction': 'I have a large number of friends.',
        },
      ],
      'allWords': [
        {
          'word': 'because',
          'count': 24,
          'usagePct': 95,
          'isCorrect': true,
          'examples': [],
        },
      ],
    };

Map<String, dynamic> _wordsPageJson({String? cursor}) => {
      'items': [
        {
          'word': 'because',
          'count': 24,
          'usagePct': 95,
          'isCorrect': true,
          'examples': [],
        },
      ],
      'nextCursor': cursor,
    };

Map<String, dynamic> _wordJson(String word) => {
      'word': word,
      'count': 7,
      'usagePct': 62,
      'isCorrect': false,
      'examples': [
        {
          'sessionLabel': 'Free Chat',
          'text': 'I have a big amount of friends.',
          'highlightStart': 10,
          'highlightEnd': 16,
          'isCorrect': false,
          'correction': 'large number',
        },
      ],
    };

void main() {
  late _MockDio dio;
  late VocabRepository repo;

  setUpAll(() {
    registerFallbackValue(<String, dynamic>{});
  });

  setUp(() {
    dio = _MockDio();
    repo = VocabRepository(dio: dio);
  });

  group('fetchSummary', () {
    test('parses stats + sections', () async {
      when(() => dio.get(any())).thenAnswer((_) async => _ok(_summaryJson()));
      final s = await repo.fetchSummary();
      expect(s.stats.uniqueWords, 412);
      expect(s.stats.correctUsagePct, 86);
      expect(s.rarelyUsed, hasLength(1));
      expect(s.needsImprovement.first.word, 'amount');
      expect(s.allWords.first.word, 'because');
    });

    test('throws inner DioException error on failure', () async {
      final inner = Exception('fail');
      when(() => dio.get(any())).thenThrow(DioException(
        requestOptions: RequestOptions(path: ''),
        error: inner,
      ));
      await expectLater(() => repo.fetchSummary(), throwsA(same(inner)));
    });
  });

  group('fetchWords', () {
    test('passes search/sort/filter/cursor/limit as query params', () async {
      when(() => dio.get(
            any(),
            queryParameters: any(named: 'queryParameters'),
          )).thenAnswer((_) async => _ok(_wordsPageJson(cursor: 'c1')));

      await repo.fetchWords(
        search: 'be',
        sort: WordSort.recent,
        filter: WordFilter.errors,
        cursor: 'cur',
        limit: 25,
      );

      final captured = verify(() => dio.get(
            any(),
            queryParameters: captureAny(named: 'queryParameters'),
          )).captured.first as Map<String, dynamic>;

      expect(captured['search'], 'be');
      expect(captured['sort'], 'recent');
      expect(captured['filter'], 'errors');
      expect(captured['cursor'], 'cur');
      expect(captured['limit'], 25);
    });

    test('omits empty search string', () async {
      when(() => dio.get(
            any(),
            queryParameters: any(named: 'queryParameters'),
          )).thenAnswer((_) async => _ok(_wordsPageJson()));

      await repo.fetchWords();

      final captured = verify(() => dio.get(
            any(),
            queryParameters: captureAny(named: 'queryParameters'),
          )).captured.first as Map<String, dynamic>;

      expect(captured.containsKey('search'), isFalse);
      expect(captured['sort'], 'count');
      expect(captured['filter'], 'all');
    });

    test('returns parsed WordsPage', () async {
      when(() => dio.get(
            any(),
            queryParameters: any(named: 'queryParameters'),
          )).thenAnswer((_) async => _ok(_wordsPageJson(cursor: 'next')));
      final page = await repo.fetchWords();
      expect(page.words, hasLength(1));
      expect(page.cursor, 'next');
    });
  });

  group('fetchWordDetail', () {
    test('parses single word detail with examples', () async {
      when(() => dio.get(any()))
          .thenAnswer((_) async => _ok(_wordJson('amount')));
      final w = await repo.fetchWordDetail('amount');
      expect(w.word, 'amount');
      expect(w.examples, hasLength(1));
      expect(w.examples.first.isCorrect, isFalse);
      expect(w.examples.first.correction, 'large number');
    });

  });
}
