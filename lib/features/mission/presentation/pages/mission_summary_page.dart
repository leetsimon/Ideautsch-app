import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/color_tokens.dart';
import '../../../../core/theme/spacing.dart';
import '../../../../core/widgets/phoenix_button.dart';
import '../../../../core/widgets/phoenix_scaffold.dart';
import '../../domain/entities/mission.dart';
import '../bloc/mission_bloc.dart';
import '../bloc/mission_state.dart';
import '../widgets/yasmina_card.dart';

/// Mission completion summary screen.
///
/// Shows the outcome (gold/silver/bronze), key metrics,
/// Yasmina's debrief, and navigation to continue.
class MissionSummaryPage extends StatelessWidget {
  const MissionSummaryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MissionBloc, MissionState>(
      builder: (context, state) {
        if (state is! MissionCompleted) {
          return const PhoenixScaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        final result = state.result;
        final isDark = Theme.of(context).brightness == Brightness.dark;

        return PhoenixScaffold(
          body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: Spacing.huge),

                // Outcome badge
                _buildOutcomeBadge(context, result.outcome, isDark),
                const SizedBox(height: Spacing.xxl),

                // Mission title
                Text(
                  'Mission Complete',
                  style: Theme.of(context).textTheme.headlineMedium,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: Spacing.sm),
                Text(
                  state.mission.titleEn,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: Spacing.xxxl),

                // Stats row
                _buildStatsRow(context, state),
                const SizedBox(height: Spacing.xxxl),

                // Yasmina debrief
                YasminaCard(
                  message: state.yasminaDebrief,
                  showDismissButton: false,
                ),
                const SizedBox(height: Spacing.xxxl),

                // Continue button
                PhoenixButton(
                  label: 'Continue',
                  icon: Icons.arrow_forward_rounded,
                  isExpanded: true,
                  onPressed: () {
                    Navigator.of(context).popUntil(
                      (route) => route.isFirst,
                    );
                  },
                ),
                const SizedBox(height: Spacing.xxl),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildOutcomeBadge(
    BuildContext context,
    MissionOutcome outcome,
    bool isDark,
  ) {
    final (icon, color, label) = switch (outcome) {
      MissionOutcome.accomplished => (
          Icons.workspace_premium_rounded,
          const Color(0xFFFFD700),
          'Accomplished',
        ),
      MissionOutcome.completed => (
          Icons.verified_rounded,
          const Color(0xFFC0C0C0),
          'Completed',
        ),
      MissionOutcome.advanced => (
          Icons.trending_up_rounded,
          const Color(0xFFCD7F32),
          'Advanced',
        ),
      MissionOutcome.attempted => (
          Icons.flag_rounded,
          isDark ? ColorTokens.onSurfaceDark : ColorTokens.onSurfaceLight,
          'Attempted',
        ),
    };

    return Column(
      children: [
        Icon(icon, size: 64, color: color)
            .animate()
            .scale(
              begin: const Offset(0.5, 0.5),
              end: const Offset(1.0, 1.0),
              duration: 600.ms,
              curve: Curves.elasticOut,
            )
            .fadeIn(duration: 300.ms),
        const SizedBox(height: Spacing.md),
        Text(
          label,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: color,
                fontWeight: FontWeight.w700,
              ),
        ),
      ],
    );
  }

  Widget _buildStatsRow(BuildContext context, MissionCompleted state) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    final result = state.result;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _StatItem(
          label: 'Speaking',
          value: '${result.totalSpeakingTimeSeconds}s',
          icon: Icons.mic_rounded,
        ),
        _StatItem(
          label: 'Exercises',
          value: '${result.successfulExercises}/${result.totalExercisesAttempted}',
          icon: Icons.check_circle_outline_rounded,
        ),
        _StatItem(
          label: 'Vocabulary',
          value: '+${result.newVocabularyLearned}',
          icon: Icons.auto_stories_rounded,
        ),
      ],
    ).animate().fadeIn(delay: 400.ms, duration: 500.ms);
  }
}

class _StatItem extends StatelessWidget {
  const _StatItem({
    required this.label,
    required this.value,
    required this.icon,
  });

  final String label;
  final String value;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Column(
      children: [
        Icon(icon, size: 24, color: colorScheme.primary),
        const SizedBox(height: Spacing.xs),
        Text(
          value,
          style: textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
        Text(
          label,
          style: textTheme.labelSmall?.copyWith(
            color: colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}
