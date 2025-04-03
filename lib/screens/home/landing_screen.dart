// lib/screens/home/landing_screen.dart
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
        const SizedBox(height: 16),
        Text(
          'Choose a Voyage',
          style: AppTheme.subheadingStyle.copyWith(color: AppTheme.primaryBlue),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 16),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(AppTheme.screenPadding),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // _buildPathButton(context, 'Tour', () {
                //   logger.i('🚀 Tour started (placeholder)');
                // }),
                // const SizedBox(height: 24),
                _buildPathButton(context, 'Competent Crew', () {
                  logger.i('📘 Navigating to Competent Crew Path');
                  context.go('/learning-paths/competent-crew');
                }),
                const SizedBox(height: 24),
                _buildPathButton(context, 'Knock the Rust Off', () {
                  logger.i('📘 Navigating to Knock the Rust Off Path');
                  context.go('/learning-paths/knock-the-rust-off');
                }),
                const SizedBox(height: 24),
                _buildPathButton(context, 'Anchoring', () {
                  logger.i('📘 Navigating to Anchoring Path');
                  context.go('/learning-paths/anchoring');
                }),
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
    VoidCallback onTap,
  ) {
    return ElevatedButton(
      onPressed: onTap,
      style: ElevatedButton.styleFrom(
        backgroundColor: AppTheme.primaryRed,
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 32),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppTheme.buttonCornerRadius),
        ),
      ),
      child: Text(label, style: AppTheme.buttonTextStyle),
    );
  }
}
