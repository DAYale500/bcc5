import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../navigation/detail_route.dart';
import '../theme/slide_direction.dart';
import '../widgets/custom_bottom_nav_bar.dart';

class MainScaffold extends StatelessWidget {
  final int branchIndex;
  final Widget child;
  final PreferredSizeWidget? appBar;

  // ✅ Use consistent and intuitive labels
  final GlobalKey harborKey;
  final GlobalKey coursesKey;
  final GlobalKey partsKey;
  final GlobalKey toolsKey;
  final GlobalKey drillsKey;

  const MainScaffold({
    super.key,
    required this.branchIndex,
    required this.child,
    required this.harborKey,
    required this.coursesKey,
    required this.partsKey,
    required this.toolsKey,
    required this.drillsKey,
    this.appBar,
  });

  void _onItemTapped(BuildContext context, int index) {
    if (index == branchIndex) return;

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
    return Scaffold(
      appBar: appBar,
      body: child,
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: branchIndex,
        onTap: (index) => _onItemTapped(context, index),
        harborKey: harborKey,
        coursesKey: coursesKey,
        partsKey: partsKey,
        toolsKey: toolsKey,
        drillsKey: drillsKey,
      ),
    );
  }
}
