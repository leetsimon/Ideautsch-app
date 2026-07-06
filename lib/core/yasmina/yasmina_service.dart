import '../../features/mission/domain/entities/mission.dart';
import '../../features/mission/domain/entities/mission_result.dart';
import '../../features/mission/domain/entities/yasmina_message.dart';

/// Yasmina's current mode determines her personality and language.
enum YasminaMode {
  /// Modules 1–3: Heavy Darija/English, maximum encouragement.
  beginner,

  /// Modules 4–8: Mix of German and English, professional coaching.
  intermediate,

  /// Modules 9–12: Mostly German, collegial, assumes competence.
  advanced,

  /// Interview preparation: coaching focus, structured feedback.
  interviewCoach,

  /// Call center simulation debrief: supervisor persona.
  callCenterSupervisor,
}

/// Rule-based Yasmina coaching runtime.
///
/// Delivers contextual coaching messages based on:
/// - Current mission phase (briefing, mid-mission, debrief)
/// - Learner performance (success, struggle, milestone)
/// - Time of day and session context
/// - Module progression (language fade)
///
/// This is a rule-based system. Future versions will integrate
/// on-device AI for dynamic conversation. The interface is
/// designed to support that transition without refactoring.
class YasminaService {
  YasminaService();

  /// Current operating mode (affects language and tone).
  YasminaMode _mode = YasminaMode.beginner;

  /// Get the current mode.
  YasminaMode get mode => _mode;

  /// Update Yasmina's mode based on the learner's current module.
  void updateModeForModule(int module) {
    if (module <= 3) {
      _mode = YasminaMode.beginner;
    } else if (module <= 8) {
      _mode = YasminaMode.intermediate;
    } else {
      _mode = YasminaMode.advanced;
    }
  }

  /// Get the session greeting message.
  ///
  /// Contextual based on time of day, days since last session,
  /// and current module. If the mission has a custom greeting,
  /// it takes precedence.
  String getSessionGreeting({
    YasminaMessages? missionMessages,
    int daysSinceLastSession = 0,
    int currentModule = 1,
  }) {
    // Use mission-specific greeting if available
    if (missionMessages?.sessionGreeting != null) {
      return _selectLanguage(missionMessages!.sessionGreeting!);
    }

    // Generate contextual greeting
    if (daysSinceLastSession == 0) {
      return _getFirstTimeGreeting(currentModule);
    } else if (daysSinceLastSession == 1) {
      return _getReturnAfterOneDayGreeting(currentModule);
    } else if (daysSinceLastSession >= 3) {
      return _getReturnAfterAbsenceGreeting(
        currentModule,
        daysSinceLastSession,
      );
    }

    return _getStandardGreeting(currentModule);
  }

  /// Get the pre-mission briefing message.
  String getPreMissionBriefing({
    required Mission mission,
  }) {
    if (mission.yasminaMessages?.preMissionBriefing != null) {
      return _selectLanguage(mission.yasminaMessages!.preMissionBriefing!);
    }

    // Default briefing based on mission type and module
    return _generateDefaultBriefing(mission);
  }

  /// Get a mid-mission encouragement message.
  ///
  /// Triggered after a specific exercise (defined in mission YAML)
  /// or when the adaptive system detects the learner needs support.
  String getMidMissionEncouragement({
    YasminaMessages? missionMessages,
    required double currentAverageScore,
    required int exercisesCompleted,
    required int totalExercises,
  }) {
    if (missionMessages?.midMissionEncouragement != null) {
      return _selectLanguage(missionMessages!.midMissionEncouragement!);
    }

    if (currentAverageScore >= 0.75) {
      return _mode == YasminaMode.beginner
          ? 'مزيان! You\'re doing great. Keep that momentum.'
          : 'Gut. Weiter so.';
    } else if (currentAverageScore < 0.40) {
      return _mode == YasminaMode.beginner
          ? 'هادشي صعيب — that\'s normal. Each attempt builds something. Keep going.'
          : 'Schwierig, aber du lernst mit jedem Versuch. Weiter.';
    }

    return _mode == YasminaMode.beginner
        ? 'Good progress. The challenge section is coming — you\'re ready.'
        : 'Die Hälfte geschafft. Der Hauptteil kommt jetzt.';
  }

  /// Get the post-mission debrief message.
  String getPostMissionDebrief({
    required Mission mission,
    required MissionResult result,
  }) {
    if (mission.yasminaMessages?.postMissionDebrief != null) {
      return _selectLanguage(mission.yasminaMessages!.postMissionDebrief!);
    }

    return _generateDefaultDebrief(mission, result);
  }

  /// Get a message for when the learner returns after absence.
  String getReturnMessage(int daysSinceLastSession) {
    if (daysSinceLastSession >= 7) {
      return _mode == YasminaMode.beginner
          ? 'مرحبا بيك. Good to have you back. Your German is still in there — let\'s warm up and see.'
          : 'Willkommen zurück. Dein Deutsch ist noch da — lass uns aufwärmen.';
    } else if (daysSinceLastSession >= 3) {
      return _mode == YasminaMode.beginner
          ? 'Welcome back. Life happens. Let\'s pick up where you left off.'
          : 'Schön, dass du wieder da bist. Weiter geht\'s.';
    }
    return _mode == YasminaMode.beginner
        ? 'Back again. Ready?'
        : 'Bereit?';
  }

  // ─── Private Helpers ───────────────────────────────────────

  String _selectLanguage(YasminaMessage message) {
    switch (_mode) {
      case YasminaMode.beginner:
        return message.textDarija ??
            message.textEn ??
            message.textDe ??
            '';
      case YasminaMode.intermediate:
        return message.textEn ?? message.textDe ?? '';
      case YasminaMode.advanced:
      case YasminaMode.interviewCoach:
      case YasminaMode.callCenterSupervisor:
        return message.textDe ?? message.textEn ?? '';
    }
  }

  String _getFirstTimeGreeting(int module) {
    if (module == 1) {
      return 'مرحبا بيك. I\'m Yasmina. Five years ago I was where you are — '
          'no German, big dreams. Today I\'m a Team Lead in Düsseldorf. '
          'Let\'s get you there too. Ready for your first mission?';
    }
    return _getStandardGreeting(module);
  }

  String _getReturnAfterOneDayGreeting(int module) {
    switch (_mode) {
      case YasminaMode.beginner:
        return 'Welcome back. Yesterday went well — let\'s build on it.';
      case YasminaMode.intermediate:
        return 'Guten Tag. Bereit für heute?';
      case YasminaMode.advanced:
      case YasminaMode.interviewCoach:
      case YasminaMode.callCenterSupervisor:
        return 'Weiter geht\'s. Heute: die nächste Herausforderung.';
    }
  }

  String _getReturnAfterAbsenceGreeting(int module, int days) {
    switch (_mode) {
      case YasminaMode.beginner:
        return 'مرحبا بيك. $days days — no problem. '
            'Your brain consolidated during the break. Let\'s see what stuck.';
      case YasminaMode.intermediate:
        return 'Schön, dass du wieder da bist. Dein Deutsch ist noch da.';
      case YasminaMode.advanced:
      case YasminaMode.interviewCoach:
      case YasminaMode.callCenterSupervisor:
        return 'Willkommen zurück. Aufwärmen, dann weiter.';
    }
  }

  String _getStandardGreeting(int module) {
    switch (_mode) {
      case YasminaMode.beginner:
        return 'Ready for today\'s mission? Let\'s go.';
      case YasminaMode.intermediate:
        return 'Bereit? Los geht\'s.';
      case YasminaMode.advanced:
      case YasminaMode.interviewCoach:
      case YasminaMode.callCenterSupervisor:
        return 'Los geht\'s.';
    }
  }

  String _generateDefaultBriefing(Mission mission) {
    final type = mission.type == MissionType.discovery
        ? 'new material'
        : mission.type == MissionType.challenge
            ? 'a challenge'
            : 'practice';

    switch (_mode) {
      case YasminaMode.beginner:
        return 'Today\'s mission: ${mission.titleEn}. This is $type. '
            'You\'ll need ${mission.estimatedDurationMinutes} minutes. '
            'Remember: speaking is the goal. Let\'s go.';
      case YasminaMode.intermediate:
        return 'Heute: ${mission.titleDe}. '
            'Ca. ${mission.estimatedDurationMinutes} Minuten. Bereit?';
      case YasminaMode.advanced:
      case YasminaMode.interviewCoach:
      case YasminaMode.callCenterSupervisor:
        return '${mission.titleDe}. Los.';
    }
  }

  String _generateDefaultDebrief(Mission mission, MissionResult result) {
    final outcome = result.outcome;

    switch (_mode) {
      case YasminaMode.beginner:
        if (outcome == MissionOutcome.accomplished) {
          return 'مزيان بزاف! You handled that professionally. '
              'Speaking time: ${result.totalSpeakingTimeSeconds} seconds. '
              'That\'s real progress.';
        } else if (outcome == MissionOutcome.completed) {
          return 'Good. Mission done. A few things to polish — '
              'they\'ll come back in review. Moving forward.';
        } else if (outcome == MissionOutcome.advanced) {
          return 'You got through it. Some parts need more practice — '
              'that\'s scheduled. You\'re still moving forward.';
        }
        return 'Challenging today. That\'s okay. Each attempt builds something. '
            'Tomorrow we approach it from a different angle.';

      case YasminaMode.intermediate:
        if (outcome == MissionOutcome.accomplished) {
          return 'Stark. Professionelle Qualität. Weiter so.';
        } else if (outcome == MissionOutcome.completed) {
          return 'Geschafft. Einige Punkte zum Verbessern — kommen wieder.';
        }
        return 'Schwierig heute. Kommt morgen wieder. Du lernst.';

      case YasminaMode.advanced:
      case YasminaMode.interviewCoach:
      case YasminaMode.callCenterSupervisor:
        if (outcome == MissionOutcome.accomplished) {
          return 'Ausgezeichnet. Nächste Mission freigeschaltet.';
        }
        return 'Erledigt. Weiter geht\'s morgen.';
    }
  }
}
