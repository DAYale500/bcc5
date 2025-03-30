// 📄 lib/data/repositories/tools/tool_repository_index.dart

import 'package:bcc5/data/models/tool_model.dart';

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
