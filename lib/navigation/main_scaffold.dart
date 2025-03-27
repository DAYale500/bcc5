import 'package:flutter/material.dart';
import '../screens/home/landing_screen.dart';
import '../screens/lessons/lesson_module_screen.dart';
import '../screens/parts/part_zone_screen.dart';
import '../screens/flashcards/flashcard_category_screen.dart';
import '../screens/tools/tools_screen.dart';
import '../utils/logger.dart';

class MainScaffold extends StatelessWidget {
  final int selectedIndex;
  final Widget child;

  const MainScaffold({
    super.key,
    required this.selectedIndex,
    required this.child,
  });

  void _onItemTapped(BuildContext context, int index) {
    if (index == selectedIndex) {
      logger.i('🔁 BNB tapped same tab: $index — no navigation');
      return;
    }

    logger.i('🧭 BNB tapped tab $index — switching screen');

    Widget newScreen;
    switch (index) {
      case 0:
        newScreen = const LandingScreen();
        break;
      case 1:
        newScreen = const LessonModuleScreen();
        break;
      case 2:
        newScreen = const PartZoneScreen();
        break;
      case 3:
        newScreen = const FlashcardCategoryScreen();
        break;
      case 4:
        newScreen = const ToolsScreen();
        break;
      default:
        newScreen = const LandingScreen();
    }

    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (_) => MainScaffold(selectedIndex: index, child: newScreen),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    logger.i('🔷 Building MainScaffold, tab index: $selectedIndex');

    return Scaffold(
      body: child,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: selectedIndex,
        onTap: (index) => _onItemTapped(context, index),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
            icon: Icon(Icons.menu_book),
            label: 'Modules',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Parts'),
          BottomNavigationBarItem(icon: Icon(Icons.style), label: 'Flashcards'),
          BottomNavigationBarItem(icon: Icon(Icons.build), label: 'Tools'),
        ],
        type: BottomNavigationBarType.fixed,
      ),
    );
  }
}
