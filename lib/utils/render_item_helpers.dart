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
  // Strict prefix match for lesson
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
    } else {
      logger.w('❌ No lesson found for ID: $id');
    }
  }
  // Strict prefix match for part
  else if (id.startsWith('part_')) {
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
    } else {
      logger.w('❌ No part found for ID: $id');
    }
  }
  // Strict prefix match for tool
  else if (id.startsWith('tool_')) {
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
    } else {
      logger.w('❌ No tool found for ID: $id');
    }
  }
  // Strict prefix match for flashcard
  else if (id.startsWith('flashcard_')) {
    logger.i('🧠 Looking up flashcard ID: $id');

    final fromLesson = LessonRepositoryIndex.getFlashcardById(id);
    logger.i(
      fromLesson != null
          ? '   ✅ Found in lesson repo → ${fromLesson.id}'
          : '   ❌ Not found in lesson repo',
    );

    final fromPart = PartRepositoryIndex.getFlashcardById(id);
    logger.i(
      fromPart != null
          ? '   ✅ Found in part repo → ${fromPart.id}'
          : '   ❌ Not found in part repo',
    );

    final fromTool = ToolRepositoryIndex.getFlashcardById(id);
    logger.i(
      fromTool != null
          ? '   ✅ Found in tool repo → ${fromTool.id}'
          : '   ❌ Not found in tool repo',
    );

    final flashcard = fromLesson ?? fromPart ?? fromTool;

    if (flashcard != null) {
      return RenderItem(
        type: RenderItemType.flashcard,
        id: flashcard.id,
        title: flashcard.title,
        content: flashcard.sideA + ContentBlock.dividerList() + flashcard.sideB,
        flashcards: [flashcard],
      );
    } else {
      logger.w('⚠️ Flashcard lookup failed in all repositories for id: $id');
    }
  }

  logger.w('❌ getContentObject: No match for id: $id');
  return null;
}
