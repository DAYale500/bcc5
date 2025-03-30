// 📄 lib/data/repositories/tools/tool_repository_index.dart

import 'package:bcc5/data/models/tool_model.dart';

import 'tool_procedures_repository.dart';
import 'tool_references_repository.dart';
import 'tool_calculators_repository.md';
import 'tool_checklists_repository.dart';
import 'tool_thumbrules_repository.dart';
import 'tool_ditchbag_repository.dart';
import 'tool_grabbag_repository.dart';

final Map<String, List<ToolItem>> toolbagMap = {
  'procedures': getItemsForGroup('procedures'),
  'references': getItemsForGroup('references'),
  'calculators': getItemsForGroup('calculators'),
  'checklists': getItemsForGroup('checklists'),
  'thumbrules': getItemsForGroup('thumbrules'),
  'ditchbag': getItemsForGroup('ditchbag'),
  'grabbag': getItemsForGroup('grabbag'),
};

List<ToolItem> getToolsForBag(String toolbag) {
  return toolbagMap[toolbag] ?? [];
}

ToolItem? getToolById(String id) {
  for (final items in toolbagMap.values) {
    for (final item in items) {
      if (item.id == id) return item;
    }
  }
  return null;
}

List<String> getToolbagNames() => toolbagMap.keys.toList();

void assertAllToolIdsValid() {
  toolbagMap.forEach((bag, items) {
    for (final item in items) {
      assert(item.id.startsWith('tool_${bag}_'), 'Invalid ID in $bag: ${item.id}');
    }
  });
}
