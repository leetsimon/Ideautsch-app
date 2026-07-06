import '../../domain/entities/srs_item.dart';

/// Data model for SrsItem — handles SQLite ↔ Domain mapping.
class SrsItemModel {
  const SrsItemModel._();

  /// Convert a SQLite row map to a domain [SrsItem] entity.
  static SrsItem fromMap(Map<String, dynamic> map) {
    return SrsItem(
      itemId: map['item_id'] as String,
      itemType: _parseItemType(map['item_type'] as String),
      easeFactor: (map['ease_factor'] as num).toDouble(),
      intervalDays: (map['interval_days'] as num).toDouble(),
      repetitions: map['repetitions'] as int,
      nextReviewAt: DateTime.parse(map['next_review_at'] as String),
      lastReviewedAt: map['last_reviewed_at'] != null
          ? DateTime.parse(map['last_reviewed_at'] as String)
          : null,
      correctStreak: map['correct_streak'] as int? ?? 0,
      lapses: map['lapses'] as int? ?? 0,
      totalReviews: map['total_reviews'] as int? ?? 0,
    );
  }

  /// Convert a domain [SrsItem] entity to a SQLite-compatible map.
  static Map<String, dynamic> toMap(SrsItem item) {
    return {
      'item_id': item.itemId,
      'item_type': item.itemType.name,
      'ease_factor': item.easeFactor,
      'interval_days': item.intervalDays,
      'repetitions': item.repetitions,
      'next_review_at': item.nextReviewAt.toIso8601String(),
      'last_reviewed_at': item.lastReviewedAt?.toIso8601String(),
      'correct_streak': item.correctStreak,
      'lapses': item.lapses,
      'total_reviews': item.totalReviews,
    };
  }

  static SrsItemType _parseItemType(String value) {
    return SrsItemType.values.firstWhere(
      (e) => e.name == value,
      orElse: () => SrsItemType.vocabulary,
    );
  }
}
