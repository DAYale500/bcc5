import 'package:bcc5/theme/app_theme.dart';
import 'package:bcc5/widgets/tour/tour_descriptions.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';
import 'package:bcc5/utils/logger.dart';

const _seenKey = 'hasSeenLandingTour';

class LandingScreenTour {
  static Future<bool> shouldStart() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_seenKey) != true;
  }

  static Future<void> markSeen() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_seenKey, true);
  }

  static void start({
    required State state,
    required GlobalKey mobKey,
    required GlobalKey settingsKey,
    required GlobalKey titleKey,
    required GlobalKey searchKey,
    required GlobalKey newCrewKey,
    required GlobalKey advancedRefreshersKey,
    required GlobalKey harborKey,
    required GlobalKey coursesKey,
    required GlobalKey partsKey,
    required GlobalKey toolsKey,
    required GlobalKey drillsKey,
  }) async {
    logger.i('🎯 Starting Landing Tour...');
    logger.i('🧪 mobKey = ${mobKey.currentContext}');
    logger.i('🧪 settingsKey = ${settingsKey.currentContext}');
    logger.i('🧪 titleKey = ${titleKey.currentContext}');
    logger.i('🧪 searchKey = ${searchKey.currentContext}');
    logger.i('🧪 newCrewKey = ${newCrewKey.currentContext}');
    logger.i(
      '🧪 advancedRefreshersKey = ${advancedRefreshersKey.currentContext}',
    );

    final tutorial = TutorialCoachMark(
      targets: [
        TargetFocus(
          identify: 'mob',
          keyTarget: mobKey,
          enableOverlayTab: true,
          contents: [
            TargetContent(
              align: ContentAlign.bottom,
              child: Text(
                TourDescriptions.mob,
                style: AppTheme.tourDescriptionStyle,
              ),
            ),
          ],
        ),
        TargetFocus(
          identify: 'search',
          keyTarget: searchKey,
          enableOverlayTab: true,
          contents: [
            TargetContent(
              align: ContentAlign.bottom,
              child: Text(
                TourDescriptions.search,
                style: AppTheme.tourDescriptionStyle,
              ),
            ),
          ],
        ),
        TargetFocus(
          identify: 'settings',
          keyTarget: settingsKey,
          enableOverlayTab: true,
          contents: [
            TargetContent(
              align: ContentAlign.bottom,
              child: Text(
                TourDescriptions.settings,
                style: AppTheme.tourDescriptionStyle,
              ),
            ),
          ],
        ),
        TargetFocus(
          identify: 'bnbHarbor',
          keyTarget: harborKey,
          enableOverlayTab: true,
          shape: ShapeLightFocus.Circle,
          radius: 50,
          paddingFocus: 25,
          contents: [
            TargetContent(
              align: ContentAlign.top,
              child: Text(
                TourDescriptions.bnbHarbor,
                style: AppTheme.tourDescriptionStyle,
              ),
            ),
          ],
        ),
        TargetFocus(
          identify: 'bnbCourses',
          keyTarget: coursesKey,
          enableOverlayTab: true,
          shape: ShapeLightFocus.Circle,
          radius: 50,
          paddingFocus: 25,
          contents: [
            TargetContent(
              align: ContentAlign.top,
              child: Text(
                TourDescriptions.bnbCourses,
                style: AppTheme.tourDescriptionStyle,
              ),
            ),
          ],
        ),
        TargetFocus(
          identify: 'bnbParts',
          keyTarget: partsKey,
          enableOverlayTab: true,
          shape: ShapeLightFocus.Circle,
          radius: 50,
          paddingFocus: 20,
          contents: [
            TargetContent(
              align: ContentAlign.top,
              child: Text(
                TourDescriptions.bnbParts,
                style: AppTheme.tourDescriptionStyle,
              ),
            ),
          ],
        ),
        TargetFocus(
          identify: 'bnbTools',
          keyTarget: toolsKey,
          enableOverlayTab: true,
          shape: ShapeLightFocus.Circle,
          radius: 50,
          paddingFocus: 20,
          contents: [
            TargetContent(
              align: ContentAlign.top,
              child: Text(
                TourDescriptions.bnbTools,
                style: AppTheme.tourDescriptionStyle,
              ),
            ),
          ],
        ),
        TargetFocus(
          identify: 'bnbDrills',
          keyTarget: drillsKey,
          enableOverlayTab: true,
          shape: ShapeLightFocus.Circle,
          radius: 50,
          paddingFocus: 20,
          contents: [
            TargetContent(
              align: ContentAlign.top,
              child: Text(
                TourDescriptions.bnbDrills,
                style: AppTheme.tourDescriptionStyle,
              ),
            ),
          ],
        ),
        TargetFocus(
          identify: 'advanced',
          keyTarget: advancedRefreshersKey,
          enableOverlayTab: true,
          shape: ShapeLightFocus.RRect,
          radius: 40,
          paddingFocus: 6,
          contents: [
            TargetContent(
              align: ContentAlign.bottom,
              child: Text(
                TourDescriptions.advanced,
                style: AppTheme.tourDescriptionStyle,
              ),
            ),
          ],
        ),
        TargetFocus(
          identify: 'newCrew',
          keyTarget: newCrewKey,
          enableOverlayTab: true,
          shape: ShapeLightFocus.RRect,
          radius: 40,
          paddingFocus: 6,
          contents: [
            TargetContent(
              align: ContentAlign.bottom,
              child: Text(
                TourDescriptions.newCrew,
                style: AppTheme.tourDescriptionStyle,
              ),
            ),
          ],
        ),
      ],
      alignSkip: Alignment.centerRight,
      textSkip: "Skip\nTour",
      textStyleSkip: const TextStyle(color: Colors.white),
      focusAnimationDuration: Duration.zero,
      unFocusAnimationDuration: Duration.zero,
      pulseEnable: true,
      onFinish: () => logger.i('✅ Tour finished'),
      onSkip: () {
        logger.i('⏭ Tour skipped');
        return true;
      },
    );

    // final tutorial = TutorialCoachMark(
    //   targets: [
    //     TargetFocus(
    //       identify: 'mob',
    //       keyTarget: mobKey,
    //       enableOverlayTab: true,

    //       contents: [
    //         TargetContent(
    //           align: ContentAlign.bottom,
    //           child: Text(
    //             TourDescriptions.mob,
    //             style: AppTheme.tourDescriptionStyle,
    //           ),
    //         ),
    //       ],
    //     ),
    //     TargetFocus(
    //       identify: 'settings',
    //       keyTarget: settingsKey,
    //       enableOverlayTab: true,

    //       contents: [
    //         TargetContent(
    //           align: ContentAlign.bottom,
    //           child: Text(
    //             TourDescriptions.settings,
    //             style: AppTheme.tourDescriptionStyle,
    //           ),
    //         ),
    //       ],
    //     ),

    //     TargetFocus(
    //       identify: 'search',
    //       keyTarget: searchKey,
    //       enableOverlayTab: true,

    //       contents: [
    //         TargetContent(
    //           align: ContentAlign.bottom,
    //           child: Text(
    //             TourDescriptions.search,
    //             style: AppTheme.tourDescriptionStyle,
    //           ),
    //         ),
    //       ],
    //     ),

    //     TargetFocus(
    //       identify: 'newCrew',
    //       keyTarget: newCrewKey,
    //       enableOverlayTab: true,

    //       shape: ShapeLightFocus.RRect,
    //       radius: 40, // 👈 shrink the circle size
    //       paddingFocus: 6, // 👈 tighter highlight
    //       contents: [
    //         TargetContent(
    //           align: ContentAlign.bottom,
    //           child: Text(
    //             TourDescriptions.newCrew,
    //             style: AppTheme.tourDescriptionStyle,
    //           ),
    //         ),
    //       ],
    //     ),
    //     TargetFocus(
    //       identify: 'advanced',
    //       keyTarget: advancedRefreshersKey,
    //       enableOverlayTab: true,

    //       shape: ShapeLightFocus.RRect,
    //       radius: 40, // 👈 shrink the circle size
    //       paddingFocus: 6, // 👈 tighter highlight
    //       contents: [
    //         TargetContent(
    //           align: ContentAlign.bottom,
    //           child: Text(
    //             TourDescriptions.advanced,
    //             style: AppTheme.tourDescriptionStyle,
    //           ),
    //         ),
    //       ],
    //     ),
    //     TargetFocus(
    //       identify: 'bnbHarbor',
    //       keyTarget: harborKey,
    //       enableOverlayTab: true,
    //       shape: ShapeLightFocus.Circle,
    //       radius: 50,
    //       paddingFocus: 25,
    //       contents: [
    //         TargetContent(
    //           align: ContentAlign.top,
    //           child: Text(
    //             TourDescriptions.bnbHarbor,
    //             style: AppTheme.tourDescriptionStyle,
    //           ),
    //         ),
    //       ],
    //     ),
    //     TargetFocus(
    //       identify: 'bnbCourses',
    //       keyTarget: coursesKey,
    //       enableOverlayTab: true,
    //       shape: ShapeLightFocus.Circle,
    //       radius: 50,
    //       paddingFocus: 25,
    //       contents: [
    //         TargetContent(
    //           align: ContentAlign.top,
    //           child: Text(
    //             TourDescriptions.bnbCourses,
    //             style: AppTheme.tourDescriptionStyle,
    //           ),
    //         ),
    //       ],
    //     ),
    //     TargetFocus(
    //       identify: 'bnbParts',
    //       keyTarget: partsKey,
    //       enableOverlayTab: true,
    //       shape: ShapeLightFocus.Circle,
    //       radius: 50,
    //       paddingFocus: 20,
    //       contents: [
    //         TargetContent(
    //           align: ContentAlign.top,
    //           child: Text(
    //             TourDescriptions.bnbParts,
    //             style: AppTheme.tourDescriptionStyle,
    //           ),
    //         ),
    //       ],
    //     ),
    //     TargetFocus(
    //       identify: 'bnbTools',
    //       keyTarget: toolsKey,
    //       enableOverlayTab: true,
    //       shape: ShapeLightFocus.Circle,
    //       radius: 50,
    //       paddingFocus: 20,
    //       contents: [
    //         TargetContent(
    //           align: ContentAlign.top,
    //           child: Text(
    //             TourDescriptions.bnbTools,
    //             style: AppTheme.tourDescriptionStyle,
    //           ),
    //         ),
    //       ],
    //     ),
    //     TargetFocus(
    //       identify: 'bnbDrills',
    //       keyTarget: drillsKey,
    //       enableOverlayTab: true,
    //       shape: ShapeLightFocus.Circle,
    //       radius: 50,
    //       paddingFocus: 20,
    //       contents: [
    //         TargetContent(
    //           align: ContentAlign.top,
    //           child: Text(
    //             TourDescriptions.bnbDrills,
    //             style: AppTheme.tourDescriptionStyle,
    //           ),
    //         ),
    //       ],
    //     ),
    //   ],

    //   // tutorial customizations
    //   alignSkip: Alignment.centerRight, // 🔄 Positions the skip button
    //   textSkip: "Skip\nTour",
    //   textStyleSkip: const TextStyle(color: Colors.white),
    //   focusAnimationDuration: Duration.zero,
    //   unFocusAnimationDuration: Duration.zero,

    //   pulseEnable: true, // 👈 disables pulsing circle effect

    //   onFinish: () => logger.i('✅ Tour finished'),
    //   onSkip: () {
    //     logger.i('⏭ Tour skipped');
    //     return true;
    //   },
    // );

    await markSeen();
    if (!state.mounted) return;
    tutorial.show(context: state.context);
  }

  static Future<void> reset() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_seenKey);
    logger.i('🔄 Tour state reset (Landing)');
  }

  static Future<void> restartNow({
    required State landingScreenState,
    required GlobalKey mobKey,
    required GlobalKey settingsKey,
    required GlobalKey titleKey,
    required GlobalKey searchKey,
    required GlobalKey newCrewKey,
    required GlobalKey advancedRefreshersKey,
    required GlobalKey harborKey,
    required GlobalKey coursesKey,
    required GlobalKey partsKey,
    required GlobalKey toolsKey,
    required GlobalKey drillsKey,
  }) async {
    await reset();
    if (!landingScreenState.mounted) return;
    await Future.delayed(const Duration(milliseconds: 200));
    start(
      state: landingScreenState,
      mobKey: mobKey,
      settingsKey: settingsKey,
      titleKey: titleKey,
      searchKey: searchKey,
      newCrewKey: newCrewKey,
      advancedRefreshersKey: advancedRefreshersKey,
      harborKey: harborKey,
      coursesKey: coursesKey,
      partsKey: partsKey,
      toolsKey: toolsKey,
      drillsKey: drillsKey,
    );
  }
}
