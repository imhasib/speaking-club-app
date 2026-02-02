import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

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

/// Interceptor to handle token refresh on 401
class TokenRefreshInterceptor extends Interceptor {
  final Dio _dio;
  final FlutterSecureStorage _secureStorage;
  final Ref _ref;
  bool _isRefreshing = false;

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
    if (err.response?.statusCode == 401 && !_isRefreshing) {
      _isRefreshing = true;

      try {
        final refreshToken = await _secureStorage.read(
          key: AppConstants.refreshTokenKey,
        );

        if (refreshToken == null) {
          _isRefreshing = false;
          return handler.next(err);
        }

        // Create a new Dio instance for refresh to avoid interceptor loop
        final refreshDio = Dio(BaseOptions(
          baseUrl: _dio.options.baseUrl,
          headers: {'Content-Type': 'application/json'},
        ));

        final response = await refreshDio.post(
          ApiEndpoints.refreshToken,
          data: {'refreshToken': refreshToken},
        );

        if (response.statusCode == 200) {
          final newAccessToken = response.data['data']['accessToken'];
          final newRefreshToken = response.data['data']['refreshToken'];

          await _secureStorage.write(
            key: AppConstants.accessTokenKey,
            value: newAccessToken,
          );
          await _secureStorage.write(
            key: AppConstants.refreshTokenKey,
            value: newRefreshToken,
          );

          // Retry the original request
          final options = err.requestOptions;
          options.headers['Authorization'] = 'Bearer $newAccessToken';

          final retryResponse = await _dio.fetch(options);
          _isRefreshing = false;
          return handler.resolve(retryResponse);
        }
      } catch (e) {
        _isRefreshing = false;
        // Clear tokens and trigger logout
        await _secureStorage.delete(key: AppConstants.accessTokenKey);
        await _secureStorage.delete(key: AppConstants.refreshTokenKey);
        // TODO: Trigger logout via ref when auth provider is implemented
      }
    }

    handler.next(err);
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

        if (data is Map<String, dynamic>) {
          message = data['message'] ?? message;
          code = data['code']?.toString();
        }

        if (statusCode == 401) {
          exception = UnauthorizedException(
            message: message,
            code: code,
            originalError: err,
          );
        } else if (statusCode == 422 || statusCode == 400) {
          Map<String, List<String>>? fieldErrors;
          if (data is Map<String, dynamic> && data['errors'] != null) {
            fieldErrors = (data['errors'] as Map<String, dynamic>).map(
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
