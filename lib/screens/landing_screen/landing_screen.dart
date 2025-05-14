import 'package:bcc5/navigation/detail_route.dart';
import 'package:bcc5/theme/slide_direction.dart';
import 'package:bcc5/theme/transition_type.dart';
import 'package:bcc5/widgets/dialogs/emergency_reminder_dialog.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:bcc5/widgets/custom_app_bar_widget.dart';
import 'package:bcc5/theme/app_theme.dart';
import 'package:bcc5/utils/logger.dart';
import 'package:bcc5/widgets/tour/landing_screen_tour.dart';

class LandingScreen extends StatefulWidget {
  final bool showReminder;
  final GlobalKey mobKey;
  final GlobalKey settingsKey;
  final GlobalKey searchKey;
  final GlobalKey titleKey;
  final GlobalKey harborKey;
  final GlobalKey coursesKey;
  final GlobalKey partsKey;
  final GlobalKey toolsKey;
  final GlobalKey drillsKey;
  final GlobalKey newCrewKey;
  final GlobalKey advancedRefreshersKey;
  final bool startTour;

  const LandingScreen({
    super.key,
    required this.showReminder,
    required this.harborKey,
    required this.coursesKey,
    required this.partsKey,
    required this.toolsKey,
    required this.drillsKey,
    required this.mobKey,
    required this.settingsKey,
    required this.searchKey,
    required this.titleKey,
    required this.newCrewKey,
    required this.advancedRefreshersKey,
    required this.startTour,
  });

  static LandingScreenState? _state;

  static LandingScreenState? getState() => _state;

  @override
  State<LandingScreen> createState() => LandingScreenState();
}

class LandingScreenState extends State<LandingScreen> {
  final GlobalKey _keyAppBarTitle = GlobalKey();
  final GlobalKey _keyMOBButton = GlobalKey();
  final GlobalKey _keySettingsIcon = GlobalKey();
  final GlobalKey _keySearchIcon = GlobalKey();
  // 👇 PUBLIC GETTERS (for access in settingsModal)
  GlobalKey get mobKey => _keyMOBButton;
  GlobalKey get settingsKey => _keySettingsIcon;
  GlobalKey get titleKey => _keyAppBarTitle;
  GlobalKey get searchKey => _keySearchIcon;

  @override
  void initState() {
    super.initState();
    LandingScreen._state = this;

    logger.i('🧭 LandingScreenState.initState() called');
    logger.i('🧭 showReminder = ${widget.showReminder}');

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (widget.startTour || await LandingScreenTour.shouldStart()) {
        if (!mounted) return;
        LandingScreenTour.start(
          state: this,
          mobKey: _keyMOBButton,
          settingsKey: _keySettingsIcon,
          titleKey: _keyAppBarTitle,
          searchKey: _keySearchIcon,
          harborKey: widget.harborKey,
          coursesKey: widget.coursesKey,
          partsKey: widget.partsKey,
          toolsKey: widget.toolsKey,
          drillsKey: widget.drillsKey,
          newCrewKey: widget.newCrewKey,
          advancedRefreshersKey: widget.advancedRefreshersKey,
        );
      }
    });

    if (widget.showReminder) {
      logger.i('🧭 Scheduling 2s delayed dialog...');

      WidgetsBinding.instance.addPostFrameCallback((_) {
        Future.delayed(const Duration(seconds: 2), () {
          if (mounted) {
            logger.i('🧭 Triggering showEmergencyReminderDialog()');
            showEmergencyReminderDialog(context);
          } else {
            logger.w('⚠️ Not mounted when dialog should show');
          }
        });
      });
    }

    // if (widget.showReminder) {
    //   WidgetsBinding.instance.addPostFrameCallback((_) {
    //     showDialog(
    //       context: context,
    //       builder:
    //           (_) => AlertDialog(
    //             title: const Text('Update Vessel Info'),
    //             content: const Text(
    //               'Review your vessel info to ensure emergency details are up to date.',
    //             ),
    //             actions: [
    //               TextButton(
    //                 onPressed: () => Navigator.pop(context),
    //                 child: const Text("Info is accurate"),
    //               ),
    //               TextButton(
    //                 onPressed: () {
    //                   Navigator.pop(context);
    //                   final routeName =
    //                       GoRouter.of(
    //                         context,
    //                       ).routeInformationProvider.value.uri.path;
    //                   showSettingsModal(context, routeName);
    //                 },
    //                 child: const Text("Update Now"),
    //               ),
    //             ],
    //           ),
    //     );
    //   });
    // }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
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
                KeyedSubtree(
                  key: widget.newCrewKey,
                  child: ElevatedButton(
                    onPressed: () {
                      logger.i('📘 Navigating to Competent Crew Path');
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
                  child: KeyedSubtree(
                    key: widget.advancedRefreshersKey,
                    child: PopupMenuButton<String>(
                      onSelected: (value) {
                        logger.i('📘 Navigating to $value');
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
                            Icon(Icons.arrow_drop_down, color: Colors.white),
                          ],
                        ),
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
    );
  }
}
