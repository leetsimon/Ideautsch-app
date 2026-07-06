import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

/// Applies staggered entrance animations to child widgets.
///
/// Wraps a Column or list of widgets, applying a fadeIn + slideY
/// animation to each child with a progressive delay. Creates the
/// effect of content "flowing" onto the screen naturally.
///
/// Used on every major screen for premium entrance feel.
class StaggeredEntrance extends StatelessWidget {
  const StaggeredEntrance({
    required this.children,
    super.key,
    this.staggerDelay = const Duration(milliseconds: 80),
    this.initialDelay = Duration.zero,
    this.slideDistance = 12,
    this.duration = const Duration(milliseconds: 400),
    this.crossAxisAlignment = CrossAxisAlignment.start,
  });

  /// Widgets to animate with staggered entrance.
  final List<Widget> children;

  /// Delay between each child's animation start.
  final Duration staggerDelay;

  /// Initial delay before the first child animates.
  final Duration initialDelay;

  /// How far each child slides up during entrance (pixels).
  final double slideDistance;

  /// Duration of each child's animation.
  final Duration duration;

  /// Cross-axis alignment for the internal Column.
  final CrossAxisAlignment crossAxisAlignment;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: crossAxisAlignment,
      children: [
        for (var i = 0; i < children.length; i++)
          children[i]
              .animate(
                delay: initialDelay + (staggerDelay * i),
              )
              .fadeIn(duration: duration, curve: Curves.easeOut)
              .slideY(
                begin: slideDistance / 100,
                end: 0,
                duration: duration,
                curve: Curves.easeOutCubic,
              ),
      ],
    );
  }
}

/// A simpler version that just fades in a single widget with slide.
class FadeSlideIn extends StatelessWidget {
  const FadeSlideIn({
    required this.child,
    super.key,
    this.delay = Duration.zero,
    this.duration = const Duration(milliseconds: 400),
    this.slideOffset = 0.05,
  });

  final Widget child;
  final Duration delay;
  final Duration duration;
  final double slideOffset;

  @override
  Widget build(BuildContext context) {
    return child
        .animate(delay: delay)
        .fadeIn(duration: duration, curve: Curves.easeOut)
        .slideY(
          begin: slideOffset,
          end: 0,
          duration: duration,
          curve: Curves.easeOutCubic,
        );
  }
}
