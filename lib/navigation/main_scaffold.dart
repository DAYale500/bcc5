import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../utils/logger.dart';

class MainScaffold extends StatelessWidget {
  final int branchIndex;
  final Widget child;
  final PreferredSizeWidget? appBar; // 🟠 Added to support top AppBar injection

  const MainScaffold({
    super.key,
    required this.branchIndex,
    required this.child,
    this.appBar, // 🟠 Optional AppBar
  });

  void _onItemTapped(BuildContext context, int index) {
    if (index == branchIndex) {
      logger.i('🔁 BNB tapped same tab: $index — no navigation');
      return;
    }

    logger.i('🧭 BNB tapped tab $index — switching via GoRouter');
    final routes = ['/', '/lessons', '/parts', '/flashcards', '/tools'];
    context.go(routes[index]);
  }

  @override
  Widget build(BuildContext context) {
    logger.i('🔷 Building MainScaffold, tab index: $branchIndex');

    return Scaffold(
      appBar: appBar, // 🟠 Use optional AppBar injected from screen
      body: child,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: branchIndex,
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
