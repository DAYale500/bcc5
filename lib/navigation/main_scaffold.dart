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

// import 'package:flutter/material.dart';
// import 'package:go_router/go_router.dart';
// // import '../utils/logger.dart';
// import '../navigation/detail_route.dart';
// import '../theme/slide_direction.dart';

// class MainScaffold extends StatelessWidget {
//   final int branchIndex;
//   final Widget child;
//   final PreferredSizeWidget? appBar;
//   final GlobalKey? harborKey;

//   const MainScaffold({
//     super.key,
//     required this.branchIndex,
//     required this.child,
//     this.appBar,
//     this.harborKey,
//   });

//   void _onItemTapped(BuildContext context, int index) {
//     if (index == branchIndex) return;

//     // logger.i('🧭 BNB tapped tab $index — switching via GoRouter');

//     final routes = ['/', '/lessons', '/parts', '/tools', '/flashcards'];
//     final destination = routes[index];

//     context.go(
//       destination,
//       extra: {
//         'transitionKey': UniqueKey(),
//         'detailRoute': DetailRoute.branch,
//         'slideFrom': SlideDirection.none,
//       },
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     // logger.d('[Scaffold] tab index: $branchIndex');

//     return Scaffold(
//       appBar: appBar,
//       body: child,
//       bottomNavigationBar: BottomNavigationBar(
//         currentIndex: branchIndex,
//         onTap: (index) => _onItemTapped(context, index),
//         type: BottomNavigationBarType.fixed,
//         items: [
//           BottomNavigationBarItem(
//             icon: Icon(Icons.anchor_outlined, key: harborKey),
//             label: 'Harbor',
//           ),

//           BottomNavigationBarItem(
//             icon: Icon(Icons.public_outlined),
//             label: 'Courses',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.sailing_outlined),
//             label: 'Parts',
//           ),
//           BottomNavigationBarItem(icon: Icon(Icons.build), label: 'Tools'),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.quiz_outlined),
//             label: 'Drills',
//           ),
//         ],
//       ),
//     );
//   }
// }
