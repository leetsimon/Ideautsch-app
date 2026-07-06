import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../theme/color_tokens.dart';
import '../theme/spacing.dart';

/// Animated microphone button for speech recording.
///
/// States:
/// - Idle: Blue circle with mic icon, ready to record
/// - Recording: Red pulsing circle with stop icon
/// - Disabled: Grey circle (no microphone permission)
class MicrophoneButton extends StatelessWidget {
  const MicrophoneButton({
    required this.onPressed,
    super.key,
    this.isRecording = false,
    this.isDisabled = false,
    this.size = Spacing.largeButton,
  });

  /// Callback when the button is pressed (start or stop recording).
  final VoidCallback? onPressed;

  /// Whether recording is currently active.
  final bool isRecording;

  /// Whether the button is disabled (e.g., no mic permission).
  final bool isDisabled;

  /// Button diameter.
  final double size;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    final backgroundColor = isDisabled
        ? colorScheme.surfaceContainerHighest
        : isRecording
            ? ColorTokens.recordingActive
            : colorScheme.primary;

    final iconColor = isDisabled
        ? colorScheme.onSurfaceVariant
        : Colors.white;

    final icon = isRecording ? Icons.stop_rounded : Icons.mic_rounded;

    Widget button = Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: backgroundColor,
        shape: BoxShape.circle,
        boxShadow: isDisabled
            ? null
            : [
                BoxShadow(
                  color: backgroundColor.withOpacity(0.3),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: isDisabled ? null : onPressed,
          customBorder: const CircleBorder(),
          child: Center(
            child: Icon(icon, color: iconColor, size: size * 0.4),
          ),
        ),
      ),
    );

    // Add pulsing animation when recording
    if (isRecording) {
      button = button
          .animate(onPlay: (controller) => controller.repeat())
          .scale(
            begin: const Offset(1.0, 1.0),
            end: const Offset(1.08, 1.08),
            duration: 800.ms,
            curve: Curves.easeInOut,
          )
          .then()
          .scale(
            begin: const Offset(1.08, 1.08),
            end: const Offset(1.0, 1.0),
            duration: 800.ms,
            curve: Curves.easeInOut,
          );
    }

    return button;
  }
}
