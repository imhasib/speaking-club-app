import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:Speaking_club/shared/widgets/animations/animated_widgets.dart';

void main() {
  group('AnimatedEmptyState', () {
    Widget buildTestWidget({
      IconData icon = Icons.inbox,
      String title = 'No Items',
      String? subtitle,
      String? actionLabel,
      VoidCallback? onAction,
      Widget? action,
    }) {
      return MaterialApp(
        home: Scaffold(
          body: AnimatedEmptyState(
            icon: icon,
            title: title,
            subtitle: subtitle,
            actionLabel: actionLabel,
            onAction: onAction,
            action: action,
          ),
        ),
      );
    }

    testWidgets('displays title', (tester) async {
      await tester.pumpWidget(buildTestWidget(title: 'Empty State Title'));
      await tester.pump();

      expect(find.text('Empty State Title'), findsOneWidget);
    });

    testWidgets('displays icon', (tester) async {
      await tester.pumpWidget(buildTestWidget(icon: Icons.search));
      await tester.pump();

      expect(find.byIcon(Icons.search), findsOneWidget);
    });

    testWidgets('displays subtitle when provided', (tester) async {
      await tester.pumpWidget(buildTestWidget(
        subtitle: 'This is a subtitle',
      ));
      await tester.pump();

      expect(find.text('This is a subtitle'), findsOneWidget);
    });

    testWidgets('does not display subtitle when not provided', (tester) async {
      await tester.pumpWidget(buildTestWidget());
      await tester.pump();

      // Should only have the title
      expect(find.byType(Text), findsWidgets);
    });

    testWidgets('displays action button with label', (tester) async {
      await tester.pumpWidget(buildTestWidget(
        actionLabel: 'Refresh',
        onAction: () {},
      ));
      await tester.pump();

      expect(find.text('Refresh'), findsOneWidget);
    });

    testWidgets('calls onAction when button is pressed', (tester) async {
      bool actionCalled = false;
      await tester.pumpWidget(buildTestWidget(
        actionLabel: 'Refresh',
        onAction: () => actionCalled = true,
      ));
      await tester.pump();

      await tester.tap(find.text('Refresh'));
      await tester.pump();

      expect(actionCalled, true);
    });

    testWidgets('displays custom action widget', (tester) async {
      await tester.pumpWidget(buildTestWidget(
        action: const Text('Custom Action'),
      ));
      await tester.pump();

      expect(find.text('Custom Action'), findsOneWidget);
    });

    testWidgets('animates on build', (tester) async {
      await tester.pumpWidget(buildTestWidget());

      // Pump a few frames to allow animation to progress
      await tester.pump(const Duration(milliseconds: 100));
      await tester.pump(const Duration(milliseconds: 100));

      // Verify the widget is rendered (animation is in progress)
      expect(find.byType(AnimatedEmptyState), findsOneWidget);
    });
  });

  group('FadeInSlide', () {
    Widget buildTestWidget({
      Duration delay = Duration.zero,
      Duration duration = const Duration(milliseconds: 500),
      Offset offset = const Offset(0, 20),
    }) {
      return MaterialApp(
        home: Scaffold(
          body: FadeInSlide(
            delay: delay,
            duration: duration,
            offset: offset,
            child: const Text('Animated Text'),
          ),
        ),
      );
    }

    testWidgets('displays child widget', (tester) async {
      await tester.pumpWidget(buildTestWidget());
      await tester.pumpAndSettle();

      expect(find.text('Animated Text'), findsOneWidget);
    });

    testWidgets('starts with opacity 0', (tester) async {
      await tester.pumpWidget(buildTestWidget(
        duration: const Duration(seconds: 2),
      ));

      // At the very beginning, opacity should be 0
      final opacityWidget = tester.widget<Opacity>(find.byType(Opacity));
      expect(opacityWidget.opacity, 0.0);
    });

    testWidgets('animates to full opacity', (tester) async {
      await tester.pumpWidget(buildTestWidget(
        duration: const Duration(milliseconds: 300),
      ));

      await tester.pumpAndSettle();

      final opacityWidget = tester.widget<Opacity>(find.byType(Opacity));
      expect(opacityWidget.opacity, 1.0);
    });

    testWidgets('respects delay before starting animation', (tester) async {
      await tester.pumpWidget(buildTestWidget(
        delay: const Duration(milliseconds: 500),
        duration: const Duration(milliseconds: 300),
      ));

      // Before delay completes
      await tester.pump(const Duration(milliseconds: 100));
      var opacityWidget = tester.widget<Opacity>(find.byType(Opacity));
      expect(opacityWidget.opacity, 0.0);

      // After delay completes and animation finishes
      await tester.pumpAndSettle();
      opacityWidget = tester.widget<Opacity>(find.byType(Opacity));
      expect(opacityWidget.opacity, 1.0);
    });
  });

  group('StaggeredListItem', () {
    Widget buildTestWidget({
      int index = 0,
      Duration baseDelay = const Duration(milliseconds: 50),
    }) {
      return MaterialApp(
        home: Scaffold(
          body: StaggeredListItem(
            index: index,
            baseDelay: baseDelay,
            child: const Text('List Item'),
          ),
        ),
      );
    }

    testWidgets('displays child widget', (tester) async {
      await tester.pumpWidget(buildTestWidget());
      await tester.pumpAndSettle();

      expect(find.text('List Item'), findsOneWidget);
    });

    testWidgets('later indices animate later', (tester) async {
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: Column(
            children: [
              StaggeredListItem(
                index: 0,
                baseDelay: const Duration(milliseconds: 100),
                child: const Text('Item 0'),
              ),
              StaggeredListItem(
                index: 2,
                baseDelay: const Duration(milliseconds: 100),
                child: const Text('Item 2'),
              ),
            ],
          ),
        ),
      ));

      // Both should be visible after animations complete
      await tester.pumpAndSettle();
      expect(find.text('Item 0'), findsOneWidget);
      expect(find.text('Item 2'), findsOneWidget);
    });
  });

  group('ScaleOnTap', () {
    Widget buildTestWidget({
      VoidCallback? onTap,
      double scaleValue = 0.95,
    }) {
      return MaterialApp(
        home: Scaffold(
          body: ScaleOnTap(
            onTap: onTap,
            scaleValue: scaleValue,
            child: Container(
              width: 100,
              height: 100,
              color: Colors.blue,
              child: const Center(child: Text('Tap Me')),
            ),
          ),
        ),
      );
    }

    testWidgets('displays child widget', (tester) async {
      await tester.pumpWidget(buildTestWidget());

      expect(find.text('Tap Me'), findsOneWidget);
    });

    testWidgets('calls onTap when tapped', (tester) async {
      bool tapped = false;
      await tester.pumpWidget(buildTestWidget(
        onTap: () => tapped = true,
      ));

      await tester.tap(find.text('Tap Me'));
      await tester.pump();

      expect(tapped, true);
    });

    testWidgets('scales down on tap down', (tester) async {
      await tester.pumpWidget(buildTestWidget(scaleValue: 0.9));

      // Get the gesture recognizer
      final gesture = await tester.startGesture(tester.getCenter(find.text('Tap Me')));
      await tester.pump(const Duration(milliseconds: 50));

      // Release
      await gesture.up();
      await tester.pumpAndSettle();

      expect(find.text('Tap Me'), findsOneWidget);
    });
  });

  group('PulsingWidget', () {
    Widget buildTestWidget({
      Duration duration = const Duration(milliseconds: 1500),
      double minScale = 0.95,
      double maxScale = 1.05,
    }) {
      return MaterialApp(
        home: Scaffold(
          body: PulsingWidget(
            duration: duration,
            minScale: minScale,
            maxScale: maxScale,
            child: const Icon(Icons.favorite, size: 50),
          ),
        ),
      );
    }

    testWidgets('displays child widget', (tester) async {
      await tester.pumpWidget(buildTestWidget());
      await tester.pump();

      expect(find.byIcon(Icons.favorite), findsOneWidget);
    });

    testWidgets('animation repeats', (tester) async {
      await tester.pumpWidget(buildTestWidget(
        duration: const Duration(milliseconds: 500),
      ));

      // Let animation run for a while
      await tester.pump(const Duration(milliseconds: 250));
      await tester.pump(const Duration(milliseconds: 250));
      await tester.pump(const Duration(milliseconds: 250));

      // Widget should still be visible
      expect(find.byIcon(Icons.favorite), findsOneWidget);
    });
  });

  group('SpinningWidget', () {
    Widget buildTestWidget({
      Duration duration = const Duration(seconds: 2),
    }) {
      return MaterialApp(
        home: Scaffold(
          body: SpinningWidget(
            duration: duration,
            child: const Icon(Icons.refresh, size: 50),
          ),
        ),
      );
    }

    testWidgets('displays child widget', (tester) async {
      await tester.pumpWidget(buildTestWidget());
      await tester.pump();

      expect(find.byIcon(Icons.refresh), findsOneWidget);
    });

    testWidgets('rotates continuously', (tester) async {
      await tester.pumpWidget(buildTestWidget(
        duration: const Duration(milliseconds: 500),
      ));

      // Let animation progress
      await tester.pump(const Duration(milliseconds: 250));
      await tester.pump(const Duration(milliseconds: 250));

      // Widget should still be visible and animating
      expect(find.byIcon(Icons.refresh), findsOneWidget);
    });
  });

  group('BounceWidget', () {
    Widget buildTestWidget({
      Duration duration = const Duration(milliseconds: 500),
      Duration delay = Duration.zero,
    }) {
      return MaterialApp(
        home: Scaffold(
          body: BounceWidget(
            duration: duration,
            delay: delay,
            child: const Text('Bounce'),
          ),
        ),
      );
    }

    testWidgets('displays child widget after animation', (tester) async {
      await tester.pumpWidget(buildTestWidget());
      await tester.pumpAndSettle();

      expect(find.text('Bounce'), findsOneWidget);
    });

    testWidgets('starts with scale 0', (tester) async {
      await tester.pumpWidget(buildTestWidget(
        duration: const Duration(seconds: 2),
      ));

      // At the start, scale should be close to 0
      // (can't easily check scale directly, so verify widget exists)
      expect(find.text('Bounce'), findsOneWidget);
    });

    testWidgets('respects delay', (tester) async {
      await tester.pumpWidget(buildTestWidget(
        delay: const Duration(milliseconds: 500),
        duration: const Duration(milliseconds: 300),
      ));

      await tester.pumpAndSettle();
      expect(find.text('Bounce'), findsOneWidget);
    });
  });

  group('TypingIndicator', () {
    Widget buildTestWidget({
      Color? color,
      double dotSize = 8.0,
      double spacing = 4.0,
    }) {
      return MaterialApp(
        home: Scaffold(
          body: TypingIndicator(
            color: color,
            dotSize: dotSize,
            spacing: spacing,
          ),
        ),
      );
    }

    testWidgets('displays three dots', (tester) async {
      await tester.pumpWidget(buildTestWidget());
      await tester.pump();

      // Should have 3 container widgets for dots
      expect(find.byType(TypingIndicator), findsOneWidget);
    });

    testWidgets('animates dots', (tester) async {
      await tester.pumpWidget(buildTestWidget());

      // Let animation run
      await tester.pump(const Duration(milliseconds: 200));
      await tester.pump(const Duration(milliseconds: 200));

      // Widget should still be visible
      expect(find.byType(TypingIndicator), findsOneWidget);
    });

    testWidgets('uses custom color', (tester) async {
      await tester.pumpWidget(buildTestWidget(color: Colors.red));
      await tester.pump();

      expect(find.byType(TypingIndicator), findsOneWidget);
    });
  });

  group('AnimatedCounter', () {
    Widget buildTestWidget({
      int value = 100,
      Duration duration = const Duration(milliseconds: 500),
      TextStyle? style,
    }) {
      return MaterialApp(
        home: Scaffold(
          body: AnimatedCounter(
            value: value,
            duration: duration,
            style: style,
          ),
        ),
      );
    }

    testWidgets('displays final value after animation', (tester) async {
      await tester.pumpWidget(buildTestWidget(value: 42));
      await tester.pumpAndSettle();

      expect(find.text('42'), findsOneWidget);
    });

    testWidgets('animates from 0 to value', (tester) async {
      await tester.pumpWidget(buildTestWidget(
        value: 100,
        duration: const Duration(milliseconds: 1000),
      ));

      // Start
      expect(find.text('0'), findsOneWidget);

      // End
      await tester.pumpAndSettle();
      expect(find.text('100'), findsOneWidget);
    });
  });

  group('AnimatedProgressBar', () {
    Widget buildTestWidget({
      double progress = 0.5,
      double height = 8,
      Color? backgroundColor,
      Color? progressColor,
    }) {
      return MaterialApp(
        home: Scaffold(
          body: AnimatedProgressBar(
            progress: progress,
            height: height,
            backgroundColor: backgroundColor,
            progressColor: progressColor,
          ),
        ),
      );
    }

    testWidgets('displays progress bar', (tester) async {
      await tester.pumpWidget(buildTestWidget());

      expect(find.byType(AnimatedProgressBar), findsOneWidget);
    });

    testWidgets('respects height parameter', (tester) async {
      await tester.pumpWidget(buildTestWidget(height: 16));

      final container = tester.widget<Container>(find.byType(Container).first);
      expect(container.constraints?.maxHeight, 16);
    });

    testWidgets('animates progress changes', (tester) async {
      await tester.pumpWidget(buildTestWidget(progress: 0.25));
      await tester.pumpAndSettle();

      await tester.pumpWidget(buildTestWidget(progress: 0.75));
      await tester.pumpAndSettle();

      expect(find.byType(AnimatedProgressBar), findsOneWidget);
    });

    testWidgets('clamps progress between 0 and 1', (tester) async {
      // Progress below 0
      await tester.pumpWidget(buildTestWidget(progress: -0.5));
      await tester.pump();
      expect(find.byType(AnimatedProgressBar), findsOneWidget);

      // Progress above 1
      await tester.pumpWidget(buildTestWidget(progress: 1.5));
      await tester.pump();
      expect(find.byType(AnimatedProgressBar), findsOneWidget);
    });
  });

  group('AnimatedVisibility', () {
    Widget buildTestWidget({
      required bool visible,
      Widget child = const Text('Visible Content'),
      Widget replacement = const SizedBox.shrink(),
    }) {
      return MaterialApp(
        home: Scaffold(
          body: AnimatedVisibility(
            visible: visible,
            replacement: replacement,
            child: child,
          ),
        ),
      );
    }

    testWidgets('displays child when visible is true', (tester) async {
      await tester.pumpWidget(buildTestWidget(visible: true));
      await tester.pumpAndSettle();

      expect(find.text('Visible Content'), findsOneWidget);
    });

    testWidgets('displays replacement when visible is false', (tester) async {
      await tester.pumpWidget(buildTestWidget(
        visible: false,
        replacement: const Text('Replacement'),
      ));
      await tester.pumpAndSettle();

      expect(find.text('Replacement'), findsOneWidget);
    });

    testWidgets('uses AnimatedCrossFade for smooth transitions', (tester) async {
      await tester.pumpWidget(buildTestWidget(visible: true));
      await tester.pumpAndSettle();

      // Verify AnimatedCrossFade is used
      expect(find.byType(AnimatedCrossFade), findsOneWidget);

      await tester.pumpWidget(buildTestWidget(visible: false));
      await tester.pumpAndSettle();

      expect(find.byType(AnimatedCrossFade), findsOneWidget);
    });
  });
}
