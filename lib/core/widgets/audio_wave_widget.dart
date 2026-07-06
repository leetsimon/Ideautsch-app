import 'dart:math';

import 'package:flutter/material.dart';

import '../theme/spacing.dart';

/// Animated audio waveform visualization.
///
/// Displays animated bars that respond to audio amplitude,
/// used during recording and playback to give visual feedback
/// that audio is being captured/played.
class AudioWaveWidget extends StatefulWidget {
  const AudioWaveWidget({
    super.key,
    this.isActive = false,
    this.barCount = 24,
    this.height = 48,
    this.color,
    this.inactiveColor,
  });

  /// Whether the waveform is animating (recording/playing).
  final bool isActive;

  /// Number of bars in the visualization.
  final int barCount;

  /// Total height of the widget.
  final double height;

  /// Active bar color (defaults to primary).
  final Color? color;

  /// Inactive bar color (defaults to surfaceVariant).
  final Color? inactiveColor;

  @override
  State<AudioWaveWidget> createState() => _AudioWaveWidgetState();
}

class _AudioWaveWidgetState extends State<AudioWaveWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late List<double> _barHeights;
  final Random _random = Random();

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
  void didUpdateWidget(AudioWaveWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isActive && !_controller.isAnimating) {
      _controller.repeat();
    } else if (!widget.isActive && _controller.isAnimating) {
      _controller.stop();
      setState(() {
        _barHeights = List.generate(widget.barCount, (_) => 0.15);
      });
    }
  }

  void _updateBars() {
    setState(() {
      for (var i = 0; i < _barHeights.length; i++) {
        final target = 0.2 + _random.nextDouble() * 0.7;
        _barHeights[i] = _barHeights[i] + (target - _barHeights[i]) * 0.3;
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
    final colorScheme = Theme.of(context).colorScheme;
    final activeColor = widget.color ?? colorScheme.primary;
    final inactiveColor =
        widget.inactiveColor ?? colorScheme.surfaceContainerHighest;

    return SizedBox(
      height: widget.height,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: List.generate(widget.barCount, (index) {
          final barHeight = widget.isActive
              ? _barHeights[index] * widget.height
              : widget.height * 0.15;

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 1.5),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 100),
              width: 3,
              height: barHeight.clamp(4.0, widget.height),
              decoration: BoxDecoration(
                color: widget.isActive ? activeColor : inactiveColor,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          );
        }),
      ),
    );
  }
}
