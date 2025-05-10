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
              child: const Text(
                TourDescriptions.mob,
                style: TextStyle(color: Colors.white),
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
              child: const Text(
                TourDescriptions.settings,
                style: TextStyle(color: Colors.white),
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
              child: const Text(
                TourDescriptions.title,
                style: TextStyle(color: Colors.white),
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
              child: const Text(
                TourDescriptions.search,
                style: TextStyle(color: Colors.white),
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
              child: const Text(
                TourDescriptions.newCrew,
                style: TextStyle(color: Colors.white),
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
              child: const Text(
                TourDescriptions.advanced,
                style: TextStyle(color: Colors.white),
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
}
