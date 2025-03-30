// 📄 lib/data/models/path_model.dart

class PathItem {
  final String pathItemId; // e.g., "lesson_dock_1.00", "part_deck_3.00"

  const PathItem({required this.pathItemId});
}

class LearningPathChapter {
  final String id; // e.g., "path_competentCrew_1.00"
  final String title;
  final List<PathItem> items;

  const LearningPathChapter({
    required this.id,
    required this.title,
    required this.items,
  });
}
