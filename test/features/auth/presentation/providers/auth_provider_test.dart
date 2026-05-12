import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:speaking_club/core/errors/app_exception.dart';
import 'package:speaking_club/features/auth/data/auth_repository.dart';
import 'package:speaking_club/features/auth/data/google_auth_service.dart';
import 'package:speaking_club/features/auth/domain/auth_state.dart';
import 'package:speaking_club/features/auth/presentation/providers/auth_provider.dart';
import 'package:speaking_club/features/profile/presentation/providers/profile_provider.dart';
import 'package:speaking_club/features/realtime/data/socket_service.dart';
import 'package:speaking_club/shared/models/auth_tokens.dart';
import 'package:speaking_club/shared/models/user.dart';

import '../../../../helpers/fake_socket_service.dart';

class _MockAuthRepository extends Mock implements AuthRepository {}

class _MockGoogleAuthService extends Mock implements GoogleAuthService {}

// ── Fixtures ───────────────────────────────────────────────────────────────

const _authUser = AuthUser(id: 'u1', name: 'Alice', email: 'alice@test.com');

AuthResponse _authResponse() => const AuthResponse(
      accessToken: 'at-test',
      refreshToken: 'rt-test',
      user: _authUser,
    );

User _fullUser({String name = 'Alice'}) => User(
      id: 'u1',
      name: name,
      email: 'alice@test.com',
      createdAt: DateTime(2024, 1, 1),
      updatedAt: DateTime(2024, 1, 1),
    );

// ── Container factory ──────────────────────────────────────────────────────

({
  ProviderContainer container,
  _MockAuthRepository authRepo,
  _MockGoogleAuthService googleAuth,
  FakeSocketService socketService,
}) _makeContainer() {
  final authRepo = _MockAuthRepository();
  final googleAuth = _MockGoogleAuthService();
  final socketService = FakeSocketService();

  // Default: no token → unauthenticated after build completes
  when(() => authRepo.isAuthenticated()).thenAnswer((_) async => false);

  final container = ProviderContainer(overrides: [
    authRepositoryProvider.overrideWithValue(authRepo),
    googleAuthServiceProvider.overrideWithValue(googleAuth),
    socketServiceProvider.overrideWithValue(socketService),
    profileDataProvider.overrideWith((_) async => _fullUser()),
  ]);

  return (
    container: container,
    authRepo: authRepo,
    googleAuth: googleAuth,
    socketService: socketService,
  );
}

/// Builds the provider and waits for the initial [checkAuthStatus] to finish.
Future<void> _settle(ProviderContainer container) async {
  container.read(authProvider); // triggers build → starts checkAuthStatus
  await pumpEventQueue(); // let checkAuthStatus complete
}

void main() {
  setUpAll(() {
    WidgetsFlutterBinding.ensureInitialized();
    registerFallbackValue(
      const RegisterRequest(
        name: '',
        email: '',
        mobileNumber: '',
        password: '',
      ),
    );
    registerFallbackValue(const LoginRequest(email: '', password: ''));
  });

  // ── checkAuthStatus ────────────────────────────────────────────────────────

  group('checkAuthStatus', () {
    test('sets unauthenticated when no token stored', () async {
      final (:container, authRepo: _, googleAuth: _, socketService: _) =
          _makeContainer();
      addTearDown(container.dispose);

      await _settle(container);

      expect(container.read(authProvider), isA<AuthStateUnauthenticated>());
    });

    test('sets authenticated when token exists and server confirms', () async {
      final (:container, :authRepo, googleAuth: _, socketService: _) =
          _makeContainer();
      addTearDown(container.dispose);

      when(() => authRepo.isAuthenticated()).thenAnswer((_) async => true);
      when(() => authRepo.getCurrentUser()).thenAnswer((_) async => _fullUser());

      await _settle(container);

      expect(container.read(authProvider), isA<AuthStateAuthenticated>());
      expect(container.read(authProvider).user?.email, 'alice@test.com');
    });

    test('sets unauthenticated when server validation fails', () async {
      final (:container, :authRepo, googleAuth: _, socketService: _) =
          _makeContainer();
      addTearDown(container.dispose);

      when(() => authRepo.isAuthenticated()).thenAnswer((_) async => true);
      when(() => authRepo.getCurrentUser()).thenThrow(Exception('401'));

      await _settle(container);

      expect(container.read(authProvider), isA<AuthStateUnauthenticated>());
    });

    test('sets unauthenticated on storage exception', () async {
      final (:container, :authRepo, googleAuth: _, socketService: _) =
          _makeContainer();
      addTearDown(container.dispose);

      // Use Future.error so the exception is asynchronous (thenThrow would
      // throw synchronously during build(), before the initial state is set).
      when(() => authRepo.isAuthenticated())
          .thenAnswer((_) => Future.error(Exception('storage')));

      await _settle(container);

      expect(container.read(authProvider), isA<AuthStateUnauthenticated>());
    });
  });

  // ── register ───────────────────────────────────────────────────────────────

  group('register', () {
    test('returns server message and transitions to unauthenticated', () async {
      final (:container, :authRepo, googleAuth: _, socketService: _) =
          _makeContainer();
      addTearDown(container.dispose);
      await _settle(container);

      when(() => authRepo.register(any()))
          .thenAnswer((_) async => 'Account created successfully');

      final states = <AuthState>[];
      container.listen(authProvider, (_, s) => states.add(s));

      final msg = await container.read(authProvider.notifier).register(
            name: 'Alice',
            email: 'alice@test.com',
            mobileNumber: '01234567890',
            password: 'password123',
          );

      expect(msg, 'Account created successfully');
      expect(states.any((s) => s is AuthStateLoading), isTrue);
      expect(container.read(authProvider), isA<AuthStateUnauthenticated>());
    });

    test('returns default message when server returns null', () async {
      final (:container, :authRepo, googleAuth: _, socketService: _) =
          _makeContainer();
      addTearDown(container.dispose);
      await _settle(container);

      when(() => authRepo.register(any())).thenAnswer((_) async => null);

      final msg = await container.read(authProvider.notifier).register(
            name: 'Alice',
            email: 'alice@test.com',
            mobileNumber: '01234567890',
            password: 'password123',
          );

      expect(msg, 'Account created successfully.');
    });

    test('sets error and returns null on AppException', () async {
      final (:container, :authRepo, googleAuth: _, socketService: _) =
          _makeContainer();
      addTearDown(container.dispose);
      await _settle(container);

      when(() => authRepo.register(any())).thenThrow(
        const ApiException(message: 'Email taken', code: 'EMAIL_TAKEN'),
      );

      final msg = await container.read(authProvider.notifier).register(
            name: 'Alice',
            email: 'alice@test.com',
            mobileNumber: '01234567890',
            password: 'password123',
          );

      expect(msg, isNull);
      final state = container.read(authProvider);
      expect(state, isA<AuthStateError>());
      expect((state as AuthStateError).code, 'EMAIL_TAKEN');
    });

    test('sets UNKNOWN_ERROR and returns null on unknown exception', () async {
      final (:container, :authRepo, googleAuth: _, socketService: _) =
          _makeContainer();
      addTearDown(container.dispose);
      await _settle(container);

      when(() => authRepo.register(any())).thenThrow(Exception('boom'));

      final msg = await container.read(authProvider.notifier).register(
            name: 'Alice',
            email: 'alice@test.com',
            mobileNumber: '01234567890',
            password: 'password123',
          );

      expect(msg, isNull);
      expect(
        (container.read(authProvider) as AuthStateError).code,
        'UNKNOWN_ERROR',
      );
    });
  });

  // ── login ──────────────────────────────────────────────────────────────────

  group('login', () {
    test('returns true and authenticates on success', () async {
      final (:container, :authRepo, googleAuth: _, socketService: _) =
          _makeContainer();
      addTearDown(container.dispose);
      await _settle(container);

      when(() => authRepo.login(any())).thenAnswer((_) async => _authResponse());

      final result = await container
          .read(authProvider.notifier)
          .login(email: 'alice@test.com', password: 'pass');

      expect(result, isTrue);
      expect(container.read(authProvider), isA<AuthStateAuthenticated>());
    });

    test('returns false with INVALID_CREDENTIALS on UnauthorizedException',
        () async {
      final (:container, :authRepo, googleAuth: _, socketService: _) =
          _makeContainer();
      addTearDown(container.dispose);
      await _settle(container);

      when(() => authRepo.login(any())).thenThrow(
        const UnauthorizedException(message: 'Bad credentials'),
      );

      final result = await container
          .read(authProvider.notifier)
          .login(email: 'bad@test.com', password: 'wrong');

      expect(result, isFalse);
      expect(
        (container.read(authProvider) as AuthStateError).code,
        'INVALID_CREDENTIALS',
      );
    });

    test('returns false with error code on AppException', () async {
      final (:container, :authRepo, googleAuth: _, socketService: _) =
          _makeContainer();
      addTearDown(container.dispose);
      await _settle(container);

      when(() => authRepo.login(any())).thenThrow(
        const NetworkException(message: 'No internet', code: 'NO_INTERNET'),
      );

      final result = await container
          .read(authProvider.notifier)
          .login(email: 'alice@test.com', password: 'pass');

      expect(result, isFalse);
      expect(container.read(authProvider), isA<AuthStateError>());
    });

    test('returns false with UNKNOWN_ERROR on unexpected exception', () async {
      final (:container, :authRepo, googleAuth: _, socketService: _) =
          _makeContainer();
      addTearDown(container.dispose);
      await _settle(container);

      when(() => authRepo.login(any())).thenThrow(Exception('unexpected'));

      final result = await container
          .read(authProvider.notifier)
          .login(email: 'alice@test.com', password: 'pass');

      expect(result, isFalse);
      expect(
        (container.read(authProvider) as AuthStateError).code,
        'UNKNOWN_ERROR',
      );
    });
  });

  // ── googleLogin ────────────────────────────────────────────────────────────

  // Token ≥50 chars because googleLogin logs substring(0, 50)
  const _googleToken =
      'eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9.fake.sig-abc123456789xx';

  group('googleLogin', () {
    test('authenticates and returns true on success', () async {
      final (:container, :authRepo, :googleAuth, socketService: _) =
          _makeContainer();
      addTearDown(container.dispose);
      await _settle(container);

      when(() => googleAuth.signIn()).thenAnswer((_) async => _googleToken);
      when(() => authRepo.googleLogin(any()))
          .thenAnswer((_) async => _authResponse());

      final result =
          await container.read(authProvider.notifier).googleLogin();

      expect(result, isTrue);
      expect(container.read(authProvider), isA<AuthStateAuthenticated>());
    });

    test('returns false and sets unauthenticated on user cancel', () async {
      final (:container, authRepo: _, :googleAuth, socketService: _) =
          _makeContainer();
      addTearDown(container.dispose);
      await _settle(container);

      when(() => googleAuth.signIn()).thenThrow(
        const AuthException(
          message: 'Cancelled',
          code: 'GOOGLE_SIGN_IN_CANCELLED',
        ),
      );

      final result =
          await container.read(authProvider.notifier).googleLogin();

      expect(result, isFalse);
      expect(container.read(authProvider), isA<AuthStateUnauthenticated>());
    });

    test('sets error on non-cancellation AuthException', () async {
      final (:container, authRepo: _, :googleAuth, socketService: _) =
          _makeContainer();
      addTearDown(container.dispose);
      await _settle(container);

      when(() => googleAuth.signIn()).thenThrow(
        const AuthException(
          message: 'Google error',
          code: 'GOOGLE_SIGN_IN_ERROR',
        ),
      );

      final result =
          await container.read(authProvider.notifier).googleLogin();

      expect(result, isFalse);
      expect(container.read(authProvider), isA<AuthStateError>());
    });

    test('sets UNKNOWN_ERROR on unexpected exception', () async {
      final (:container, authRepo: _, :googleAuth, socketService: _) =
          _makeContainer();
      addTearDown(container.dispose);
      await _settle(container);

      when(() => googleAuth.signIn()).thenThrow(Exception('crash'));

      final result =
          await container.read(authProvider.notifier).googleLogin();

      expect(result, isFalse);
      expect(
        (container.read(authProvider) as AuthStateError).code,
        'UNKNOWN_ERROR',
      );
    });
  });

  // ── logout ─────────────────────────────────────────────────────────────────

  group('logout', () {
    test('transitions to unauthenticated from authenticated state', () async {
      final (:container, :authRepo, :googleAuth, socketService: _) =
          _makeContainer();
      addTearDown(container.dispose);

      // Start authenticated
      when(() => authRepo.isAuthenticated()).thenAnswer((_) async => true);
      when(() => authRepo.getCurrentUser()).thenAnswer((_) async => _fullUser());
      await _settle(container);
      expect(container.read(authProvider), isA<AuthStateAuthenticated>());

      when(() => googleAuth.signOut()).thenAnswer((_) async {});
      when(() => authRepo.logout()).thenAnswer((_) async {});

      await container.read(authProvider.notifier).logout();

      expect(container.read(authProvider), isA<AuthStateUnauthenticated>());
    });

    test('sets unauthenticated in finally even when signOut throws', () async {
      final (:container, :authRepo, :googleAuth, socketService: _) =
          _makeContainer();
      addTearDown(container.dispose);

      when(() => authRepo.isAuthenticated()).thenAnswer((_) async => true);
      when(() => authRepo.getCurrentUser()).thenAnswer((_) async => _fullUser());
      await _settle(container);
      expect(container.read(authProvider), isA<AuthStateAuthenticated>());

      when(() => googleAuth.signOut()).thenThrow(Exception('signOut failed'));

      // logout() uses try-finally so state is always set to unauthenticated,
      // but the exception from signOut() propagates to the caller.
      try {
        await container.read(authProvider.notifier).logout();
      } catch (_) {}

      expect(container.read(authProvider), isA<AuthStateUnauthenticated>());
    });
  });

  // ── sessionExpired ─────────────────────────────────────────────────────────

  group('sessionExpired', () {
    test('clears tokens and transitions to unauthenticated from authenticated',
        () async {
      final (:container, :authRepo, :googleAuth, :socketService) =
          _makeContainer();
      addTearDown(container.dispose);

      when(() => authRepo.isAuthenticated()).thenAnswer((_) async => true);
      when(() => authRepo.getCurrentUser()).thenAnswer((_) async => _fullUser());
      await _settle(container);
      expect(container.read(authProvider), isA<AuthStateAuthenticated>());

      when(() => googleAuth.signOut()).thenAnswer((_) async {});
      when(() => authRepo.clearTokens()).thenAnswer((_) async {});

      await container.read(authProvider.notifier).sessionExpired();

      expect(container.read(authProvider), isA<AuthStateUnauthenticated>());
      expect(socketService.disconnectCalls, 1);
      verify(() => authRepo.clearTokens()).called(1);
    });

    test('is a no-op when already unauthenticated', () async {
      final (:container, :authRepo, googleAuth: _, socketService: _) =
          _makeContainer();
      addTearDown(container.dispose);
      await _settle(container);
      expect(container.read(authProvider), isA<AuthStateUnauthenticated>());

      await container.read(authProvider.notifier).sessionExpired();

      verifyNever(() => authRepo.clearTokens());
    });
  });

  // ── clearError ─────────────────────────────────────────────────────────────

  group('clearError', () {
    test('resets error state to unauthenticated', () async {
      final (:container, :authRepo, googleAuth: _, socketService: _) =
          _makeContainer();
      addTearDown(container.dispose);
      await _settle(container);

      when(() => authRepo.login(any())).thenThrow(Exception('fail'));
      await container
          .read(authProvider.notifier)
          .login(email: 'x@x.com', password: 'p');
      expect(container.read(authProvider), isA<AuthStateError>());

      container.read(authProvider.notifier).clearError();

      expect(container.read(authProvider), isA<AuthStateUnauthenticated>());
    });

    test('is a no-op when not in error state', () async {
      final (:container, authRepo: _, googleAuth: _, socketService: _) =
          _makeContainer();
      addTearDown(container.dispose);
      await _settle(container);

      container.read(authProvider.notifier).clearError();

      expect(container.read(authProvider), isA<AuthStateUnauthenticated>());
    });
  });

  // ── updateUser ─────────────────────────────────────────────────────────────

  group('updateUser', () {
    test('updates the user object when authenticated', () async {
      final (:container, :authRepo, googleAuth: _, socketService: _) =
          _makeContainer();
      addTearDown(container.dispose);

      when(() => authRepo.isAuthenticated()).thenAnswer((_) async => true);
      when(() => authRepo.getCurrentUser()).thenAnswer((_) async => _fullUser());
      await _settle(container);

      const updated = AuthUser(
        id: 'u1',
        name: 'Alice Updated',
        email: 'alice@test.com',
      );
      container.read(authProvider.notifier).updateUser(updated);

      expect(container.read(authProvider).user?.name, 'Alice Updated');
    });

    test('is a no-op when not authenticated', () async {
      final (:container, authRepo: _, googleAuth: _, socketService: _) =
          _makeContainer();
      addTearDown(container.dispose);
      await _settle(container);
      expect(container.read(authProvider), isA<AuthStateUnauthenticated>());

      const updated =
          AuthUser(id: 'u1', name: 'Alice', email: 'alice@test.com');
      container.read(authProvider.notifier).updateUser(updated);

      expect(container.read(authProvider), isA<AuthStateUnauthenticated>());
    });
  });

  // ── AuthStateExtension ─────────────────────────────────────────────────────

  group('AuthStateExtension', () {
    test('isAuthenticated is true only for authenticated state', () {
      expect(
          const AuthState.authenticated(user: _authUser).isAuthenticated, isTrue);
      expect(const AuthState.unauthenticated().isAuthenticated, isFalse);
      expect(const AuthState.loading().isAuthenticated, isFalse);
      expect(const AuthState.initial().isAuthenticated, isFalse);
      expect(const AuthState.error(message: 'e').isAuthenticated, isFalse);
    });

    test('isLoading is true only for loading state', () {
      expect(const AuthState.loading().isLoading, isTrue);
      expect(const AuthState.unauthenticated().isLoading, isFalse);
    });

    test('hasError is true only for error state', () {
      expect(const AuthState.error(message: 'err').hasError, isTrue);
      expect(const AuthState.unauthenticated().hasError, isFalse);
    });

    test('user returns user only when authenticated', () {
      expect(
        const AuthState.authenticated(user: _authUser).user,
        _authUser,
      );
      expect(const AuthState.unauthenticated().user, isNull);
      expect(const AuthState.loading().user, isNull);
    });

    test('errorMessage returns message only in error state', () {
      expect(
        const AuthState.error(message: 'Something went wrong').errorMessage,
        'Something went wrong',
      );
      expect(const AuthState.unauthenticated().errorMessage, isNull);
    });
  });
}
