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

  final GlobalKey mobKey;
  final GlobalKey settingsKey;
  final GlobalKey searchKey;
  final GlobalKey titleKey;

  CustomAppBarWidget({
    super.key,
    required this.title,
    this.showBackButton = false,
    this.showSearchIcon = true,
    this.showSettingsIcon = true,
    this.onBack,
    this.onSearchTap,
    this.onSettingsTap,
    GlobalKey? mobKey,
    GlobalKey? settingsKey,
    GlobalKey? searchKey,
    GlobalKey? titleKey,
  }) : mobKey = mobKey ?? GlobalKey(debugLabel: 'MOBKey'),
       settingsKey = settingsKey ?? GlobalKey(debugLabel: 'SettingsKey'),
       searchKey = searchKey ?? GlobalKey(debugLabel: 'SearchKey'),
       titleKey = titleKey ?? GlobalKey(debugLabel: 'TitleKey');

  /// MOB Icon opens a modal via `showDialog(...)`.
  /// ⚠️ Do not replace with `Navigator.push(...)`
  /// unless you explicitly track and restore navigation state.
  ///
  /// The current design allows users to:
  /// - Tap the MOB icon
  /// - Navigate deeper (e.g. to procedures screen)
  /// - Tap back → returns to MOB modal
  /// - Close modal → returns to originating screen
  ///
  /// If you change this behavior, test for:
  /// 🔁 Stack restoration
  /// 🔙 Correct screen on modal close

  @override
  Widget build(BuildContext context) {
    // logger.d(
    //   '[AppBar] title: "$title" | back: $showBackButton | search: $showSearchIcon | settings: $showSettingsIcon',
    // );

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
