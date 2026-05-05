import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:Speaking_club/core/constants/app_constants.dart';
import 'package:Speaking_club/core/errors/app_exception.dart';
import 'package:Speaking_club/features/auth/data/auth_repository.dart';
import 'package:Speaking_club/shared/models/user.dart';

class _MockDio extends Mock implements Dio {}

class _MockSecureStorage extends Mock implements FlutterSecureStorage {}

Response<T> _ok<T>(T data) => Response<T>(
      data: data,
      statusCode: 200,
      requestOptions: RequestOptions(path: ''),
    );

DioException _dioErr({Object? error}) => DioException(
      requestOptions: RequestOptions(path: ''),
      error: error,
    );

// Minimal valid user JSON
Map<String, dynamic> _userJson({String id = 'u1', String name = 'Alice'}) => {
      'id': id,
      'name': name,
      'email': 'alice@test.com',
      'mobile': null,
      'profilePicture': null,
      'createdAt': '2024-01-01T00:00:00.000Z',
      'updatedAt': '2024-01-01T00:00:00.000Z',
    };

Map<String, dynamic> _flatAuthData() => {
      'user': {
        'id': 'u1',
        'name': 'Alice',
        'email': 'alice@test.com',
        'mobile': null,
        'profilePicture': null,
      },
      'tokens': {
        'accessToken': 'at-test',
        'refreshToken': 'rt-test',
      },
    };

void main() {
  late _MockDio dio;
  late _MockSecureStorage storage;
  late AuthRepository repo;

  setUp(() {
    dio = _MockDio();
    storage = _MockSecureStorage();
    repo = AuthRepository(dio: dio, secureStorage: storage);
  });

  // ── register ───────────────────────────────────────────────────────────────

  group('register', () {
    const req = RegisterRequest(
      name: 'Alice',
      email: 'alice@test.com',
      mobileNumber: '01234567890',
      password: 'password123',
    );

    test('returns message when present in response', () async {
      when(() => dio.post(any(), data: any(named: 'data'))).thenAnswer(
        (_) async => _ok({'message': 'Account created successfully'}),
      );

      final result = await repo.register(req);
      expect(result, 'Account created successfully');
    });

    test('returns null when response has no message field', () async {
      when(() => dio.post(any(), data: any(named: 'data'))).thenAnswer(
        (_) async => _ok({'status': 'ok'}),
      );

      expect(await repo.register(req), isNull);
    });

    test('returns null when message is empty string', () async {
      when(() => dio.post(any(), data: any(named: 'data'))).thenAnswer(
        (_) async => _ok({'message': ''}),
      );

      expect(await repo.register(req), isNull);
    });

    test('returns null when response data is not a Map', () async {
      when(() => dio.post(any(), data: any(named: 'data'))).thenAnswer(
        (_) async => _ok('ok'),
      );

      expect(await repo.register(req), isNull);
    });

    test('throws inner error from DioException when present', () async {
      final inner = Exception('server error');
      when(() => dio.post(any(), data: any(named: 'data')))
          .thenThrow(_dioErr(error: inner));

      await expectLater(() => repo.register(req), throwsA(same(inner)));
    });

    test('throws DioException itself when inner error is null', () async {
      when(() => dio.post(any(), data: any(named: 'data')))
          .thenThrow(_dioErr());

      await expectLater(() => repo.register(req), throwsA(isA<DioException>()));
    });
  });

  // ── login ──────────────────────────────────────────────────────────────────

  group('login', () {
    const req = LoginRequest(email: 'alice@test.com', password: 'pass');

    setUp(() {
      when(() => storage.write(
            key: any(named: 'key'),
            value: any(named: 'value'),
          )).thenAnswer((_) async {});
    });

    test('parses flat response, saves tokens, returns AuthResponse', () async {
      when(() => dio.post(any(), data: any(named: 'data'))).thenAnswer(
        (_) async => _ok(_flatAuthData()),
      );

      final result = await repo.login(req);

      expect(result.user.email, 'alice@test.com');
      expect(result.accessToken, 'at-test');
      verify(() =>
          storage.write(key: AppConstants.accessTokenKey, value: 'at-test'))
          .called(1);
      verify(() =>
          storage.write(key: AppConstants.refreshTokenKey, value: 'rt-test'))
          .called(1);
    });

    test('parses wrapped {data: ...} response', () async {
      when(() => dio.post(any(), data: any(named: 'data'))).thenAnswer(
        (_) async => _ok({'data': _flatAuthData()}),
      );

      final result = await repo.login(req);
      expect(result.user.id, 'u1');
    });

    test('throws inner DioException error on failure', () async {
      final inner = Exception('401 Unauthorized');
      when(() => dio.post(any(), data: any(named: 'data')))
          .thenThrow(_dioErr(error: inner));

      await expectLater(() => repo.login(req), throwsA(same(inner)));
    });
  });

  // ── googleLogin ────────────────────────────────────────────────────────────

  group('googleLogin', () {
    setUp(() {
      when(() => storage.write(
            key: any(named: 'key'),
            value: any(named: 'value'),
          )).thenAnswer((_) async {});
    });

    // Token must be ≥50 chars because googleLogin calls substring(0, 50) for logging
  const _googleToken =
      'eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9.fake.sig-abc123456789xx';

    test('returns AuthResponse and saves tokens', () async {
      when(() => dio.post(any(), data: any(named: 'data'))).thenAnswer(
        (_) async => _ok(_flatAuthData()),
      );

      final result = await repo.googleLogin(_googleToken);
      expect(result.user.email, 'alice@test.com');
      expect(result.accessToken, 'at-test');
    });

    test('throws inner error on DioException', () async {
      final inner = Exception('google error');
      when(() => dio.post(any(), data: any(named: 'data')))
          .thenThrow(_dioErr(error: inner));

      await expectLater(
          () => repo.googleLogin(_googleToken), throwsA(same(inner)));
    });
  });

  // ── refreshToken ───────────────────────────────────────────────────────────

  group('refreshToken', () {
    setUp(() {
      when(() => storage.write(
            key: any(named: 'key'),
            value: any(named: 'value'),
          )).thenAnswer((_) async {});
    });

    test('throws AuthException when no refresh token stored', () async {
      when(() => storage.read(key: AppConstants.refreshTokenKey))
          .thenAnswer((_) async => null);

      await expectLater(
        () => repo.refreshToken(),
        throwsA(isA<AuthException>().having(
          (e) => e.code,
          'code',
          'NO_REFRESH_TOKEN',
        )),
      );
    });

    test('returns tokens from flat response and persists them', () async {
      when(() => storage.read(key: AppConstants.refreshTokenKey))
          .thenAnswer((_) async => 'old-rt');
      when(() => dio.post(any(), data: any(named: 'data'))).thenAnswer(
        (_) async => _ok({
          'accessToken': 'new-at',
          'refreshToken': 'new-rt',
        }),
      );

      final tokens = await repo.refreshToken();
      expect(tokens.accessToken, 'new-at');
      expect(tokens.refreshToken, 'new-rt');
      verify(() =>
          storage.write(key: AppConstants.accessTokenKey, value: 'new-at'))
          .called(1);
    });

    test('returns tokens from wrapped {data: ...} response', () async {
      when(() => storage.read(key: AppConstants.refreshTokenKey))
          .thenAnswer((_) async => 'old-rt');
      when(() => dio.post(any(), data: any(named: 'data'))).thenAnswer(
        (_) async => _ok({
          'data': {
            'accessToken': 'wrapped-at',
            'refreshToken': 'wrapped-rt',
          }
        }),
      );

      final tokens = await repo.refreshToken();
      expect(tokens.accessToken, 'wrapped-at');
    });

    test('throws inner error on DioException', () async {
      when(() => storage.read(key: AppConstants.refreshTokenKey))
          .thenAnswer((_) async => 'old-rt');
      final inner = Exception('network error');
      when(() => dio.post(any(), data: any(named: 'data')))
          .thenThrow(_dioErr(error: inner));

      await expectLater(() => repo.refreshToken(), throwsA(same(inner)));
    });
  });

  // ── logout ─────────────────────────────────────────────────────────────────

  group('logout', () {
    setUp(() {
      when(() => storage.read(key: any(named: 'key')))
          .thenAnswer((_) async => null);
      when(() => storage.delete(key: any(named: 'key')))
          .thenAnswer((_) async {});
      when(() => storage.write(
            key: any(named: 'key'),
            value: any(named: 'value'),
          )).thenAnswer((_) async {});
    });

    test('calls clearTokens on successful API response', () async {
      when(() => dio.post(any(), data: any(named: 'data'))).thenAnswer(
        (_) async => _ok({'message': 'logged out'}),
      );

      await repo.logout();
      verify(() => storage.delete(key: AppConstants.accessTokenKey)).called(1);
      verify(() => storage.delete(key: AppConstants.refreshTokenKey)).called(1);
    });

    test('still clears tokens when API call throws', () async {
      when(() => dio.post(any(), data: any(named: 'data')))
          .thenThrow(Exception('network'));

      await repo.logout(); // should not propagate
      verify(() => storage.delete(key: AppConstants.accessTokenKey)).called(1);
    });
  });

  // ── getCurrentUser ─────────────────────────────────────────────────────────

  group('getCurrentUser', () {
    test('returns User from flat response', () async {
      when(() => dio.get(any())).thenAnswer(
        (_) async => _ok(_userJson()),
      );

      final user = await repo.getCurrentUser();
      expect(user.email, 'alice@test.com');
    });

    test('returns User from wrapped {data: ...} response', () async {
      when(() => dio.get(any())).thenAnswer(
        (_) async => _ok({'data': _userJson(id: 'u2', name: 'Bob')}),
      );

      final user = await repo.getCurrentUser();
      expect(user.name, 'Bob');
      expect(user.id, 'u2');
    });

    test('throws DioException when request fails', () async {
      when(() => dio.get(any())).thenThrow(_dioErr());

      await expectLater(
          () => repo.getCurrentUser(), throwsA(isA<DioException>()));
    });
  });

  // ── isAuthenticated ────────────────────────────────────────────────────────

  group('isAuthenticated', () {
    test('returns true when access token exists', () async {
      when(() => storage.read(key: AppConstants.accessTokenKey))
          .thenAnswer((_) async => 'some-token');

      expect(await repo.isAuthenticated(), isTrue);
    });

    test('returns false when no access token', () async {
      when(() => storage.read(key: AppConstants.accessTokenKey))
          .thenAnswer((_) async => null);

      expect(await repo.isAuthenticated(), isFalse);
    });
  });

  // ── getAccessToken / getRefreshToken ───────────────────────────────────────

  group('getAccessToken', () {
    test('returns stored token', () async {
      when(() => storage.read(key: AppConstants.accessTokenKey))
          .thenAnswer((_) async => 'at-xyz');

      expect(await repo.getAccessToken(), 'at-xyz');
    });

    test('returns null when not stored', () async {
      when(() => storage.read(key: AppConstants.accessTokenKey))
          .thenAnswer((_) async => null);

      expect(await repo.getAccessToken(), isNull);
    });
  });

  group('getRefreshToken', () {
    test('returns stored token', () async {
      when(() => storage.read(key: AppConstants.refreshTokenKey))
          .thenAnswer((_) async => 'rt-xyz');

      expect(await repo.getRefreshToken(), 'rt-xyz');
    });

    test('returns null when not stored', () async {
      when(() => storage.read(key: AppConstants.refreshTokenKey))
          .thenAnswer((_) async => null);

      expect(await repo.getRefreshToken(), isNull);
    });
  });

  // ── clearTokens ────────────────────────────────────────────────────────────

  group('clearTokens', () {
    setUp(() {
      when(() => storage.delete(key: any(named: 'key')))
          .thenAnswer((_) async {});
      when(() => storage.write(
            key: any(named: 'key'),
            value: any(named: 'value'),
          )).thenAnswer((_) async {});
    });

    test('deletes access token', () async {
      await repo.clearTokens();
      verify(() => storage.delete(key: AppConstants.accessTokenKey)).called(1);
    });

    test('deletes refresh token', () async {
      await repo.clearTokens();
      verify(() => storage.delete(key: AppConstants.refreshTokenKey)).called(1);
    });

    test('deletes user data', () async {
      await repo.clearTokens();
      verify(() => storage.delete(key: AppConstants.userDataKey)).called(1);
    });

    test('deletes welcome seen flag', () async {
      await repo.clearTokens();
      verify(() => storage.delete(key: AppConstants.welcomeSeenKey)).called(1);
    });

    test('sets onboarding complete flag to true', () async {
      await repo.clearTokens();
      verify(() => storage.write(
            key: AppConstants.onboardingCompleteKey,
            value: 'true',
          )).called(1);
    });
  });

  // ── checkUsernameAvailability ──────────────────────────────────────────────

  group('checkUsernameAvailability', () {
    test('returns true when server says available', () async {
      when(() => dio.get(
            any(),
            queryParameters: any(named: 'queryParameters'),
          )).thenAnswer(
        (_) async => _ok({'data': {'available': true}}),
      );

      expect(await repo.checkUsernameAvailability('alice'), isTrue);
    });

    test('returns false when server says not available', () async {
      when(() => dio.get(
            any(),
            queryParameters: any(named: 'queryParameters'),
          )).thenAnswer(
        (_) async => _ok({'data': {'available': false}}),
      );

      expect(await repo.checkUsernameAvailability('taken'), isFalse);
    });

    test('returns true on any exception (graceful fallback)', () async {
      when(() => dio.get(
            any(),
            queryParameters: any(named: 'queryParameters'),
          )).thenThrow(Exception('network'));

      expect(await repo.checkUsernameAvailability('unknown'), isTrue);
    });
  });
}
