import 'package:flutter/material.dart';
import 'main_scaffold.dart';

/// Wraps any screen with the MainScaffold layout,
/// ensuring the BottomNavigationBar remains visible.
///
/// [selectedIndex] determines which BNB tab is highlighted.
/// [child] is the content screen to render inside the scaffold.
Widget withBNB({required int selectedIndex, required Widget child}) {
  return MainScaffold(selectedIndex: selectedIndex, child: child);
}
