import 'package:bcc5/data/models/content_block.dart';
import 'package:bcc5/data/models/render_item.dart';
import 'package:bcc5/data/repositories/lessons/lesson_repository_index.dart';
import 'package:bcc5/data/repositories/parts/part_repository_index.dart';
import 'package:bcc5/data/repositories/tools/tool_repository_index.dart';
import 'package:bcc5/utils/logger.dart';

List<RenderItem> buildRenderItems({required List<String> ids}) {
  logger.i('🛠️ buildRenderItems → ids: $ids');

  final items = <RenderItem>[];
  final invalidIds = <String>[];

  for (final id in ids) {
    final item = getContentObject(id);
    if (item != null) {
      // logger.d('✅ Built RenderItem → id: ${item.id}, type: ${item.type}');
      items.add(item);
    } else {
      logger.w('❌ Failed to resolve RenderItem for id: $id');
      invalidIds.add(id);
    }
  }

  logger.d(
    '📦 buildRenderItems summary:\n'
    '  • valid: ${items.length}\n'
    '  • invalid: ${invalidIds.length}',
  );

  if (invalidIds.isNotEmpty) {
    logger.w('⚠️ Invalid RenderItem IDs: $invalidIds');
  }

  return items;
}

RenderItem? getContentObject(String id) {
  if (id.startsWith('lesson_')) {
    final lesson = LessonRepositoryIndex.getLessonById(id);
    if (lesson != null) {
      return RenderItem(
        type: RenderItemType.lesson,
        id: lesson.id,
        title: lesson.title,
        content: lesson.content,
        flashcards: lesson.flashcards,
      );
    }
  }

  if (id.startsWith('part_')) {
    final part = PartRepositoryIndex.getPartById(id);
    if (part != null) {
      return RenderItem(
        type: RenderItemType.part,
        id: part.id,
        title: part.title,
        content: part.content,
        flashcards: part.flashcards,
      );
    }
  }

  if (id.startsWith('tool_')) {
    final tool = ToolRepositoryIndex.getToolById(id);
    if (tool != null) {
      return RenderItem(
        type: RenderItemType.tool,
        id: tool.id,
        title: tool.title,
        content: tool.content,
        flashcards: tool.flashcards,
      );
    }
  }

  if (id.startsWith('flashcard_')) {
    final flashcard =
        LessonRepositoryIndex.getFlashcardById(id) ??
        PartRepositoryIndex.getFlashcardById(id) ??
        ToolRepositoryIndex.getFlashcardById(id);

    if (flashcard != null) {
      return RenderItem(
        type: RenderItemType.flashcard,
        id: flashcard.id,
        title: flashcard.title,
        content: flashcard.sideA + ContentBlock.dividerList() + flashcard.sideB,
        flashcards: [flashcard],
      );
    }
  }

  logger.w('❌ getContentObject → no match for id: $id');
  return null;
}
