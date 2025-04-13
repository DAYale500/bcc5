import 'package:bcc5/utils/logger.dart';
import 'package:bcc5/widgets/mob_modal.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:bcc5/theme/app_theme.dart';
import 'package:bcc5/widgets/search_modal.dart'; // 🔍 Search Modal
import 'package:bcc5/widgets/settings_modal.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart'; // ⚙️ Settings Modal

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
    required this.mobKey,
    required this.settingsKey,
    required this.searchKey,
    required this.titleKey,
  });

  final GlobalKey mobKey;
  final GlobalKey settingsKey;
  final GlobalKey searchKey;
  final GlobalKey titleKey;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppTheme.primaryBlue,
      centerTitle: false,
      elevation: 0,
      automaticallyImplyLeading: false,
      title: Row(
        children: [
          // LEFT: Back, Search, Settings
          if (showBackButton)
            IconButton(
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
            ),
          if (showSearchIcon)
            IconButton(
              key: searchKey,
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
              key: settingsKey,
              icon: const Icon(Icons.settings),
              onPressed:
                  onSettingsTap ??
                  () {
                    showSettingsModal(context);
                  },
            ),

          // CENTER: Title
          Expanded(
            child: Text(
              title,
              key: titleKey,
              style: AppTheme.headingStyle,
              textAlign: TextAlign.center,
            ),
          ),

          // RIGHT: Life Ring (MOB)
          IconButton(
            key: mobKey,
            icon: Icon(
              MdiIcons.lifebuoy,
              size: 40, // Set to match previous image size
              color:
                  Colors
                      .red, // Optional: makes it bright red for emergency visibility
            ),
            tooltip: 'Man Overboard',
            onPressed: () {
              logger.i('🆘 MOB button tapped');
              showMOBModal(context);
            },
          ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
