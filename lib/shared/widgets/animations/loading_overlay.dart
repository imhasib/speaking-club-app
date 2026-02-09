import 'package:flutter/material.dart';

/// Full screen loading overlay
class LoadingOverlay extends StatelessWidget {
  const LoadingOverlay({
    super.key,
    required this.isLoading,
    required this.child,
    this.message,
    this.opacity = 0.5,
  });

  final bool isLoading;
  final Widget child;
  final String? message;
  final double opacity;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,
        if (isLoading)
          Positioned.fill(
            child: Container(
              color: Colors.black.withOpacity(opacity),
              child: Center(
                child: _LoadingContent(message: message),
              ),
            ),
          ),
      ],
    );
  }
}

class _LoadingContent extends StatelessWidget {
  const _LoadingContent({this.message});

  final String? message;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const CircularProgressIndicator(),
          if (message != null) ...[
            const SizedBox(height: 16),
            Text(
              message!,
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
          ],
        ],
      ),
    );
  }
}

/// Animated loading button
class LoadingButton extends StatelessWidget {
  const LoadingButton({
    super.key,
    required this.onPressed,
    required this.child,
    this.isLoading = false,
    this.loadingText,
    this.style,
    this.icon,
  });

  final VoidCallback? onPressed;
  final Widget child;
  final bool isLoading;
  final String? loadingText;
  final ButtonStyle? style;
  final Widget? icon;

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 200),
      child: isLoading
          ? FilledButton(
              key: const ValueKey('loading'),
              onPressed: null,
              style: style,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                  if (loadingText != null) ...[
                    const SizedBox(width: 12),
                    Text(loadingText!),
                  ],
                ],
              ),
            )
          : icon != null
              ? FilledButton.icon(
                  key: const ValueKey('normal'),
                  onPressed: onPressed,
                  style: style,
                  icon: icon!,
                  label: child,
                )
              : FilledButton(
                  key: const ValueKey('normal'),
                  onPressed: onPressed,
                  style: style,
                  child: child,
                ),
    );
  }
}

/// Success animation (checkmark)
class SuccessAnimation extends StatefulWidget {
  const SuccessAnimation({
    super.key,
    this.size = 80,
    this.color,
    this.onComplete,
  });

  final double size;
  final Color? color;
  final VoidCallback? onComplete;

  @override
  State<SuccessAnimation> createState() => _SuccessAnimationState();
}

class _SuccessAnimationState extends State<SuccessAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _checkAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    _scaleAnimation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween(begin: 0.0, end: 1.2).chain(
          CurveTween(curve: Curves.easeOut),
        ),
        weight: 60,
      ),
      TweenSequenceItem(
        tween: Tween(begin: 1.2, end: 1.0).chain(
          CurveTween(curve: Curves.easeIn),
        ),
        weight: 40,
      ),
    ]).animate(_controller);

    _checkAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.4, 1.0, curve: Curves.easeOut),
      ),
    );

    _controller.forward().then((_) {
      widget.onComplete?.call();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final color = widget.color ?? Theme.of(context).colorScheme.primary;

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: Container(
            width: widget.size,
            height: widget.size,
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: CustomPaint(
              painter: _CheckmarkPainter(
                progress: _checkAnimation.value,
                color: color,
                strokeWidth: widget.size / 15,
              ),
            ),
          ),
        );
      },
    );
  }
}

class _CheckmarkPainter extends CustomPainter {
  _CheckmarkPainter({
    required this.progress,
    required this.color,
    required this.strokeWidth,
  });

  final double progress;
  final Color color;
  final double strokeWidth;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    final center = Offset(size.width / 2, size.height / 2);
    final checkSize = size.width * 0.4;

    final path = Path();
    final start = Offset(center.dx - checkSize * 0.5, center.dy);
    final mid = Offset(center.dx - checkSize * 0.15, center.dy + checkSize * 0.35);
    final end = Offset(center.dx + checkSize * 0.5, center.dy - checkSize * 0.35);

    if (progress <= 0.5) {
      // First stroke: start to mid
      final firstProgress = progress * 2;
      path.moveTo(start.dx, start.dy);
      path.lineTo(
        start.dx + (mid.dx - start.dx) * firstProgress,
        start.dy + (mid.dy - start.dy) * firstProgress,
      );
    } else {
      // Full first stroke
      path.moveTo(start.dx, start.dy);
      path.lineTo(mid.dx, mid.dy);

      // Second stroke: mid to end
      final secondProgress = (progress - 0.5) * 2;
      path.lineTo(
        mid.dx + (end.dx - mid.dx) * secondProgress,
        mid.dy + (end.dy - mid.dy) * secondProgress,
      );
    }

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(_CheckmarkPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}

/// Error animation (X mark)
class ErrorAnimation extends StatefulWidget {
  const ErrorAnimation({
    super.key,
    this.size = 80,
    this.color,
    this.onComplete,
  });

  final double size;
  final Color? color;
  final VoidCallback? onComplete;

  @override
  State<ErrorAnimation> createState() => _ErrorAnimationState();
}

class _ErrorAnimationState extends State<ErrorAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _xAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    _scaleAnimation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween(begin: 0.0, end: 1.2).chain(
          CurveTween(curve: Curves.easeOut),
        ),
        weight: 60,
      ),
      TweenSequenceItem(
        tween: Tween(begin: 1.2, end: 1.0).chain(
          CurveTween(curve: Curves.easeIn),
        ),
        weight: 40,
      ),
    ]).animate(_controller);

    _xAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.4, 1.0, curve: Curves.easeOut),
      ),
    );

    _controller.forward().then((_) {
      widget.onComplete?.call();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final color = widget.color ?? Theme.of(context).colorScheme.error;

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: Container(
            width: widget.size,
            height: widget.size,
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: CustomPaint(
              painter: _XMarkPainter(
                progress: _xAnimation.value,
                color: color,
                strokeWidth: widget.size / 15,
              ),
            ),
          ),
        );
      },
    );
  }
}

class _XMarkPainter extends CustomPainter {
  _XMarkPainter({
    required this.progress,
    required this.color,
    required this.strokeWidth,
  });

  final double progress;
  final Color color;
  final double strokeWidth;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    final center = Offset(size.width / 2, size.height / 2);
    final xSize = size.width * 0.3;

    if (progress <= 0.5) {
      // First line (top-left to bottom-right)
      final firstProgress = progress * 2;
      final start = Offset(center.dx - xSize, center.dy - xSize);
      final end = Offset(center.dx + xSize, center.dy + xSize);
      canvas.drawLine(
        start,
        Offset(
          start.dx + (end.dx - start.dx) * firstProgress,
          start.dy + (end.dy - start.dy) * firstProgress,
        ),
        paint,
      );
    } else {
      // Full first line
      canvas.drawLine(
        Offset(center.dx - xSize, center.dy - xSize),
        Offset(center.dx + xSize, center.dy + xSize),
        paint,
      );

      // Second line (top-right to bottom-left)
      final secondProgress = (progress - 0.5) * 2;
      final start = Offset(center.dx + xSize, center.dy - xSize);
      final end = Offset(center.dx - xSize, center.dy + xSize);
      canvas.drawLine(
        start,
        Offset(
          start.dx + (end.dx - start.dx) * secondProgress,
          start.dy + (end.dy - start.dy) * secondProgress,
        ),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(_XMarkPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}

/// Animated connection status indicator
class ConnectionStatusIndicator extends StatelessWidget {
  const ConnectionStatusIndicator({
    super.key,
    required this.isConnected,
    this.size = 12,
  });

  final bool isConnected;
  final double size;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: isConnected ? Colors.green : Colors.red,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: (isConnected ? Colors.green : Colors.red).withOpacity(0.5),
            blurRadius: isConnected ? 6 : 0,
            spreadRadius: isConnected ? 2 : 0,
          ),
        ],
      ),
    );
  }
}

/// Animated search indicator (radar-like)
class SearchingIndicator extends StatefulWidget {
  const SearchingIndicator({
    super.key,
    this.size = 100,
    this.color,
    this.duration = const Duration(milliseconds: 2000),
  });

  final double size;
  final Color? color;
  final Duration duration;

  @override
  State<SearchingIndicator> createState() => _SearchingIndicatorState();
}

class _SearchingIndicatorState extends State<SearchingIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    );
    _controller.repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final color = widget.color ?? Theme.of(context).colorScheme.primary;

    return SizedBox(
      width: widget.size,
      height: widget.size,
      child: Stack(
        alignment: Alignment.center,
        children: List.generate(3, (index) {
          return AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              final delay = index / 3;
              final animValue = ((_controller.value + delay) % 1.0);
              return Transform.scale(
                scale: 0.3 + animValue * 0.7,
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: color.withOpacity(1 - animValue),
                      width: 2,
                    ),
                  ),
                ),
              );
            },
          );
        }),
      ),
    );
  }
}
