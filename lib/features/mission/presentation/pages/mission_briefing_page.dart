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
import 'mission_player_page.dart';
import 'mission_summary_page.dart';

/// Mission screen — handles the full lifecycle:
/// Loading → Briefing → Exercise Player → Mission Complete.
///
/// All states are handled within a single BlocProvider scope so
/// the MissionBloc remains alive throughout the entire mission.
class MissionBriefingPage extends StatelessWidget {
  const MissionBriefingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MissionBloc, MissionState>(
      builder: (context, state) {
        return switch (state) {
          MissionInitial() => const PhoenixScaffold(
              body: Center(child: CircularProgressIndicator()),
            ),
          MissionLoading() => const PhoenixScaffold(
              body: Center(child: CircularProgressIndicator()),
            ),
          MissionBriefing() => _BriefingView(state: state),
          MissionInProgress() => const MissionPlayerPage(),
          MissionCompleted() => const MissionSummaryPage(),
          MissionError() => _ErrorView(state: state),
        };
      },
    );
  }
}

/// Error fallback with retry option.
class _ErrorView extends StatelessWidget {
  const _ErrorView({required this.state});

  final MissionError state;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return PhoenixScaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(Spacing.xxl),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.error_outline_rounded,
                size: 48,
                color: colorScheme.error.withOpacity(0.7),
              ),
              const SizedBox(height: Spacing.lg),
              Text(
                'Could not load mission',
                style: textTheme.titleMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: Spacing.sm),
              Text(
                state.message,
                style: textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: Spacing.xxl),
              PhoenixButton(
                label: 'Go Back',
                icon: Icons.arrow_back_rounded,
                onPressed: () => Navigator.of(context).maybePop(),
                variant: PhoenixButtonVariant.outlined,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// The briefing view — shows mission info + Begin button.
class _BriefingView extends StatelessWidget {
  const _BriefingView({required this.state});

  final MissionBriefing state;

  @override
  Widget build(BuildContext context) {
    final mission = state.mission;

    return PhoenixScaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: Spacing.lg),
            _buildHeader(context, mission),
            const SizedBox(height: Spacing.lg),
            YasminaCard(
              message: state.yasminaGreeting,
              showDismissButton: false,
            ),
            const SizedBox(height: Spacing.lg),
            _buildObjective(context, mission),
            const SizedBox(height: Spacing.md),
            _buildMeta(context, mission),
            const SizedBox(height: Spacing.xxl),
            _buildStartButton(context),
            const SizedBox(height: Spacing.lg),
          ],
        ),
      ),
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
          style: textTheme.labelMedium?.copyWith(
            color: colorScheme.primary,
            letterSpacing: 1.2,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          mission.titleEn,
          style: textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          mission.titleDe,
          style: textTheme.titleMedium?.copyWith(
            color: colorScheme.onSurfaceVariant,
            fontStyle: FontStyle.italic,
          ),
        ),
      ],
    ).animate().fadeIn(duration: 500.ms).slideX(begin: -0.03, end: 0);
  }

  Widget _buildObjective(BuildContext context, Mission mission) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: Spacing.md,
        vertical: Spacing.md,
      ),
      decoration: BoxDecoration(
        border: Border.all(color: colorScheme.outlineVariant),
        borderRadius: BorderRadius.circular(Spacing.cardRadius),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'OBJECTIVE',
            style: textTheme.labelSmall?.copyWith(
              color: colorScheme.primary,
              letterSpacing: 1,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: Spacing.xs),
          Text(
            mission.learningObjectiveEn,
            style: textTheme.bodySmall?.copyWith(
              height: 1.4,
              color: colorScheme.onSurface,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMeta(BuildContext context, Mission mission) {
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
          label: '${mission.skills.speaking}%',
        ),
      ],
    );
  }

  Widget _buildStartButton(BuildContext context) {
    return PhoenixButton(
      label: state.resumeExerciseIndex != null
          ? 'Resume Mission'
          : 'Begin Mission',
      icon: Icons.play_arrow_rounded,
      isExpanded: true,
      onPressed: () {
        context.read<MissionBloc>().add(const StartMissionEvent());
      },
    ).animate().fadeIn(delay: 500.ms, duration: 400.ms);
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
        horizontal: Spacing.sm,
        vertical: 3,
      ),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(Spacing.chipRadius),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: colorScheme.onSurfaceVariant),
          const SizedBox(width: 3),
          Text(
            label,
            style: textTheme.labelSmall?.copyWith(
              color: colorScheme.onSurfaceVariant,
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }
}
