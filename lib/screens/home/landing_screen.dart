import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:bcc5/widgets/custom_app_bar_widget.dart';
import 'package:bcc5/theme/app_theme.dart';
import 'package:bcc5/utils/logger.dart';

class LandingScreen extends StatelessWidget {
  const LandingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const CustomAppBarWidget(
          title: 'Welcome Aboard',
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
                    'Sailing Routes',
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
                  AppTheme.highlightedGroupButtonStyle,
                  () {
                    logger.i('📘 Navigating to Competent Crew Path');
                    context.go('/learning-paths/competent-crew');
                  },
                ),
                const SizedBox(height: 28),
                // 📘 Competent Crew Intro Text
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    "Knock the rust off these topics if your sea-legs are gone.",
                    style: AppTheme.subheadingStyle.copyWith(
                      color: AppTheme.primaryBlue,
                      fontStyle: FontStyle.italic,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),

                const SizedBox(height: 16),
                _buildPathButton(
                  context,
                  'Knock the Rust Off',
                  _groupButtonStyle(),
                  () {
                    logger.i('📘 Navigating to Knock the Rust Off Path');
                    context.go('/learning-paths/knock-the-rust-off');
                  },
                ),
                const SizedBox(height: 16),
                _buildPathButton(context, 'Docking', _groupButtonStyle(), () {
                  logger.i('📘 Navigating to Docking Path');
                  context.go('/learning-paths/docking');
                }),
                const SizedBox(height: 16),
                _buildPathButton(context, 'Anchoring', _groupButtonStyle(), () {
                  logger.i('📘 Navigating to Anchoring Path');
                  context.go('/learning-paths/anchoring');
                }),

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
      backgroundColor: AppTheme.groupButtonSelected,
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 24),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppTheme.buttonCornerRadius),
      ),
    );
  }
}
