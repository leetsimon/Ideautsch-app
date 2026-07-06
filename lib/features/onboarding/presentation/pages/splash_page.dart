import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/spacing.dart';

/// Premium animated splash screen.
///
/// Displays the Phoenix logo with a staggered entrance animation,
/// then automatically transitions to the home screen after
/// initialization completes.
class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    _navigateAfterDelay();
  }

  Future<void> _navigateAfterDelay() async {
    await Future<void>.delayed(const Duration(milliseconds: 2400));
    if (mounted) {
      context.go('/home');
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark
          ? const Color(0xFF0A0A12)
          : const Color(0xFFF8F9FC),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Phoenix icon with glow
            Container(
              width: 96,
              height: 96,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    colorScheme.primary.withOpacity(0.15),
                    Colors.transparent,
                  ],
                  radius: 1.5,
                ),
              ),
              child: Icon(
                Icons.local_fire_department_rounded,
                size: 56,
                color: colorScheme.primary,
              ),
            )
                .animate()
                .scale(
                  begin: const Offset(0.6, 0.6),
                  end: const Offset(1.0, 1.0),
                  duration: 800.ms,
                  curve: Curves.easeOutBack,
                )
                .fadeIn(duration: 600.ms),

            const SizedBox(height: Spacing.xxl),

            // App name
            Text(
              'Phoenix',
              style: textTheme.displayMedium?.copyWith(
                fontWeight: FontWeight.w700,
                letterSpacing: -1,
                color: colorScheme.onSurface,
              ),
            )
                .animate(delay: 300.ms)
                .fadeIn(duration: 600.ms)
                .slideY(begin: 0.3, end: 0, curve: Curves.easeOut),

            const SizedBox(height: Spacing.sm),

            // Tagline
            Text(
              'Dein Weg zum deutschen Beruf',
              style: textTheme.bodyLarge?.copyWith(
                color: colorScheme.onSurfaceVariant,
                letterSpacing: 0.3,
              ),
            )
                .animate(delay: 600.ms)
                .fadeIn(duration: 500.ms),

            const SizedBox(height: Spacing.huge),

            // Loading indicator
            SizedBox(
              width: 120,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(2),
                child: LinearProgressIndicator(
                  backgroundColor:
                      colorScheme.surfaceContainerHighest,
                  valueColor: AlwaysStoppedAnimation(
                    colorScheme.primary,
                  ),
                  minHeight: 3,
                ),
              ),
            ).animate(delay: 900.ms).fadeIn(duration: 400.ms),
          ],
        ),
      ),
    );
  }
}
