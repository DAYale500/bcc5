// 📄 lib/data/models/path_model.dart

class PathItem {
  final String pathItemId; // e.g., "lesson_dock_1.00", "part_deck_3.00"

  const PathItem({required this.pathItemId});
}

class LearningPathChapter {
  final String id;
  final String title;
  final List<PathItem> items;
  final bool showFlashcardEnding; // NEW

  LearningPathChapter({
    required this.id,
    required this.title,
    required this.items,
    this.showFlashcardEnding = true, // NEW
  });
}
