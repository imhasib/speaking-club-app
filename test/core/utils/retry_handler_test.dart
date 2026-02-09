import 'package:flutter_test/flutter_test.dart';
import 'package:Speaking_club/core/utils/retry_handler.dart';
import 'package:Speaking_club/core/errors/app_exception.dart';

void main() {
  group('RetryHandler', () {
    test('executes function successfully on first try', () async {
      final handler = RetryHandler(maxRetries: 3);
      var attempts = 0;

      final result = await handler.execute(() async {
        attempts++;
        return 'success';
      });

      expect(result, 'success');
      expect(attempts, 1);
    });

    test('retries on network exception', () async {
      final handler = RetryHandler(
        maxRetries: 3,
        initialDelay: const Duration(milliseconds: 10),
      );
      var attempts = 0;

      final result = await handler.execute(() async {
        attempts++;
        if (attempts < 3) {
          throw const NetworkException(message: 'Network error');
        }
        return 'success';
      });

      expect(result, 'success');
      expect(attempts, 3);
    });

    test('throws after max retries exceeded', () async {
      final handler = RetryHandler(
        maxRetries: 3,
        initialDelay: const Duration(milliseconds: 10),
      );
      var attempts = 0;

      expect(
        () => handler.execute(() async {
          attempts++;
          throw const NetworkException(message: 'Network error');
        }),
        throwsA(isA<NetworkException>()),
      );
    });

    test('does not retry on auth exception', () async {
      final handler = RetryHandler(
        maxRetries: 3,
        initialDelay: const Duration(milliseconds: 10),
      );
      var attempts = 0;

      expect(
        () => handler.execute(() async {
          attempts++;
          throw const AuthException(message: 'Auth error');
        }),
        throwsA(isA<AuthException>()),
      );

      // Give time for any async operations
      await Future.delayed(const Duration(milliseconds: 50));
      expect(attempts, 1);
    });

    test('does not retry on validation exception', () async {
      final handler = RetryHandler(
        maxRetries: 3,
        initialDelay: const Duration(milliseconds: 10),
      );
      var attempts = 0;

      expect(
        () => handler.execute(() async {
          attempts++;
          throw const ValidationException(message: 'Validation error');
        }),
        throwsA(isA<ValidationException>()),
      );

      await Future.delayed(const Duration(milliseconds: 50));
      expect(attempts, 1);
    });

    test('calls onRetry callback before each retry', () async {
      final retryAttempts = <int>[];
      final handler = RetryHandler(
        maxRetries: 3,
        initialDelay: const Duration(milliseconds: 10),
        onRetry: (error, attempt, delay) {
          retryAttempts.add(attempt);
        },
      );
      var attempts = 0;

      final result = await handler.execute(() async {
        attempts++;
        if (attempts < 3) {
          throw const NetworkException(message: 'Network error');
        }
        return 'success';
      });

      expect(result, 'success');
      expect(retryAttempts, [1, 2]);
    });

    test('respects custom retryIf predicate', () async {
      final handler = RetryHandler(
        maxRetries: 3,
        initialDelay: const Duration(milliseconds: 10),
        retryIf: (error, attempt) => attempt < 2,
      );
      var attempts = 0;

      expect(
        () => handler.execute(() async {
          attempts++;
          throw const NetworkException(message: 'Network error');
        }),
        throwsA(isA<NetworkException>()),
      );

      await Future.delayed(const Duration(milliseconds: 100));
      expect(attempts, 2);
    });
  });

  group('CircuitBreaker', () {
    test('allows execution when closed', () async {
      final breaker = CircuitBreaker(failureThreshold: 3);

      final result = await breaker.execute(() async => 'success');

      expect(result, 'success');
      expect(breaker.state, CircuitState.closed);
    });

    test('opens after failure threshold', () async {
      final breaker = CircuitBreaker(failureThreshold: 3);

      for (var i = 0; i < 3; i++) {
        try {
          await breaker.execute(() async => throw Exception('Error'));
        } catch (_) {}
      }

      expect(breaker.state, CircuitState.open);
    });

    test('throws CircuitOpenException when open', () async {
      final breaker = CircuitBreaker(
        failureThreshold: 1,
        resetTimeout: const Duration(seconds: 30),
      );

      // Trigger failure to open circuit
      try {
        await breaker.execute(() async => throw Exception('Error'));
      } catch (_) {}

      expect(
        () => breaker.execute(() async => 'success'),
        throwsA(isA<CircuitOpenException>()),
      );
    });

    test('resets to half-open after timeout', () async {
      final breaker = CircuitBreaker(
        failureThreshold: 1,
        resetTimeout: const Duration(milliseconds: 50),
      );

      // Trigger failure to open circuit
      try {
        await breaker.execute(() async => throw Exception('Error'));
      } catch (_) {}

      expect(breaker.state, CircuitState.open);

      // Wait for reset timeout
      await Future.delayed(const Duration(milliseconds: 100));

      // Should transition to half-open on next call
      final result = await breaker.execute(() async => 'success');
      expect(result, 'success');
      expect(breaker.state, CircuitState.closed);
    });

    test('reset method closes the circuit', () async {
      final breaker = CircuitBreaker(failureThreshold: 1);

      try {
        await breaker.execute(() async => throw Exception('Error'));
      } catch (_) {}

      expect(breaker.state, CircuitState.open);

      breaker.reset();

      expect(breaker.state, CircuitState.closed);
    });
  });

  group('ThrottledHandler', () {
    test('executes immediately on first call', () async {
      final handler = ThrottledHandler(
        minInterval: const Duration(milliseconds: 100),
      );

      final start = DateTime.now();
      await handler.execute(() async => 'result');
      final elapsed = DateTime.now().difference(start);

      expect(elapsed.inMilliseconds, lessThan(50));
    });

    test('throttles rapid calls', () async {
      final handler = ThrottledHandler(
        minInterval: const Duration(milliseconds: 100),
      );

      await handler.execute(() async => 'first');
      final start = DateTime.now();
      await handler.execute(() async => 'second');
      final elapsed = DateTime.now().difference(start);

      expect(elapsed.inMilliseconds, greaterThanOrEqualTo(50));
    });

    test('canExecute returns correct value', () async {
      final handler = ThrottledHandler(
        minInterval: const Duration(milliseconds: 100),
      );

      expect(handler.canExecute, isTrue);

      await handler.execute(() async => 'result');

      expect(handler.canExecute, isFalse);

      await Future.delayed(const Duration(milliseconds: 150));

      expect(handler.canExecute, isTrue);
    });
  });
}
