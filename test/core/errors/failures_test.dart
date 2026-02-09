import 'package:flutter_test/flutter_test.dart';
import 'package:Speaking_club/core/errors/failures.dart';

void main() {
  group('Failure', () {
    group('ServerFailure', () {
      test('creates server failure with message', () {
        const failure = ServerFailure(message: 'Server error');

        expect(failure.message, 'Server error');
        expect(failure.statusCode, isNull);
      });

      test('creates server failure with status code', () {
        const failure = ServerFailure(
          message: 'Internal server error',
          statusCode: 500,
          code: 'SERVER_ERROR',
        );

        expect(failure.message, 'Internal server error');
        expect(failure.statusCode, 500);
        expect(failure.code, 'SERVER_ERROR');
      });

      test('props includes statusCode', () {
        const failure1 = ServerFailure(message: 'Error', statusCode: 500);
        const failure2 = ServerFailure(message: 'Error', statusCode: 500);
        const failure3 = ServerFailure(message: 'Error', statusCode: 404);

        expect(failure1.props, equals(failure2.props));
        expect(failure1.props, isNot(equals(failure3.props)));
      });
    });

    group('NetworkFailure', () {
      test('has default message', () {
        const failure = NetworkFailure();

        expect(failure.message, 'No internet connection');
        expect(failure.code, 'NETWORK_ERROR');
      });

      test('accepts custom message', () {
        const failure = NetworkFailure(message: 'Connection timeout');

        expect(failure.message, 'Connection timeout');
      });
    });

    group('CacheFailure', () {
      test('has default message', () {
        const failure = CacheFailure();

        expect(failure.message, 'Cache error occurred');
        expect(failure.code, 'CACHE_ERROR');
      });

      test('accepts custom message', () {
        const failure = CacheFailure(message: 'Failed to write cache');

        expect(failure.message, 'Failed to write cache');
      });
    });

    group('AuthFailure', () {
      test('creates auth failure with message', () {
        const failure = AuthFailure(message: 'Invalid token');

        expect(failure.message, 'Invalid token');
      });

      test('accepts code', () {
        const failure = AuthFailure(
          message: 'Session expired',
          code: 'TOKEN_EXPIRED',
        );

        expect(failure.code, 'TOKEN_EXPIRED');
      });
    });

    group('ValidationFailure', () {
      test('creates validation failure with message', () {
        const failure = ValidationFailure(message: 'Validation failed');

        expect(failure.message, 'Validation failed');
        expect(failure.code, 'VALIDATION_ERROR');
      });

      test('includes field errors', () {
        const failure = ValidationFailure(
          message: 'Validation failed',
          fieldErrors: {
            'email': ['Invalid email'],
            'password': ['Too short'],
          },
        );

        expect(failure.fieldErrors, isNotNull);
        expect(failure.fieldErrors!['email'], contains('Invalid email'));
      });

      test('props includes fieldErrors', () {
        const failure1 = ValidationFailure(
          message: 'Error',
          fieldErrors: {'field': ['error']},
        );
        const failure2 = ValidationFailure(
          message: 'Error',
          fieldErrors: {'field': ['error']},
        );

        expect(failure1.props, equals(failure2.props));
      });
    });
  });

  group('Failure type checking', () {
    test('ServerFailure is Failure', () {
      const failure = ServerFailure(message: 'Test');
      expect(failure, isA<Failure>());
    });

    test('NetworkFailure is Failure', () {
      const failure = NetworkFailure();
      expect(failure, isA<Failure>());
    });

    test('CacheFailure is Failure', () {
      const failure = CacheFailure();
      expect(failure, isA<Failure>());
    });

    test('AuthFailure is Failure', () {
      const failure = AuthFailure(message: 'Test');
      expect(failure, isA<Failure>());
    });

    test('ValidationFailure is Failure', () {
      const failure = ValidationFailure(message: 'Test');
      expect(failure, isA<Failure>());
    });
  });

  group('Failure equality', () {
    test('same failures are equal', () {
      const failure1 = NetworkFailure(message: 'No connection');
      const failure2 = NetworkFailure(message: 'No connection');

      expect(failure1, equals(failure2));
    });

    test('different failures are not equal', () {
      const failure1 = NetworkFailure(message: 'No connection');
      const failure2 = NetworkFailure(message: 'Timeout');

      expect(failure1, isNot(equals(failure2)));
    });

    test('different failure types are not equal', () {
      const failure1 = NetworkFailure(message: 'Error');
      const failure2 = CacheFailure(message: 'Error');

      expect(failure1, isNot(equals(failure2)));
    });
  });
}
