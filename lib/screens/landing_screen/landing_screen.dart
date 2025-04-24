import 'package:bcc5/navigation/detail_route.dart';
import 'package:bcc5/theme/slide_direction.dart';
import 'package:bcc5/theme/transition_type.dart';
import 'package:bcc5/widgets/settings_modal.dart';
import 'package:bcc5/widgets/tour/tour_controller.dart';
import 'package:bcc5/widgets/tour/tour_overlay_manager.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:bcc5/widgets/custom_app_bar_widget.dart';
import 'package:bcc5/theme/app_theme.dart';
import 'package:bcc5/utils/logger.dart';

class LandingScreen extends StatelessWidget {
  final bool showReminder;
  final GlobalKey harborKey;
  final GlobalKey mobKey;
  final GlobalKey settingsKey;
  final GlobalKey searchKey;
  final GlobalKey titleKey;
  // 🚩 Add this to hold the controller
  final TourController _tourController = TourController(steps: []);

  // 🚩 GlobalKeys for onboarding tour steps
  final GlobalKey _keyAppBarTitle = GlobalKey();
  final GlobalKey _keyMOBButton = GlobalKey();
  final GlobalKey _keySettingsIcon = GlobalKey();
  final GlobalKey _keySearchIcon = GlobalKey();
  final GlobalKey _keyBNBLessons = GlobalKey(); // ✅
  final GlobalKey _keyBNBParts = GlobalKey(); // ✅
  final GlobalKey _keyBNBTools = GlobalKey(); // ✅
  final GlobalKey _keyBNBFlashcards = GlobalKey(); // ✅
  final GlobalKey bnbLessonsKey; // ✅
  final GlobalKey bnbPartsKey; // ✅
  final GlobalKey bnbToolsKey; // ✅
  final GlobalKey bnbFlashcardsKey; // ✅

  LandingScreen({
    super.key,
    required this.showReminder,
    required this.harborKey,
    required this.mobKey,
    required this.settingsKey,
    required this.searchKey,
    required this.titleKey,
    required this.bnbLessonsKey,
    required this.bnbPartsKey,
    required this.bnbToolsKey,
    required this.bnbFlashcardsKey,
  }) {
    logger.i('📘 [LandingScreen] Constructor called'); // ✅
  }

  @override
  Widget build(BuildContext context) {
    logger.i('📘 [LandingScreen] build() triggered'); // ✅

    if (showReminder) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        showDialog(
          context: context,
          builder:
              (_) => AlertDialog(
                title: const Text('Update Vessel Info'),
                content: const Text(
                  'Review your vessel info to ensure emergency details are up to date.',
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text("Info is accurate"),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                      showSettingsModal(context);
                    },
                    child: const Text("Update Now"),
                  ),
                ],
              ),
        );
      });
    }
    // ✅ Tour steps in desired order
    _tourController.steps.clear();
    _tourController.steps.addAll([
      _keyAppBarTitle,
      _keyMOBButton,
      _keySettingsIcon,
      _keySearchIcon,
      _keyBNBLessons, // ✅
      _keyBNBParts, // ✅
      _keyBNBTools, // ✅
      _keyBNBFlashcards, // ✅
    ]);
    _tourController.addStep(
      id: 'newCrew',
      key: _tourController.getKeyForStep('newCrew'),
      description: 'Start your training here as a new crewmember.',
    ); // ✅

    _tourController.addStep(
      id: 'search',
      key: _keySearchIcon,
      description: 'Tap here to search lessons, tools, or flashcards.',
    ); // ✅

    _tourController.addStep(
      id: 'settings',
      key: _keySettingsIcon,
      description: 'Tap here to adjust your preferences and profile.',
    ); // ✅

    _tourController.addStep(
      id: 'mob',
      key: _keyMOBButton,
      description: 'In case of emergency, tap here to trigger the MOB alert.',
    ); // ✅

    _tourController.addStep(
      id: 'bnbLessons',
      key: _tourController.getKeyForStep('bnbLessons'),
      description: 'Tap here to explore safety lessons and core skills.',
    ); // ✅
    _tourController.addStep(
      id: 'bnbParts',
      key: _tourController.getKeyForStep('bnbParts'),
      description: 'Learn about the different parts of your boat.',
    ); // ✅
    _tourController.addStep(
      id: 'bnbTools',
      key: _tourController.getKeyForStep('bnbTools'),
      description: 'Find tools to help in common onboard situations.',
    ); // ✅
    _tourController.addStep(
      id: 'bnbFlashcards',
      key: _tourController.getKeyForStep('bnbFlashcards'),
      description: 'Drill important terms and concepts with flashcards.',
    ); // ✅

    return TourOverlayManager(
      highlightKey: _tourController.currentKey, // ✅
      onNext: _tourController.nextStep, // ✅
      onEnd: _tourController.endTour, // ✅
      child: Column(
        // ✅
        children: [
          CustomAppBarWidget(
            title: 'Welcome!',
            mobKey: _keyMOBButton,
            settingsKey: _keySettingsIcon,
            searchKey: _keySearchIcon,
            titleKey: _keyAppBarTitle,
            showBackButton: false,
            showSearchIcon: true,
            showSettingsIcon: true,
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.only(
                top: 24,
                left: AppTheme.screenPadding,
                right: AppTheme.screenPadding,
                bottom: 80,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // (Tour button, welcome message, etc. remain unchanged)

                  // 🚀 App Tour
                  Center(
                    child: ElevatedButton(
                      onPressed: () {
                        logger.i('🚩 Tour Start button tapped');
                        _tourController
                            .reset(); // ✅ This alone will trigger rebuild via notifyListeners()
                      },
                      style: AppTheme.whiteTextButton,
                      child: const Text('App Tour'),
                    ),
                  ),
                  const SizedBox(height: 10),

                  // 📘 Welcome Message
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      "Welcome Aboard! Tap below to learn how to be safe, helpful, and enjoy your boating!",
                      style: AppTheme.subheadingStyle.copyWith(
                        color: AppTheme.primaryBlue,
                        fontStyle: FontStyle.italic,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 20),

                  // 🧭 New Crewmembers Button
                  ElevatedButton(
                    key: _tourController.getKeyForStep('newCrew'), // ✅

                    onPressed: () {
                      logger.i('📘 Navigating to Competent Crew Path');
                      context.go(
                        '/learning-paths/competent-crew',
                        extra: {
                          'slideFrom': SlideDirection.right,
                          'transitionType': TransitionType.slide,
                          'detailRoute': DetailRoute.path,
                          'mobKey': mobKey,
                          'settingsKey': settingsKey,
                          'searchKey': searchKey,
                          'titleKey': titleKey,
                        },
                      );
                    },
                    style: AppTheme.landingPrimaryButton,
                    child: const Text('New Crewmembers'),
                  ),

                  const SizedBox(height: 36),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      "More experienced and returning sailors might find some useful guided lessons in one of these advanced paths",
                      style: AppTheme.subheadingStyle.copyWith(
                        color: AppTheme.primaryBlue,
                        fontStyle: FontStyle.italic,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // 🎯 Advanced Refresher Dropdown
                  Center(
                    child: PopupMenuButton<String>(
                      onSelected: (value) {
                        logger.i('📘 Navigating to $value');
                        context.go(
                          '/learning-paths/$value',
                          extra: {
                            'slideFrom': SlideDirection.right,
                            'transitionType': TransitionType.slide,
                            'detailRoute': DetailRoute.path,
                            'mobKey': mobKey,
                            'settingsKey': settingsKey,
                            'searchKey': searchKey,
                            'titleKey': titleKey,
                          },
                        );
                      },
                      itemBuilder:
                          (context) => const [
                            PopupMenuItem(
                              value: 'knock-the-rust-off',
                              child: Text('Knock the Rust Off'),
                            ),
                            PopupMenuItem(
                              value: 'docking',
                              child: Text('Docking'),
                            ),
                            PopupMenuItem(
                              value: 'transition-demo',
                              child: Text('Anchoring'),
                            ),
                          ],
                      child: Container(
                        constraints: const BoxConstraints(minWidth: 280),
                        padding: const EdgeInsets.symmetric(
                          vertical: 18,
                          horizontal: 32,
                        ),
                        decoration: BoxDecoration(
                          color: AppTheme.primaryRed,
                          borderRadius: BorderRadius.circular(
                            AppTheme.buttonCornerRadius,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: const [
                            Text(
                              'Advanced Refreshers',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(width: 8),
                            Icon(Icons.arrow_drop_down, color: Colors.white),
                          ],
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 36),

                  // 📍 Footer Hint
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      'Use the icons below to navigate to Self-Guided expeditions: Sailing Courses, Boat Parts, Guidance Tools, and Flashcard Drills.',
                      style: AppTheme.subheadingStyle.copyWith(
                        color: AppTheme.primaryBlue,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    ); // ✅
  }
}
