/// Base exception class for the app
sealed class AppException implements Exception {
  final String message;
  final String? code;
  final dynamic originalError;

  const AppException({
    required this.message,
    this.code,
    this.originalError,
  });

  @override
  String toString() => 'AppException: $message (code: $code)';
}

/// Network-related exceptions
class NetworkException extends AppException {
  const NetworkException({
    required super.message,
    super.code,
    super.originalError,
  });
}

/// Server-returned error responses
class ApiException extends AppException {
  final int? statusCode;

  const ApiException({
    required super.message,
    super.code,
    super.originalError,
    this.statusCode,
  });
}

/// Authentication-related exceptions
class AuthException extends AppException {
  const AuthException({
    required super.message,
    super.code,
    super.originalError,
  });
}

/// Token expired exception
class TokenExpiredException extends AuthException {
  const TokenExpiredException({
    super.message = 'Session expired. Please login again.',
    super.code = 'TOKEN_EXPIRED',
    super.originalError,
  });
}

/// Unauthorized exception
class UnauthorizedException extends AuthException {
  const UnauthorizedException({
    super.message = 'Unauthorized. Please login.',
    super.code = 'UNAUTHORIZED',
    super.originalError,
  });
}

/// Validation exception
class ValidationException extends AppException {
  final Map<String, List<String>>? fieldErrors;

  const ValidationException({
    required super.message,
    super.code = 'VALIDATION_ERROR',
    super.originalError,
    this.fieldErrors,
  });
}

/// Cache-related exceptions
class CacheException extends AppException {
  const CacheException({
    required super.message,
    super.code = 'CACHE_ERROR',
    super.originalError,
  });
}

/// WebRTC-related exceptions
class WebRTCException extends AppException {
  const WebRTCException({
    required super.message,
    super.code = 'WEBRTC_ERROR',
    super.originalError,
  });
}

/// Socket/WebSocket exceptions
class SocketException extends AppException {
  const SocketException({
    required super.message,
    super.code = 'SOCKET_ERROR',
    super.originalError,
  });
}
