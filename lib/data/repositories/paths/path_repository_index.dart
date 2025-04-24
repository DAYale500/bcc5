import 'package:bcc5/data/models/path_model.dart';
import 'package:bcc5/data/repositories/paths/competent_crew_repository.dart';
import 'package:bcc5/utils/logger.dart';

class PathRepositoryIndex {
  static final Map<String, List<LearningPathChapter>> _pathMap = {
    'competent crew': CompetentCrewRepository.getChapters(),
    // more paths...
  };

  static List<LearningPathChapter> getChaptersForPath(String pathName) =>
      _pathMap[pathName.toLowerCase()] ?? [];

  static List<String> getChapterTitles(String pathName) =>
      getChaptersForPath(pathName.toLowerCase()).map((c) => c.title).toList();

  static LearningPathChapter? getChapterById(
    String pathName,
    String chapterId,
  ) {
    try {
      return getChaptersForPath(
        pathName.toLowerCase(),
      ).firstWhere((chapter) => chapter.id == chapterId);
    } catch (_) {
      return null;
    }
  }

  static String? getChapterTitleForPath(String pathName, String chapterId) {
    final chapters = getChaptersForPath(pathName);
    final matching = chapters.where((c) => c.id == chapterId);
    if (matching.isEmpty) return null;
    return matching.first.title;
  }

  static List<String> getPathNames() => _pathMap.keys.toList();

  static List<PathItem> getAllPathItems(String pathName) =>
      getChaptersForPath(pathName).expand((chapter) => chapter.items).toList();

  static void logAvailablePathKeys() {
    logger.i('🧩 Available path keys: ${_pathMap.keys}');
  }

  static LearningPathChapter? getNextChapter(
    String pathName,
    String currentChapterId,
  ) {
    final chapters = getChaptersForPath(pathName);
    for (int i = 0; i < chapters.length - 1; i++) {
      if (chapters[i].id == currentChapterId) {
        return chapters[i + 1];
      }
    }
    return null;
  }
}
