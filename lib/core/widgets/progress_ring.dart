import 'dart:math';

import 'package:flutter/material.dart';

/// Animated circular progress ring.
///
/// Used for career readiness display, module completion,
/// and individual domain progress visualization.
/// Animates smoothly between values.
class ProgressRing extends StatelessWidget {
  const ProgressRing({
    required this.value,
    super.key,
    this.size = 120,
    this.strokeWidth = 8,
    this.backgroundColor,
    this.foregroundColor,
    this.child,
    this.animationDuration = const Duration(milliseconds: 800),
  });

  /// Progress value (0.0–1.0).
  final double value;

  /// Ring diameter.
  final double size;

  /// Ring stroke width.
  final double strokeWidth;

  /// Track color (behind the progress arc).
  final Color? backgroundColor;

  /// Progress arc color.
  final Color? foregroundColor;

  /// Widget displayed in the center of the ring.
  final Widget? child;

  /// Duration for the animation.
  final Duration animationDuration;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final bgColor = backgroundColor ?? colorScheme.surfaceContainerHighest;
    final fgColor = foregroundColor ?? colorScheme.primary;

    return SizedBox(
      width: size,
      height: size,
      child: TweenAnimationBuilder<double>(
        tween: Tween(begin: 0, end: value.clamp(0.0, 1.0)),
        duration: animationDuration,
        curve: Curves.easeOutCubic,
        builder: (context, animatedValue, _) {
          return Stack(
            alignment: Alignment.center,
            children: [
              CustomPaint(
                size: Size(size, size),
                painter: _RingPainter(
                  progress: animatedValue,
                  strokeWidth: strokeWidth,
                  backgroundColor: bgColor,
                  foregroundColor: fgColor,
                ),
              ),
              if (child != null) child!,
            ],
          );
        },
      ),
    );
  }
}

class _RingPainter extends CustomPainter {
  _RingPainter({
    required this.progress,
    required this.strokeWidth,
    required this.backgroundColor,
    required this.foregroundColor,
  });

  final double progress;
  final double strokeWidth;
  final Color backgroundColor;
  final Color foregroundColor;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - strokeWidth) / 2;

    // Background track
    final bgPaint = Paint()
      ..color = backgroundColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(center, radius, bgPaint);

    // Foreground arc
    if (progress > 0) {
      final fgPaint = Paint()
        ..color = foregroundColor
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        ..strokeCap = StrokeCap.round;

      final sweepAngle = 2 * pi * progress;
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        -pi / 2,
        sweepAngle,
        false,
        fgPaint,
      );
    }
  }

  @override
  bool shouldRepaint(_RingPainter oldDelegate) =>
      oldDelegate.progress != progress ||
      oldDelegate.foregroundColor != foregroundColor;
}
