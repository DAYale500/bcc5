import 'package:bcc5/data/repositories/lessons/lesson_repository_index.dart';
import 'package:bcc5/data/repositories/parts/part_repository_index.dart';
import 'package:bcc5/data/repositories/tools/tool_repository_index.dart';

class FlashcardCategoryRepository {
  static List<String> getLessonCategories() =>
      LessonRepositoryIndex.getModuleNames();

  static List<String> getPartCategories() => PartRepositoryIndex.getZoneNames();

  static List<String> getToolCategories() =>
      ToolRepositoryIndex.getToolbagNames();

  static List<String> getAllCategories() => [
    ...getLessonCategories(),
    ...getPartCategories(),
    ...getToolCategories(),
    'all',
    'random',
  ];
}
