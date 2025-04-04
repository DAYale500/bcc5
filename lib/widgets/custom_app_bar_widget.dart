import 'package:flutter/material.dart';
import 'package:bcc5/theme/app_theme.dart';
import 'package:go_router/go_router.dart';

class CustomAppBarWidget extends StatelessWidget
    implements PreferredSizeWidget {
  final String title;
  final bool showBackButton;
  final bool showSearchIcon;
  final bool showSettingsIcon;
  final VoidCallback? onBack;

  const CustomAppBarWidget({
    super.key,
    required this.title,
    this.showBackButton = false,
    this.showSearchIcon = true,
    this.showSettingsIcon = true,
    this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppTheme.primaryBlue,
      centerTitle: true,
      elevation: 0,
      leading:
          showBackButton
              ? IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed:
                    onBack ??
                    () {
                      if (Navigator.of(context).canPop()) {
                        Navigator.of(context).pop();
                      } else {
                        context.go('/');
                      }
                    },
              )
              : const SizedBox(
                width: kToolbarHeight, // 🟢 Reserve space to center title
              ),
      title: Text(title, style: AppTheme.headingStyle),
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
