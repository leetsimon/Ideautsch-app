import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../theme/spacing.dart';
import 'phoenix_button.dart';

/// Beautiful empty state widget for screens with no content yet.
///
/// Used when:
/// - No missions completed yet (progress dashboard)
/// - No vocabulary learned yet (vocabulary screen)
/// - No reviews due (review screen)
///
/// Each empty state is encouraging, not apologetic.
/// The message always points toward action.
class EmptyState extends StatelessWidget {
  const EmptyState({
    required this.icon,
    required this.title,
    required this.message,
    super.key,
    this.actionLabel,
    this.onAction,
    this.iconColor,
  });

  /// Large icon displayed above the title.
  final IconData icon;

  /// Short title (1-3 words).
  final String title;

  /// Encouraging message explaining what to do.
  final String message;

  /// Optional action button label.
  final String? actionLabel;

  /// Optional action callback.
  final VoidCallback? onAction;

  /// Custom icon color (defaults to primary at 60%).
  final Color? iconColor;

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
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: (iconColor ?? colorScheme.primary).withOpacity(0.08),
              ),
              child: Icon(
                icon,
                size: 36,
                color: iconColor ?? colorScheme.primary.withOpacity(0.6),
              ),
            )
                .animate()
                .scale(
                  begin: const Offset(0.8, 0.8),
                  duration: 500.ms,
                  curve: Curves.easeOutBack,
                )
                .fadeIn(duration: 400.ms),

            const SizedBox(height: Spacing.xxl),

            Text(
              title,
              style: textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w600,
                color: colorScheme.onSurface,
              ),
              textAlign: TextAlign.center,
            ).animate(delay: 200.ms).fadeIn(duration: 400.ms),

            const SizedBox(height: Spacing.md),

            Text(
              message,
              style: textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ).animate(delay: 300.ms).fadeIn(duration: 400.ms),

            if (actionLabel != null && onAction != null) ...[
              const SizedBox(height: Spacing.xxl),
              PhoenixButton(
                label: actionLabel!,
                onPressed: onAction,
                icon: Icons.arrow_forward_rounded,
              ).animate(delay: 500.ms).fadeIn(duration: 400.ms),
            ],
          ],
        ),
      ),
    );
  }
}
