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
import 'package:go_router/go_router.dart';

class ToolItemScreen extends StatefulWidget {
  final String toolbag;
  final bool cameFromMob;

  const ToolItemScreen({
    super.key,
    required this.toolbag,
    this.cameFromMob = false,
  });

  @override
  State<ToolItemScreen> createState() => _ToolItemScreenState();
}

class _ToolItemScreenState extends State<ToolItemScreen> {
  final GlobalKey mobKey = GlobalKey(debugLabel: 'MOBKey');
  final GlobalKey settingsKey = GlobalKey(debugLabel: 'SettingsKey');
  final GlobalKey searchKey = GlobalKey(debugLabel: 'SearchKey');
  final GlobalKey titleKey = GlobalKey(debugLabel: 'TitleKey');

  @override
  Widget build(BuildContext context) {
    logger.i('🛠️ ToolItemScreen loaded for toolbag: ${widget.toolbag}');

    return PopScope(
      canPop: true,
      onPopInvokedWithResult: (didPop, _) {
        if (didPop) return;
        if (widget.cameFromMob) {
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
      child: _buildContent(context),
    );
  }

  Widget _buildContent(BuildContext context) {
    final tools = ToolRepositoryIndex.getToolsForBag(widget.toolbag);
    final toolIds = tools.map((t) => t.id).toList();
    final renderItems = buildRenderItems(ids: toolIds);
    final toolbagTitle = widget.toolbag.toTitleCase();

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
            if (widget.cameFromMob) {
              logger.i('🔙 Back to MOBEmergencyScreen (cameFromMob = true)');
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  fullscreenDialog: true,
                  builder: (_) => const MOBEmergencyScreen(),
                ),
              );
            } else if (Navigator.of(context).canPop()) {
              logger.i('🔙 Back to previous screen via Navigator');
              Navigator.of(context).pop();
            } else {
              logger.i('🔙 Back to ToolBagScreen (fallback)');
              context.go(
                '/tools',
                extra: {
                  'transitionKey': UniqueKey().toString(),
                  'slideFrom': SlideDirection.left,
                  'transitionType': TransitionType.slide,
                  'detailRoute': DetailRoute.branch,
                },
              );
            }
          },
        ),
        const SizedBox(height: 16),
        Text(
          '$toolbagTitle:\nWhich ${toolbagTitle.replaceFirst(RegExp(r's$'), '')} would you like?',
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
                        'toolbag': widget.toolbag,
                        'cameFromMob': widget.cameFromMob,
                        'fromNext': true, // 👈 explicit
                      },
                      detailRoute: DetailRoute.branch,
                      direction: SlideDirection.right,
                      transitionType: TransitionType.slide,
                      replace: false,
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
