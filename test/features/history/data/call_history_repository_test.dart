import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:speaking_club/features/history/data/call_history_repository.dart';
import 'package:speaking_club/shared/models/call.dart';

class _MockDio extends Mock implements Dio {}

Response<T> _ok<T>(T data) => Response<T>(
      data: data,
      statusCode: 200,
      requestOptions: RequestOptions(path: ''),
    );

DioException _dioErr({Object? error}) => DioException(
      requestOptions: RequestOptions(path: ''),
      error: error,
    );

Map<String, dynamic> _participantJson({String id = 'u1', String name = 'Alice'}) => {
      '_id': id,
      'name': name,
      'profilePicture': null,
    };

Map<String, dynamic> _callJson({
  String id = 'c1',
  String status = 'completed',
  String? endedAt,
  int? duration,
}) =>
    {
      '_id': id,
      'participants': [_participantJson(), _participantJson(id: 'u2', name: 'Bob')],
      'initiatedBy': _participantJson(),
      'startedAt': '2024-06-01T10:00:00.000Z',
      if (endedAt != null) 'endedAt': endedAt,
      'status': status,
      if (duration != null) 'duration': duration,
      'callType': 'random',
    };

Map<String, dynamic> _pagedResponse({
  List<Map<String, dynamic>>? calls,
  int page = 1,
  int limit = 20,
  int total = 1,
  int pages = 1,
}) =>
    {
      'data': calls ?? [_callJson()],
      'pagination': {
        'page': page,
        'limit': limit,
        'total': total,
        'pages': pages,
      },
    };

void main() {
  late _MockDio dio;
  late CallHistoryRepository repo;

  setUp(() {
    dio = _MockDio();
    repo = CallHistoryRepository(dio: dio);
  });

  // ── PaginatedCallHistory.fromApiResponse ───────────────────────────────────

  group('PaginatedCallHistory.fromApiResponse', () {
    test('parses calls and pagination correctly', () {
      final data = _pagedResponse(page: 2, limit: 10, total: 25, pages: 3);

      final result = PaginatedCallHistory.fromApiResponse(data);

      expect(result.calls, hasLength(1));
      expect(result.page, 2);
      expect(result.limit, 10);
      expect(result.total, 25);
      expect(result.totalPages, 3);
    });

    test('hasMore is true when current page is less than total pages', () {
      final result = PaginatedCallHistory.fromApiResponse(
        _pagedResponse(page: 1, pages: 3),
      );
      expect(result.hasMore, isTrue);
    });

    test('hasMore is false when on last page', () {
      final result = PaginatedCallHistory.fromApiResponse(
        _pagedResponse(page: 3, pages: 3),
      );
      expect(result.hasMore, isFalse);
    });

    test('hasMore is false when total pages is zero', () {
      final result = PaginatedCallHistory.fromApiResponse(
        _pagedResponse(page: 1, total: 0, pages: 0, calls: []),
      );
      expect(result.hasMore, isFalse);
    });

    test('parses empty calls list', () {
      final result = PaginatedCallHistory.fromApiResponse(
        _pagedResponse(calls: [], total: 0, pages: 0),
      );
      expect(result.calls, isEmpty);
    });

    test('parses multiple calls', () {
      final result = PaginatedCallHistory.fromApiResponse(
        _pagedResponse(
          calls: [_callJson(id: 'c1'), _callJson(id: 'c2')],
          total: 2,
          pages: 1,
        ),
      );
      expect(result.calls, hasLength(2));
      expect(result.calls.first.id, 'c1');
      expect(result.calls.last.id, 'c2');
    });

    test('parses all CallStatus values', () {
      for (final status in ['completed', 'missed', 'cancelled', 'rejected']) {
        final result = PaginatedCallHistory.fromApiResponse(
          _pagedResponse(calls: [_callJson(status: status)]),
        );
        expect(result.calls.first.status, isNotNull);
      }
    });
  });

  // ── getCallHistory ─────────────────────────────────────────────────────────

  group('getCallHistory', () {
    test('calls correct endpoint with default page and limit', () async {
      when(() => dio.get(
            any(),
            queryParameters: any(named: 'queryParameters'),
          )).thenAnswer((_) async => _ok(_pagedResponse()));

      await repo.getCallHistory();

      final captured = verify(() => dio.get(
            any(),
            queryParameters: captureAny(named: 'queryParameters'),
          )).captured.first as Map<String, dynamic>;

      expect(captured['page'], 1);
      expect(captured['limit'], 20);
    });

    test('passes custom page and limit parameters', () async {
      when(() => dio.get(
            any(),
            queryParameters: any(named: 'queryParameters'),
          )).thenAnswer((_) async => _ok(_pagedResponse(page: 2, limit: 10)));

      await repo.getCallHistory(page: 2, limit: 10);

      final captured = verify(() => dio.get(
            any(),
            queryParameters: captureAny(named: 'queryParameters'),
          )).captured.first as Map<String, dynamic>;

      expect(captured['page'], 2);
      expect(captured['limit'], 10);
    });

    test('returns PaginatedCallHistory on success', () async {
      when(() => dio.get(
            any(),
            queryParameters: any(named: 'queryParameters'),
          )).thenAnswer(
        (_) async => _ok(_pagedResponse(page: 1, total: 5, pages: 1)),
      );

      final result = await repo.getCallHistory();
      expect(result.total, 5);
      expect(result.calls, hasLength(1));
    });

    test('throws inner DioException error on failure', () async {
      final inner = Exception('network error');
      when(() => dio.get(
            any(),
            queryParameters: any(named: 'queryParameters'),
          )).thenThrow(DioException(
        requestOptions: RequestOptions(path: ''),
        error: inner,
      ));

      await expectLater(
        () => repo.getCallHistory(),
        throwsA(same(inner)),
      );
    });

    test('throws DioException itself when inner error is null', () async {
      when(() => dio.get(
            any(),
            queryParameters: any(named: 'queryParameters'),
          )).thenThrow(
        DioException(requestOptions: RequestOptions(path: '')),
      );

      await expectLater(
        () => repo.getCallHistory(),
        throwsA(isA<DioException>()),
      );
    });
  });

  // ── getCallDetails ─────────────────────────────────────────────────────────

  group('getCallDetails', () {
    test('returns Call on success', () async {
      when(() => dio.get(any())).thenAnswer(
        (_) async => _ok({'data': _callJson(id: 'call-xyz')}),
      );

      final call = await repo.getCallDetails('call-xyz');
      expect(call.id, 'call-xyz');
      expect(call.status, CallStatus.completed);
    });

    test('throws inner DioException error on failure', () async {
      final inner = Exception('not found');
      when(() => dio.get(any())).thenThrow(DioException(
        requestOptions: RequestOptions(path: ''),
        error: inner,
      ));

      await expectLater(
        () => repo.getCallDetails('bad-id'),
        throwsA(same(inner)),
      );
    });
  });
}
