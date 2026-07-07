import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/spacing.dart';
import '../../../../core/theme/typography_tokens.dart';
import '../../../../core/widgets/microphone_button.dart';
import '../../../../core/widgets/phoenix_button.dart';
import '../../domain/entities/exercise.dart';
import '../../domain/entities/exercise_result.dart';
import '../bloc/mission_bloc.dart';
import '../bloc/mission_event.dart';
import '../bloc/mission_state.dart';

/// Widget for speaking exercises (shadow, repeat, vocabulary_present).
///
/// Displays:
/// - Prompt text (what to do)
/// - Target German text (if scaffolding allows)
/// - Play model button
/// - Microphone button for recording
/// - Recording timer when active
class SpeakingExerciseWidget extends StatelessWidget {
  const SpeakingExerciseWidget({
    required this.exercise,
    required this.scaffolding,
    required this.state,
    super.key,
  });

  final Exercise exercise;
  final ScaffoldLevel scaffolding;
  final MissionInProgress state;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: Spacing.pagePaddingHorizontal,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Spacer(flex: 2),

          // Prompt
          Text(
            exercise.promptTextEn,
            style: textTheme.bodyLarge?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: Spacing.xxl),

          // German target text (if visible in current scaffolding)
          if (scaffolding.textVisible && exercise.targetTextDe != null) ...[
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(Spacing.lg),
              decoration: BoxDecoration(
                color: colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(Spacing.cardRadius),
              ),
              child: Text(
                exercise.targetTextDe!,
                style: TypographyTokens.germanContent(
                  color: colorScheme.onSurface,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: Spacing.xxl),
          ],

          // First words hint (standard scaffolding)
          if (scaffolding.firstWordsVisible &&
              scaffolding.firstWords.isNotEmpty) ...[
            Wrap(
              spacing: Spacing.sm,
              runSpacing: Spacing.xs,
              alignment: WrapAlignment.center,
              children: scaffolding.firstWords
                  .map((word) => Chip(
                        label: Text(word),
                        backgroundColor:
                            colorScheme.primaryContainer.withOpacity(0.5),
                      ))
                  .toList(),
            ),
            const SizedBox(height: Spacing.xxl),
          ],

          // Play model button
          if (exercise.targetAudioNative != null)
            PhoenixButton(
              label: scaffolding.audioModelFirst
                  ? 'Listen First'
                  : 'Play Model',
              icon: Icons.volume_up_rounded,
              onPressed: () {
                context.read<MissionBloc>().add(
                      PlayAudioEvent(audioPath: exercise.targetAudioNative),
                    );
              },
              variant: PhoenixButtonVariant.outlined,
            ),

          const Spacer(flex: 3),

          // Microphone button
          MicrophoneButton(
            isRecording: state.isRecording,
            onPressed: () {
              if (state.isRecording) {
                context.read<MissionBloc>().add(const StopRecordingEvent());
              } else {
                context.read<MissionBloc>().add(const StartRecordingEvent());
              }
            },
          ),
          const SizedBox(height: Spacing.md),

          // Recording status text
          Text(
            state.isRecording ? 'Recording... tap to stop' : 'Tap to speak',
            style: textTheme.bodySmall?.copyWith(
              color: state.isRecording
                  ? colorScheme.error
                  : colorScheme.onSurfaceVariant,
            ),
          ),

          const SizedBox(height: Spacing.lg),

          // Skip button (allows progression when recording isn't available)
          TextButton(
            onPressed: () {
              // Simulate a passing result so the learner can proceed
              context.read<MissionBloc>().add(
                    SubmitExerciseEvent(
                      result: ExerciseResult(
                        exerciseId: exercise.id,
                        outcome: ExerciseOutcome.partial,
                        score: 0.5,
                        attemptNumber: state.currentAttempt,
                        timeSpentSeconds: 3,
                      ),
                    ),
                  );
            },
            child: Text(
              'Skip for now',
              style: textTheme.bodySmall?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
          ),

          const Spacer(flex: 2),

          // Hint button (if available)
          if (scaffolding.hintAvailable && state.hintText == null)
            TextButton.icon(
              onPressed: () {
                context.read<MissionBloc>().add(const RequestHintEvent());
              },
              icon: const Icon(Icons.lightbulb_outline, size: 18),
              label: const Text('Hint'),
            ),

          // Displayed hint
          if (state.hintText != null)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(Spacing.md),
              margin: const EdgeInsets.only(top: Spacing.sm),
              decoration: BoxDecoration(
                color: colorScheme.tertiaryContainer.withOpacity(0.3),
                borderRadius: BorderRadius.circular(Spacing.chipRadius),
              ),
              child: Text(
                state.hintText!,
                style: textTheme.bodySmall?.copyWith(
                  color: colorScheme.onTertiaryContainer,
                ),
                textAlign: TextAlign.center,
              ),
            ),

          const SizedBox(height: Spacing.lg),
        ],
      ),
    );
  }
}
