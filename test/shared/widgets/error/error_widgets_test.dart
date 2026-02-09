import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:Speaking_club/shared/widgets/error/error_widgets.dart';
import 'package:Speaking_club/core/errors/app_exception.dart';
import 'package:Speaking_club/core/errors/failures.dart';

void main() {
  group('NetworkErrorWidget', () {
    Widget buildTestWidget({
      VoidCallback? onRetry,
      String? message,
    }) {
      return MaterialApp(
        home: Scaffold(
          body: NetworkErrorWidget(
            onRetry: onRetry ?? () {},
            message: message,
          ),
        ),
      );
    }

    testWidgets('displays "No Internet Connection" title', (tester) async {
      await tester.pumpWidget(buildTestWidget());
      await tester.pump();

      expect(find.text('No Internet Connection'), findsOneWidget);
    });

    testWidgets('displays default message when not provided', (tester) async {
      await tester.pumpWidget(buildTestWidget());
      await tester.pump();

      expect(find.text('Please check your connection and try again.'), findsOneWidget);
    });

    testWidgets('displays custom message when provided', (tester) async {
      await tester.pumpWidget(buildTestWidget(
        message: 'Custom network error message',
      ));
      await tester.pump();

      expect(find.text('Custom network error message'), findsOneWidget);
    });

    testWidgets('calls onRetry when retry button is pressed', (tester) async {
      bool retryCalled = false;
      await tester.pumpWidget(buildTestWidget(
        onRetry: () => retryCalled = true,
      ));
      await tester.pump();

      await tester.tap(find.text('Retry'));
      await tester.pump();

      expect(retryCalled, true);
    });

    testWidgets('displays wifi_off icon', (tester) async {
      await tester.pumpWidget(buildTestWidget());
      await tester.pump();

      expect(find.byIcon(Icons.wifi_off), findsOneWidget);
    });
  });

  group('ServerErrorWidget', () {
    Widget buildTestWidget({
      VoidCallback? onRetry,
      String? message,
    }) {
      return MaterialApp(
        home: Scaffold(
          body: ServerErrorWidget(
            onRetry: onRetry ?? () {},
            message: message,
          ),
        ),
      );
    }

    testWidgets('displays "Server Error" title', (tester) async {
      await tester.pumpWidget(buildTestWidget());
      await tester.pump();

      expect(find.text('Server Error'), findsOneWidget);
    });

    testWidgets('displays default message when not provided', (tester) async {
      await tester.pumpWidget(buildTestWidget());
      await tester.pump();

      expect(find.text('Something went wrong. Please try again later.'), findsOneWidget);
    });

    testWidgets('displays custom message when provided', (tester) async {
      await tester.pumpWidget(buildTestWidget(
        message: 'Server is under maintenance',
      ));
      await tester.pump();

      expect(find.text('Server is under maintenance'), findsOneWidget);
    });

    testWidgets('displays cloud_off icon', (tester) async {
      await tester.pumpWidget(buildTestWidget());
      await tester.pump();

      expect(find.byIcon(Icons.cloud_off), findsOneWidget);
    });
  });

  group('GenericErrorWidget', () {
    Widget buildTestWidget({
      String? title,
      String? message,
      IconData? icon,
      VoidCallback? onRetry,
      String? actionLabel,
    }) {
      return MaterialApp(
        home: Scaffold(
          body: GenericErrorWidget(
            title: title,
            message: message,
            icon: icon,
            onRetry: onRetry,
            actionLabel: actionLabel,
          ),
        ),
      );
    }

    testWidgets('displays default title when not provided', (tester) async {
      await tester.pumpWidget(buildTestWidget());
      await tester.pump();

      expect(find.text('Something went wrong'), findsOneWidget);
    });

    testWidgets('displays custom title', (tester) async {
      await tester.pumpWidget(buildTestWidget(title: 'Custom Error'));
      await tester.pump();

      expect(find.text('Custom Error'), findsOneWidget);
    });

    testWidgets('displays default message when not provided', (tester) async {
      await tester.pumpWidget(buildTestWidget());
      await tester.pump();

      expect(find.text('An unexpected error occurred. Please try again.'), findsOneWidget);
    });

    testWidgets('displays custom message', (tester) async {
      await tester.pumpWidget(buildTestWidget(
        message: 'Something specific went wrong',
      ));
      await tester.pump();

      expect(find.text('Something specific went wrong'), findsOneWidget);
    });

    testWidgets('displays custom icon', (tester) async {
      await tester.pumpWidget(buildTestWidget(icon: Icons.warning));
      await tester.pump();

      expect(find.byIcon(Icons.warning), findsOneWidget);
    });

    testWidgets('displays default error_outline icon', (tester) async {
      await tester.pumpWidget(buildTestWidget());
      await tester.pump();

      expect(find.byIcon(Icons.error_outline), findsOneWidget);
    });

    testWidgets('shows retry button only when onRetry is provided', (tester) async {
      await tester.pumpWidget(buildTestWidget());
      await tester.pump();

      expect(find.text('Retry'), findsNothing);

      await tester.pumpWidget(buildTestWidget(onRetry: () {}));
      await tester.pump();

      expect(find.text('Retry'), findsOneWidget);
    });

    testWidgets('uses custom action label', (tester) async {
      await tester.pumpWidget(buildTestWidget(
        onRetry: () {},
        actionLabel: 'Try Again',
      ));
      await tester.pump();

      expect(find.text('Try Again'), findsOneWidget);
    });
  });

  group('AdaptiveErrorWidget', () {
    Widget buildTestWidget({
      required dynamic error,
      VoidCallback? onRetry,
    }) {
      return MaterialApp(
        home: Scaffold(
          body: AdaptiveErrorWidget(
            error: error,
            onRetry: onRetry ?? () {},
          ),
        ),
      );
    }

    testWidgets('shows NetworkErrorWidget for NetworkException', (tester) async {
      await tester.pumpWidget(buildTestWidget(
        error: const NetworkException(message: 'Network failed'),
      ));
      await tester.pump();

      expect(find.text('No Internet Connection'), findsOneWidget);
    });

    testWidgets('shows NetworkErrorWidget for NetworkFailure', (tester) async {
      await tester.pumpWidget(buildTestWidget(
        error: const NetworkFailure(),
      ));
      await tester.pump();

      expect(find.text('No Internet Connection'), findsOneWidget);
    });

    testWidgets('shows ServerErrorWidget for ApiException with status >= 500', (tester) async {
      await tester.pumpWidget(buildTestWidget(
        error: const ApiException(message: 'Server error', statusCode: 500),
      ));
      await tester.pump();

      expect(find.text('Server Error'), findsOneWidget);
    });

    testWidgets('shows ServerErrorWidget for ServerFailure', (tester) async {
      await tester.pumpWidget(buildTestWidget(
        error: const ServerFailure(message: 'Internal server error'),
      ));
      await tester.pump();

      expect(find.text('Server Error'), findsOneWidget);
    });

    testWidgets('shows GenericErrorWidget with lock icon for AuthException', (tester) async {
      await tester.pumpWidget(buildTestWidget(
        error: const AuthException(message: 'Authentication failed'),
      ));
      await tester.pump();

      expect(find.text('Authentication Error'), findsOneWidget);
      expect(find.byIcon(Icons.lock_outline), findsOneWidget);
    });

    testWidgets('shows GenericErrorWidget for string error', (tester) async {
      await tester.pumpWidget(buildTestWidget(
        error: 'Simple error message',
      ));
      await tester.pump();

      expect(find.text('Simple error message'), findsOneWidget);
    });
  });

  group('ErrorBanner', () {
    Widget buildTestWidget({
      required String message,
      VoidCallback? onDismiss,
      VoidCallback? onRetry,
      ErrorBannerType type = ErrorBannerType.error,
    }) {
      return MaterialApp(
        home: Scaffold(
          body: ErrorBanner(
            message: message,
            onDismiss: onDismiss,
            onRetry: onRetry,
            type: type,
          ),
        ),
      );
    }

    testWidgets('displays error message', (tester) async {
      await tester.pumpWidget(buildTestWidget(message: 'Error occurred'));

      expect(find.text('Error occurred'), findsOneWidget);
    });

    testWidgets('shows error icon for error type', (tester) async {
      await tester.pumpWidget(buildTestWidget(
        message: 'Error',
        type: ErrorBannerType.error,
      ));

      expect(find.byIcon(Icons.error_outline), findsOneWidget);
    });

    testWidgets('shows warning icon for warning type', (tester) async {
      await tester.pumpWidget(buildTestWidget(
        message: 'Warning',
        type: ErrorBannerType.warning,
      ));

      expect(find.byIcon(Icons.warning_amber_outlined), findsOneWidget);
    });

    testWidgets('shows info icon for info type', (tester) async {
      await tester.pumpWidget(buildTestWidget(
        message: 'Info',
        type: ErrorBannerType.info,
      ));

      expect(find.byIcon(Icons.info_outline), findsOneWidget);
    });

    testWidgets('shows wifi_off icon for network type', (tester) async {
      await tester.pumpWidget(buildTestWidget(
        message: 'Network',
        type: ErrorBannerType.network,
      ));

      expect(find.byIcon(Icons.wifi_off), findsOneWidget);
    });

    testWidgets('shows retry button when onRetry is provided', (tester) async {
      await tester.pumpWidget(buildTestWidget(
        message: 'Error',
        onRetry: () {},
      ));

      expect(find.text('Retry'), findsOneWidget);
    });

    testWidgets('calls onRetry when retry button is pressed', (tester) async {
      bool retryCalled = false;
      await tester.pumpWidget(buildTestWidget(
        message: 'Error',
        onRetry: () => retryCalled = true,
      ));

      await tester.tap(find.text('Retry'));
      await tester.pump();

      expect(retryCalled, true);
    });

    testWidgets('shows dismiss button when onDismiss is provided', (tester) async {
      await tester.pumpWidget(buildTestWidget(
        message: 'Error',
        onDismiss: () {},
      ));

      expect(find.byIcon(Icons.close), findsOneWidget);
    });

    testWidgets('calls onDismiss when dismiss button is pressed', (tester) async {
      bool dismissCalled = false;
      await tester.pumpWidget(buildTestWidget(
        message: 'Error',
        onDismiss: () => dismissCalled = true,
      ));

      await tester.tap(find.byIcon(Icons.close));
      await tester.pump();

      expect(dismissCalled, true);
    });
  });

  group('InlineError', () {
    Widget buildTestWidget({
      required String message,
      VoidCallback? onRetry,
    }) {
      return MaterialApp(
        home: Scaffold(
          body: InlineError(
            message: message,
            onRetry: onRetry,
          ),
        ),
      );
    }

    testWidgets('displays error message', (tester) async {
      await tester.pumpWidget(buildTestWidget(message: 'Inline error message'));

      expect(find.text('Inline error message'), findsOneWidget);
    });

    testWidgets('displays error icon', (tester) async {
      await tester.pumpWidget(buildTestWidget(message: 'Error'));

      expect(find.byIcon(Icons.error_outline), findsOneWidget);
    });

    testWidgets('shows retry button when onRetry is provided', (tester) async {
      await tester.pumpWidget(buildTestWidget(
        message: 'Error',
        onRetry: () {},
      ));

      expect(find.text('Retry'), findsOneWidget);
    });

    testWidgets('does not show retry button when onRetry is null', (tester) async {
      await tester.pumpWidget(buildTestWidget(message: 'Error'));

      expect(find.text('Retry'), findsNothing);
    });
  });

  group('ConnectionStatusBanner', () {
    Widget buildTestWidget({
      required bool isConnected,
      VoidCallback? onRetryConnection,
    }) {
      return MaterialApp(
        home: Scaffold(
          body: Column(
            children: [
              ConnectionStatusBanner(
                isConnected: isConnected,
                onRetryConnection: onRetryConnection,
              ),
            ],
          ),
        ),
      );
    }

    testWidgets('displays banner when not connected', (tester) async {
      await tester.pumpWidget(buildTestWidget(isConnected: false));
      await tester.pump();

      expect(find.text('No internet connection'), findsOneWidget);
    });

    testWidgets('hides banner when connected', (tester) async {
      await tester.pumpWidget(buildTestWidget(isConnected: true));
      await tester.pump();

      // The banner animates out, so we need to verify opacity
      final opacityWidget = tester.widget<AnimatedOpacity>(
        find.byType(AnimatedOpacity),
      );
      expect(opacityWidget.opacity, 0);
    });
  });
}
