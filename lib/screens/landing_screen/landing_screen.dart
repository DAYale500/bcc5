import 'package:bcc5/navigation/detail_route.dart';
import 'package:bcc5/theme/slide_direction.dart';
import 'package:bcc5/theme/transition_type.dart';
import 'package:bcc5/widgets/settings_modal.dart';
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

  // 🚩 GlobalKeys for onboarding tour steps
  final GlobalKey _keyAppBarTitle = GlobalKey();
  final GlobalKey _keyMOBButton = GlobalKey();
  final GlobalKey _keySettingsIcon = GlobalKey();
  final GlobalKey _keySearchIcon = GlobalKey();

  LandingScreen({
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
    return Column(
      children: [
        CustomAppBarWidget(
          title: 'Welcome Aboard',
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
            padding: const EdgeInsets.symmetric(
              vertical: 24,
              horizontal: AppTheme.screenPadding,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // 📝 General Intro Text
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    "Let's make this the Tour button?",
                    style: AppTheme.subheadingStyle.copyWith(
                      color: AppTheme.primaryBlue,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 20),

                // 📘 Competent Crew Intro Text
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    "Competent Crew: New crew start here to learn how to be safe, helpful, and enjoy.",
                    style: AppTheme.subheadingStyle.copyWith(
                      color: AppTheme.primaryBlue,
                      fontStyle: FontStyle.italic,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 28),

                // 🚀 Path Buttons
                _buildPathButton(
                  context,
                  'Competent Crew',
                  _groupButtonStyle(), // 🔴 match the picker button style
                  () {
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
                ),

                const SizedBox(height: 28),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    "Sea-legs shaky? Knock the rust off with these!",
                    style: AppTheme.subheadingStyle.copyWith(
                      color: AppTheme.primaryBlue,
                      fontStyle: FontStyle.italic,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 16),

                // 🧭 Knock the Rust Off Picker
                // Knock the Rust Off Picker
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Text(
                      //   'Knock the Rust Off Paths',
                      //   style: AppTheme.subheadingStyle.copyWith(
                      //     color: AppTheme.primaryBlue,
                      //   ),
                      //   textAlign: TextAlign.center,
                      // ),
                      const SizedBox(height: 8),
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
                              (context) => [
                                const PopupMenuItem(
                                  value: 'knock-the-rust-off',
                                  child: Text('Knock the Rust Off'),
                                ),
                                const PopupMenuItem(
                                  value: 'docking',
                                  child: Text('Docking'),
                                ),
                                const PopupMenuItem(
                                  value: 'transition-demo',
                                  child: Text('Anchoring'),
                                ),
                              ],
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              vertical: 14,
                              horizontal: 24,
                            ),
                            decoration: BoxDecoration(
                              color:
                                  AppTheme.primaryRed, // 🔴 Your desired color
                              borderRadius: BorderRadius.circular(
                                AppTheme.buttonCornerRadius,
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: const [
                                Text(
                                  'Knock the Rust Off',
                                  style: TextStyle(color: Colors.white),
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
                    ],
                  ),
                ),

                const SizedBox(height: 36),

                // 📍 BNB-related Hint
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    'Self-guided expeditions begin below.',
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

  Widget _buildPathButton(
    BuildContext context,
    String label,
    ButtonStyle style,
    VoidCallback onTap,
  ) {
    return ElevatedButton(
      onPressed: onTap,
      style: style,
      child: Text(label, style: AppTheme.buttonTextStyle),
    );
  }

  ButtonStyle _groupButtonStyle() {
    return ElevatedButton.styleFrom(
      backgroundColor:
          AppTheme.primaryRed, // 🔴 changed from groupButtonSelected
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 24),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppTheme.buttonCornerRadius),
      ),
    );
  }
}
