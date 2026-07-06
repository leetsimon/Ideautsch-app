import 'package:equatable/equatable.dart';

/// A vocabulary chunk taught within a mission.
///
/// Vocabulary in Phoenix is ALWAYS a usable chunk (phrase),
/// never an isolated word. Each item carries multilingual
/// support, pronunciation guidance, and SRS configuration.
class VocabularyItem extends Equatable {
  const VocabularyItem({
    required this.id,
    required this.chunkPhrase,
    required this.functionalMeaning,
    required this.translationEn,
    required this.audioNative,
    required this.register,
    required this.domain,
    required this.cluster,
    this.literalMeaning,
    this.translationDarija,
    this.translationFr,
    this.ipa,
    this.audioSlow,
    this.exampleDe,
    this.exampleEn,
    this.exampleAudio,
    this.srsInitialIntervalHours = 12,
    this.srsInitialEaseFactor = 2.5,
    this.contextVariations = const [],
  });

  /// Unique vocabulary identifier (e.g., "v_guten_tag").
  final String id;

  /// The phrase as taught — always a usable chunk.
  final String chunkPhrase;

  /// What this phrase DOES in communication.
  final String functionalMeaning;

  /// Literal word-for-word meaning (if helpful).
  final String? literalMeaning;

  /// Natural English translation.
  final String translationEn;

  /// Natural Moroccan Darija translation.
  final String? translationDarija;

  /// French translation (when useful for bridges).
  final String? translationFr;

  /// IPA transcription.
  final String? ipa;

  /// Path to native-speed audio file.
  final String audioNative;

  /// Path to slow-speed audio file.
  final String? audioSlow;

  /// Example sentence in German.
  final String? exampleDe;

  /// Example sentence in English.
  final String? exampleEn;

  /// Path to example sentence audio.
  final String? exampleAudio;

  /// Formality level.
  final String register;

  /// Career domain this belongs to.
  final String domain;

  /// Tactical vocabulary cluster.
  final String cluster;

  /// Initial SRS interval in hours after learning.
  final int srsInitialIntervalHours;

  /// Initial SM-2 ease factor.
  final double srsInitialEaseFactor;

  /// Different sentences for SRS review encounters.
  final List<String> contextVariations;

  @override
  List<Object?> get props => [id, chunkPhrase];
}
