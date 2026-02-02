import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../../core/errors/app_exception.dart';

/// Google auth service provider
final googleAuthServiceProvider = Provider<GoogleAuthService>((ref) {
  return GoogleAuthService();
});

/// Service for Google OAuth authentication
class GoogleAuthService {
  bool _initialized = false;

  /// Initialize Google Sign-In (call once at app startup)
  Future<void> initialize() async {
    if (_initialized) return;
    await GoogleSignIn.instance.initialize();
    _initialized = true;
  }

  /// Sign in with Google and return the ID token
  Future<String> signIn() async {
    try {
      // Ensure initialized
      await initialize();

      // Disconnect first to ensure account picker is shown
      await GoogleSignIn.instance.disconnect();

      final account = await GoogleSignIn.instance.authenticate();
      if (account == null) {
        throw const AuthException(
          message: 'Google sign-in was cancelled',
          code: 'GOOGLE_SIGN_IN_CANCELLED',
        );
      }

      // authentication is now synchronous in v7.x
      final idToken = account.authentication.idToken;

      if (idToken == null) {
        throw const AuthException(
          message: 'Failed to get Google ID token',
          code: 'GOOGLE_ID_TOKEN_NULL',
        );
      }

      return idToken;
    } on GoogleSignInException catch (e) {
      if (e.code == GoogleSignInExceptionCode.canceled) {
        throw const AuthException(
          message: 'Google sign-in was cancelled',
          code: 'GOOGLE_SIGN_IN_CANCELLED',
        );
      }
      throw AuthException(
        message: 'Google sign-in failed: ${e.description}',
        code: 'GOOGLE_SIGN_IN_ERROR',
        originalError: e,
      );
    } catch (e) {
      if (e is AuthException) rethrow;
      throw AuthException(
        message: 'Google sign-in failed: ${e.toString()}',
        code: 'GOOGLE_SIGN_IN_ERROR',
        originalError: e,
      );
    }
  }

  /// Sign out from Google
  Future<void> signOut() async {
    if (!_initialized) return;
    await GoogleSignIn.instance.disconnect();
  }
}
