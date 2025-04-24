import 'package:flutter/material.dart';
import 'landing_screen.dart';

class LandingScreenTourWrapper extends StatelessWidget {
  final bool showReminder;
  final GlobalKey harborKey;
  final GlobalKey mobKey;
  final GlobalKey settingsKey;
  final GlobalKey searchKey;
  final GlobalKey titleKey;

  const LandingScreenTourWrapper({
    super.key,
    required this.showReminder,
    required this.harborKey,
    required this.mobKey,
    required this.settingsKey,
    required this.searchKey,
    required this.titleKey,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        LandingScreen(
          showReminder: showReminder,
          harborKey: harborKey,
          mobKey: mobKey,
          settingsKey: settingsKey,
          searchKey: searchKey,
          titleKey: titleKey,
          bnbLessonsKey: GlobalKey(debugLabel: 'BNBLessonsKey'), // ✅
          bnbPartsKey: GlobalKey(debugLabel: 'BNBPartsKey'), // ✅
          bnbToolsKey: GlobalKey(debugLabel: 'BNBToolsKey'), // ✅
          bnbFlashcardsKey: GlobalKey(debugLabel: 'BNBFlashcardsKey'), // ✅
        ),
        // ✅ Future overlay goes here (TourOverlayManager)
      ],
    );
  }
}
