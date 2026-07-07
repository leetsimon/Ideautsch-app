import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../core/theme/spacing.dart';

/// Confirmation dialog shown when the learner attempts to leave
/// a mission in progress.
///
/// Returns true if the user confirms leaving, false if cancelled.
Future<bool> showLeaveMissionDialog(BuildContext context) async {
  final result = await showDialog<bool>(
    context: context,
    barrierDismissible: true,
    builder: (context) => const _LeaveMissionDialog(),
  );
  return result ?? false;
}

class _LeaveMissionDialog extends StatelessWidget {
  const _LeaveMissionDialog();

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Spacing.cardRadius),
      ),
      title: Text(
        'Leave this mission?',
        style: textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.w600,
        ),
      ),
      content: Text(
        'Your progress will be saved. You can resume later.',
        style: textTheme.bodyMedium?.copyWith(
          color: colorScheme.onSurfaceVariant,
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: () => Navigator.of(context).pop(true),
          child: const Text('Leave Mission'),
        ),
      ],
    );
  }
}
