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
          contents: [
            TargetContent(
              align: ContentAlign.bottom,
              child: Text(
                TourDescriptions.mob,
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
        TargetFocus(
          identify: 'settings',
          keyTarget: settingsKey,
          contents: [
            TargetContent(
              align: ContentAlign.bottom,
              child: Text(
                TourDescriptions.settings,
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
        TargetFocus(
          identify: 'title',
          keyTarget: titleKey,
          contents: [
            TargetContent(
              align: ContentAlign.bottom,
              child: Text(
                TourDescriptions.title,
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
        TargetFocus(
          identify: 'search',
          keyTarget: searchKey,
          contents: [
            TargetContent(
              align: ContentAlign.bottom,
              child: Text(
                TourDescriptions.search,
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
        TargetFocus(
          identify: 'newCrew',
          keyTarget: newCrewKey,
          contents: [
            TargetContent(
              align: ContentAlign.bottom,
              child: Text(
                TourDescriptions.newCrew,
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
        TargetFocus(
          identify: 'advanced',
          keyTarget: advancedRefreshersKey,
          contents: [
            TargetContent(
              align: ContentAlign.bottom,
              child: Text(
                TourDescriptions.advanced,
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
        TargetFocus(
          identify: 'bnbHarbor',
          keyTarget: harborKey,
          contents: [
            TargetContent(
              align: ContentAlign.top,
              child: Text(
                TourDescriptions.bnbHarbor,
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
        TargetFocus(
          identify: 'bnbCourses',
          keyTarget: coursesKey,
          contents: [
            TargetContent(
              align: ContentAlign.top,
              child: Text(
                TourDescriptions.bnbCourses,
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
        TargetFocus(
          identify: 'bnbParts',
          keyTarget: partsKey,
          contents: [
            TargetContent(
              align: ContentAlign.top,
              child: Text(
                TourDescriptions.bnbParts,
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
        TargetFocus(
          identify: 'bnbTools',
          keyTarget: toolsKey,
          contents: [
            TargetContent(
              align: ContentAlign.top,
              child: Text(
                TourDescriptions.bnbTools,
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
        TargetFocus(
          identify: 'bnbDrills',
          keyTarget: drillsKey,
          contents: [
            TargetContent(
              align: ContentAlign.top,
              child: Text(
                TourDescriptions.bnbDrills,
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ],
      onFinish: () => logger.i('✅ Tour finished'),
      onSkip: () {
        logger.i('⏭ Tour skipped');
        return true;
      },
    );

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
