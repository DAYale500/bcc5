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


















// // ─────────────────────────────────────────────────────────────────────────────
// // lib/utils/render_item_helpers.dart
// // Locks detail navigation to the provided list; JSON-only resolution.
// // ─────────────────────────────────────────────────────────────────────────────
// import 'package:bcc5/data/models/render_item.dart';
// import 'package:bcc5/data/repositories/lessons/json_lesson_repository.dart';
// import 'package:bcc5/data/repositories/parts/json_part_repository.dart';
// import 'package:bcc5/data/repositories/tools/json_tool_repository.dart';
// import 'package:bcc5/utils/logger.dart';

// Future<List<RenderItem>> buildRenderItems({required List<String> ids}) async {
//   final items = <RenderItem>[];
//   final invalid = <String>[];

//   for (final id in ids) {
//     final item = await getContentObject(id);
//     if (item != null) {
//       items.add(item);
//     } else {
//       invalid.add(id);
//       logger.w('❌ Failed to resolve RenderItem for id: $id');
//     }
//   }
//   if (invalid.isNotEmpty) {
//     logger.w('⚠️ Invalid RenderItem IDs: $invalid');
//   }
//   return items;
// }

// Future<RenderItem?> getContentObject(String id) async {
//   if (id.startsWith('lesson_')) {
//     final lesson = await JsonLessonRepository.loadById(id);
//     if (lesson != null) {
//       return RenderItem(
//         type: RenderItemType.lesson,
//         id: lesson.id,
//         title: lesson.title,
//         content: lesson.content,
//         flashcards: lesson.flashcards,
//       );
//     }
//   }

//   if (id.startsWith('part_')) {
//     final part = await JsonPartRepository.loadById(id);
//     if (part != null) {
//       return RenderItem(
//         type: RenderItemType.part,
//         id: part.id,
//         title: part.title,
//         content: part.content,
//         flashcards: part.flashcards,
//       );
//     }
//   }

//   if (id.startsWith('tool_')) {
//     final tool = await JsonToolRepository.loadById(id);
//     if (tool != null) {
//       return RenderItem(
//         type: RenderItemType.tool,
//         id: tool.id,
//         title: tool.title,
//         content: tool.content,
//         flashcards: tool.flashcards,
//       );
//     }
//   }

//   // If you add JSON-backed flashcards, resolve them here similarly.
//   logger.w('❌ getContentObject → no match for id: $id');
//   return null;
// }

// int? nextIndexIn(List<RenderItem> items, int i) =>
//     (i + 1 < items.length) ? i + 1 : null;
// int? prevIndexIn(List<RenderItem> items, int i) => (i - 1 >= 0) ? i - 1 : null;






















// // // lib/utils/render_item_helpers.dart
// // import 'package:bcc5/data/models/render_item.dart';
// // import 'package:bcc5/data/repositories/lessons/json_lesson_repository.dart';
// // import 'package:bcc5/data/repositories/parts/json_part_repository.dart';
// // import 'package:bcc5/data/repositories/tools/json_tool_repository.dart';
// // import 'package:bcc5/utils/logger.dart';

// // /// Build RenderItems from a list of IDs. No legacy fallback here.
// // Future<List<RenderItem>> buildRenderItems({required List<String> ids}) async {
// //   final items = <RenderItem>[];
// //   final invalidIds = <String>[];

// //   for (final id in ids) {
// //     final item = await getContentObject(id);
// //     if (item != null) {
// //       items.add(item);
// //     } else {
// //       logger.w('❌ Failed to resolve RenderItem for id: $id');
// //       invalidIds.add(id);
// //     }
// //   }

// //   if (invalidIds.isNotEmpty) {
// //     logger.w('⚠️ Invalid RenderItem IDs: $invalidIds');
// //   }
// //   return items;
// // }

// // /// Strictly resolve by JSON repositories only (no legacy fallback).
// // Future<RenderItem?> getContentObject(String id) async {
// //   if (id.startsWith('lesson_')) {
// //     final lesson = await JsonLessonRepository.loadById(id);
// //     if (lesson != null) {
// //       return RenderItem(
// //         type: RenderItemType.lesson,
// //         id: lesson.id,
// //         title: lesson.title,
// //         content: lesson.content,
// //         flashcards: lesson.flashcards,
// //       );
// //     }
// //   }

// //   if (id.startsWith('part_')) {
// //     final part = await JsonPartRepository.loadById(id);
// //     if (part != null) {
// //       return RenderItem(
// //         type: RenderItemType.part,
// //         id: part.id,
// //         title: part.title,
// //         content: part.content,
// //         flashcards: part.flashcards,
// //       );
// //     }
// //   }

// //   if (id.startsWith('tool_')) {
// //     final tool = await JsonToolRepository.loadById(id);
// //     if (tool != null) {
// //       return RenderItem(
// //         type: RenderItemType.tool,
// //         id: tool.id,
// //         title: tool.title,
// //         content: tool.content,
// //         flashcards: tool.flashcards,
// //       );
// //     }
// //   }

// //   if (id.startsWith('flashcard_')) {
// //     // If you have JSON-backed flashcards, resolve them here.
// //     logger.w('❌ getContentObject → flashcard JSON resolver not implemented.');
// //   }

// //   logger.w('❌ getContentObject → no match for id: $id');
// //   return null;
// // }

// // /// List-bound navigation helpers (no repo calls, no legacy).
// // int? nextIndexIn(List<RenderItem> items, int i) =>
// //     (i + 1 < items.length) ? i + 1 : null;

// // int? prevIndexIn(List<RenderItem> items, int i) =>
// //     (i - 1 >= 0) ? i - 1 : null;




// // // import 'package:bcc5/data/models/content_block.dart';
// // // import 'package:bcc5/data/models/render_item.dart';
// // // import 'package:bcc5/data/repositories/lessons/lesson_repository_index.dart';
// // // import 'package:bcc5/data/repositories/parts/part_repository_index.dart';
// // // import 'package:bcc5/data/repositories/tools/tool_repository_index.dart';
// // // import 'package:bcc5/data/loaders/content_loader.dart';
// // // import 'package:bcc5/utils/logger.dart';
// // // import 'package:bcc5/data/repositories/parts/json_part_repository.dart';
// // // import 'package:bcc5/data/repositories/tools/json_tool_repository.dart';

// // // Future<List<RenderItem>> buildRenderItems({required List<String> ids}) async {
// // //   final items = <RenderItem>[];
// // //   final invalidIds = <String>[];

// // //   for (final id in ids) {
// // //     final item = await getContentObject(id);
// // //     if (item != null) {
// // //       items.add(item);
// // //     } else {
// // //       logger.w('❌ Failed to resolve RenderItem for id: $id');
// // //       invalidIds.add(id);
// // //     }
// // //   }

// // //   if (invalidIds.isNotEmpty) {
// // //     logger.w('⚠️ Invalid RenderItem IDs: $invalidIds');
// // //   }

// // //   return items;
// // // }

// // // Future<RenderItem?> getContentObject(String id) async {
// // //   if (id.startsWith('lesson_')) {
// // //     final lesson = await ContentLoader.loadLessonById(id);
// // //     if (lesson != null) {
// // //       return RenderItem(
// // //         type: RenderItemType.lesson,
// // //         id: lesson.id,
// // //         title: lesson.title,
// // //         content: lesson.content,
// // //         flashcards: lesson.flashcards,
// // //       );
// // //     }
// // //   }

// // //   if (id.startsWith('part_')) {
// // //     // 1) Prefer JSON (assets/json/parts/<module>.json)
// // //     final jsonPart = await JsonPartRepository.loadById(id);
// // //     if (jsonPart != null) {
// // //       return RenderItem(
// // //         type: RenderItemType.part,
// // //         id: jsonPart.id,
// // //         title: jsonPart.title,
// // //         content: jsonPart.content,
// // //         flashcards: jsonPart.flashcards,
// // //       );
// // //     }

// // //     // 2) Fallback to legacy repo (temporary during migration)
// // //     final legacyPart = PartRepositoryIndex.getPartById(id);
// // //     if (legacyPart != null) {
// // //       return RenderItem(
// // //         type: RenderItemType.part,
// // //         id: legacyPart.id,
// // //         title: legacyPart.title,
// // //         content: legacyPart.content,
// // //         flashcards: legacyPart.flashcards,
// // //       );
// // //     }
// // //   }

// // //   if (id.startsWith('tool_')) {
// // //     final tool =
// // //         await JsonToolRepository.loadById(id) ??
// // //         ToolRepositoryIndex.getToolById(id); // legacy fallback
// // //     if (tool != null) {
// // //       return RenderItem(
// // //         type: RenderItemType.tool,
// // //         id: tool.id,
// // //         title: tool.title,
// // //         content: tool.content,
// // //         flashcards: tool.flashcards,
// // //       );
// // //     }
// // //   }

// // //   // if (id.startsWith('tool_')) {
// // //   //   final tool = ToolRepositoryIndex.getToolById(id);
// // //   //   if (tool != null) {
// // //   //     return RenderItem(
// // //   //       type: RenderItemType.tool,
// // //   //       id: tool.id,
// // //   //       title: tool.title,
// // //   //       content: tool.content,
// // //   //       flashcards: tool.flashcards,
// // //   //     );
// // //   //   }
// // //   // }

// // //   if (id.startsWith('flashcard_')) {
// // //     final flashcard =
// // //         LessonRepositoryIndex.getFlashcardById(id) ??
// // //         PartRepositoryIndex.getFlashcardById(id) ??
// // //         ToolRepositoryIndex.getFlashcardById(id);

// // //     if (flashcard != null) {
// // //       return RenderItem(
// // //         type: RenderItemType.flashcard,
// // //         id: flashcard.id,
// // //         title: flashcard.title,
// // //         content: flashcard.sideA + ContentBlock.dividerList() + flashcard.sideB,
// // //         flashcards: [flashcard],
// // //       );
// // //     }
// // //   }

// // //   logger.w('❌ getContentObject → no match for id: $id');
// // //   return null;
// // // }

// // // // import 'package:bcc5/data/models/content_block.dart';
// // // // import 'package:bcc5/data/models/render_item.dart';
// // // // import 'package:bcc5/data/repositories/lessons/lesson_repository_index.dart';
// // // // import 'package:bcc5/data/repositories/parts/part_repository_index.dart';
// // // // import 'package:bcc5/data/repositories/tools/tool_repository_index.dart';
// // // // import 'package:bcc5/utils/logger.dart';

// // // // List<RenderItem> buildRenderItems({required List<String> ids}) {
// // // //   // if (ids.length > 2) {
// // // //   //   logger.d('[Render] ${ids.length} item IDs: $ids');
// // // //   // }
// // // //   final items = <RenderItem>[];
// // // //   final invalidIds = <String>[];

// // // //   for (final id in ids) {
// // // //     final item = getContentObject(id);
// // // //     if (item != null) {
// // // //       // logger.d('✅ Built RenderItem → id: ${item.id}, type: ${item.type}');
// // // //       items.add(item);
// // // //     } else {
// // // //       logger.w('❌ Failed to resolve RenderItem for id: $id');
// // // //       invalidIds.add(id);
// // // //     }
// // // //   }

// // // //   if (invalidIds.isNotEmpty) {
// // // //     logger.w('⚠️ Invalid RenderItem IDs: $invalidIds');
// // // //   }

// // // //   return items;
// // // // }

// // // // RenderItem? getContentObject(String id) {
// // // //   if (id.startsWith('lesson_')) {
// // // //     final lesson = LessonRepositoryIndex.getLessonById(id);
// // // //     if (lesson != null) {
// // // //       return RenderItem(
// // // //         type: RenderItemType.lesson,
// // // //         id: lesson.id,
// // // //         title: lesson.title,
// // // //         content: lesson.content,
// // // //         flashcards: lesson.flashcards,
// // // //       );
// // // //     }
// // // //   }

// // // //   if (id.startsWith('part_')) {
// // // //     final part = PartRepositoryIndex.getPartById(id);
// // // //     if (part != null) {
// // // //       return RenderItem(
// // // //         type: RenderItemType.part,
// // // //         id: part.id,
// // // //         title: part.title,
// // // //         content: part.content,
// // // //         flashcards: part.flashcards,
// // // //       );
// // // //     }
// // // //   }

// // // //   if (id.startsWith('tool_')) {
// // // //     final tool = ToolRepositoryIndex.getToolById(id);
// // // //     if (tool != null) {
// // // //       return RenderItem(
// // // //         type: RenderItemType.tool,
// // // //         id: tool.id,
// // // //         title: tool.title,
// // // //         content: tool.content,
// // // //         flashcards: tool.flashcards,
// // // //       );
// // // //     }
// // // //   }

// // // //   if (id.startsWith('flashcard_')) {
// // // //     final flashcard =
// // // //         LessonRepositoryIndex.getFlashcardById(id) ??
// // // //         PartRepositoryIndex.getFlashcardById(id) ??
// // // //         ToolRepositoryIndex.getFlashcardById(id);

// // // //     if (flashcard != null) {
// // // //       return RenderItem(
// // // //         type: RenderItemType.flashcard,
// // // //         id: flashcard.id,
// // // //         title: flashcard.title,
// // // //         content: flashcard.sideA + ContentBlock.dividerList() + flashcard.sideB,
// // // //         flashcards: [flashcard],
// // // //       );
// // // //     }
// // // //   }

// // // //   logger.w('❌ getContentObject → no match for id: $id');
// // // //   return null;
// // // // }
