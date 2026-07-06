import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../../core/theme/color_tokens.dart';
import '../../../../core/theme/spacing.dart';
import '../../../../core/widgets/phoenix_button.dart';
import '../../domain/entities/exercise_result.dart';

/// Feedback display shown after exercise evaluation.
///
/// Shows the result (success/partial/retry), feedback text,
/// and action buttons (Next / Retry / Listen Again).
class FeedbackOverlay extends StatelessWidget {
  const FeedbackOverlay({
    required this.result,
    required this.feedbackText,
    required this.onNext,
    super.key,
    this.onRetry,
    this.onListenModel,
    this.canRetry = false,
  });

  /// The exercise result being displayed.
  final ExerciseResult result;

  /// Contextual feedback text from the exercise definition.
  final String feedbackText;

  /// Navigate to the next exercise.
  final VoidCallback onNext;

  /// Retry the current exercise (if allowed).
  final VoidCallback? onRetry;

  /// Play the model audio for comparison.
  final VoidCallback? onListenModel;

  /// Whether the retry option is available.
  final bool canRetry;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final (icon, color, label) = switch (result.outcome) {
      ExerciseOutcome.success => (
          Icons.check_circle_rounded,
          isDark ? ColorTokens.successDark : ColorTokens.successLight,
          'Well done',
        ),
      ExerciseOutcome.partial => (
          Icons.info_rounded,
          colorScheme.tertiary,
          'Almost there',
        ),
      ExerciseOutcome.retry => (
          Icons.refresh_rounded,
          isDark ? ColorTokens.warningDark : ColorTokens.warningLight,
          'Let\'s try again',
        ),
      ExerciseOutcome.skipped => (
          Icons.skip_next_rounded,
          colorScheme.onSurfaceVariant,
          'Skipped',
        ),
    };

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(Spacing.xxl),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(Spacing.cardRadius),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 16,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Result indicator
          Row(
            children: [
              Icon(icon, color: color, size: 28),
              const SizedBox(width: Spacing.md),
              Text(
                label,
                style: textTheme.titleMedium?.copyWith(
                  color: color,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: Spacing.lg),

          // Feedback text
          Text(
            feedbackText,
            style: textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurface,
              height: 1.5,
            ),
          ),
          const SizedBox(height: Spacing.xxl),

          // Action buttons
          Row(
            children: [
              if (onListenModel != null)
                IconButton(
                  onPressed: onListenModel,
                  icon: const Icon(Icons.volume_up_rounded),
                  tooltip: 'Listen to model',
                ),
              if (canRetry && onRetry != null) ...[
                Expanded(
                  child: PhoenixButton(
                    label: 'Try Again',
                    onPressed: onRetry,
                    variant: PhoenixButtonVariant.outlined,
                  ),
                ),
                const SizedBox(width: Spacing.md),
              ],
              Expanded(
                child: PhoenixButton(
                  label: 'Continue',
                  onPressed: onNext,
                  variant: PhoenixButtonVariant.filled,
                ),
              ),
            ],
          ),
        ],
      ),
    )
        .animate()
        .fadeIn(duration: 300.ms)
        .slideY(begin: 0.3, end: 0, duration: 300.ms, curve: Curves.easeOut);
  }
}
