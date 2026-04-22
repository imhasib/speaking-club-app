import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/errors/app_exception.dart';
import '../../../../shared/models/auth_tokens.dart';
import '../../../../shared/models/user.dart';
import '../../../profile/presentation/providers/profile_provider.dart';
import '../../data/auth_repository.dart';
import '../../data/google_auth_service.dart';
import '../../domain/auth_state.dart';

/// Auth state notifier provider
final authProvider = NotifierProvider<AuthNotifier, AuthState>(() {
  return AuthNotifier();
});

/// Notifier for authentication state management
class AuthNotifier extends Notifier<AuthState> {
  late final AuthRepository _authRepository;
  late final GoogleAuthService _googleAuthService;

  @override
  AuthState build() {
    _authRepository = ref.watch(authRepositoryProvider);
    _googleAuthService = ref.watch(googleAuthServiceProvider);
    checkAuthStatus();
    return const AuthState.initial();
  }

  /// Check current authentication status
  Future<void> checkAuthStatus() async {
    try {
      // Quick local check - no server call needed if no token exists
      final hasToken = await _authRepository.isAuthenticated().timeout(
        const Duration(seconds: 2),
        onTimeout: () => false,
      );

      if (!hasToken) {
        // No token stored - go straight to login, no server call needed
        state = const AuthState.unauthenticated();
        return;
      }

      // Token exists - validate with server
      try {
        final user = await _authRepository.getCurrentUser();
        state = AuthState.authenticated(
          user: AuthUser(
            id: user.id,
            username: user.username,
            email: user.email,
            mobileNumber: user.mobileNumber,
            avatar: user.avatar,
          ),
        );
      } catch (e) {
        // Server validation failed - token invalid, go to login
        state = const AuthState.unauthenticated();
      }
    } catch (e) {
      state = const AuthState.unauthenticated();
    }
  }

  /// Register with email and password.
  ///
  /// The backend's register endpoint does not issue tokens — on success the
  /// user must log in separately. Returns `true` when the account was
  /// created; the caller is responsible for routing to the login screen.
  Future<bool> register({
    required String username,
    required String email,
    required String mobileNumber,
    required String password,
  }) async {
    state = const AuthState.loading();

    try {
      await _authRepository.register(
        RegisterRequest(
          username: username,
          email: email,
          mobileNumber: mobileNumber,
          password: password,
        ),
      );
      state = const AuthState.unauthenticated();
      return true;
    } on AppException catch (e) {
      state = AuthState.error(message: e.message, code: e.code);
      return false;
    } catch (_) {
      state = const AuthState.error(
        message: 'Registration failed. Please try again.',
        code: 'UNKNOWN_ERROR',
      );
      return false;
    }
  }

  /// Login with email and password
  Future<bool> login({
    required String email,
    required String password,
  }) async {
    state = const AuthState.loading();

    try {
      final response = await _authRepository.login(
        LoginRequest(
          email: email,
          password: password,
        ),
      );

      ref.invalidate(profileDataProvider);
      state = AuthState.authenticated(user: response.user);
      return true;
    } on UnauthorizedException {
      state = const AuthState.error(
        message: 'Invalid email or password',
        code: 'INVALID_CREDENTIALS',
      );
      return false;
    } on AppException catch (e) {
      state = AuthState.error(
        message: e.message,
        code: e.code,
      );
      return false;
    } catch (e) {
      state = AuthState.error(
        message: 'Login failed. Please try again.',
        code: 'UNKNOWN_ERROR',
      );
      return false;
    }
  }

  /// Login with Google
  Future<bool> googleLogin() async {
    state = const AuthState.loading();

    try {
      final idToken = await _googleAuthService.signIn();
      final response = await _authRepository.googleLogin(idToken);

      ref.invalidate(profileDataProvider);
      state = AuthState.authenticated(user: response.user);
      return true;
    } on AuthException catch (e) {
      if (e.code == 'GOOGLE_SIGN_IN_CANCELLED') {
        state = const AuthState.unauthenticated();
        return false;
      }
      state = AuthState.error(
        message: e.message,
        code: e.code,
      );
      return false;
    } on AppException catch (e) {
      state = AuthState.error(
        message: e.message,
        code: e.code,
      );
      return false;
    } catch (e) {
      state = AuthState.error(
        message: 'Google login failed. Please try again.',
        code: 'UNKNOWN_ERROR',
      );
      return false;
    }
  }

  /// Logout
  Future<void> logout() async {
    try {
      await _googleAuthService.signOut();
      await _authRepository.logout();
    } finally {
      ref.invalidate(profileDataProvider);
      state = const AuthState.unauthenticated();
    }
  }

  /// Clear error state
  void clearError() {
    if (state is AuthStateError) {
      state = const AuthState.unauthenticated();
    }
  }

  /// Update user data after profile changes
  void updateUser(AuthUser user) {
    if (state is AuthStateAuthenticated) {
      state = AuthState.authenticated(user: user);
    }
  }
}
