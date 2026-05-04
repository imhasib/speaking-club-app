import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/errors/app_exception.dart';
import '../../../../shared/models/auth_tokens.dart';
import '../../../../shared/models/user.dart';
import '../../../profile/presentation/providers/profile_provider.dart';
import '../../../realtime/data/socket_service.dart';
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
            name: user.name,
            email: user.email,
            mobileNumber: user.mobileNumber,
            profilePicture: user.profilePicture,
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
  /// user must log in separately. Returns the server's success message on
  /// success (or a default message if the server did not provide one), or
  /// `null` on failure. The caller is responsible for routing to the
  /// registration-success screen.
  Future<String?> register({
    required String name,
    required String email,
    required String mobileNumber,
    required String password,
  }) async {
    state = const AuthState.loading();

    try {
      final message = await _authRepository.register(
        RegisterRequest(
          name: name,
          email: email,
          mobileNumber: mobileNumber,
          password: password,
        ),
      );
      state = const AuthState.unauthenticated();
      return message ?? 'Account created successfully.';
    } on AppException catch (e) {
      state = AuthState.error(message: e.message, code: e.code);
      return null;
    } catch (_) {
      state = const AuthState.error(
        message: 'Registration failed. Please try again.',
        code: 'UNKNOWN_ERROR',
      );
      return null;
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

  /// Called when the refresh token is no longer valid (server rejected it
  /// with 401/403, or no refresh token is stored). Clears local session
  /// state without calling the server logout endpoint, since the credentials
  /// we'd send have already been rejected.
  Future<void> sessionExpired() async {
    if (state is AuthStateUnauthenticated) return;
    try {
      await _googleAuthService.signOut();
    } catch (_) {
      // Ignore — we still want to clear local state below.
    }
    try {
      ref.read(socketServiceProvider).disconnect();
    } catch (_) {
      // Socket may not be initialized at this point (e.g. cold-start refresh).
    }
    await _authRepository.clearTokens();
    ref.invalidate(profileDataProvider);
    state = const AuthState.unauthenticated();
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
