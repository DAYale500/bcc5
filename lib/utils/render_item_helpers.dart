import 'package:bcc5/data/models/content_block.dart';
import 'package:bcc5/data/models/render_item.dart'; // ✅ centralized model
import 'package:bcc5/data/repositories/lessons/lesson_repository_index.dart';
import 'package:bcc5/data/repositories/parts/part_repository_index.dart';
import 'package:bcc5/data/repositories/tools/tool_repository_index.dart';
import 'package:bcc5/utils/logger.dart';

List<RenderItem> buildRenderItems({required List<String> ids}) {
  logger.i('🛠️ buildRenderItems → ids: $ids');

  final items = <RenderItem>[];
  final invalidIds = <String>[];

  for (final id in ids) {
    logger.i('🔍 Attempting to build RenderItem for id: $id');
    final item = getContentObject(id);
    if (item != null) {
      logger.i('✅ Success → id: ${item.id}, type: ${item.type}');
      items.add(item);
    } else {
      logger.w('❌ Failed to resolve id: $id');
      invalidIds.add(id);
    }
  }

  logger.i(
    '📦 buildRenderItems summary:\n'
    '  • valid: ${items.length}\n'
    '  • invalid: ${invalidIds.length}',
  );

  if (invalidIds.isNotEmpty) {
    logger.w('⚠️ Invalid IDs: $invalidIds');
  }

  return items;
}

RenderItem? getContentObject(String id) {
  if (id.startsWith('lesson_')) {
    final lesson = LessonRepositoryIndex.getLessonById(id);
    if (lesson != null) {
      logger.i('📘 Matched lesson → ${lesson.id}');
      return RenderItem(
        type: RenderItemType.lesson,
        id: lesson.id,
        title: lesson.title,
        content: lesson.content,
        flashcards: lesson.flashcards,
      );
    }
  } else if (id.startsWith('part_')) {
    final part = PartRepositoryIndex.getPartById(id);
    if (part != null) {
      logger.i('🔧 Matched part → ${part.id}');
      return RenderItem(
        type: RenderItemType.part,
        id: part.id,
        title: part.title,
        content: part.content,
        flashcards: part.flashcards,
      );
    }
  } else if (id.startsWith('tool_')) {
    final tool = ToolRepositoryIndex.getToolById(id);
    if (tool != null) {
      logger.i('🧰 Matched tool → ${tool.id}');
      return RenderItem(
        type: RenderItemType.tool,
        id: tool.id,
        title: tool.title,
        content: tool.content,
        flashcards: tool.flashcards,
      );
    }
  } else if (id.startsWith('flashcard_')) {
    final flashcard = LessonRepositoryIndex.getFlashcardById(id);
    if (flashcard != null) {
      logger.i('🧠 Matched flashcard → ${flashcard.id}');

      final sideA = flashcard.sideA;
      final sideB = flashcard.sideB;

      return RenderItem(
        type: RenderItemType.flashcard,
        id: flashcard.id,
        title: flashcard.title,
        content: sideA + ContentBlock.divider() + sideB,
        flashcards: [flashcard],
      );
    } else {
      logger.w('⚠️ No flashcard found for id: $id');
    }
  }

  return null;
}
