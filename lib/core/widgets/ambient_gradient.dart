import 'package:flutter/material.dart';

/// Subtle animated ambient gradient for premium screen backgrounds.
///
/// A very soft color shift in the background that creates depth
/// without being distracting. Used on:
/// - Splash screen
/// - Mission complete screen
/// - Home dashboard (behind career ring)
///
/// The gradient is so subtle the learner may not consciously notice
/// it, but its absence would make the screen feel "flat."
class AmbientGradient extends StatelessWidget {
  const AmbientGradient({
    required this.child,
    super.key,
    this.primaryColor,
    this.intensity = 0.03,
    this.alignment = Alignment.topRight,
  });

  /// The widget to display on top of the gradient.
  final Widget child;

  /// The ambient color (defaults to theme primary).
  final Color? primaryColor;

  /// How strong the gradient is (0.0–0.2 range recommended).
  final double intensity;

  /// Where the gradient emanates from.
  final Alignment alignment;

  @override
  Widget build(BuildContext context) {
    final color = primaryColor ?? Theme.of(context).colorScheme.primary;
    final backgroundColor = Theme.of(context).scaffoldBackgroundColor;

    return Container(
      decoration: BoxDecoration(
        gradient: RadialGradient(
          center: alignment,
          radius: 1.5,
          colors: [
            color.withOpacity(intensity),
            backgroundColor,
          ],
        ),
      ),
      child: child,
    );
  }
}

/// A version with two gradient points for richer ambient feel.
class DualAmbientGradient extends StatelessWidget {
  const DualAmbientGradient({
    required this.child,
    super.key,
    this.primaryColor,
    this.secondaryColor,
    this.intensity = 0.025,
  });

  final Widget child;
  final Color? primaryColor;
  final Color? secondaryColor;
  final double intensity;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final primary = primaryColor ?? colorScheme.primary;
    final secondary = secondaryColor ?? colorScheme.tertiary;
    final bg = Theme.of(context).scaffoldBackgroundColor;

    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color.lerp(bg, primary, intensity)!,
            bg,
            Color.lerp(bg, secondary, intensity * 0.7)!,
          ],
          stops: const [0.0, 0.5, 1.0],
        ),
      ),
      child: child,
    );
  }
}
