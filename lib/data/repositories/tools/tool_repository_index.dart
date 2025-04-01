import 'package:bcc5/data/models/flashcard_model.dart';
import 'package:bcc5/data/models/tool_model.dart';
import 'package:bcc5/utils/logger.dart';

import 'tool_procedures_repository.dart';
import 'tool_references_repository.dart';
import 'tool_checklists_repository.dart';
import 'tool_ditchbag_repository.dart';
import 'tool_grabbag_repository.dart';
import 'tool_thumbrules_repository.dart';

class ToolRepositoryIndex {
  static final Map<String, List<ToolItem>> _toolbags = {
    'procedures': ToolProceduresRepository.toolItems,
    'references': ToolReferencesRepository.toolItems,
    'checklists': ToolChecklistsRepository.toolItems,
    'grabbag': ToolGrabbagRepository.toolItems,
    'ditchbag': ToolDitchbagRepository.toolItems,
    'thumbrules': ToolThumbrulesRepository.toolItems,
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
    logger.i(
      '🔍 ToolRepositoryIndex.getFlashcardById → attempting lookup for "$id"',
    );

    for (final tool in getAllTools()) {
      for (final card in tool.flashcards) {
        logger.i('   • checking ${card.id}');
        if (card.id == id) {
          logger.i('✅ match found in toolbag for $id');
          return card;
        }
      }
    }

    logger.e('❌ Flashcard not found in toolbags for id: $id');
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
