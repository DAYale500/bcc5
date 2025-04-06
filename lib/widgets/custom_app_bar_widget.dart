import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:bcc5/theme/app_theme.dart';
import 'package:bcc5/widgets/search_modal.dart'; // 🔍 Search Modal
import 'package:bcc5/widgets/settings_modal.dart'; // ⚙️ Settings Modal

class CustomAppBarWidget extends StatelessWidget
    implements PreferredSizeWidget {
  final String title;
  final bool showBackButton;
  final bool showSearchIcon;
  final bool showSettingsIcon;
  final VoidCallback? onBack;
  final VoidCallback? onSearchTap;
  final VoidCallback? onSettingsTap;

  const CustomAppBarWidget({
    super.key,
    required this.title,
    this.showBackButton = false,
    this.showSearchIcon = true,
    this.showSettingsIcon = true,
    this.onBack,
    this.onSearchTap,
    this.onSettingsTap,
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
              : const SizedBox(width: kToolbarHeight),
      title: Text(title, style: AppTheme.headingStyle),
      actions: [
        if (showSearchIcon)
          IconButton(
            icon: const Icon(Icons.search),
            onPressed:
                onSearchTap ??
                () {
                  showDialog(
                    context: context,
                    builder: (_) => const SearchModal(),
                  );
                },
          ),
        if (showSettingsIcon)
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed:
                onSettingsTap ??
                () {
                  showSettingsModal(context);
                },
          ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
