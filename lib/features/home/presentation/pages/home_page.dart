import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/spacing.dart';
import '../../../../core/widgets/phoenix_button.dart';

/// Premium home screen — the learner's daily starting point.
///
/// Optimized for Windows desktop: compact vertical layout,
/// content fits without excessive scrolling.
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(
            horizontal: Spacing.pagePaddingHorizontal,
            vertical: Spacing.lg,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: Spacing.md),
              _buildHeader(context),
              const SizedBox(height: Spacing.xl),
              _buildCareerReadiness(context),
              const SizedBox(height: Spacing.lg),
              _buildMissionCard(context),
              const SizedBox(height: Spacing.lg),
              _buildQuickStats(context),
              const SizedBox(height: Spacing.lg),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    final hour = DateTime.now().hour;
    final greeting = hour < 12
        ? 'Guten Morgen'
        : hour < 18
            ? 'Guten Tag'
            : 'Guten Abend';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          greeting,
          style: textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ).animate().fadeIn(duration: 500.ms).slideX(begin: -0.03, end: 0),
        const SizedBox(height: 2),
        Text(
          'Ready for today\'s mission?',
          style: textTheme.bodyMedium?.copyWith(
            color: colorScheme.onSurfaceVariant,
          ),
        ).animate(delay: 200.ms).fadeIn(duration: 400.ms),
      ],
    );
  }

  Widget _buildCareerReadiness(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: Spacing.lg,
        vertical: Spacing.md,
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            colorScheme.primaryContainer.withOpacity(0.4),
            colorScheme.primaryContainer.withOpacity(0.15),
          ],
        ),
        borderRadius: BorderRadius.circular(Spacing.cardRadius),
        border: Border.all(
          color: colorScheme.primary.withOpacity(0.08),
        ),
      ),
      child: Row(
        children: [
          // Compact circular progress
          SizedBox(
            width: 64,
            height: 64,
            child: Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  width: 64,
                  height: 64,
                  child: CircularProgressIndicator(
                    value: 0.03,
                    strokeWidth: 5,
                    backgroundColor: colorScheme.surfaceContainerHighest,
                    valueColor: AlwaysStoppedAnimation(colorScheme.primary),
                    strokeCap: StrokeCap.round,
                  ),
                ),
                Text(
                  '3%',
                  style: textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: colorScheme.primary,
                  ),
                ),
              ],
            ),
          )
              .animate(delay: 300.ms)
              .scale(begin: const Offset(0.8, 0.8), duration: 600.ms, curve: Curves.easeOutBack)
              .fadeIn(duration: 400.ms),

          const SizedBox(width: Spacing.lg),

          // Text beside ring
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Career Readiness',
                  style: textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'Complete missions to build your professional German',
                  style: textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ).animate(delay: 400.ms).fadeIn(duration: 500.ms).slideY(begin: 0.03, end: 0);
  }

  Widget _buildMissionCard(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(Spacing.cardRadius),
        border: Border.all(color: colorScheme.outlineVariant),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(Spacing.cardRadius),
        child: InkWell(
          borderRadius: BorderRadius.circular(Spacing.cardRadius),
          onTap: () => context.go('/mission/m01_001_d/briefing'),
          child: Padding(
            padding: const EdgeInsets.all(Spacing.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: Spacing.sm,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: colorScheme.primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(Spacing.chipRadius),
                      ),
                      child: Text(
                        'MISSION 1',
                        style: textTheme.labelSmall?.copyWith(
                          color: colorScheme.primary,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.8,
                        ),
                      ),
                    ),
                    const Spacer(),
                    Icon(
                      Icons.timer_outlined,
                      size: 14,
                      color: colorScheme.onSurfaceVariant,
                    ),
                    const SizedBox(width: 3),
                    Text(
                      '25 min',
                      style: textTheme.labelSmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: Spacing.md),
                Text(
                  'Your Phone Is Ringing',
                  style: textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'Answer your first customer call in German',
                  style: textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: Spacing.md),
                PhoenixButton(
                  label: 'Start Mission',
                  icon: Icons.play_arrow_rounded,
                  isExpanded: true,
                  onPressed: () => context.go('/mission/m01_001_d/briefing'),
                ),
              ],
            ),
          ),
        ),
      ),
    ).animate(delay: 600.ms).fadeIn(duration: 500.ms).slideY(begin: 0.03, end: 0);
  }

  Widget _buildQuickStats(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Row(
      children: [
        _StatTile(
          icon: Icons.mic_rounded,
          label: 'Speaking',
          value: '0m',
          color: colorScheme.tertiary,
        ),
        const SizedBox(width: Spacing.sm),
        _StatTile(
          icon: Icons.auto_stories_rounded,
          label: 'Vocab',
          value: '0',
          color: colorScheme.secondary,
        ),
        const SizedBox(width: Spacing.sm),
        _StatTile(
          icon: Icons.local_fire_department_rounded,
          label: 'Streak',
          value: '0d',
          color: colorScheme.error,
        ),
      ],
    ).animate(delay: 800.ms).fadeIn(duration: 400.ms);
  }
}

class _StatTile extends StatelessWidget {
  const _StatTile({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  final IconData icon;
  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: Spacing.sm,
          vertical: Spacing.md,
        ),
        decoration: BoxDecoration(
          color: color.withOpacity(0.05),
          borderRadius: BorderRadius.circular(Spacing.cardRadius),
          border: Border.all(color: color.withOpacity(0.1)),
        ),
        child: Column(
          children: [
            Icon(icon, size: 18, color: color),
            const SizedBox(height: 3),
            Text(
              value,
              style: textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w700,
                color: colorScheme.onSurface,
              ),
            ),
            Text(
              label,
              style: textTheme.labelSmall?.copyWith(
                color: colorScheme.onSurfaceVariant,
                fontSize: 10,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
