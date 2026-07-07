import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/spacing.dart';
import '../../../../core/theme/typography_tokens.dart';
import '../../../../core/widgets/audio_wave_widget.dart';
import '../../../../core/widgets/microphone_button.dart';
import '../../../../core/widgets/phoenix_button.dart';
import '../../domain/entities/exercise.dart';
import '../../domain/entities/exercise_result.dart';
import '../bloc/mission_bloc.dart';
import '../bloc/mission_event.dart';
import '../bloc/mission_state.dart';

/// Widget for speaking exercises (shadow, repeat, vocabulary_present, etc).
///
/// Shows:
/// - Prompt text
/// - German target text (when scaffolding allows)
/// - Play model button (when audio available)
/// - Microphone button with recording state
/// - Waveform animation during recording
/// - Recording timer
/// - Skip option for when recording isn't possible
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
          const SizedBox(height: Spacing.xl),

          // German target text (if visible)
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
            const SizedBox(height: Spacing.xl),
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
            const SizedBox(height: Spacing.xl),
          ],

          const Spacer(flex: 2),

          // Waveform visualization (visible during recording)
          if (state.isRecording)
            Padding(
              padding: const EdgeInsets.only(bottom: Spacing.lg),
              child: AudioWaveWidget(
                isActive: true,
                height: 40,
                barCount: 20,
                color: colorScheme.error,
              ),
            ),

          // Recording timer
          if (state.isRecording)
            Padding(
              padding: const EdgeInsets.only(bottom: Spacing.md),
              child: _RecordingTimer(),
            ),

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
          const SizedBox(height: Spacing.sm),

          // Recording status text
          Text(
            state.isRecording
                ? 'Listening... tap to stop'
                : 'Tap to speak',
            style: textTheme.bodySmall?.copyWith(
              color: state.isRecording
                  ? colorScheme.error
                  : colorScheme.onSurfaceVariant,
            ),
          ),

          const Spacer(flex: 2),

          // Bottom area: hint + skip
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Hint button
              if (scaffolding.hintAvailable && state.hintText == null)
                TextButton.icon(
                  onPressed: () {
                    context.read<MissionBloc>().add(const RequestHintEvent());
                  },
                  icon: const Icon(Icons.lightbulb_outline, size: 16),
                  label: const Text('Hint'),
                )
              else
                const SizedBox.shrink(),

              // Skip button
              TextButton(
                onPressed: () {
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
                  'Skip',
                  style: textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
            ],
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

          const SizedBox(height: Spacing.md),
        ],
      ),
    );
  }
}

/// Live recording timer that counts up.
class _RecordingTimer extends StatefulWidget {
  @override
  State<_RecordingTimer> createState() => _RecordingTimerState();
}

class _RecordingTimerState extends State<_RecordingTimer> {
  late final Stopwatch _stopwatch;
  late final Timer _timer;

  @override
  void initState() {
    super.initState();
    _stopwatch = Stopwatch()..start();
    _timer = Timer.periodic(const Duration(milliseconds: 100), (_) {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    _stopwatch.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final elapsed = _stopwatch.elapsed;
    final seconds = elapsed.inSeconds;
    final tenths = (elapsed.inMilliseconds ~/ 100) % 10;

    return Text(
      '${seconds}s',
      style: Theme.of(context).textTheme.titleMedium?.copyWith(
            color: Theme.of(context).colorScheme.error,
            fontWeight: FontWeight.w600,
            fontFeatures: [const FontFeature.tabularFigures()],
          ),
    );
  }
}
