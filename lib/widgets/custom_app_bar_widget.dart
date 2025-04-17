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
    logger.i('🔍 CustomAppBarWidget.build()');
    logger.i('  ├─ title: "$title"');
    logger.i('  ├─ showBackButton: $showBackButton');
    logger.i('  ├─ showSearchIcon: $showSearchIcon');
    logger.i('  ├─ showSettingsIcon: $showSettingsIcon');
    logger.i('  ├─ mobKey: ${mobKey.toString()}');
    logger.i('  ├─ searchKey: ${searchKey.toString()}');
    logger.i('  ├─ settingsKey: ${settingsKey.toString()}');
    logger.i('  └─ titleKey: ${titleKey.toString()}');

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
            Builder(
              builder:
                  (innerContext) => IconButton(
                    key: searchKey,
                    icon: const Icon(Icons.search),
                    onPressed:
                        onSearchTap ??
                        () {
                          showDialog(
                            context: innerContext,
                            builder: (_) => const SearchModal(),
                          );
                        },
                  ),
            ),

          if (showSettingsIcon)
            Builder(
              builder:
                  (innerContext) => IconButton(
                    key: settingsKey,
                    icon: const Icon(Icons.settings),
                    onPressed:
                        onSettingsTap ??
                        () {
                          showSettingsModal(innerContext);
                        },
                  ),
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
          Builder(
            builder:
                (innerContext) => IconButton(
                  key: mobKey,
                  icon: Icon(MdiIcons.lifebuoy, size: 40, color: Colors.red),
                  tooltip: 'Man Overboard',
                  onPressed: () {
                    logger.i('🆘 MOB button tapped');
                    showMOBModal(innerContext);
                  },
                ),
          ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
