import 'package:flutter/material.dart';

import '../theme/spacing.dart';

/// Primary action button used across the application.
///
/// Follows Material 3 filled button styling with Phoenix-specific
/// sizing and typography for consistent, professional appearance.
class PhoenixButton extends StatelessWidget {
  const PhoenixButton({
    required this.label,
    required this.onPressed,
    super.key,
    this.icon,
    this.isLoading = false,
    this.isExpanded = false,
    this.variant = PhoenixButtonVariant.filled,
  });

  /// Button label text.
  final String label;

  /// Callback when pressed. Null disables the button.
  final VoidCallback? onPressed;

  /// Optional leading icon.
  final IconData? icon;

  /// Whether to show a loading indicator instead of the label.
  final bool isLoading;

  /// Whether the button should expand to full width.
  final bool isExpanded;

  /// Visual variant (filled, outlined, text).
  final PhoenixButtonVariant variant;

  @override
  Widget build(BuildContext context) {
    final child = isLoading
        ? const SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(strokeWidth: 2),
          )
        : Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (icon != null) ...[
                Icon(icon, size: 20),
                const SizedBox(width: Spacing.sm),
              ],
              Text(label),
            ],
          );

    final button = switch (variant) {
      PhoenixButtonVariant.filled => FilledButton(
          onPressed: isLoading ? null : onPressed,
          child: child,
        ),
      PhoenixButtonVariant.outlined => OutlinedButton(
          onPressed: isLoading ? null : onPressed,
          child: child,
        ),
      PhoenixButtonVariant.text => TextButton(
          onPressed: isLoading ? null : onPressed,
          child: child,
        ),
    };

    if (isExpanded) {
      return SizedBox(width: double.infinity, child: button);
    }

    return button;
  }
}

/// Visual variants for PhoenixButton.
enum PhoenixButtonVariant {
  filled,
  outlined,
  text,
}
