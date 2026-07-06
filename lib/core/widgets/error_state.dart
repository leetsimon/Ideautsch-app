import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../theme/spacing.dart';
import 'phoenix_button.dart';

/// Graceful error state — never blames the user, always offers recovery.
///
/// Tone: "Something went wrong on our end. Here's what you can do."
/// Never shows technical error messages to the learner.
class ErrorState extends StatelessWidget {
  const ErrorState({
    super.key,
    this.title = 'Something went wrong',
    this.message = 'We couldn\'t load this content. Please try again.',
    this.onRetry,
    this.onGoBack,
    this.icon = Icons.cloud_off_rounded,
  });

  /// Error title (short, human-readable).
  final String title;

  /// Helpful message with recovery suggestion.
  final String message;

  /// Retry callback.
  final VoidCallback? onRetry;

  /// Go back callback.
  final VoidCallback? onGoBack;

  /// Error icon.
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(Spacing.xxxl),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: colorScheme.errorContainer.withOpacity(0.5),
              ),
              child: Icon(
                icon,
                size: 32,
                color: colorScheme.error.withOpacity(0.7),
              ),
            ).animate().fadeIn(duration: 300.ms),

            const SizedBox(height: Spacing.xxl),

            Text(
              title,
              style: textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: Spacing.md),

            Text(
              message,
              style: textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: Spacing.xxl),

            if (onRetry != null)
              PhoenixButton(
                label: 'Try Again',
                icon: Icons.refresh_rounded,
                onPressed: onRetry,
              ),

            if (onGoBack != null) ...[
              const SizedBox(height: Spacing.md),
              PhoenixButton(
                label: 'Go Back',
                icon: Icons.arrow_back_rounded,
                onPressed: onGoBack,
                variant: PhoenixButtonVariant.text,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
