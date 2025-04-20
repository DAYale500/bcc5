import 'package:bcc5/data/models/render_item.dart';
import 'package:bcc5/data/repositories/tools/tool_repository_index.dart';
import 'package:bcc5/screens/emergency/mob_emergency_screen.dart';
import 'package:bcc5/theme/slide_direction.dart';
import 'package:bcc5/theme/transition_type.dart';
import 'package:bcc5/utils/string_extensions.dart';
import 'package:bcc5/utils/transition_manager.dart';
import 'package:flutter/material.dart';
import 'package:bcc5/widgets/custom_app_bar_widget.dart';
import 'package:bcc5/widgets/item_button.dart';
import 'package:bcc5/utils/logger.dart';
import 'package:bcc5/utils/render_item_helpers.dart';
import 'package:bcc5/theme/app_theme.dart';
import 'package:bcc5/navigation/detail_route.dart';

class ToolItemScreen extends StatelessWidget {
  final String toolbag;
  final bool cameFromMob;

  const ToolItemScreen({
    super.key,
    required this.toolbag,
    required this.mobKey,
    required this.settingsKey,
    required this.searchKey,
    required this.titleKey,
    this.cameFromMob = false,
  });

  final GlobalKey mobKey;
  final GlobalKey settingsKey;
  final GlobalKey searchKey;
  final GlobalKey titleKey;

  @override
  Widget build(BuildContext context) {
    logger.i('🛠️ ToolItemScreen loaded for toolbag: $toolbag');

    final content = _buildContent(context);

    return PopScope(
      canPop: true,
      onPopInvokedWithResult: (bool didPop, Object? result) {
        if (didPop) return;

        if (cameFromMob) {
          logger.i('🔙 System back → MOBEmergencyScreen');
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              fullscreenDialog: true,
              builder: (_) => const MOBEmergencyScreen(),
            ),
          );
        } else {
          logger.w('⚠️ Back ignored — nothing to pop and no override');
        }
      },
      child: content,
    );
  }

  Widget _buildContent(BuildContext context) {
    final tools = ToolRepositoryIndex.getToolsForBag(toolbag);
    final toolIds = tools.map((t) => t.id).toList();
    final renderItems = buildRenderItems(ids: toolIds);
    final toolbagTitle = toolbag.toTitleCase();

    return Column(
      children: [
        CustomAppBarWidget(
          title: 'Tools',
          showBackButton: true,
          showSearchIcon: true,
          showSettingsIcon: true,
          mobKey: mobKey,
          settingsKey: settingsKey,
          searchKey: searchKey,
          titleKey: titleKey,
          onBack: () {
            if (cameFromMob) {
              logger.i('🔙 Back to MOBEmergencyScreen (cameFromMob = true)');
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  fullscreenDialog: true,
                  builder: (_) => const MOBEmergencyScreen(),
                ),
              );
            } else if (Navigator.of(context).canPop()) {
              // ✅ Check before popping
              logger.i('🔙 Back to previous screen via Navigator');
              Navigator.of(context).pop();
            } else {
              logger.w('⚠️ Back tap ignored — nothing to pop!');
            }
          },
        ),
        const SizedBox(height: 16),
        Text(
          '$toolbagTitle:\nWhich ${toolbagTitle.replaceFirst(RegExp(r's\$'), '')} would you like?',
          style: AppTheme.subheadingStyle.copyWith(color: AppTheme.primaryBlue),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 16),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: GridView.builder(
              itemCount: tools.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 4,
                mainAxisSpacing: 4,
                childAspectRatio: 2.8,
              ),
              itemBuilder: (context, index) {
                final tool = tools[index];

                return ItemButton(
                  label: tool.title,
                  onTap: () {
                    logger.i('🛠️ Tapped tool: ${tool.id}');
                    TransitionManager.goToDetailScreen(
                      context: context,
                      screenType: RenderItemType.tool,
                      renderItems: renderItems,
                      currentIndex: index,
                      branchIndex: 3,
                      backDestination: '/tools/items',
                      backExtra: {
                        'toolbag': toolbag,
                        'cameFromMob': cameFromMob,
                      },
                      detailRoute: DetailRoute.branch,
                      direction: SlideDirection.right,
                      transitionType: TransitionType.slide,
                      mobKey: GlobalKey(debugLabel: 'MOBKey'),
                      settingsKey: GlobalKey(debugLabel: 'SettingsKey'),
                      searchKey: GlobalKey(debugLabel: 'SearchKey'),
                      titleKey: GlobalKey(debugLabel: 'TitleKey'),
                      replace: false, // 🛠️ Critical: preserve the stack
                    );
                  },
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}
