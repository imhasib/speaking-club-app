import 'dart:developer' as dev;

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../../core/config/env.dart';
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
    dev.log('🔐 Initializing Google Sign-In with serverClientId: ${Env.googleClientId}');
    await GoogleSignIn.instance.initialize(
      serverClientId: Env.googleClientId,
    );
    _initialized = true;
    dev.log('✅ Google Sign-In initialized');
  }

  /// Sign in with Google and return the ID token
  ///
  /// Set [forceAccountPicker] to true to show account picker even if already signed in
  Future<String> signIn({bool forceAccountPicker = false}) async {
    try {
      // Ensure initialized
      await initialize();

      GoogleSignInAccount? account;

      if (forceAccountPicker) {
        // Force disconnect to show account picker
        dev.log('🔄 Forcing account picker...');
        await GoogleSignIn.instance.disconnect();
      } else {
        // Try lightweight (silent) sign-in first (uses cached credentials)
        dev.log('🔇 Attempting lightweight authentication...');
        account = await GoogleSignIn.instance.attemptLightweightAuthentication();
        if (account != null) {
          dev.log('✅ Lightweight authentication successful');
        } else {
          dev.log('ℹ️ Lightweight auth returned null, will show interactive auth');
        }
      }

      // If silent sign-in failed, show interactive authentication
      if (account == null) {
        dev.log('🚀 Starting interactive Google authentication...');
        account = await GoogleSignIn.instance.authenticate();
      }

      dev.log('📦 Google response received:');
      dev.log('   account: $account');

      if (account == null) {
        dev.log('❌ Account is null - sign-in was cancelled');
        throw const AuthException(
          message: 'Google sign-in was cancelled',
          code: 'GOOGLE_SIGN_IN_CANCELLED',
        );
      }

      dev.log('👤 Account details:');
      dev.log('   email: ${account.email}');
      dev.log('   displayName: ${account.displayName}');
      dev.log('   id: ${account.id}');
      dev.log('   photoUrl: ${account.photoUrl}');

      // authentication is now synchronous in v7.x
      final idToken = account.authentication.idToken;

      dev.log('🎫 Authentication tokens:');
      dev.log('   idToken: ${idToken != null ? '${idToken.substring(0, 50)}...' : 'NULL'}');

      if (idToken == null) {
        dev.log('❌ ID token is null');
        throw const AuthException(
          message: 'Failed to get Google ID token',
          code: 'GOOGLE_ID_TOKEN_NULL',
        );
      }

      dev.log('✅ Google sign-in successful, returning ID token');
      return idToken;
    } on GoogleSignInException catch (e) {
      dev.log('❌ GoogleSignInException: code=${e.code}, description=${e.description}');
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
    } catch (e, stackTrace) {
      dev.log('❌ Exception during Google sign-in: $e');
      dev.log('   Stack trace: $stackTrace');
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
