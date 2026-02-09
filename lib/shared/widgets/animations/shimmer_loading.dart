import 'package:flutter/material.dart';

/// Shimmer effect widget for loading states
class Shimmer extends StatefulWidget {
  const Shimmer({
    super.key,
    required this.child,
    this.baseColor,
    this.highlightColor,
    this.duration = const Duration(milliseconds: 1500),
    this.enabled = true,
  });

  final Widget child;
  final Color? baseColor;
  final Color? highlightColor;
  final Duration duration;
  final bool enabled;

  @override
  State<Shimmer> createState() => _ShimmerState();
}

class _ShimmerState extends State<Shimmer> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    );
    _animation = Tween<double>(begin: -1.0, end: 2.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
    if (widget.enabled) {
      _controller.repeat();
    }
  }

  @override
  void didUpdateWidget(Shimmer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.enabled != oldWidget.enabled) {
      if (widget.enabled) {
        _controller.repeat();
      } else {
        _controller.stop();
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.enabled) {
      return widget.child;
    }

    final colorScheme = Theme.of(context).colorScheme;
    final baseColor = widget.baseColor ?? colorScheme.surfaceContainerHighest;
    final highlightColor = widget.highlightColor ?? colorScheme.surface;

    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return ShaderMask(
          shaderCallback: (bounds) {
            return LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [
                baseColor,
                highlightColor,
                baseColor,
              ],
              stops: [
                _animation.value - 0.3,
                _animation.value,
                _animation.value + 0.3,
              ].map((s) => s.clamp(0.0, 1.0)).toList(),
            ).createShader(bounds);
          },
          blendMode: BlendMode.srcATop,
          child: widget.child,
        );
      },
    );
  }
}

/// Shimmer box placeholder
class ShimmerBox extends StatelessWidget {
  const ShimmerBox({
    super.key,
    this.width,
    this.height,
    this.borderRadius,
    this.shape = BoxShape.rectangle,
  });

  final double? width;
  final double? height;
  final BorderRadius? borderRadius;
  final BoxShape shape;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest,
        borderRadius: shape == BoxShape.circle ? null : (borderRadius ?? BorderRadius.circular(8)),
        shape: shape,
      ),
    );
  }
}

/// Shimmer loading for user cards
class ShimmerUserCard extends StatelessWidget {
  const ShimmerUserCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const ShimmerBox(
              width: 64,
              height: 64,
              shape: BoxShape.circle,
            ),
            const SizedBox(height: 12),
            ShimmerBox(
              width: 80,
              height: 16,
              borderRadius: BorderRadius.circular(4),
            ),
            const SizedBox(height: 8),
            ShimmerBox(
              width: 50,
              height: 12,
              borderRadius: BorderRadius.circular(4),
            ),
          ],
        ),
      ),
    );
  }
}

/// Shimmer loading grid for online users
class ShimmerUserGrid extends StatelessWidget {
  const ShimmerUserGrid({
    super.key,
    this.itemCount = 6,
  });

  final int itemCount;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 0.9,
      ),
      itemCount: itemCount,
      itemBuilder: (context, index) => const ShimmerUserCard(),
    );
  }
}

/// Shimmer loading for call history items
class ShimmerCallHistoryItem extends StatelessWidget {
  const ShimmerCallHistoryItem({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            const ShimmerBox(
              width: 48,
              height: 48,
              shape: BoxShape.circle,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ShimmerBox(
                    width: 120,
                    height: 16,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  const SizedBox(height: 8),
                  ShimmerBox(
                    width: 80,
                    height: 12,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ],
              ),
            ),
            ShimmerBox(
              width: 60,
              height: 12,
              borderRadius: BorderRadius.circular(4),
            ),
          ],
        ),
      ),
    );
  }
}

/// Shimmer loading list for call history
class ShimmerCallHistoryList extends StatelessWidget {
  const ShimmerCallHistoryList({
    super.key,
    this.itemCount = 8,
  });

  final int itemCount;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      itemCount: itemCount,
      itemBuilder: (context, index) => const ShimmerCallHistoryItem(),
    );
  }
}

/// Shimmer loading for profile
class ShimmerProfile extends StatelessWidget {
  const ShimmerProfile({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const ShimmerBox(
              width: 100,
              height: 100,
              shape: BoxShape.circle,
            ),
            const SizedBox(height: 24),
            ShimmerBox(
              width: 150,
              height: 24,
              borderRadius: BorderRadius.circular(4),
            ),
            const SizedBox(height: 16),
            ShimmerBox(
              width: 200,
              height: 16,
              borderRadius: BorderRadius.circular(4),
            ),
            const SizedBox(height: 32),
            ...List.generate(
              4,
              (index) => Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: ShimmerBox(
                  width: double.infinity,
                  height: 56,
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
