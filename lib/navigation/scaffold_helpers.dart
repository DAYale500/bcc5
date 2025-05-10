import 'package:flutter/material.dart';
import 'main_scaffold.dart';

/// Wraps any screen with the MainScaffold layout,
/// ensuring the BottomNavigationBar remains visible.
///
/// [branchIndex] determines which BNB tab is highlighted.
/// [child] is the content screen to render inside the scaffold.
Widget withBNB({required int branchIndex, required Widget child}) {
  return MainScaffold(
    branchIndex: branchIndex,
    harborKey: GlobalKey(debugLabel: 'HarborIconKey'),
    coursesKey: GlobalKey(debugLabel: 'LessonsIconKey'),
    partsKey: GlobalKey(debugLabel: 'PartsIconKey'),
    toolsKey: GlobalKey(debugLabel: 'ToolsIconKey'),
    drillsKey: GlobalKey(debugLabel: 'DrillsIconKey'),
    child: child,
  );
}
