import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../theme/spacing.dart';

/// Shimmer skeleton loader for content loading states.
///
/// Provides a premium loading experience instead of generic spinners.
/// Matches the shape of the content that will appear, creating a
/// seamless perceived-performance improvement.
class SkeletonLoader extends StatelessWidget {
  const SkeletonLoader({
    super.key,
    this.width,
    this.height = 16,
    this.borderRadius,
    this.margin,
  });

  /// Creates a text-shaped skeleton line.
  const SkeletonLoader.text({
    super.key,
    this.width = double.infinity,
    this.height = 14,
    this.margin = const EdgeInsets.only(bottom: 8),
  }) : borderRadius = 4;

  /// Creates a heading-shaped skeleton.
  const SkeletonLoader.heading({
    super.key,
    this.width = 200,
    this.height = 24,
    this.margin = const EdgeInsets.only(bottom: 12),
  }) : borderRadius = 6;

  /// Creates a circular skeleton (avatar, icon).
  const SkeletonLoader.circle({
    super.key,
    double size = 48,
    this.margin,
  })  : width = size,
        height = size,
        borderRadius = 9999;

  /// Creates a card-shaped skeleton.
  const SkeletonLoader.card({
    super.key,
    this.width = double.infinity,
    this.height = 120,
    this.margin = const EdgeInsets.only(bottom: 12),
  }) : borderRadius = 16;

  final double? width;
  final double height;
  final double? borderRadius;
  final EdgeInsetsGeometry? margin;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final baseColor = isDark
        ? const Color(0xFF1C2128)
        : const Color(0xFFEEEFF2);
    final highlightColor = isDark
        ? const Color(0xFF2D333B)
        : const Color(0xFFF8F9FC);

    return Container(
      width: width,
      height: height,
      margin: margin,
      decoration: BoxDecoration(
        color: baseColor,
        borderRadius: BorderRadius.circular(borderRadius ?? 4),
      ),
    )
        .animate(onPlay: (controller) => controller.repeat())
        .shimmer(
          duration: 1200.ms,
          color: highlightColor.withOpacity(0.6),
        );
  }
}

/// A pre-built skeleton for the mission card on the home screen.
class MissionCardSkeleton extends StatelessWidget {
  const MissionCardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(Spacing.lg),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(Spacing.cardRadius),
        border: Border.all(color: colorScheme.outlineVariant),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              SkeletonLoader(width: 80, height: 20, borderRadius: 6),
              Spacer(),
              SkeletonLoader(width: 50, height: 14, borderRadius: 4),
            ],
          ),
          SizedBox(height: Spacing.lg),
          SkeletonLoader.heading(width: 220),
          SizedBox(height: Spacing.xs),
          SkeletonLoader.text(width: 280),
          SizedBox(height: Spacing.lg),
          SkeletonLoader(
            width: double.infinity,
            height: 52,
            borderRadius: 12,
          ),
        ],
      ),
    );
  }
}

/// A pre-built skeleton for the exercise content area.
class ExerciseSkeleton extends StatelessWidget {
  const ExerciseSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.all(Spacing.pagePaddingHorizontal),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SkeletonLoader.text(width: 240),
          SizedBox(height: Spacing.xxxl),
          SkeletonLoader.card(height: 80),
          SizedBox(height: Spacing.xxxl),
          SkeletonLoader(width: 160, height: 52, borderRadius: 12),
          SizedBox(height: Spacing.huge),
          SkeletonLoader.circle(size: 80),
        ],
      ),
    );
  }
}
