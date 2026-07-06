import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../services/haptic_service.dart';
import '../theme/spacing.dart';

/// Elegant success celebration overlay.
///
/// NOT confetti. NOT fireworks. NOT childish.
/// A subtle, professional acknowledgment of achievement:
/// - Centered icon with spring animation
/// - Radial glow pulse
/// - Minimal particle effect (gentle rising dots)
/// - Haptic feedback
///
/// Appears for 2 seconds, then fades away.
/// Used for: mission complete, major milestones, first achievements.
class SuccessCelebration extends StatefulWidget {
  const SuccessCelebration({
    super.key,
    this.icon = Icons.workspace_premium_rounded,
    this.color,
    this.onComplete,
    this.duration = const Duration(milliseconds: 2200),
  });

  /// The celebration icon.
  final IconData icon;

  /// Icon color (defaults to gold).
  final Color? color;

  /// Callback when animation completes.
  final VoidCallback? onComplete;

  /// How long the celebration is visible.
  final Duration duration;

  @override
  State<SuccessCelebration> createState() => _SuccessCelebrationState();
}

class _SuccessCelebrationState extends State<SuccessCelebration>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    );
    _controller.forward();
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        widget.onComplete?.call();
      }
    });
    HapticService.celebration();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final celebrationColor = widget.color ?? const Color(0xFFD4A853);

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final progress = _controller.value;
        final fadeOut = progress > 0.75 ? (1.0 - progress) * 4 : 1.0;

        return Opacity(
          opacity: fadeOut.clamp(0.0, 1.0),
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Radial glow
              Container(
                width: 160,
                height: 160,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      celebrationColor.withOpacity(0.2 * (1 - progress)),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),

              // Rising particles
              ...List.generate(8, (i) {
                final angle = (i / 8) * 2 * pi;
                final distance = 40 + progress * 60;
                return Transform.translate(
                  offset: Offset(
                    cos(angle) * distance,
                    sin(angle) * distance - progress * 30,
                  ),
                  child: Opacity(
                    opacity: (1 - progress).clamp(0.0, 1.0),
                    child: Container(
                      width: 6,
                      height: 6,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: celebrationColor.withOpacity(0.6),
                      ),
                    ),
                  ),
                );
              }),

              // Center icon
              Icon(
                widget.icon,
                size: 64,
                color: celebrationColor,
              ),
            ],
          ),
        );
      },
    )
        .animate()
        .scale(
          begin: const Offset(0.3, 0.3),
          end: const Offset(1.0, 1.0),
          duration: 600.ms,
          curve: Curves.easeOutBack,
        )
        .fadeIn(duration: 300.ms);
  }
}
