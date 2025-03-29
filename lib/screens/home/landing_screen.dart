import 'package:flutter/material.dart';
import 'package:bcc5/widgets/custom_app_bar_widget.dart';
import 'package:bcc5/theme/app_theme.dart';

class LandingScreen extends StatelessWidget {
  const LandingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: const [
        CustomAppBarWidget(
          title: 'Welcome Aboard',
          showBackButton: false,
          showSearchIcon: true,
          showSettingsIcon: true,
        ),
        Expanded(
          child: Center(
            child: Text(
              'Landing screen body here',
              style: AppTheme.bodyTextStyle,
            ),
          ),
        ),
      ],
    );
  }
}
