import 'package:flutter/material.dart';

/// Smoothly animated number counter.
///
/// Instead of instantly showing "42%", the number counts up
/// from the previous value. Creates a satisfying sense of
/// growth and progress.
///
/// Used for:
/// - Career readiness percentage
/// - Speaking time
/// - Vocabulary count
/// - Score display on mission complete
class AnimatedCounter extends StatelessWidget {
  const AnimatedCounter({
    required this.value,
    super.key,
    this.style,
    this.duration = const Duration(milliseconds: 800),
    this.curve = Curves.easeOutCubic,
    this.suffix = '',
    this.prefix = '',
    this.decimals = 0,
  });

  /// The target number to display.
  final double value;

  /// Text style for the number.
  final TextStyle? style;

  /// Animation duration.
  final Duration duration;

  /// Animation curve.
  final Curve curve;

  /// Text appended after the number (e.g., "%", "s", "m").
  final String suffix;

  /// Text prepended before the number (e.g., "+", "€").
  final String prefix;

  /// Number of decimal places to show.
  final int decimals;

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: value),
      duration: duration,
      curve: curve,
      builder: (context, animatedValue, child) {
        final displayValue = decimals > 0
            ? animatedValue.toStringAsFixed(decimals)
            : animatedValue.round().toString();

        return Text(
          '$prefix$displayValue$suffix',
          style: style ?? Theme.of(context).textTheme.headlineMedium,
        );
      },
    );
  }
}

/// Animated counter specifically for integer values.
class AnimatedIntCounter extends StatelessWidget {
  const AnimatedIntCounter({
    required this.value,
    super.key,
    this.style,
    this.duration = const Duration(milliseconds: 800),
    this.suffix = '',
    this.prefix = '',
  });

  final int value;
  final TextStyle? style;
  final Duration duration;
  final String suffix;
  final String prefix;

  @override
  Widget build(BuildContext context) {
    return AnimatedCounter(
      value: value.toDouble(),
      style: style,
      duration: duration,
      suffix: suffix,
      prefix: prefix,
    );
  }
}
