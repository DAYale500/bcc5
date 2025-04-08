import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../utils/logger.dart';
import '../navigation/detail_route.dart';
import '../theme/slide_direction.dart';

class MainScaffold extends StatelessWidget {
  final int branchIndex;
  final Widget child;
  final PreferredSizeWidget? appBar;

  const MainScaffold({
    super.key,
    required this.branchIndex,
    required this.child,
    this.appBar,
  });

  void _onItemTapped(BuildContext context, int index) {
    if (index == branchIndex) return;

    logger.i('🧭 BNB tapped tab $index — switching via GoRouter');

    final routes = ['/', '/lessons', '/parts', '/tools', '/flashcards'];
    final destination = routes[index];

    context.go(
      destination,
      extra: {
        'transitionKey': UniqueKey(),
        'detailRoute': DetailRoute.branch,
        'slideFrom': SlideDirection.none,
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    logger.d('🔷 Building MainScaffold, tab index: $branchIndex');

    return Scaffold(
      appBar: appBar,
      body: child,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: branchIndex,
        onTap: (index) => _onItemTapped(context, index),
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.anchor_outlined),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.public_outlined),
            label: 'Modules',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.sailing_outlined),
            label: 'Parts',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.build), label: 'Tools'),
          BottomNavigationBarItem(
            icon: Icon(Icons.quiz_outlined),
            label: 'Flashcards',
          ),
        ],
      ),
    );
  }
}
