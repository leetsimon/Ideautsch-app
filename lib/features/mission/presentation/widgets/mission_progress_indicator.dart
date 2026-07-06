import 'package:flutter/material.dart';

import '../../../../core/theme/spacing.dart';

/// Top progress bar showing mission completion progress.
///
/// Displays a smooth animated linear progress indicator
/// with exercise count (e.g., "3 / 10").
class MissionProgressIndicator extends StatelessWidget {
  const MissionProgressIndicator({
    required this.current,
    required this.total,
    super.key,
  });

  /// Current exercise index (0-based, displayed as 1-based).
  final int current;

  /// Total number of exercises in the mission.
  final int total;

  double get _progress => total > 0 ? (current + 1) / total : 0.0;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: Spacing.pagePaddingHorizontal,
        vertical: Spacing.sm,
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${current + 1} / $total',
                style: textTheme.labelMedium?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
              Text(
                '${(_progress * 100).round()}%',
                style: textTheme.labelMedium?.copyWith(
                  color: colorScheme.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: Spacing.xs),
          ClipRRect(
            borderRadius: BorderRadius.circular(3),
            child: TweenAnimationBuilder<double>(
              tween: Tween(begin: 0, end: _progress),
              duration: const Duration(milliseconds: 400),
              curve: Curves.easeOutCubic,
              builder: (context, value, _) {
                return LinearProgressIndicator(
                  value: value,
                  minHeight: 6,
                  backgroundColor: colorScheme.surfaceContainerHighest,
                  valueColor: AlwaysStoppedAnimation(colorScheme.primary),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
