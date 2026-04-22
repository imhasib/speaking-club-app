import 'dart:developer' as dev;

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../../core/constants/api_endpoints.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/errors/app_exception.dart';
import '../../../shared/models/auth_tokens.dart';
import '../../../shared/models/user.dart';
import '../../../shared/providers/core_providers.dart';

/// Auth repository provider
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  final secureStorage = ref.watch(secureStorageProvider);
  return AuthRepository(
    dio: apiClient.dio,
    secureStorage: secureStorage,
  );
});

/// Repository for authentication operations
class AuthRepository {
  final Dio _dio;
  final FlutterSecureStorage _secureStorage;

  AuthRepository({
    required Dio dio,
    required FlutterSecureStorage secureStorage,
  })  : _dio = dio,
        _secureStorage = secureStorage;

  /// Register a new user with email and password
  Future<AuthResponse> register(RegisterRequest request) async {
    try {
      final response = await _dio.post(
        ApiEndpoints.register,
        data: request.toJson(),
      );

      final authResponse = _parseAuthResponse(response.data);
      await _saveTokens(authResponse.tokens);
      return authResponse;
    } on DioException catch (e) {
      throw e.error ?? e;
    }
  }

  /// Login with email and password
  Future<AuthResponse> login(LoginRequest request) async {
    try {
      final response = await _dio.post(
        ApiEndpoints.login,
        data: request.toJson(),
      );

      final authResponse = _parseAuthResponse(response.data);
      await _saveTokens(authResponse.tokens);
      return authResponse;
    } on DioException catch (e) {
      throw e.error ?? e;
    }
  }

  /// Parse auth response tolerating both wrapped ({data: {...}}) and flat
  /// ({user, tokens}) shapes, and user id/name field variants.
  AuthResponse _parseAuthResponse(dynamic data) {
    final raw = data as Map<String, dynamic>;
    final payload = (raw['data'] is Map<String, dynamic>)
        ? raw['data'] as Map<String, dynamic>
        : raw;

    final userJson = payload['user'] as Map<String, dynamic>;
    final tokensJson = payload['tokens'] as Map<String, dynamic>;

    return AuthResponse(
      accessToken: tokensJson['accessToken'] as String,
      refreshToken: tokensJson['refreshToken'] as String,
      user: AuthUser(
        id: (userJson['id'] ?? userJson['_id']) as String,
        username: (userJson['name'] ?? userJson['username']) as String,
        email: userJson['email'] as String,
        mobileNumber: userJson['mobileNumber'] as String?,
        avatar: (userJson['profilePicture'] ?? userJson['avatar']) as String?,
      ),
    );
  }

  /// Login with Google OAuth
  Future<AuthResponse> googleLogin(String idToken) async {
    try {
      dev.log('🌐 Sending Google ID token to server...');
      dev.log('   Endpoint: ${ApiEndpoints.googleAuth}');
      dev.log('   idToken: ${idToken.substring(0, 50)}...');

      final response = await _dio.post(
        ApiEndpoints.googleAuth,
        data: {'idToken': idToken},
      );

      dev.log('📥 Server response received:');
      dev.log('   Status: ${response.statusCode}');
      dev.log('   Data: ${response.data}');

      final authResponse = _parseAuthResponse(response.data);
      dev.log('✅ Auth response parsed successfully');
      dev.log('   User: ${authResponse.user.email}');

      await _saveTokens(authResponse.tokens);
      dev.log('💾 Tokens saved to secure storage');

      return authResponse;
    } on DioException catch (e) {
      dev.log('❌ Server error during Google login:');
      dev.log('   Status: ${e.response?.statusCode}');
      dev.log('   Response: ${e.response?.data}');
      dev.log('   Message: ${e.message}');
      throw e.error ?? e;
    }
  }

  /// Refresh access token
  Future<AuthTokens> refreshToken() async {
    try {
      final refreshToken = await _secureStorage.read(
        key: AppConstants.refreshTokenKey,
      );

      if (refreshToken == null) {
        throw const AuthException(
          message: 'No refresh token available',
          code: 'NO_REFRESH_TOKEN',
        );
      }

      final response = await _dio.post(
        ApiEndpoints.refreshToken,
        data: {'refreshToken': refreshToken},
      );

      final tokens = AuthTokens.fromJson(response.data['data']);
      await _saveTokens(tokens);
      return tokens;
    } on DioException catch (e) {
      throw e.error ?? e;
    }
  }

  /// Logout current user
  Future<void> logout() async {
    try {
      final refreshToken = await _secureStorage.read(
        key: AppConstants.refreshTokenKey,
      );
      await _dio.post(
        ApiEndpoints.logout,
        data: {'refreshToken': refreshToken ?? ''},
      );
    } catch (_) {
      // Ignore logout API errors
    } finally {
      await clearTokens();
    }
  }

  /// Get current user profile
  Future<User> getCurrentUser() async {
    try {
      final response = await _dio.get(ApiEndpoints.me);
      final raw = response.data as Map<String, dynamic>;
      final payload = raw['data'] is Map<String, dynamic>
          ? raw['data'] as Map<String, dynamic>
          : raw;
      return User.fromJson(payload);
    } on DioException catch (e) {
      throw e.error ?? e;
    }
  }

  /// Check if user is authenticated
  Future<bool> isAuthenticated() async {
    final token = await _secureStorage.read(key: AppConstants.accessTokenKey);
    return token != null;
  }

  /// Get stored access token
  Future<String?> getAccessToken() async {
    return _secureStorage.read(key: AppConstants.accessTokenKey);
  }

  /// Get stored refresh token
  Future<String?> getRefreshToken() async {
    return _secureStorage.read(key: AppConstants.refreshTokenKey);
  }

  /// Save tokens to secure storage
  Future<void> _saveTokens(AuthTokens tokens) async {
    await Future.wait([
      _secureStorage.write(
        key: AppConstants.accessTokenKey,
        value: tokens.accessToken,
      ),
      _secureStorage.write(
        key: AppConstants.refreshTokenKey,
        value: tokens.refreshToken,
      ),
    ]);
  }

  /// Clear stored tokens
  Future<void> clearTokens() async {
    await Future.wait([
      _secureStorage.delete(key: AppConstants.accessTokenKey),
      _secureStorage.delete(key: AppConstants.refreshTokenKey),
      _secureStorage.delete(key: AppConstants.userDataKey),
      // Clear welcome seen flag so user sees welcome screen after logout
      _secureStorage.delete(key: AppConstants.welcomeSeenKey),
      // Mark onboarding complete so returning users skip it and see welcome screen
      _secureStorage.write(key: AppConstants.onboardingCompleteKey, value: 'true'),
    ]);
  }

  /// Check username availability
  Future<bool> checkUsernameAvailability(String username) async {
    try {
      final response = await _dio.get(
        '/users/check-username',
        queryParameters: {'username': username},
      );
      return response.data['data']['available'] ?? false;
    } catch (_) {
      // If endpoint doesn't exist, assume available
      return true;
    }
  }
}
