import 'package:flutter_test/flutter_test.dart';
import 'package:Speaking_club/core/errors/app_exception.dart';

void main() {
  group('AppException', () {
    test('NetworkException has correct message', () {
      const exception = NetworkException(
        message: 'No internet connection',
        code: 'NETWORK_ERROR',
      );

      expect(exception.message, 'No internet connection');
      expect(exception.code, 'NETWORK_ERROR');
    });

    test('ApiException includes status code', () {
      const exception = ApiException(
        message: 'Server error',
        statusCode: 500,
        code: 'SERVER_ERROR',
      );

      expect(exception.message, 'Server error');
      expect(exception.statusCode, 500);
      expect(exception.code, 'SERVER_ERROR');
    });

    test('AuthException has correct properties', () {
      const exception = AuthException(
        message: 'Invalid credentials',
        code: 'AUTH_ERROR',
      );

      expect(exception.message, 'Invalid credentials');
      expect(exception.code, 'AUTH_ERROR');
    });

    test('TokenExpiredException has default message', () {
      const exception = TokenExpiredException();

      expect(exception.message, 'Session expired. Please login again.');
      expect(exception.code, 'TOKEN_EXPIRED');
    });

    test('UnauthorizedException has default message', () {
      const exception = UnauthorizedException();

      expect(exception.message, 'Unauthorized. Please login.');
      expect(exception.code, 'UNAUTHORIZED');
    });

    test('ValidationException includes field errors', () {
      const exception = ValidationException(
        message: 'Validation failed',
        fieldErrors: {
          'email': ['Invalid email format'],
          'password': ['Password too short', 'Password needs uppercase'],
        },
      );

      expect(exception.message, 'Validation failed');
      expect(exception.fieldErrors, isNotNull);
      expect(exception.fieldErrors!['email'], contains('Invalid email format'));
      expect(exception.fieldErrors!['password']?.length, 2);
    });

    test('CacheException has correct properties', () {
      const exception = CacheException(
        message: 'Failed to read cache',
      );

      expect(exception.message, 'Failed to read cache');
      expect(exception.code, 'CACHE_ERROR');
    });

    test('WebRTCException has correct properties', () {
      const exception = WebRTCException(
        message: 'Failed to create peer connection',
      );

      expect(exception.message, 'Failed to create peer connection');
      expect(exception.code, 'WEBRTC_ERROR');
    });

    test('SocketException has correct properties', () {
      const exception = SocketException(
        message: 'Socket connection failed',
      );

      expect(exception.message, 'Socket connection failed');
      expect(exception.code, 'SOCKET_ERROR');
    });

    test('toString returns formatted message', () {
      const exception = NetworkException(
        message: 'No internet',
        code: 'NETWORK_ERROR',
      );

      expect(
        exception.toString(),
        'AppException: No internet (code: NETWORK_ERROR)',
      );
    });

    test('originalError is preserved', () {
      final originalError = Exception('Original error');
      final exception = NetworkException(
        message: 'Network error',
        originalError: originalError,
      );

      expect(exception.originalError, originalError);
    });
  });

  group('Exception type checking', () {
    test('NetworkException is AppException', () {
      const exception = NetworkException(message: 'Test');
      expect(exception, isA<AppException>());
    });

    test('ApiException is AppException', () {
      const exception = ApiException(message: 'Test');
      expect(exception, isA<AppException>());
    });

    test('TokenExpiredException is AuthException', () {
      const exception = TokenExpiredException();
      expect(exception, isA<AuthException>());
      expect(exception, isA<AppException>());
    });

    test('UnauthorizedException is AuthException', () {
      const exception = UnauthorizedException();
      expect(exception, isA<AuthException>());
      expect(exception, isA<AppException>());
    });
  });
}
