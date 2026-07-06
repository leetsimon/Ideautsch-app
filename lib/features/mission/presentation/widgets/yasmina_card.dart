import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../../core/theme/spacing.dart';

/// Displays a Yasmina coaching message with professional styling.
///
/// Appears at mission briefing, mid-mission encouragement, and debrief.
/// Animated entrance (fade + slide). Dismissible with tap or button.
class YasminaCard extends StatelessWidget {
  const YasminaCard({
    required this.message,
    super.key,
    this.onDismiss,
    this.showDismissButton = true,
  });

  /// The coaching message text.
  final String message;

  /// Callback when the card is dismissed.
  final VoidCallback? onDismiss;

  /// Whether to show a dismiss/continue button.
  final bool showDismissButton;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Card(
      elevation: 0,
      color: colorScheme.primaryContainer.withOpacity(0.4),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Spacing.cardRadius),
        side: BorderSide(
          color: colorScheme.primary.withOpacity(0.2),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(Spacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 16,
                  backgroundColor: colorScheme.primary,
                  child: const Text(
                    'Y',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                ),
                const SizedBox(width: Spacing.sm),
                Text(
                  'Yasmina',
                  style: textTheme.titleSmall?.copyWith(
                    color: colorScheme.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: Spacing.md),
            Text(
              message,
              style: textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurface,
                height: 1.6,
              ),
            ),
            if (showDismissButton) ...[
              const SizedBox(height: Spacing.lg),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: onDismiss,
                  child: const Text('Continue'),
                ),
              ),
            ],
          ],
        ),
      ),
    )
        .animate()
        .fadeIn(duration: 400.ms, curve: Curves.easeOut)
        .slideY(begin: 0.1, end: 0, duration: 400.ms, curve: Curves.easeOut);
  }
}
