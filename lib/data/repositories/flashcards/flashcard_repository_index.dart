// 📄 lib/data/repositories/flashcards/flashcard_repository_index.dart

import 'package:bcc5/data/models/flashcard_model.dart';
import 'package:bcc5/data/repositories/lessons/lesson_repository_index.dart';
import 'package:bcc5/data/repositories/parts/part_repository_index.dart';
import 'package:bcc5/data/repositories/tools/tool_repository_index.dart';

/// Returns all flashcards for a given category name (e.g., 'dock', 'deck', 'procedures')
List<Flashcard> getFlashcardsForCategory(String category) {
  final lc = category.toLowerCase();

  if (lc == 'all') {
    return [
      ..._getAllLessonFlashcards(),
      ..._getAllPartFlashcards(),
      ..._getAllToolFlashcards(),
    ];
  }

  if (lc == 'random') {
    final all = [
      ..._getAllLessonFlashcards(),
      ..._getAllPartFlashcards(),
      ..._getAllToolFlashcards(),
    ]..shuffle();
    return all.take(10).toList();
  }

  if (LessonRepositoryIndex.getModuleNames().contains(lc)) {
    return LessonRepositoryIndex.getLessonsForModule(
      lc,
    ).expand((lesson) => lesson.flashcards).toList();
  }

  if (PartRepositoryIndex.getZoneNames().contains(lc)) {
    return PartRepositoryIndex.getPartsForZone(
      lc,
    ).expand((part) => part.flashcards).toList();
  }

  if (ToolRepositoryIndex.getToolbagNames().contains(lc)) {
    return ToolRepositoryIndex.getToolsForBag(
      lc,
    ).expand((tool) => tool.flashcards).toList();
  }

  return [];
}

List<String> getAllCategories() {
  return [
    ...LessonRepositoryIndex.getModuleNames(),
    ...PartRepositoryIndex.getZoneNames(),
    ...ToolRepositoryIndex.getToolbagNames(),
    'all',
    'random',
  ];
}

List<Flashcard> _getAllLessonFlashcards() =>
    LessonRepositoryIndex.getModuleNames()
        .expand((m) => LessonRepositoryIndex.getLessonsForModule(m))
        .expand((l) => l.flashcards)
        .toList();

List<Flashcard> _getAllPartFlashcards() =>
    PartRepositoryIndex.getZoneNames()
        .expand((z) => PartRepositoryIndex.getPartsForZone(z))
        .expand((p) => p.flashcards)
        .toList();

List<Flashcard> _getAllToolFlashcards() =>
    ToolRepositoryIndex.getToolbagNames()
        .expand((t) => ToolRepositoryIndex.getToolsForBag(t))
        .expand((tool) => tool.flashcards)
        .toList();
List<Flashcard> getAllFlashcards() {
  return [
    ..._getAllLessonFlashcards(),
    ..._getAllPartFlashcards(),
    ..._getAllToolFlashcards(),
  ];
}
