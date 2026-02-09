import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:Speaking_club/shared/widgets/animations/shimmer_loading.dart';
import 'package:Speaking_club/shared/widgets/animations/loading_overlay.dart';

void main() {
  group('Shimmer', () {
    Widget buildTestWidget({bool enabled = true}) {
      return MaterialApp(
        home: Scaffold(
          body: Shimmer(
            enabled: enabled,
            child: Container(
              width: 100,
              height: 100,
              color: Colors.grey,
            ),
          ),
        ),
      );
    }

    testWidgets('renders child widget', (tester) async {
      await tester.pumpWidget(buildTestWidget());

      expect(find.byType(Container), findsWidgets);
    });

    testWidgets('animates shimmer effect when enabled', (tester) async {
      await tester.pumpWidget(buildTestWidget(enabled: true));

      // Let animation run
      await tester.pump(const Duration(milliseconds: 500));
      await tester.pump(const Duration(milliseconds: 500));

      expect(find.byType(Shimmer), findsOneWidget);
    });

    testWidgets('does not animate when disabled', (tester) async {
      await tester.pumpWidget(buildTestWidget(enabled: false));

      expect(find.byType(Shimmer), findsOneWidget);
    });
  });

  group('ShimmerBox', () {
    Widget buildTestWidget({
      double? width,
      double? height,
      BoxShape shape = BoxShape.rectangle,
    }) {
      return MaterialApp(
        home: Scaffold(
          body: ShimmerBox(
            width: width,
            height: height,
            shape: shape,
          ),
        ),
      );
    }

    testWidgets('renders with specified width and height', (tester) async {
      await tester.pumpWidget(buildTestWidget(width: 100, height: 50));

      expect(find.byType(ShimmerBox), findsOneWidget);
    });

    testWidgets('renders as circle shape', (tester) async {
      await tester.pumpWidget(buildTestWidget(
        width: 50,
        height: 50,
        shape: BoxShape.circle,
      ));

      expect(find.byType(ShimmerBox), findsOneWidget);
    });
  });

  group('ShimmerUserCard', () {
    testWidgets('renders user card shimmer', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: ShimmerUserCard()),
        ),
      );
      await tester.pump();

      expect(find.byType(ShimmerUserCard), findsOneWidget);
      expect(find.byType(Shimmer), findsOneWidget);
    });
  });

  group('ShimmerUserGrid', () {
    Widget buildTestWidget({int itemCount = 6}) {
      return MaterialApp(
        home: Scaffold(
          body: ShimmerUserGrid(itemCount: itemCount),
        ),
      );
    }

    testWidgets('renders grid with specified item count', (tester) async {
      await tester.pumpWidget(buildTestWidget(itemCount: 4));
      await tester.pump();

      // Should have a GridView
      expect(find.byType(GridView), findsOneWidget);
      expect(find.byType(ShimmerUserGrid), findsOneWidget);
    });
  });

  group('ShimmerCallHistoryItem', () {
    testWidgets('renders call history item shimmer', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: ShimmerCallHistoryItem()),
        ),
      );
      await tester.pump();

      expect(find.byType(ShimmerCallHistoryItem), findsOneWidget);
      expect(find.byType(Shimmer), findsOneWidget);
    });
  });

  group('ShimmerCallHistoryList', () {
    Widget buildTestWidget({int itemCount = 5}) {
      return MaterialApp(
        home: Scaffold(
          body: ShimmerCallHistoryList(itemCount: itemCount),
        ),
      );
    }

    testWidgets('renders shimmer list', (tester) async {
      await tester.pumpWidget(buildTestWidget());
      await tester.pump();

      expect(find.byType(ShimmerCallHistoryList), findsOneWidget);
      expect(find.byType(ListView), findsOneWidget);
    });
  });

  group('ShimmerProfile', () {
    testWidgets('renders profile shimmer', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: ShimmerProfile()),
        ),
      );
      await tester.pump();

      expect(find.byType(ShimmerProfile), findsOneWidget);
      expect(find.byType(Shimmer), findsOneWidget);
    });
  });

  group('LoadingOverlay', () {
    Widget buildTestWidget({
      bool isLoading = true,
      String? message,
    }) {
      return MaterialApp(
        home: Scaffold(
          body: LoadingOverlay(
            isLoading: isLoading,
            message: message,
            child: const Text('Content'),
          ),
        ),
      );
    }

    testWidgets('shows content when not loading', (tester) async {
      await tester.pumpWidget(buildTestWidget(isLoading: false));

      expect(find.text('Content'), findsOneWidget);
      expect(find.byType(CircularProgressIndicator), findsNothing);
    });

    testWidgets('shows loading indicator when loading', (tester) async {
      await tester.pumpWidget(buildTestWidget(isLoading: true));
      await tester.pump();

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('shows message when provided', (tester) async {
      await tester.pumpWidget(buildTestWidget(
        isLoading: true,
        message: 'Loading...',
      ));
      await tester.pump();

      expect(find.text('Loading...'), findsOneWidget);
    });

    testWidgets('content is still visible but overlay shown when loading', (tester) async {
      await tester.pumpWidget(buildTestWidget(isLoading: true));
      await tester.pump();

      // Both content and loading indicator should be visible
      expect(find.text('Content'), findsOneWidget);
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });
  });

  group('LoadingButton', () {
    Widget buildTestWidget({
      bool isLoading = false,
      VoidCallback? onPressed,
      Widget child = const Text('Submit'),
      String? loadingText,
    }) {
      return MaterialApp(
        home: Scaffold(
          body: LoadingButton(
            isLoading: isLoading,
            onPressed: onPressed ?? () {},
            loadingText: loadingText,
            child: child,
          ),
        ),
      );
    }

    testWidgets('displays child when not loading', (tester) async {
      await tester.pumpWidget(buildTestWidget(child: const Text('Click Me')));

      expect(find.text('Click Me'), findsOneWidget);
    });

    testWidgets('shows progress indicator when loading', (tester) async {
      await tester.pumpWidget(buildTestWidget(isLoading: true));
      await tester.pump();

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('shows loading text when provided', (tester) async {
      await tester.pumpWidget(buildTestWidget(
        isLoading: true,
        loadingText: 'Please wait...',
      ));
      await tester.pump();

      expect(find.text('Please wait...'), findsOneWidget);
    });

    testWidgets('calls onPressed when not loading', (tester) async {
      bool pressed = false;
      await tester.pumpWidget(buildTestWidget(
        isLoading: false,
        onPressed: () => pressed = true,
      ));

      await tester.tap(find.byType(FilledButton));
      await tester.pump();

      expect(pressed, true);
    });

    testWidgets('button is disabled when loading', (tester) async {
      await tester.pumpWidget(buildTestWidget(isLoading: true));
      await tester.pump();

      // When loading, the button has onPressed: null
      final button = tester.widget<FilledButton>(find.byType(FilledButton));
      expect(button.onPressed, isNull);
    });
  });

  group('SuccessAnimation', () {
    Widget buildTestWidget({
      double size = 80,
      Color? color,
    }) {
      return MaterialApp(
        home: Scaffold(
          body: SuccessAnimation(
            size: size,
            color: color,
          ),
        ),
      );
    }

    testWidgets('renders success animation', (tester) async {
      await tester.pumpWidget(buildTestWidget());
      await tester.pump();

      expect(find.byType(SuccessAnimation), findsOneWidget);
    });

    testWidgets('animates on build', (tester) async {
      await tester.pumpWidget(buildTestWidget());

      // Let animation run
      await tester.pump(const Duration(milliseconds: 300));
      await tester.pump(const Duration(milliseconds: 300));

      expect(find.byType(SuccessAnimation), findsOneWidget);
    });

    testWidgets('uses custom size', (tester) async {
      await tester.pumpWidget(buildTestWidget(size: 120));
      await tester.pump();

      expect(find.byType(SuccessAnimation), findsOneWidget);
    });

    testWidgets('calls onComplete when animation finishes', (tester) async {
      bool completed = false;
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: SuccessAnimation(
            onComplete: () => completed = true,
          ),
        ),
      ));

      await tester.pumpAndSettle();
      expect(completed, true);
    });
  });

  group('ErrorAnimation', () {
    Widget buildTestWidget({
      double size = 80,
      Color? color,
    }) {
      return MaterialApp(
        home: Scaffold(
          body: ErrorAnimation(
            size: size,
            color: color,
          ),
        ),
      );
    }

    testWidgets('renders error animation', (tester) async {
      await tester.pumpWidget(buildTestWidget());
      await tester.pump();

      expect(find.byType(ErrorAnimation), findsOneWidget);
    });

    testWidgets('animates on build', (tester) async {
      await tester.pumpWidget(buildTestWidget());

      // Let animation run
      await tester.pump(const Duration(milliseconds: 300));
      await tester.pump(const Duration(milliseconds: 300));

      expect(find.byType(ErrorAnimation), findsOneWidget);
    });

    testWidgets('calls onComplete when animation finishes', (tester) async {
      bool completed = false;
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: ErrorAnimation(
            onComplete: () => completed = true,
          ),
        ),
      ));

      await tester.pumpAndSettle();
      expect(completed, true);
    });
  });

  group('ConnectionStatusIndicator', () {
    Widget buildTestWidget({required bool isConnected}) {
      return MaterialApp(
        home: Scaffold(
          body: ConnectionStatusIndicator(isConnected: isConnected),
        ),
      );
    }

    testWidgets('displays connected state', (tester) async {
      await tester.pumpWidget(buildTestWidget(isConnected: true));

      expect(find.byType(ConnectionStatusIndicator), findsOneWidget);
    });

    testWidgets('displays disconnected state', (tester) async {
      await tester.pumpWidget(buildTestWidget(isConnected: false));

      expect(find.byType(ConnectionStatusIndicator), findsOneWidget);
    });

    testWidgets('animates when state changes', (tester) async {
      await tester.pumpWidget(buildTestWidget(isConnected: true));
      await tester.pump();

      await tester.pumpWidget(buildTestWidget(isConnected: false));
      await tester.pumpAndSettle();

      expect(find.byType(ConnectionStatusIndicator), findsOneWidget);
    });
  });

  group('SearchingIndicator', () {
    Widget buildTestWidget({double size = 100}) {
      return MaterialApp(
        home: Scaffold(
          body: SearchingIndicator(size: size),
        ),
      );
    }

    testWidgets('renders searching indicator', (tester) async {
      await tester.pumpWidget(buildTestWidget());
      await tester.pump();

      expect(find.byType(SearchingIndicator), findsOneWidget);
    });

    testWidgets('animates continuously', (tester) async {
      await tester.pumpWidget(buildTestWidget());

      // Let animation run
      await tester.pump(const Duration(milliseconds: 500));
      await tester.pump(const Duration(milliseconds: 500));

      expect(find.byType(SearchingIndicator), findsOneWidget);
    });

    testWidgets('uses custom size', (tester) async {
      await tester.pumpWidget(buildTestWidget(size: 150));
      await tester.pump();

      final sizedBox = tester.widget<SizedBox>(find.byType(SizedBox).first);
      expect(sizedBox.width, 150);
      expect(sizedBox.height, 150);
    });
  });
}
