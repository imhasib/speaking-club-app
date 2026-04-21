import 'dart:math';

import 'package:flutter/material.dart';

/// Animated audio waveform widget
class AudioWaveformWidget extends StatefulWidget {
  final bool isActive;
  final Color color;
  final double height;
  final int barCount;

  const AudioWaveformWidget({
    super.key,
    required this.isActive,
    required this.color,
    this.height = 80,
    this.barCount = 20,
  });

  @override
  State<AudioWaveformWidget> createState() => _AudioWaveformWidgetState();
}

class _AudioWaveformWidgetState extends State<AudioWaveformWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late List<double> _barHeights;
  final _random = Random();

  @override
  void initState() {
    super.initState();
    _barHeights = List.generate(widget.barCount, (_) => 0.2);
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
    )..addListener(_updateBars);

    if (widget.isActive) {
      _controller.repeat();
    }
  }

  @override
  void didUpdateWidget(AudioWaveformWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isActive != oldWidget.isActive) {
      if (widget.isActive) {
        _controller.repeat();
      } else {
        _controller.stop();
        setState(() {
          _barHeights = List.generate(widget.barCount, (_) => 0.2);
        });
      }
    }
  }

  void _updateBars() {
    if (!widget.isActive) return;

    setState(() {
      for (int i = 0; i < _barHeights.length; i++) {
        // Create a more natural wave pattern
        final baseHeight = 0.3 + sin(i * 0.3 + _controller.value * 2 * pi) * 0.2;
        final randomFactor = _random.nextDouble() * 0.3;
        _barHeights[i] = (baseHeight + randomFactor).clamp(0.15, 1.0);
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.height,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: List.generate(widget.barCount, (index) {
          return AnimatedContainer(
            duration: const Duration(milliseconds: 100),
            margin: const EdgeInsets.symmetric(horizontal: 2),
            width: 4,
            height: widget.height * _barHeights[index],
            decoration: BoxDecoration(
              color: widget.color.withOpacity(widget.isActive ? 1.0 : 0.3),
              borderRadius: BorderRadius.circular(2),
            ),
          );
        }),
      ),
    );
  }
}

/// Static waveform for displaying audio visualization
class StaticWaveform extends StatelessWidget {
  final List<double> amplitudes;
  final Color color;
  final double height;
  final double barWidth;

  const StaticWaveform({
    super.key,
    required this.amplitudes,
    required this.color,
    this.height = 40,
    this.barWidth = 3,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: amplitudes.map((amplitude) {
          return Container(
            margin: const EdgeInsets.symmetric(horizontal: 1),
            width: barWidth,
            height: height * amplitude.clamp(0.1, 1.0),
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(barWidth / 2),
            ),
          );
        }).toList(),
      ),
    );
  }
}
