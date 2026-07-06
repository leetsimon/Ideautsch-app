import '../core/constants/app_constants.dart';
import '../features/progress/domain/entities/srs_item.dart';

/// Modified SM-2 Spaced Repetition Engine.
///
/// Implements the SuperMemo 2 algorithm with modifications for
/// language learning:
/// - Speaking-only recall (no passive recognition)
/// - Grace period for new items (gentler early intervals)
/// - Context variation (same word in different sentences)
/// - Anti-pile-up mechanism (max reviews per day)
///
/// This is a pure Dart class with ZERO Flutter dependencies.
/// It can be unit-tested without any framework.
class SrsEngine {
  const SrsEngine();

  /// Process a review event and return the updated SRS item.
  ///
  /// [quality] is rated 0–5 based on exercise performance:
  /// - 5: Perfect, immediate recall
  /// - 4: Correct with minor hesitation
  /// - 3: Correct after thinking
  /// - 2: Incorrect but recognized correct answer
  /// - 1: Incorrect, didn't recognize
  /// - 0: Complete blank / skipped
  SrsItem processReview(SrsItem item, int quality) {
    assert(quality >= 0 && quality <= 5, 'Quality must be 0–5');

    double newEaseFactor = item.easeFactor;
    double newInterval = item.intervalDays;
    int newRepetitions = item.repetitions;
    final bool wasCorrect = quality >= 3;

    if (wasCorrect) {
      // Successful recall
      if (newRepetitions == 0) {
        newInterval = 1.0; // First successful review: 1 day
      } else if (newRepetitions == 1) {
        newInterval = 3.0; // Second successful review: 3 days
      } else {
        newInterval = item.intervalDays * newEaseFactor;
      }
      newRepetitions += 1;

      // Update ease factor (SM-2 formula)
      newEaseFactor = newEaseFactor +
          (0.1 - (5 - quality) * (0.08 + (5 - quality) * 0.02));
    } else {
      // Failed recall (lapse)
      newRepetitions = 0;
      newInterval = 0.5; // Review again within 12 hours
      newEaseFactor = newEaseFactor - 0.2;
    }

    // Enforce minimum ease factor
    if (newEaseFactor < AppConstants.minEaseFactor) {
      newEaseFactor = AppConstants.minEaseFactor;
    }

    // Enforce maximum interval
    if (newInterval > AppConstants.maxIntervalDays) {
      newInterval = AppConstants.maxIntervalDays;
    }

    // Calculate next review date
    final intervalDuration = Duration(
      hours: (newInterval * 24).round(),
    );
    final nextReview = DateTime.now().add(intervalDuration);

    return item.reviewed(
      newEaseFactor: newEaseFactor,
      newIntervalDays: newInterval,
      newRepetitions: newRepetitions,
      newNextReviewAt: nextReview,
      wasCorrect: wasCorrect,
    );
  }

  /// Map an exercise score (0.0–1.0) to SM-2 quality (0–5).
  int scoreToQuality(double score) {
    if (score >= 0.95) return 5;
    if (score >= 0.80) return 4;
    if (score >= 0.60) return 3;
    if (score >= 0.40) return 2;
    if (score >= 0.20) return 1;
    return 0;
  }

  /// Calculate how many items should be reviewed today,
  /// applying the anti-pile-up mechanism.
  ///
  /// Returns the capped number of items to present.
  int calculateDailyReviewCount({
    required int totalDueItems,
    required int maxPerDay,
  }) {
    if (totalDueItems <= maxPerDay) {
      return totalDueItems;
    }

    // Anti-pile-up: never show more than maxPerDay
    // Prioritize by urgency (handled at query level)
    return maxPerDay;
  }

  /// Create a new SRS item for a freshly learned vocabulary chunk.
  SrsItem createNewItem({
    required String itemId,
    required SrsItemType itemType,
    int initialIntervalHours = 12,
    double initialEaseFactor = 2.5,
  }) {
    return SrsItem(
      itemId: itemId,
      itemType: itemType,
      easeFactor: initialEaseFactor,
      intervalDays: initialIntervalHours / 24.0,
      repetitions: 0,
      nextReviewAt: DateTime.now().add(
        Duration(hours: initialIntervalHours),
      ),
    );
  }
}
