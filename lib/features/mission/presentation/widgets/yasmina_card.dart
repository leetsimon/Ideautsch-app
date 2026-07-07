import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../../core/theme/spacing.dart';
import '../../../../core/widgets/multilingual_text.dart';

/// Displays a Yasmina coaching message with professional styling.
///
/// Automatically detects Arabic/Darija content and renders RTL.
/// Appears at mission briefing, mid-mission encouragement, and debrief.
class YasminaCard extends StatelessWidget {
  const YasminaCard({
    required this.message,
    super.key,
    this.onDismiss,
    this.showDismissButton = true,
  });

  final String message;
  final VoidCallback? onDismiss;
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
        padding: const EdgeInsets.symmetric(
          horizontal: Spacing.lg,
          vertical: Spacing.md,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 14,
                  backgroundColor: colorScheme.primary,
                  child: const Text(
                    'Y',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                    ),
                  ),
                ),
                const SizedBox(width: Spacing.sm),
                Text(
                  'Yasmina',
                  style: textTheme.labelLarge?.copyWith(
                    color: colorScheme.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: Spacing.sm),
            MultilingualText(
              message,
              style: textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurface,
                height: 1.5,
              ),
            ),
            if (showDismissButton) ...[
              const SizedBox(height: Spacing.md),
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
        .slideY(begin: 0.08, end: 0, duration: 400.ms, curve: Curves.easeOut);
  }
}
