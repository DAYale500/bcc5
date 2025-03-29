import 'package:flutter/material.dart';
import 'package:bcc5/theme/app_theme.dart';

class CustomAppBarWidget extends StatelessWidget
    implements PreferredSizeWidget {
  final String title;
  final bool showBackButton;
  final bool showSearchIcon;
  final bool showSettingsIcon;

  const CustomAppBarWidget({
    super.key,
    required this.title,
    this.showBackButton = false,
    this.showSearchIcon = true,
    this.showSettingsIcon = true,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading:
          showBackButton
              ? IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => Navigator.of(context).pop(),
              )
              : null,
      centerTitle: true,
      title: Text(title, style: AppTheme.headingStyle),
      backgroundColor: AppTheme.primaryBlue,
      elevation: 0,
      actions: [
        if (showSearchIcon)
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              // TO-DO: Navigate to search screen
            },
          ),
        if (showSettingsIcon)
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              // TO-DO: Navigate to settings screen
            },
          ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
