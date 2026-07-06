import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../theme/color_tokens.dart';
import '../theme/spacing.dart';

/// Yasmina's mood expression for avatar display.
enum YasminaExpression {
  welcoming,
  coaching,
  proud,
  encouraging,
  thinking,
  neutral,
}

/// Yasmina's animated avatar with mood-based expressions.
///
/// A professional, warm visual representation of the AI mentor.
/// Uses a circular avatar with a gradient ring that subtly pulses
/// when Yasmina is "speaking" (message displayed).
class YasminaAvatar extends StatelessWidget {
  const YasminaAvatar({
    super.key,
    this.size = 48,
    this.expression = YasminaExpression.neutral,
    this.isSpeaking = false,
    this.showBadge = false,
  });

  /// Avatar diameter.
  final double size;

  /// Current mood expression.
  final YasminaExpression expression;

  /// Whether Yasmina is currently "speaking" (animates ring).
  final bool isSpeaking;

  /// Whether to show a notification badge.
  final bool showBadge;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final ringColor = isDark
        ? ColorTokens.primaryDark
        : ColorTokens.primaryLight;

    Widget avatar = Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            ringColor.withOpacity(0.8),
            ringColor,
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: ringColor.withOpacity(isSpeaking ? 0.4 : 0.15),
            blurRadius: isSpeaking ? 12 : 6,
            spreadRadius: isSpeaking ? 2 : 0,
          ),
        ],
      ),
      child: Center(
        child: Container(
          width: size - 4,
          height: size - 4,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: colorScheme.surface,
          ),
          child: Center(
            child: Text(
              _getExpressionEmoji(),
              style: TextStyle(fontSize: size * 0.4),
            ),
          ),
        ),
      ),
    );

    // Subtle pulse when speaking
    if (isSpeaking) {
      avatar = avatar
          .animate(onPlay: (c) => c.repeat(reverse: true))
          .scale(
            begin: const Offset(1.0, 1.0),
            end: const Offset(1.04, 1.04),
            duration: 1200.ms,
            curve: Curves.easeInOut,
          );
    }

    // Badge
    if (showBadge) {
      avatar = Stack(
        clipBehavior: Clip.none,
        children: [
          avatar,
          Positioned(
            right: 0,
            top: 0,
            child: Container(
              width: 12,
              height: 12,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: colorScheme.error,
                border: Border.all(
                  color: colorScheme.surface,
                  width: 2,
                ),
              ),
            ),
          ),
        ],
      );
    }

    return avatar;
  }

  String _getExpressionEmoji() {
    return switch (expression) {
      YasminaExpression.welcoming => 'Y',
      YasminaExpression.coaching => 'Y',
      YasminaExpression.proud => 'Y',
      YasminaExpression.encouraging => 'Y',
      YasminaExpression.thinking => 'Y',
      YasminaExpression.neutral => 'Y',
    };
  }
}
