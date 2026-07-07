import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/spacing.dart';
import '../../../../core/widgets/phoenix_button.dart';
import '../../domain/entities/exercise.dart';
import '../../domain/entities/exercise_result.dart';
import '../bloc/mission_bloc.dart';
import '../bloc/mission_event.dart';
import '../bloc/mission_state.dart';
import '../widgets/feedback_overlay.dart';
import '../widgets/leave_mission_dialog.dart';
import '../widgets/listen_exercise_widget.dart';
import '../widgets/mission_progress_indicator.dart';
import '../widgets/speaking_exercise_widget.dart';
import '../widgets/yasmina_card.dart';

/// Main mission player page — orchestrates exercise display.
///
/// Renders the current exercise based on MissionInProgress state.
/// Handles all exercise types with graceful fallbacks for missing
/// audio assets or unavailable microphone.
class MissionPlayerPage extends StatelessWidget {
  const MissionPlayerPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MissionBloc, MissionState>(
      buildWhen: (previous, current) => current is MissionInProgress,
      builder: (context, state) {
        if (state is! MissionInProgress) {
          return const SizedBox.shrink();
        }

        return Scaffold(
          body: SafeArea(
            child: Column(
              children: [
                // Top bar: back button + progress
                Row(
                  children: [
                    IconButton(
                      onPressed: () async {
                        final shouldLeave =
                            await showLeaveMissionDialog(context);
                        if (shouldLeave && context.mounted) {
                          GoRouter.of(context).go('/home');
                        }
                      },
                      icon: const Icon(Icons.close_rounded),
                      tooltip: 'Leave mission',
                    ),
                    Expanded(
                      child: MissionProgressIndicator(
                        current: state.exerciseIndex,
                        total: state.totalExercises,
                      ),
                    ),
                    const SizedBox(width: 48), // Balance the close button
                  ],
                ),

                // Main exercise area
                Expanded(
                  child: _buildExerciseArea(context, state),
                ),

                // Feedback overlay (when showing feedback)
                if (state.phase == ExercisePlayPhase.showingFeedback &&
                    state.lastResult != null)
                  _buildFeedback(context, state),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildExerciseArea(BuildContext context, MissionInProgress state) {
    // Show Yasmina card if in coaching phase
    if (state.phase == ExercisePlayPhase.showingYasmina &&
        state.yasminaMessage != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(Spacing.xxl),
          child: YasminaCard(
            message: state.yasminaMessage!,
            onDismiss: () {
              context.read<MissionBloc>().add(const DismissYasminaEvent());
            },
          ),
        ),
      );
    }

    // Route to the correct exercise widget based on type
    final exercise = state.currentExercise;
    final scaffolding = state.currentScaffolding;

    return switch (exercise.type) {
      ExerciseType.listenComprehend => ListenExerciseWidget(
          exercise: exercise,
          scaffolding: scaffolding,
          state: state,
        ),
      ExerciseType.shadow ||
      ExerciseType.repeat ||
      ExerciseType.vocabularyPresent ||
      ExerciseType.reconstruct ||
      ExerciseType.conversation ||
      ExerciseType.timePressure ||
      ExerciseType.parallelTracks ||
      ExerciseType.rescue ||
      ExerciseType.dictation => SpeakingExerciseWidget(
          exercise: exercise,
          scaffolding: scaffolding,
          state: state,
        ),
    };
  }

  Widget _buildFeedback(BuildContext context, MissionInProgress state) {
    final result = state.lastResult!;
    final exercise = state.currentExercise;

    final feedbackText = switch (result.outcome) {
      ExerciseOutcome.success => exercise.feedback.onSuccess,
      ExerciseOutcome.partial => exercise.feedback.onPartial,
      ExerciseOutcome.retry => exercise.feedback.onRetry,
      ExerciseOutcome.skipped => exercise.feedback.onRetry,
    };

    return FeedbackOverlay(
      result: result,
      feedbackText: feedbackText,
      canRetry: state.canRetry &&
          result.outcome == ExerciseOutcome.retry,
      onNext: () {
        context.read<MissionBloc>().add(const NextExerciseEvent());
      },
      onRetry: state.canRetry
          ? () {
              context.read<MissionBloc>().add(const RetryExerciseEvent());
            }
          : null,
      onListenModel: null, // Audio assets not yet available
    );
  }
}
