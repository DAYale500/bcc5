import 'package:bcc5/navigation/detail_route.dart';
import 'package:bcc5/theme/app_theme.dart';
import 'package:bcc5/theme/slide_direction.dart';
import 'package:bcc5/theme/transition_type.dart';
import 'package:bcc5/utils/logger.dart';
import 'package:bcc5/utils/resume_manager.dart';
import 'package:bcc5/widgets/custom_app_bar_widget.dart';
import 'package:bcc5/widgets/settings_modal.dart';
import 'package:bcc5/widgets/tour/tour_controller.dart';
import 'package:bcc5/widgets/tour/tour_overlay_manager.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

  static LandingScreenState? _state;

  static LandingScreenState? getStateIfMounted() {
    final state = _state;
    return (state != null && state.mounted) ? state : null;
  }

  static void markAutoRunTriggered() {
    getStateIfMounted()?._markAutoRunTriggered();
  }

  static void restartTourFromSettingsGlobal() {
    getStateIfMounted()?.restartTourFromSettings();
  }

  @override
  State<LandingScreen> createState() => LandingScreenState();
}

class LandingScreenState extends State<LandingScreen> {
  final TourController _tourController = TourController();
  bool _autoRunTriggered = false;

  void _markAutoRunTriggered() {
    _autoRunTriggered = true;
  }

  void restartTourFromSettings() {
    logger.i('🎯 Restarting Tour from Settings');
    _tourController.reset();
  }

  @override
  void initState() {
    super.initState();
    LandingScreen._state = this;

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final prefs = await SharedPreferences.getInstance();
      final hasSeenTour = prefs.getBool('hasSeenTour') ?? false;

      if (!hasSeenTour) {
        logger.i('⛳ Auto-starting tour (first app launch)');
        _autoRunTriggered = true;
        _tourController.reset();
        await prefs.setBool('hasSeenTour', true);
      }
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (ResumeManager.shouldRestartTour) {
      logger.i('🏁 Detected shouldRestartTour — restarting tour now!');

      if (!_autoRunTriggered) {
        logger.i('🔄 Restarting because autoRun not yet triggered');
        WidgetsBinding.instance.addPostFrameCallback((_) {
          restartTourFromSettings();
        });
      } else {
        logger.i('⏭️ Skipping restart — autoRun already triggered');
      }

      ResumeManager.shouldRestartTour = false;
    }
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
      description:
          'Explore advanced refresher lessons for experienced sailors.',
    );

    return AnimatedBuilder(
      animation: _tourController,
      builder: (context, _) {
        return TourOverlayManager(
          highlightKey: _tourController.currentKey,
          description: _tourController.currentDescription,
          onNext: _tourController.nextStep,
          onEnd: _tourController.endTour,
          onReset: _tourController.reset,
          currentStepId: _tourController.currentStepId,
          isLastStep: _tourController.isLastStep,
          child: Column(
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
                      const SizedBox(height: 46),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Text(
                          "More experienced and returning sailors might find some useful guided lessons in one of these advanced paths",
                          style: AppTheme.subheadingStyle.copyWith(
                            color: AppTheme.primaryBlue,
                            fontStyle: FontStyle.italic,
                            fontWeight: FontWeight.w600,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Center(
                        child: PopupMenuButton<String>(
                          key: _tourController.getKeyForStep(
                            'advancedRefreshers',
                          ),
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
