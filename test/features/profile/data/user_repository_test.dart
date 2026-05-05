import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:Speaking_club/features/profile/data/user_repository.dart';
import 'package:Speaking_club/shared/models/user.dart';

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

Map<String, dynamic> _userJson({
  String id = 'u1',
  String name = 'Alice',
  String email = 'alice@test.com',
}) =>
    {
      'id': id,
      'name': name,
      'email': email,
      'mobile': null,
      'profilePicture': null,
      'createdAt': '2024-01-01T00:00:00.000Z',
      'updatedAt': '2024-01-01T00:00:00.000Z',
    };

void main() {
  late _MockDio dio;
  late UserRepository repo;

  setUp(() {
    dio = _MockDio();
    repo = UserRepository(dio: dio);
    registerFallbackValue(FormData());
  });

  // ── getCurrentUser ─────────────────────────────────────────────────────────

  group('getCurrentUser', () {
    test('returns User from flat response', () async {
      when(() => dio.get(any())).thenAnswer(
        (_) async => _ok(_userJson()),
      );

      final user = await repo.getCurrentUser();
      expect(user.email, 'alice@test.com');
      expect(user.id, 'u1');
    });

    test('returns User from wrapped {data: ...} response', () async {
      when(() => dio.get(any())).thenAnswer(
        (_) async =>
            _ok({'data': _userJson(id: 'u2', name: 'Bob')}),
      );

      final user = await repo.getCurrentUser();
      expect(user.name, 'Bob');
      expect(user.id, 'u2');
    });

    test('throws inner DioException error on failure', () async {
      final inner = Exception('not found');
      when(() => dio.get(any())).thenThrow(_dioErr(error: inner));

      await expectLater(() => repo.getCurrentUser(), throwsA(same(inner)));
    });

    test('throws DioException itself when inner error is null', () async {
      when(() => dio.get(any())).thenThrow(_dioErr());

      await expectLater(
          () => repo.getCurrentUser(), throwsA(isA<DioException>()));
    });
  });

  // ── updateProfile ──────────────────────────────────────────────────────────

  group('updateProfile', () {
    test('sends PATCH and returns updated User from flat response', () async {
      when(() => dio.patch(any(), data: any(named: 'data'))).thenAnswer(
        (_) async => _ok(_userJson(name: 'Alice Updated')),
      );

      final user = await repo.updateProfile(
        const UpdateProfileRequest(name: 'Alice Updated'),
      );
      expect(user.name, 'Alice Updated');
    });

    test('returns User from wrapped response', () async {
      when(() => dio.patch(any(), data: any(named: 'data'))).thenAnswer(
        (_) async =>
            _ok({'data': _userJson(name: 'Bob Updated')}),
      );

      final user = await repo.updateProfile(
        const UpdateProfileRequest(name: 'Bob Updated'),
      );
      expect(user.name, 'Bob Updated');
    });

    test('throws inner DioException error on failure', () async {
      final inner = Exception('update failed');
      when(() => dio.patch(any(), data: any(named: 'data')))
          .thenThrow(_dioErr(error: inner));

      await expectLater(
        () => repo.updateProfile(const UpdateProfileRequest(name: 'New')),
        throwsA(same(inner)),
      );
    });
  });

  // ── uploadProfilePicture ───────────────────────────────────────────────────

  group('uploadProfilePicture', () {
    late Directory tempDir;
    late File tempFile;

    setUp(() async {
      tempDir = await Directory.systemTemp.createTemp('sc_test_');
      tempFile = File('${tempDir.path}/avatar.jpg');
      await tempFile.writeAsBytes([0xFF, 0xD8, 0xFF]); // JPEG magic bytes
    });

    tearDown(() async {
      await tempDir.delete(recursive: true);
    });

    test('returns image URL from server on success', () async {
      when(() => dio.post(any(), data: any(named: 'data'))).thenAnswer(
        (_) async => _ok({'data': {'url': 'https://cdn.example.com/img.jpg'}}),
      );

      final url = await repo.uploadProfilePicture(tempFile.path);
      expect(url, 'https://cdn.example.com/img.jpg');
    });

    test('throws inner DioException error on failure', () async {
      final inner = Exception('upload failed');
      when(() => dio.post(any(), data: any(named: 'data')))
          .thenThrow(_dioErr(error: inner));

      await expectLater(
        () => repo.uploadProfilePicture(tempFile.path),
        throwsA(same(inner)),
      );
    });
  });

  // ── _unwrap (private helper, tested via public methods) ────────────────────

  group('_unwrap (via getCurrentUser)', () {
    test('uses data directly when inner is not a Map', () async {
      // Response where 'data' key is absent — should use the whole response
      when(() => dio.get(any())).thenAnswer(
        (_) async => _ok(_userJson()),
      );

      final user = await repo.getCurrentUser();
      expect(user, isA<User>());
    });
  });
}
