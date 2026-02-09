import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Custom page transition types
enum PageTransitionType {
  fade,
  slideUp,
  slideRight,
  scale,
  fadeScale,
  slideUpFade,
}

/// Custom page transition builder for GoRouter
CustomTransitionPage<T> buildPageWithTransition<T>({
  required BuildContext context,
  required GoRouterState state,
  required Widget child,
  PageTransitionType type = PageTransitionType.fadeScale,
  Duration duration = const Duration(milliseconds: 300),
  Curve curve = Curves.easeInOut,
}) {
  return CustomTransitionPage<T>(
    key: state.pageKey,
    child: child,
    transitionDuration: duration,
    reverseTransitionDuration: duration,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      return _buildTransition(
        type: type,
        animation: animation,
        secondaryAnimation: secondaryAnimation,
        child: child,
        curve: curve,
      );
    },
  );
}

Widget _buildTransition({
  required PageTransitionType type,
  required Animation<double> animation,
  required Animation<double> secondaryAnimation,
  required Widget child,
  required Curve curve,
}) {
  final curvedAnimation = CurvedAnimation(
    parent: animation,
    curve: curve,
  );

  switch (type) {
    case PageTransitionType.fade:
      return FadeTransition(
        opacity: curvedAnimation,
        child: child,
      );

    case PageTransitionType.slideUp:
      return SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(0, 1),
          end: Offset.zero,
        ).animate(curvedAnimation),
        child: child,
      );

    case PageTransitionType.slideRight:
      return SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(1, 0),
          end: Offset.zero,
        ).animate(curvedAnimation),
        child: child,
      );

    case PageTransitionType.scale:
      return ScaleTransition(
        scale: Tween<double>(begin: 0.8, end: 1.0).animate(curvedAnimation),
        child: child,
      );

    case PageTransitionType.fadeScale:
      return FadeTransition(
        opacity: curvedAnimation,
        child: ScaleTransition(
          scale: Tween<double>(begin: 0.95, end: 1.0).animate(curvedAnimation),
          child: child,
        ),
      );

    case PageTransitionType.slideUpFade:
      return FadeTransition(
        opacity: curvedAnimation,
        child: SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0, 0.1),
            end: Offset.zero,
          ).animate(curvedAnimation),
          child: child,
        ),
      );
  }
}

/// Shared axis transition (Material motion)
class SharedAxisTransitionPage<T> extends CustomTransitionPage<T> {
  SharedAxisTransitionPage({
    required super.child,
    super.key,
    this.transitionType = SharedAxisTransitionType.horizontal,
    Duration duration = const Duration(milliseconds: 300),
  }) : super(
          transitionDuration: duration,
          reverseTransitionDuration: duration,
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return _SharedAxisTransition(
              animation: animation,
              secondaryAnimation: secondaryAnimation,
              transitionType: transitionType,
              child: child,
            );
          },
        );

  final SharedAxisTransitionType transitionType;
}

enum SharedAxisTransitionType { horizontal, vertical, scaled }

class _SharedAxisTransition extends StatelessWidget {
  const _SharedAxisTransition({
    required this.animation,
    required this.secondaryAnimation,
    required this.transitionType,
    required this.child,
  });

  final Animation<double> animation;
  final Animation<double> secondaryAnimation;
  final SharedAxisTransitionType transitionType;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final curve = CurvedAnimation(
      parent: animation,
      curve: Curves.easeInOut,
    );

    final secondaryCurve = CurvedAnimation(
      parent: secondaryAnimation,
      curve: Curves.easeInOut,
    );

    Widget result = child;

    switch (transitionType) {
      case SharedAxisTransitionType.horizontal:
        result = SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0.3, 0),
            end: Offset.zero,
          ).animate(curve),
          child: SlideTransition(
            position: Tween<Offset>(
              begin: Offset.zero,
              end: const Offset(-0.3, 0),
            ).animate(secondaryCurve),
            child: child,
          ),
        );
        break;
      case SharedAxisTransitionType.vertical:
        result = SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0, 0.3),
            end: Offset.zero,
          ).animate(curve),
          child: SlideTransition(
            position: Tween<Offset>(
              begin: Offset.zero,
              end: const Offset(0, -0.3),
            ).animate(secondaryCurve),
            child: child,
          ),
        );
        break;
      case SharedAxisTransitionType.scaled:
        result = ScaleTransition(
          scale: Tween<double>(begin: 0.8, end: 1.0).animate(curve),
          child: ScaleTransition(
            scale: Tween<double>(begin: 1.0, end: 1.1).animate(secondaryCurve),
            child: child,
          ),
        );
        break;
    }

    return FadeTransition(
      opacity: curve,
      child: FadeTransition(
        opacity: Tween<double>(begin: 1.0, end: 0.0).animate(secondaryCurve),
        child: result,
      ),
    );
  }
}

/// Hero dialog route for seamless transitions
class HeroDialogRoute<T> extends PageRoute<T> {
  HeroDialogRoute({
    required this.builder,
    this.barrierColor = Colors.black54,
    this.barrierDismissible = true,
    super.settings,
  });

  final WidgetBuilder builder;

  @override
  final Color barrierColor;

  @override
  final bool barrierDismissible;

  @override
  String? get barrierLabel => null;

  @override
  bool get opaque => false;

  @override
  bool get maintainState => true;

  @override
  Duration get transitionDuration => const Duration(milliseconds: 300);

  @override
  Widget buildPage(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
  ) {
    return builder(context);
  }

  @override
  Widget buildTransitions(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    return FadeTransition(
      opacity: CurvedAnimation(parent: animation, curve: Curves.easeOut),
      child: child,
    );
  }
}
