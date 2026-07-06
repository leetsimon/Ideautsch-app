/// Asset path constants for audio, images, and databases.
///
/// Centralizes all asset references to prevent string typos
/// and enable easy asset reorganization.
abstract final class AssetPaths {
  // ─── Base Directories ──────────────────────────────────────────────

  static const String _audioBase = 'assets/audio';
  static const String _missionsBase = '$_audioBase/missions';
  static const String _uiAudioBase = '$_audioBase/ui';
  static const String _databaseBase = 'assets/databases';

  // ─── Mission Zero Audio ────────────────────────────────────────────

  static const String missionZeroDir = '$_missionsBase/mission_zero';

  /// Full greeting phrase: "Guten Tag, wie kann ich Ihnen helfen?"
  static const String greetingFull = '$missionZeroDir/greeting_full.mp3';

  /// Chunk: "Guten Tag"
  static const String gutenTag = '$missionZeroDir/guten_tag.mp3';

  /// Chunk: "wie kann ich"
  static const String wieKannIch = '$missionZeroDir/wie_kann_ich.mp3';

  /// Chunk: "Ihnen helfen"
  static const String ihnenHelfen = '$missionZeroDir/ihnen_helfen.mp3';

  // ─── Vocabulary Audio ──────────────────────────────────────────────

  static const String vocabGutenTag = '$missionZeroDir/vocab_guten_tag.mp3';
  static const String vocabHelfen = '$missionZeroDir/vocab_helfen.mp3';
  static const String vocabBitte = '$missionZeroDir/vocab_bitte.mp3';
  static const String vocabDanke = '$missionZeroDir/vocab_danke.mp3';
  static const String vocabEntschuldigung =
      '$missionZeroDir/vocab_entschuldigung.mp3';

  // ─── Conversation Audio ────────────────────────────────────────────

  static const String convoCustomer01 =
      '$missionZeroDir/convo_customer_01.mp3';
  static const String convoCustomer02 =
      '$missionZeroDir/convo_customer_02.mp3';
  static const String convoCustomer03 =
      '$missionZeroDir/convo_customer_03.mp3';
  static const String convoCustomer04 =
      '$missionZeroDir/convo_customer_04.mp3';

  // ─── UI Audio ──────────────────────────────────────────────────────

  static const String sessionStart = '$_uiAudioBase/session_start.mp3';
  static const String exerciseComplete = '$_uiAudioBase/exercise_complete.mp3';

  // ─── Databases ─────────────────────────────────────────────────────

  static const String contentDatabase = '$_databaseBase/phoenix_content.db';
}
