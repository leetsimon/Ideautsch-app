import 'package:equatable/equatable.dart';

/// The type of item tracked by the SRS system.
enum SrsItemType {
  vocabulary,
  phrase,
}

/// A single item in the spaced repetition system.
///
/// Tracks the scheduling state for one vocabulary chunk
/// using a modified SM-2 algorithm.
class SrsItem extends Equatable {
  const SrsItem({
    required this.itemId,
    required this.itemType,
    required this.easeFactor,
    required this.intervalDays,
    required this.repetitions,
    required this.nextReviewAt,
    this.lastReviewedAt,
    this.correctStreak = 0,
    this.lapses = 0,
    this.totalReviews = 0,
  });

  /// Vocabulary item ID this SRS entry tracks.
  final String itemId;

  /// Type of item (vocabulary chunk or phrase).
  final SrsItemType itemType;

  /// Current ease factor (starts at 2.5, min 1.3).
  final double easeFactor;

  /// Current interval in days until next review.
  final double intervalDays;

  /// Number of consecutive successful reviews.
  final int repetitions;

  /// When the next review is scheduled.
  final DateTime nextReviewAt;

  /// When the item was last reviewed.
  final DateTime? lastReviewedAt;

  /// Current streak of correct answers.
  final int correctStreak;

  /// Number of times the item was forgotten (lapsed).
  final int lapses;

  /// Total number of review events.
  final int totalReviews;

  /// Whether this item is due for review now.
  bool get isDue => DateTime.now().isAfter(nextReviewAt);

  /// Whether this item is considered "mastered" (interval > 21 days).
  bool get isMastered => intervalDays > 21;

  /// Whether this item is new (never reviewed).
  bool get isNew => totalReviews == 0;

  /// Days until the next review (negative = overdue).
  int get daysUntilReview =>
      nextReviewAt.difference(DateTime.now()).inDays;

  /// Create updated SRS item after a review.
  SrsItem reviewed({
    required double newEaseFactor,
    required double newIntervalDays,
    required int newRepetitions,
    required DateTime newNextReviewAt,
    required bool wasCorrect,
  }) {
    return SrsItem(
      itemId: itemId,
      itemType: itemType,
      easeFactor: newEaseFactor,
      intervalDays: newIntervalDays,
      repetitions: newRepetitions,
      nextReviewAt: newNextReviewAt,
      lastReviewedAt: DateTime.now(),
      correctStreak: wasCorrect ? correctStreak + 1 : 0,
      lapses: wasCorrect ? lapses : lapses + 1,
      totalReviews: totalReviews + 1,
    );
  }

  @override
  List<Object?> get props => [itemId, itemType, intervalDays, nextReviewAt];
}
