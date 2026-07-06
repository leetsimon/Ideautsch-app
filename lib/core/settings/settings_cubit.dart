import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Settings state containing all user-configurable preferences.
class SettingsState extends Equatable {
  const SettingsState({
    this.themeMode = ThemeMode.system,
    this.dailyGoalMinutes = 25,
    this.explanationLanguage = ExplanationLanguage.english,
    this.audioPlaybackSpeed = 1.0,
    this.showDarijaTranslations = true,
    this.showFrenchBridges = true,
  });

  /// Current theme mode (light, dark, or system).
  final ThemeMode themeMode;

  /// Daily learning goal in minutes.
  final int dailyGoalMinutes;

  /// Primary language for explanations.
  final ExplanationLanguage explanationLanguage;

  /// Default audio playback speed.
  final double audioPlaybackSpeed;

  /// Whether to show Darija translations.
  final bool showDarijaTranslations;

  /// Whether to show French phonetic bridges.
  final bool showFrenchBridges;

  SettingsState copyWith({
    ThemeMode? themeMode,
    int? dailyGoalMinutes,
    ExplanationLanguage? explanationLanguage,
    double? audioPlaybackSpeed,
    bool? showDarijaTranslations,
    bool? showFrenchBridges,
  }) {
    return SettingsState(
      themeMode: themeMode ?? this.themeMode,
      dailyGoalMinutes: dailyGoalMinutes ?? this.dailyGoalMinutes,
      explanationLanguage:
          explanationLanguage ?? this.explanationLanguage,
      audioPlaybackSpeed: audioPlaybackSpeed ?? this.audioPlaybackSpeed,
      showDarijaTranslations:
          showDarijaTranslations ?? this.showDarijaTranslations,
      showFrenchBridges: showFrenchBridges ?? this.showFrenchBridges,
    );
  }

  @override
  List<Object?> get props => [
        themeMode,
        dailyGoalMinutes,
        explanationLanguage,
        audioPlaybackSpeed,
        showDarijaTranslations,
        showFrenchBridges,
      ];
}

/// Available languages for explanations.
enum ExplanationLanguage {
  english,
  darija,
  french,
}

/// Cubit for managing application settings.
///
/// Uses Cubit (not full BLoC) because settings changes are
/// simple state mutations without complex event flows.
class SettingsCubit extends Cubit<SettingsState> {
  SettingsCubit() : super(const SettingsState());

  /// Toggle between light, dark, and system theme.
  void setThemeMode(ThemeMode mode) {
    emit(state.copyWith(themeMode: mode));
  }

  /// Update the daily learning goal.
  void setDailyGoal(int minutes) {
    emit(state.copyWith(dailyGoalMinutes: minutes));
  }

  /// Change the explanation language.
  void setExplanationLanguage(ExplanationLanguage language) {
    emit(state.copyWith(explanationLanguage: language));
  }

  /// Set audio playback speed.
  void setAudioSpeed(double speed) {
    emit(state.copyWith(audioPlaybackSpeed: speed));
  }

  /// Toggle Darija translation visibility.
  void toggleDarijaTranslations({required bool show}) {
    emit(state.copyWith(showDarijaTranslations: show));
  }

  /// Toggle French bridge visibility.
  void toggleFrenchBridges({required bool show}) {
    emit(state.copyWith(showFrenchBridges: show));
  }
}
