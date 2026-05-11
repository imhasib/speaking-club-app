import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:speaking_club/features/home/data/streak_repository.dart';

class _MockDio extends Mock implements Dio {}

Response<T> _ok<T>(T data) => Response<T>(
      data: data,
      statusCode: 200,
      requestOptions: RequestOptions(path: ''),
    );

void main() {
  late _MockDio dio;
  late StreakRepository repo;

  setUp(() {
    dio = _MockDio();
    repo = StreakRepository(dio: dio);
  });

  group('fetchStreak', () {
    test('parses streak payload', () async {
      when(() => dio.get(any())).thenAnswer(
        (_) async => _ok({
          'streakDays': 7,
          'todayMinutes': 3,
          'dailyGoalMinutes': 5,
          'weekDays': [true, true, true, true, true, true, false],
        }),
      );

      final s = await repo.fetchStreak();
      expect(s.streakDays, 7);
      expect(s.todayMinutes, 3);
      expect(s.dailyGoalMinutes, 5);
      expect(s.weekDays, hasLength(7));
      expect(s.weekDays.last, isFalse);
    });

    test('tolerates {data: {...}} envelope', () async {
      when(() => dio.get(any())).thenAnswer(
        (_) async => _ok({
          'data': {
            'streakDays': 2,
            'todayMinutes': 0,
            'dailyGoalMinutes': 5,
            'weekDays': [false, false, false, false, false, false, false],
          }
        }),
      );

      final s = await repo.fetchStreak();
      expect(s.streakDays, 2);
    });

    test('surfaces DioException inner error', () async {
      final inner = Exception('boom');
      when(() => dio.get(any())).thenThrow(DioException(
        requestOptions: RequestOptions(path: ''),
        error: inner,
      ));
      await expectLater(() => repo.fetchStreak(), throwsA(same(inner)));
    });
  });

  group('fetchStats', () {
    test('parses lifetime stats', () async {
      when(() => dio.get(any())).thenAnswer(
        (_) async => _ok({
          'totalSessions': 23,
          'totalWords': 412,
          'streakDays': 7,
          'memberSince': '2024-01-15T00:00:00.000Z',
        }),
      );

      final s = await repo.fetchStats();
      expect(s.totalSessions, 23);
      expect(s.totalWords, 412);
      expect(s.streakDays, 7);
      expect(s.memberSince?.year, 2024);
    });
  });
}
