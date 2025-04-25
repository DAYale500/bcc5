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
import 'package:shared_preferences/shared_preferences.dart';

// Imports remain unchanged...

class LandingScreen extends StatefulWidget {
  final bool showReminder;
  final GlobalKey harborKey;
  final GlobalKey mobKey;
  final GlobalKey settingsKey;
  final GlobalKey searchKey;
  final GlobalKey titleKey;
  final GlobalKey bnbLessonsKey;
  final GlobalKey bnbPartsKey;
  final GlobalKey bnbToolsKey;
  final GlobalKey bnbFlashcardsKey;

  const LandingScreen({
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
  });

  @override
  State<LandingScreen> createState() => _LandingScreenState();
}

class _LandingScreenState extends State<LandingScreen> {
  final TourController _tourController = TourController();
  final GlobalKey _keyAppTourButton = GlobalKey(debugLabel: 'AppTourButton');

  bool _autoRunTriggered = false;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final prefs = await SharedPreferences.getInstance();
      final hasSeenTour = prefs.getBool('hasSeenTour') ?? false;

      if (!mounted) return; // ✅ added mounted check for async safety

      if (!hasSeenTour && !_autoRunTriggered) {
        _autoRunTriggered = true;
        logger.i('⛳ Auto-starting tour (first app launch)');
        Future.delayed(const Duration(milliseconds: 600), () {
          if (!mounted) return; // ✅ also double check here
          _tourController.reset();
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    logger.i('📘 [LandingScreen] build() triggered');

    if (widget.showReminder) {
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

    // _tourController.steps.clear();
    // _tourController.steps.addAll([
    //   _keyAppTourButton,
    //   widget.mobKey,
    //   widget.settingsKey,
    //   widget.searchKey,
    //   widget.bnbLessonsKey,
    //   widget.bnbPartsKey,
    //   widget.bnbToolsKey,
    //   widget.bnbFlashcardsKey,
    // ]);
    _tourController.addStep(
      id: 'appTour',
      key: _keyAppTourButton,
      description:
          'Tap here to chart a quick course through the app. You can pause, resume, or drop anchor anytime.',
    );

    _tourController.addStep(
      id: 'mob',
      key: widget.mobKey,
      description:
          'Tap here in case of a Man Overboard emergency. This is the most urgent action in the app.',
    );

    _tourController.addStep(
      id: 'settings',
      key: widget.settingsKey,
      description:
          'Tap here to access your profile and customize your app preferences.',
    );

    _tourController.addStep(
      id: 'search',
      key: widget.searchKey,
      description:
          'Use the search icon to quickly find any lesson, tool, or flashcard.',
    );
    _tourController.addStep(
      id: 'newCrew',
      key: _tourController.getKeyForStep('newCrew'),
      description: 'Start your training here as a new crewmember.',
    );

    _tourController.addStep(
      id: 'advancedRefreshers',
      key: _tourController.getKeyForStep('advancedRefreshers'),
      description: 'Browse advanced paths for docking, anchoring, and more.',
    );

    _tourController.addStep(
      id: 'bnbLessons',
      key: widget.bnbLessonsKey,
      description: 'Tap here to explore safety lessons and core skills.',
    );

    _tourController.addStep(
      id: 'bnbParts',
      key: widget.bnbPartsKey,
      description: 'Tap here to explore the boat’s Parts and their function.',
    );

    _tourController.addStep(
      id: 'bnbTools',
      key: widget.bnbToolsKey,
      description: 'Find practical Tools for real-world problems on board.',
    );

    _tourController.addStep(
      id: 'bnbFlashcards',
      key: widget.bnbFlashcardsKey,
      description: 'Drill essential concepts and vocabulary with flashcards.',
    );

    return AnimatedBuilder(
      animation: _tourController,
      builder: (context, _) {
        return TourOverlayManager(
          highlightKey: _tourController.currentKey,
          description: _tourController.currentDescription,
          currentStepId: _tourController.currentStepId, // ✅ Add this

          onNext: _tourController.nextStep,
          onEnd: _tourController.endTour,
          onReset: _tourController.reset,
          child: Column(
            // return TourOverlayManager(
            //   highlightKey: _tourController.currentKey,
            //   onNext: _tourController.nextStep,
            //   onEnd: _tourController.endTour,
            //   child: Column(
            children: [
              CustomAppBarWidget(
                title: 'Welcome!',
                mobKey: widget.mobKey,
                settingsKey: widget.settingsKey,
                searchKey: widget.searchKey,
                titleKey: widget.titleKey,
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
                      Center(
                        child: ElevatedButton(
                          key: _keyAppTourButton,
                          onPressed: () {
                            logger.i('🚩 Tour Start button tapped');
                            Future.delayed(
                              const Duration(milliseconds: 300),
                              () {
                                _tourController.reset();
                              },
                            );
                          },
                          style: AppTheme.whiteTextButton,
                          child: const Text('App Tour'),
                        ),
                      ),
                      const SizedBox(height: 10),
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
                      ElevatedButton(
                        key: _tourController.getKeyForStep('newCrew'),
                        onPressed: () {
                          context.go(
                            '/learning-paths/competent-crew',
                            extra: {
                              'slideFrom': SlideDirection.right,
                              'transitionType': TransitionType.slide,
                              'detailRoute': DetailRoute.path,
                              'mobKey': widget.mobKey,
                              'settingsKey': widget.settingsKey,
                              'searchKey': widget.searchKey,
                              'titleKey': widget.titleKey,
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
                      Center(
                        child: PopupMenuButton<String>(
                          key: _tourController.getKeyForStep(
                            'advancedRefreshers',
                          ), // ✅ Added this line

                          onSelected: (value) {
                            context.go(
                              '/learning-paths/$value',
                              extra: {
                                'slideFrom': SlideDirection.right,
                                'transitionType': TransitionType.slide,
                                'detailRoute': DetailRoute.path,
                                'mobKey': widget.mobKey,
                                'settingsKey': widget.settingsKey,
                                'searchKey': widget.searchKey,
                                'titleKey': widget.titleKey,
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
                                Icon(
                                  Icons.arrow_drop_down,
                                  color: Colors.white,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 36),
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
        );
      },
    );
  }
}
