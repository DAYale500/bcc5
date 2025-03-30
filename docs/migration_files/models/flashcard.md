// Relative path: /lib/models/flashcard.dart

class Flashcard {
  final String
      id; // Unique identifier for the flashcard (e.g., "zone_deck_01").
  final String front; // Text/image displayed on the front.
  final String back; // Text/image displayed on the back.
  final bool isReversible; // Whether the front/back can be swapped randomly.
  final bool isPaidContent; // Restricts content for free-tier users.
  final List<String> keywords; // Keywords for filtering and cross-referencing.
  final List<String> relatedLessons; // IDs of related lessons.
  final List<String> relatedParts; // IDs of related boat parts.

  const Flashcard({
    required this.id,
    required this.front,
    required this.back,
    required this.isReversible,
    required this.isPaidContent,
    this.keywords = const [],
    this.relatedLessons = const [],
    this.relatedParts = const [],
  });
}
