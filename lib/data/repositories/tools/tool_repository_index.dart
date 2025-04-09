import 'package:bcc5/data/models/flashcard_model.dart';
import 'package:bcc5/data/models/tool_model.dart';
import 'package:bcc5/data/repositories/tools/tool_references_repository.dart';
import 'package:bcc5/utils/logger.dart';

import 'tool_procedures_repository.dart';
import 'tool_colregs_repository.dart';
import 'tool_checklists_repository.dart';

class ToolRepositoryIndex {
  static final Map<String, List<ToolItem>> _toolbags = {
    'checklists': ToolChecklistsRepository.toolItems,
    'procedures': ToolProceduresRepository.toolItems,
    'references': ToolReferencesRepository.toolItems,
    'colregs': ToolColregsRepository.toolItems,
  };

  static List<ToolItem> getToolsForBag(String toolbag) =>
      _toolbags[toolbag] ?? [];

  static ToolItem? getToolById(String id) {
    for (final items in _toolbags.values) {
      for (final item in items) {
        if (item.id == id) return item;
      }
    }
    return null;
  }

  static List<ToolItem> getAllTools() =>
      _toolbags.values.expand((list) => list).toList();

  static Flashcard? getFlashcardById(String id) {
    logger.i('🔍 Looking for flashcard in tools: $id');

    for (final tool in getAllTools()) {
      for (final card in tool.flashcards) {
        if (card.id == id) {
          logger.i('✅ Found flashcard in tool: ${card.id}');
          return card;
        }
      }
    }

    logger.w('❌ Flashcard not found in toolbags for id: $id');
    return null;
  }

  static List<String> getToolbagNames() => _toolbags.keys.toList();

  static void assertAllToolIdsValid() {
    _toolbags.forEach((bag, items) {
      for (final item in items) {
        assert(
          item.id.startsWith('tool_${bag}_'),
          'Invalid ID in $bag: ${item.id}',
        );
      }
    });
  }
}
