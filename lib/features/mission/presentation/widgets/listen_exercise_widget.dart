import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/spacing.dart';
import '../../../../core/theme/typography_tokens.dart';
import '../../../../core/widgets/phoenix_button.dart';
import '../../domain/entities/exercise.dart';
import '../bloc/mission_bloc.dart';
import '../bloc/mission_event.dart';
import '../bloc/mission_state.dart';

/// Widget for listen & comprehension exercises.
///
/// Displays:
/// - Prompt (what to listen for)
/// - Play audio button
/// - Target text (if scaffolding shows it)
/// - Multiple choice options (for comprehension checks)
class ListenExerciseWidget extends StatelessWidget {
  const ListenExerciseWidget({
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
    final options = exercise.evaluationConfig.comprehensionOptions;

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: Spacing.pagePaddingHorizontal,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Spacer(),

          // Prompt
          Text(
            exercise.promptTextEn,
            style: textTheme.bodyLarge?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: Spacing.xxxl),

          // German text (if visible)
          if (scaffolding.textVisible && exercise.targetTextDe != null)
            Container(
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

          // Play audio button — shows status based on availability
          if (exercise.targetAudioNative != null &&
              !exercise.targetAudioNative!.contains('placeholder'))
            Center(
              child: PhoenixButton(
                label: state.phase == ExercisePlayPhase.playingAudio
                    ? 'Playing...'
                    : 'Play Audio',
                icon: state.phase == ExercisePlayPhase.playingAudio
                    ? Icons.pause_rounded
                    : Icons.play_arrow_rounded,
                onPressed: state.phase == ExercisePlayPhase.playingAudio
                    ? null
                    : () {
                        context.read<MissionBloc>().add(
                              PlayAudioEvent(
                                audioPath: exercise.targetAudioNative,
                              ),
                            );
                      },
                variant: PhoenixButtonVariant.filled,
              ),
            )
          else
            Center(
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: Spacing.lg,
                  vertical: Spacing.md,
                ),
                decoration: BoxDecoration(
                  color: colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(Spacing.chipRadius),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.volume_off_rounded,
                      size: 16,
                      color: colorScheme.onSurfaceVariant,
                    ),
                    const SizedBox(width: Spacing.sm),
                    Text(
                      'Audio coming soon',
                      style: textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            ),

          const SizedBox(height: Spacing.xxxl),

          // Comprehension options (if present)
          if (options.isNotEmpty) ...[
            Text(
              exercise.evaluationConfig.comprehensionOptions.isNotEmpty
                  ? 'What did you hear?'
                  : '',
              style: textTheme.titleSmall?.copyWith(
                color: colorScheme.onSurface,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: Spacing.lg),
            ...List.generate(options.length, (index) {
              final option = options[index];
              return Padding(
                padding: const EdgeInsets.only(bottom: Spacing.sm),
                child: OutlinedButton(
                  onPressed: () {
                    context.read<MissionBloc>().add(
                          SelectAnswerEvent(optionIndex: index),
                        );
                  },
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.all(Spacing.lg),
                    alignment: Alignment.centerLeft,
                  ),
                  child: Text(
                    option.textEn,
                    style: textTheme.bodyMedium,
                  ),
                ),
              );
            }),
          ],

          const Spacer(),
        ],
      ),
    );
  }
}
