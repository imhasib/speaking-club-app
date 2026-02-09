import 'package:flutter/material.dart';
import '../../../core/errors/app_exception.dart';
import '../../../core/errors/failures.dart';
import '../animations/animations.dart';

/// Network error widget with retry option
class NetworkErrorWidget extends StatelessWidget {
  const NetworkErrorWidget({
    super.key,
    required this.onRetry,
    this.message,
  });

  final VoidCallback onRetry;
  final String? message;

  @override
  Widget build(BuildContext context) {
    return AnimatedEmptyState(
      icon: Icons.wifi_off,
      title: 'No Internet Connection',
      subtitle: message ?? 'Please check your connection and try again.',
      actionLabel: 'Retry',
      onAction: onRetry,
    );
  }
}

/// Server error widget with retry option
class ServerErrorWidget extends StatelessWidget {
  const ServerErrorWidget({
    super.key,
    required this.onRetry,
    this.message,
  });

  final VoidCallback onRetry;
  final String? message;

  @override
  Widget build(BuildContext context) {
    return AnimatedEmptyState(
      icon: Icons.cloud_off,
      title: 'Server Error',
      subtitle: message ?? 'Something went wrong. Please try again later.',
      actionLabel: 'Retry',
      onAction: onRetry,
    );
  }
}

/// Generic error widget
class GenericErrorWidget extends StatelessWidget {
  const GenericErrorWidget({
    super.key,
    this.title,
    this.message,
    this.icon,
    this.onRetry,
    this.actionLabel,
  });

  final String? title;
  final String? message;
  final IconData? icon;
  final VoidCallback? onRetry;
  final String? actionLabel;

  @override
  Widget build(BuildContext context) {
    return AnimatedEmptyState(
      icon: icon ?? Icons.error_outline,
      title: title ?? 'Something went wrong',
      subtitle: message ?? 'An unexpected error occurred. Please try again.',
      actionLabel: onRetry != null ? (actionLabel ?? 'Retry') : null,
      onAction: onRetry,
    );
  }
}

/// Error widget that adapts based on error type
class AdaptiveErrorWidget extends StatelessWidget {
  const AdaptiveErrorWidget({
    super.key,
    required this.error,
    required this.onRetry,
  });

  final dynamic error;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    // Handle different error types
    if (error is NetworkException || error is NetworkFailure) {
      return NetworkErrorWidget(
        onRetry: onRetry,
        message: error is AppException ? (error as AppException).message : null,
      );
    }

    if (error is ApiException) {
      final apiError = error as ApiException;
      if (apiError.statusCode != null && apiError.statusCode! >= 500) {
        return ServerErrorWidget(
          onRetry: onRetry,
          message: apiError.message,
        );
      }
    }

    if (error is ServerFailure) {
      return ServerErrorWidget(
        onRetry: onRetry,
        message: error.message,
      );
    }

    if (error is AuthException || error is AuthFailure) {
      return GenericErrorWidget(
        icon: Icons.lock_outline,
        title: 'Authentication Error',
        message: error is AppException
            ? (error as AppException).message
            : (error as Failure).message,
        onRetry: onRetry,
      );
    }

    // Default error widget
    String? message;
    if (error is AppException) {
      message = error.message;
    } else if (error is Failure) {
      message = error.message;
    } else if (error is String) {
      message = error;
    }

    return GenericErrorWidget(
      message: message,
      onRetry: onRetry,
    );
  }
}

/// Error banner that can be shown at the top of a screen
class ErrorBanner extends StatelessWidget {
  const ErrorBanner({
    super.key,
    required this.message,
    this.onDismiss,
    this.onRetry,
    this.type = ErrorBannerType.error,
  });

  final String message;
  final VoidCallback? onDismiss;
  final VoidCallback? onRetry;
  final ErrorBannerType type;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    Color backgroundColor;
    Color foregroundColor;
    IconData icon;

    switch (type) {
      case ErrorBannerType.error:
        backgroundColor = colorScheme.errorContainer;
        foregroundColor = colorScheme.onErrorContainer;
        icon = Icons.error_outline;
      case ErrorBannerType.warning:
        backgroundColor = Colors.orange.shade100;
        foregroundColor = Colors.orange.shade900;
        icon = Icons.warning_amber_outlined;
      case ErrorBannerType.info:
        backgroundColor = colorScheme.primaryContainer;
        foregroundColor = colorScheme.onPrimaryContainer;
        icon = Icons.info_outline;
      case ErrorBannerType.network:
        backgroundColor = colorScheme.errorContainer;
        foregroundColor = colorScheme.onErrorContainer;
        icon = Icons.wifi_off;
    }

    return Material(
      color: backgroundColor,
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              Icon(icon, color: foregroundColor, size: 24),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  message,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: foregroundColor,
                      ),
                ),
              ),
              if (onRetry != null)
                TextButton(
                  onPressed: onRetry,
                  child: Text(
                    'Retry',
                    style: TextStyle(color: foregroundColor),
                  ),
                ),
              if (onDismiss != null)
                IconButton(
                  icon: Icon(Icons.close, color: foregroundColor),
                  onPressed: onDismiss,
                  visualDensity: VisualDensity.compact,
                ),
            ],
          ),
        ),
      ),
    );
  }
}

enum ErrorBannerType { error, warning, info, network }

/// Inline error message
class InlineError extends StatelessWidget {
  const InlineError({
    super.key,
    required this.message,
    this.onRetry,
  });

  final String message;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: colorScheme.errorContainer.withAlpha(77),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: colorScheme.error.withAlpha(51),
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.error_outline,
            size: 20,
            color: colorScheme.error,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              message,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: colorScheme.error,
                  ),
            ),
          ),
          if (onRetry != null)
            TextButton(
              onPressed: onRetry,
              child: const Text('Retry'),
            ),
        ],
      ),
    );
  }
}

/// Connection status banner
class ConnectionStatusBanner extends StatelessWidget {
  const ConnectionStatusBanner({
    super.key,
    required this.isConnected,
    this.onRetryConnection,
  });

  final bool isConnected;
  final VoidCallback? onRetryConnection;

  @override
  Widget build(BuildContext context) {
    return AnimatedSlide(
      duration: const Duration(milliseconds: 300),
      offset: isConnected ? const Offset(0, -1) : Offset.zero,
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 300),
        opacity: isConnected ? 0 : 1,
        child: ErrorBanner(
          message: 'No internet connection',
          type: ErrorBannerType.network,
          onRetry: onRetryConnection,
        ),
      ),
    );
  }
}

/// Error snackbar helper
void showErrorSnackBar(
  BuildContext context,
  String message, {
  VoidCallback? onRetry,
  Duration duration = const Duration(seconds: 4),
}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message),
      backgroundColor: Theme.of(context).colorScheme.error,
      duration: duration,
      action: onRetry != null
          ? SnackBarAction(
              label: 'Retry',
              textColor: Theme.of(context).colorScheme.onError,
              onPressed: onRetry,
            )
          : null,
    ),
  );
}

/// Success snackbar helper
void showSuccessSnackBar(
  BuildContext context,
  String message, {
  Duration duration = const Duration(seconds: 3),
}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Row(
        children: [
          Icon(
            Icons.check_circle,
            color: Theme.of(context).colorScheme.onPrimary,
          ),
          const SizedBox(width: 12),
          Expanded(child: Text(message)),
        ],
      ),
      backgroundColor: Colors.green,
      duration: duration,
    ),
  );
}

/// Info snackbar helper
void showInfoSnackBar(
  BuildContext context,
  String message, {
  Duration duration = const Duration(seconds: 3),
}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Row(
        children: [
          Icon(
            Icons.info_outline,
            color: Theme.of(context).colorScheme.onPrimary,
          ),
          const SizedBox(width: 12),
          Expanded(child: Text(message)),
        ],
      ),
      duration: duration,
    ),
  );
}
