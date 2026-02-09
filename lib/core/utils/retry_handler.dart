import 'dart:async';
import 'dart:math';

import '../errors/app_exception.dart';

/// Retry handler with exponential backoff
class RetryHandler {
  const RetryHandler({
    this.maxRetries = 3,
    this.initialDelay = const Duration(milliseconds: 500),
    this.maxDelay = const Duration(seconds: 30),
    this.backoffMultiplier = 2.0,
    this.retryIf,
    this.onRetry,
  });

  /// Maximum number of retry attempts
  final int maxRetries;

  /// Initial delay before first retry
  final Duration initialDelay;

  /// Maximum delay between retries
  final Duration maxDelay;

  /// Multiplier for exponential backoff
  final double backoffMultiplier;

  /// Predicate to determine if error should trigger retry
  final bool Function(Exception error, int attempt)? retryIf;

  /// Callback called before each retry
  final void Function(Exception error, int attempt, Duration delay)? onRetry;

  /// Execute a function with automatic retry on failure
  Future<T> execute<T>(Future<T> Function() fn) async {
    int attempt = 0;
    Duration currentDelay = initialDelay;

    while (true) {
      try {
        return await fn();
      } on Exception catch (e) {
        attempt++;

        if (attempt >= maxRetries) {
          rethrow;
        }

        if (retryIf != null && !retryIf!(e, attempt)) {
          rethrow;
        }

        if (!_shouldRetry(e)) {
          rethrow;
        }

        // Calculate delay with jitter
        final jitter = Random().nextDouble() * 0.3 * currentDelay.inMilliseconds;
        final delayWithJitter = Duration(
          milliseconds: currentDelay.inMilliseconds + jitter.toInt(),
        );

        onRetry?.call(e, attempt, delayWithJitter);

        await Future.delayed(delayWithJitter);

        // Exponential backoff
        currentDelay = Duration(
          milliseconds: min(
            (currentDelay.inMilliseconds * backoffMultiplier).toInt(),
            maxDelay.inMilliseconds,
          ),
        );
      }
    }
  }

  /// Determine if an exception should trigger a retry
  bool _shouldRetry(Exception e) {
    // Don't retry auth errors
    if (e is AuthException || e is UnauthorizedException || e is TokenExpiredException) {
      return false;
    }

    // Don't retry validation errors
    if (e is ValidationException) {
      return false;
    }

    // Retry network errors
    if (e is NetworkException) {
      return true;
    }

    // Retry server errors (5xx)
    if (e is ApiException && e.statusCode != null) {
      return e.statusCode! >= 500;
    }

    // Default to no retry
    return false;
  }
}

/// Stream-based retry wrapper
class StreamRetryHandler {
  const StreamRetryHandler({
    this.maxRetries = 3,
    this.retryDelay = const Duration(seconds: 2),
  });

  final int maxRetries;
  final Duration retryDelay;

  /// Wrap a stream with automatic reconnection on error
  Stream<T> wrap<T>(Stream<T> Function() createStream) async* {
    int retryCount = 0;

    while (retryCount < maxRetries) {
      try {
        await for (final event in createStream()) {
          retryCount = 0; // Reset on successful event
          yield event;
        }
        return; // Stream completed normally
      } catch (e) {
        retryCount++;
        if (retryCount >= maxRetries) {
          rethrow;
        }
        await Future.delayed(retryDelay);
      }
    }
  }
}

/// Debounced retry handler for rapid-fire operations
class DebouncedRetryHandler {
  DebouncedRetryHandler({
    this.delay = const Duration(milliseconds: 500),
  });

  final Duration delay;
  Timer? _debounceTimer;
  Completer<void>? _completer;

  /// Execute with debounce - only the last call within the delay period executes
  Future<T> execute<T>(Future<T> Function() fn) async {
    _debounceTimer?.cancel();
    _completer?.completeError(CancelledByNewerRequest());

    _completer = Completer<void>();
    final currentCompleter = _completer!;

    _debounceTimer = Timer(delay, () {
      if (!currentCompleter.isCompleted) {
        currentCompleter.complete();
      }
    });

    await currentCompleter.future;
    return fn();
  }

  /// Cancel any pending operation
  void cancel() {
    _debounceTimer?.cancel();
    _completer?.completeError(CancelledByNewerRequest());
  }

  /// Dispose resources
  void dispose() {
    cancel();
  }
}

/// Exception thrown when operation is cancelled by a newer request
class CancelledByNewerRequest implements Exception {
  @override
  String toString() => 'Operation cancelled by newer request';
}

/// Throttled handler - ensures minimum time between executions
class ThrottledHandler {
  ThrottledHandler({
    this.minInterval = const Duration(seconds: 1),
  });

  final Duration minInterval;
  DateTime? _lastExecution;

  /// Execute with throttling - blocks if called too frequently
  Future<T> execute<T>(Future<T> Function() fn) async {
    if (_lastExecution != null) {
      final elapsed = DateTime.now().difference(_lastExecution!);
      if (elapsed < minInterval) {
        await Future.delayed(minInterval - elapsed);
      }
    }

    _lastExecution = DateTime.now();
    return fn();
  }

  /// Check if enough time has passed since last execution
  bool get canExecute {
    if (_lastExecution == null) return true;
    return DateTime.now().difference(_lastExecution!) >= minInterval;
  }
}

/// Circuit breaker pattern for handling repeated failures
class CircuitBreaker {
  CircuitBreaker({
    this.failureThreshold = 5,
    this.resetTimeout = const Duration(seconds: 30),
  });

  final int failureThreshold;
  final Duration resetTimeout;

  int _failureCount = 0;
  CircuitState _state = CircuitState.closed;
  DateTime? _lastFailure;

  CircuitState get state => _state;
  bool get isOpen => _state == CircuitState.open;

  /// Execute with circuit breaker protection
  Future<T> execute<T>(Future<T> Function() fn) async {
    if (_state == CircuitState.open) {
      if (_lastFailure != null &&
          DateTime.now().difference(_lastFailure!) >= resetTimeout) {
        _state = CircuitState.halfOpen;
      } else {
        throw CircuitOpenException();
      }
    }

    try {
      final result = await fn();
      _onSuccess();
      return result;
    } catch (e) {
      _onFailure();
      rethrow;
    }
  }

  void _onSuccess() {
    _failureCount = 0;
    _state = CircuitState.closed;
  }

  void _onFailure() {
    _failureCount++;
    _lastFailure = DateTime.now();

    if (_failureCount >= failureThreshold) {
      _state = CircuitState.open;
    }
  }

  /// Reset the circuit breaker
  void reset() {
    _failureCount = 0;
    _state = CircuitState.closed;
    _lastFailure = null;
  }
}

enum CircuitState { closed, open, halfOpen }

/// Exception thrown when circuit breaker is open
class CircuitOpenException implements Exception {
  @override
  String toString() => 'Circuit breaker is open - too many failures';
}
