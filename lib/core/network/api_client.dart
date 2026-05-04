import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../features/auth/presentation/providers/auth_provider.dart';
import '../../features/realtime/data/socket_service.dart';
import '../constants/api_endpoints.dart';
import '../constants/app_constants.dart';
import '../errors/app_exception.dart';

/// API client configuration and provider
class ApiClient {
  final Dio _dio;
  final FlutterSecureStorage _secureStorage;
  final Ref _ref;

  ApiClient({
    required Dio dio,
    required FlutterSecureStorage secureStorage,
    required Ref ref,
  })  : _dio = dio,
        _secureStorage = secureStorage,
        _ref = ref {
    _setupInterceptors();
  }

  Dio get dio => _dio;

  void _setupInterceptors() {
    _dio.interceptors.clear();

    // Auth interceptor
    _dio.interceptors.add(AuthInterceptor(
      secureStorage: _secureStorage,
    ));

    // Token refresh interceptor
    _dio.interceptors.add(TokenRefreshInterceptor(
      dio: _dio,
      secureStorage: _secureStorage,
      ref: _ref,
    ));

    // Logging interceptor (debug only)
    if (kDebugMode) {
      _dio.interceptors.add(LogInterceptor(
        requestBody: true,
        responseBody: true,
        requestHeader: true,
        error: true,
        logPrint: (obj) => debugPrint(obj.toString()),
      ));
    }

    // Error handling interceptor
    _dio.interceptors.add(ErrorInterceptor());
  }

  /// Create base Dio instance with configuration
  static Dio createDio(String baseUrl) {
    return Dio(BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      sendTimeout: const Duration(seconds: 30),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    ));
  }
}

/// Interceptor to add JWT token to requests
class AuthInterceptor extends Interceptor {
  final FlutterSecureStorage _secureStorage;

  AuthInterceptor({required FlutterSecureStorage secureStorage})
      : _secureStorage = secureStorage;

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    // Skip auth for public endpoints
    final publicEndpoints = [
      ApiEndpoints.login,
      ApiEndpoints.register,
      ApiEndpoints.refreshToken,
    ];

    if (!publicEndpoints.any((e) => options.path.contains(e))) {
      final token = await _secureStorage.read(key: AppConstants.accessTokenKey);
      if (token != null) {
        options.headers['Authorization'] = 'Bearer $token';
      }
    }

    handler.next(options);
  }
}

/// Interceptor that refreshes the access token on 401 and replays the
/// original request. Handles concurrent 401s with a single in-flight refresh
/// (others wait for it) and prevents retry loops by tagging replayed
/// requests in `options.extra`.
class TokenRefreshInterceptor extends Interceptor {
  static const String _retriedKey = '__refreshed';

  final Dio _dio;
  final FlutterSecureStorage _secureStorage;
  final Ref _ref;

  /// Single-flight gate: while non-null, a refresh is in progress and any
  /// concurrent 401s should wait on its future instead of starting a second
  /// refresh. Resolves to the new access token, or null on failure.
  Completer<String?>? _refreshCompleter;

  TokenRefreshInterceptor({
    required Dio dio,
    required FlutterSecureStorage secureStorage,
    required Ref ref,
  })  : _dio = dio,
        _secureStorage = secureStorage,
        _ref = ref;

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    final options = err.requestOptions;
    final isUnauthorized = err.response?.statusCode == 401;
    final alreadyRetried = options.extra[_retriedKey] == true;
    final isAuthEndpoint = options.path.contains(ApiEndpoints.refreshToken) ||
        options.path.contains(ApiEndpoints.login) ||
        options.path.contains(ApiEndpoints.register);

    if (!isUnauthorized || alreadyRetried || isAuthEndpoint) {
      return handler.next(err);
    }

    final newAccessToken = await _refreshSingleFlight();
    if (newAccessToken == null) {
      return handler.next(err);
    }

    options.headers['Authorization'] = 'Bearer $newAccessToken';
    options.extra[_retriedKey] = true;

    try {
      final retryResponse = await _dio.fetch(options);
      handler.resolve(retryResponse);
    } on DioException catch (retryErr) {
      handler.next(retryErr);
    }
  }

  Future<String?> _refreshSingleFlight() {
    final existing = _refreshCompleter;
    if (existing != null) return existing.future;

    final completer = Completer<String?>();
    _refreshCompleter = completer;

    unawaited(_doRefresh().then((token) {
      completer.complete(token);
    }, onError: (Object _) {
      completer.complete(null);
    }).whenComplete(() {
      _refreshCompleter = null;
    }));

    return completer.future;
  }

  Future<String?> _doRefresh() async {
    final refreshToken = await _secureStorage.read(
      key: AppConstants.refreshTokenKey,
    );

    if (refreshToken == null) {
      await _triggerSessionExpired();
      return null;
    }

    // Use a fresh Dio that doesn't share our interceptor chain, so the
    // refresh call cannot recurse into this interceptor on its own 401.
    final refreshDio = Dio(BaseOptions(
      baseUrl: _dio.options.baseUrl,
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      sendTimeout: const Duration(seconds: 30),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    ));

    try {
      final response = await refreshDio.post(
        ApiEndpoints.refreshToken,
        data: {'refreshToken': refreshToken},
      );

      // user-service returns a flat { accessToken, refreshToken } payload.
      final raw = response.data;
      if (raw is! Map<String, dynamic>) return null;
      final payload = raw['data'] is Map<String, dynamic>
          ? raw['data'] as Map<String, dynamic>
          : raw;
      final newAccessToken = payload['accessToken'] as String?;
      final newRefreshToken = payload['refreshToken'] as String?;
      if (newAccessToken == null || newRefreshToken == null) return null;

      await Future.wait([
        _secureStorage.write(
          key: AppConstants.accessTokenKey,
          value: newAccessToken,
        ),
        _secureStorage.write(
          key: AppConstants.refreshTokenKey,
          value: newRefreshToken,
        ),
      ]);

      // Update the live socket so its next reconnect handshake uses the new
      // token. Doesn't disrupt the current connection.
      try {
        _ref.read(socketServiceProvider).updateAuthToken(newAccessToken);
      } catch (e) {
        if (kDebugMode) {
          debugPrint('Socket auth update skipped: $e');
        }
      }

      return newAccessToken;
    } on DioException catch (e) {
      // Only treat as a definitive logout when the server itself rejects the
      // refresh token. Network/timeout errors leave the user signed in so
      // they can retry once connectivity returns.
      final status = e.response?.statusCode;
      if (status == 401 || status == 403) {
        await _triggerSessionExpired();
      }
      return null;
    }
  }

  Future<void> _triggerSessionExpired() async {
    try {
      await _ref.read(authProvider.notifier).sessionExpired();
    } catch (e) {
      // Defensive fallback: if for any reason the provider isn't reachable,
      // at least scrub the stored tokens so subsequent requests don't keep
      // reusing them.
      if (kDebugMode) {
        debugPrint('sessionExpired() fallback to direct clear: $e');
      }
      await Future.wait([
        _secureStorage.delete(key: AppConstants.accessTokenKey),
        _secureStorage.delete(key: AppConstants.refreshTokenKey),
      ]);
    }
  }
}

/// Interceptor to transform errors
class ErrorInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    final AppException exception;

    switch (err.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        exception = const NetworkException(
          message: 'Connection timeout. Please check your internet connection.',
          code: 'TIMEOUT',
        );
        break;

      case DioExceptionType.connectionError:
        exception = const NetworkException(
          message: 'No internet connection.',
          code: 'NO_CONNECTION',
        );
        break;

      case DioExceptionType.badResponse:
        final statusCode = err.response?.statusCode;
        final data = err.response?.data;
        String message = 'An error occurred';
        String? code;
        Map<String, dynamic>? errorBody;

        if (data is Map<String, dynamic>) {
          // Server wraps errors as { "error": { "message": "...", "code": "..." } }.
          // Tolerate a flat { "message": "..." } shape too.
          final inner = data['error'];
          errorBody = inner is Map<String, dynamic> ? inner : data;
          message = (errorBody['message'] as String?) ?? message;
          code = errorBody['code']?.toString();
        }

        if (statusCode == 401) {
          exception = UnauthorizedException(
            message: message,
            code: code,
            originalError: err,
          );
        } else if (statusCode == 422 || statusCode == 400) {
          Map<String, List<String>>? fieldErrors;
          if (errorBody != null && errorBody['errors'] != null) {
            fieldErrors = (errorBody['errors'] as Map<String, dynamic>).map(
              (key, value) => MapEntry(
                key,
                (value as List).map((e) => e.toString()).toList(),
              ),
            );
          }
          exception = ValidationException(
            message: message,
            code: code,
            fieldErrors: fieldErrors,
            originalError: err,
          );
        } else {
          exception = ApiException(
            message: message,
            code: code,
            statusCode: statusCode,
            originalError: err,
          );
        }
        break;

      case DioExceptionType.cancel:
        exception = const NetworkException(
          message: 'Request cancelled',
          code: 'CANCELLED',
        );
        break;

      default:
        exception = NetworkException(
          message: err.message ?? 'An unknown error occurred',
          code: 'UNKNOWN',
          originalError: err,
        );
    }

    handler.next(DioException(
      requestOptions: err.requestOptions,
      error: exception,
      type: err.type,
      response: err.response,
    ));
  }
}
