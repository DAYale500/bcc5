import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
// import '../utils/logger.dart';
import '../navigation/detail_route.dart';
import '../theme/slide_direction.dart';

class MainScaffold extends StatelessWidget {
  final int branchIndex;
  final Widget child;
  final PreferredSizeWidget? appBar;
  final GlobalKey? harborKey;
  final GlobalKey? bnbLessonsKey;
  final GlobalKey? bnbPartsKey;
  final GlobalKey? bnbToolsKey;
  final GlobalKey? bnbFlashcardsKey;

  const MainScaffold({
    super.key,
    required this.branchIndex,
    required this.child,
    this.appBar,
    this.harborKey,
    this.bnbLessonsKey, // ✅
    this.bnbPartsKey, // ✅
    this.bnbToolsKey, // ✅
    this.bnbFlashcardsKey, // ✅
  });

  void _onItemTapped(BuildContext context, int index) {
    if (index == branchIndex) return;

    // logger.i('🧭 BNB tapped tab $index — switching via GoRouter');

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

  GlobalKey? _getBNBKey(int index) {
    switch (index) {
      case 1:
        return bnbLessonsKey; // ✅
      case 2:
        return bnbPartsKey; // ✅
      case 3:
        return bnbToolsKey; // ✅
      case 4:
        return bnbFlashcardsKey; // ✅
      default:
        return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    // logger.d('[Scaffold] tab index: $branchIndex');

    return Scaffold(
      appBar: appBar,
      body: child,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: branchIndex,
        onTap: (index) => _onItemTapped(context, index),
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.anchor_outlined, key: harborKey),
            label: 'Harbor',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.public_outlined, key: _getBNBKey(1)), // ✅
            label: 'Courses',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.sailing_outlined, key: _getBNBKey(2)), // ✅
            label: 'Parts',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.build, key: _getBNBKey(3)), // ✅
            label: 'Tools',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.quiz_outlined, key: _getBNBKey(4)), // ✅
            label: 'Drills',
          ),
        ],
      ),
    );
  }
}
