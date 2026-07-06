import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/spacing.dart';
import '../../../../core/widgets/phoenix_button.dart';
import '../../../../core/widgets/phoenix_scaffold.dart';
import '../../domain/entities/mission.dart';
import '../bloc/mission_bloc.dart';
import '../bloc/mission_event.dart';
import '../bloc/mission_state.dart';
import '../widgets/yasmina_card.dart';

/// Mission briefing screen.
///
/// Displays the scenario, Yasmina's greeting, and a
/// "Begin Mission" button. This is the first screen the
/// learner sees when they select a mission.
class MissionBriefingPage extends StatelessWidget {
  const MissionBriefingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MissionBloc, MissionState>(
      builder: (context, state) {
        if (state is! MissionBriefing) {
          return const PhoenixScaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        final mission = state.mission;

        return PhoenixScaffold(
          body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: Spacing.xxl),
                _buildHeader(context, mission),
                const SizedBox(height: Spacing.xxl),
                YasminaCard(
                  message: state.yasminaGreeting,
                  showDismissButton: false,
                ),
                const SizedBox(height: Spacing.xxxl),
                _buildObjective(context, mission),
                const SizedBox(height: Spacing.xxl),
                _buildMeta(context, mission),
                const SizedBox(height: Spacing.huge),
                _buildStartButton(context, state),
                const SizedBox(height: Spacing.xxl),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildHeader(BuildContext context, Mission mission) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'MISSION ${mission.sequence}',
          style: textTheme.labelLarge?.copyWith(
            color: colorScheme.primary,
            letterSpacing: 1.2,
          ),
        ),
        const SizedBox(height: Spacing.xs),
        Text(
          mission.titleEn,
          style: textTheme.displaySmall,
        ),
        const SizedBox(height: Spacing.sm),
        Text(
          mission.titleDe,
          style: textTheme.headlineMedium?.copyWith(
            color: colorScheme.onSurfaceVariant,
            fontStyle: FontStyle.italic,
          ),
        ),
      ],
    ).animate().fadeIn(duration: 500.ms).slideX(begin: -0.05, end: 0);
  }

  Widget _buildObjective(BuildContext context, Mission mission) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(Spacing.lg),
      decoration: BoxDecoration(
        border: Border.all(color: colorScheme.outlineVariant),
        borderRadius: BorderRadius.circular(Spacing.cardRadius),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'OBJECTIVE',
            style: textTheme.labelMedium?.copyWith(
              color: colorScheme.primary,
              letterSpacing: 1,
            ),
          ),
          const SizedBox(height: Spacing.sm),
          Text(
            mission.learningObjectiveEn,
            style: textTheme.bodyMedium?.copyWith(
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMeta(BuildContext context, Mission mission) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Row(
      children: [
        _MetaChip(
          icon: Icons.timer_outlined,
          label: '${mission.estimatedDurationMinutes} min',
        ),
        const SizedBox(width: Spacing.sm),
        _MetaChip(
          icon: Icons.school_outlined,
          label: mission.cefrTarget,
        ),
        const SizedBox(width: Spacing.sm),
        _MetaChip(
          icon: Icons.mic_outlined,
          label: '${mission.skills.speaking}% speaking',
        ),
      ],
    );
  }

  Widget _buildStartButton(BuildContext context, MissionBriefing state) {
    return Center(
      child: PhoenixButton(
        label: state.resumeExerciseIndex != null
            ? 'Resume Mission'
            : 'Begin Mission',
        icon: Icons.play_arrow_rounded,
        isExpanded: true,
        onPressed: () {
          context.read<MissionBloc>().add(const StartMissionEvent());
        },
      ),
    ).animate().fadeIn(delay: 600.ms, duration: 400.ms);
  }
}

class _MetaChip extends StatelessWidget {
  const _MetaChip({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: Spacing.md,
        vertical: Spacing.xs,
      ),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(Spacing.chipRadius),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: colorScheme.onSurfaceVariant),
          const SizedBox(width: Spacing.xs),
          Text(
            label,
            style: textTheme.labelSmall?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}
