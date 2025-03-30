// 📄 lib/data/repositories/tools/tool_repository_index.dart

import 'package:bcc5/data/models/tool_model.dart';

import 'tool_procedures_repository.dart' as procedures;
import 'tool_references_repository.dart' as references;
// import 'tool_calculators_repository.dart' as calculators;
// import 'tool_checklists_repository.dart' as checklists;
// import 'tool_thumbrules_repository.dart' as thumbrules;
// import 'tool_ditchbag_repository.dart' as ditchbag;
// import 'tool_grabbag_repository.dart' as grabbag;

final Map<String, List<ToolItem>> toolbagMap = {
  'procedures': procedures.getItemsForGroup('procedures'),
  'references': references.getItemsForGroup('references'),
  // 'calculators': calculators.getItemsForGroup('calculators'),
  // 'checklists': checklists.getItemsForGroup('checklists'),
  // 'thumbrules': thumbrules.getItemsForGroup('thumbrules'),
  // 'ditchbag': ditchbag.getItemsForGroup('ditchbag'),
  // 'grabbag': grabbag.getItemsForGroup('grabbag'),
};

/// Public: Returns tool items for a specific bag
List<ToolItem> getToolsForBag(String toolbag) => toolbagMap[toolbag] ?? [];

/// Public: Searches all tool items across bags by ID
ToolItem? getToolById(String id) {
  for (final items in toolbagMap.values) {
    for (final item in items) {
      if (item.id == id) return item;
    }
  }
  return null;
}

/// Public: Returns all known toolbag keys
List<String> getToolbagNames() => toolbagMap.keys.toList();

/// Public: Asserts every tool item ID is correctly prefixed
void assertAllToolIdsValid() {
  toolbagMap.forEach((bag, items) {
    for (final item in items) {
      assert(
        item.id.startsWith('tool_${bag}_'),
        'Invalid ID in $bag: ${item.id}',
      );
    }
  });
}
