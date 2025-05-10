// lib/widgets/custom_bottom_nav_bar.dart

import 'package:flutter/material.dart';

class CustomBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;
  final GlobalKey harborKey;
  final GlobalKey coursesKey;
  final GlobalKey partsKey;
  final GlobalKey toolsKey;
  final GlobalKey drillsKey;

  const CustomBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
    required this.harborKey,
    required this.coursesKey,
    required this.partsKey,
    required this.toolsKey,
    required this.drillsKey,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: onTap,
      type: BottomNavigationBarType.fixed,
      items: [
        BottomNavigationBarItem(
          icon: Icon(Icons.anchor_outlined, key: harborKey),
          label: 'Harbor',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.public_outlined, key: coursesKey),
          label: 'Courses',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.sailing_outlined, key: partsKey),
          label: 'Parts',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.build, key: toolsKey),
          label: 'Tools',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.quiz_outlined, key: drillsKey),
          label: 'Drills',
        ),
      ],
    );
  }
}
