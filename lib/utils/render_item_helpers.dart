// ─────────────────────────────────────────────────────────────────────────────
// lib/utils/render_item_helpers.dart
// Locks detail navigation to the provided list; JSON-only resolution.
// ─────────────────────────────────────────────────────────────────────────────
import 'package:bcc5/data/models/render_item.dart';
import 'package:bcc5/data/repositories/lessons/json_lesson_repository.dart';
import 'package:bcc5/data/repositories/parts/json_part_repository.dart';
import 'package:bcc5/data/repositories/tools/json_tool_repository.dart';
import 'package:bcc5/data/repositories/flashcards/json_flashcard_repository.dart'; // ✅ NEW
import 'package:bcc5/utils/logger.dart';

Future<List<RenderItem>> buildRenderItems({required List<String> ids}) async {
  final items = <RenderItem>[];
  final invalid = <String>[];

  for (final id in ids) {
    final item = await getContentObject(id);
    if (item != null) {
      items.add(item);
    } else {
      invalid.add(id);
      logger.w('❌ Failed to resolve RenderItem for id: $id');
    }
  }
  if (invalid.isNotEmpty) {
    logger.w('⚠️ Invalid RenderItem IDs: $invalid');
  }
  return items;
}

Future<RenderItem?> getContentObject(String id) async {
  if (id.startsWith('lesson_')) {
    final lesson = await JsonLessonRepository.loadById(id);
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
    final part = await JsonPartRepository.loadById(id);
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
    final tool = await JsonToolRepository.loadById(id);
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

  // ✅ NEW: direct flashcard ids (e.g., "flashcard_xyz") via JSON repo.
  if (id.startsWith('flashcard_')) {
    final cards = await JsonFlashcardRepository.getFlashcardsByIds([id]);
    if (cards.isNotEmpty) {
      return RenderItem.fromFlashcard(cards.first);
    }
  }

  // If you add other JSON-backed types, resolve them here similarly.
  logger.w('❌ getContentObject → no match for id: $id');
  return null;
}

int? nextIndexIn(List<RenderItem> items, int i) =>
    (i + 1 < items.length) ? i + 1 : null;
int? prevIndexIn(List<RenderItem> items, int i) => (i - 1 >= 0) ? i - 1 : null;
