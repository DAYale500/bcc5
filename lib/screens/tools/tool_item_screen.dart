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

  void _handleBack() {
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
  }

  @override
  Widget build(BuildContext context) {
    // logger.i('🛠️ ToolItemScreen loaded for toolbag: ${widget.toolbag}');

    return PopScope(
      canPop: !widget.cameFromMob,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop || widget.cameFromMob) {
          _handleBack(); // ⬅️ force fallback logic
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
          onBack: _handleBack,
        ),
        const SizedBox(height: 16),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Align(
            alignment: Alignment.centerLeft,
            child: RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: 'Tools',
                    style: AppTheme.branchBreadcrumbStyle,
                  ),
                  const TextSpan(
                    text: ' / ',
                    style: TextStyle(color: Colors.black87),
                  ),
                  TextSpan(
                    text: toolbagTitle,
                    style: AppTheme.groupBreadcrumbStyle,
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Which ${toolbagTitle.replaceFirst(RegExp(r's$'), '')} would you like?',
          style: AppTheme.subheadingStyle.copyWith(color: AppTheme.primaryBlue),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 16),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: ListView.builder(
              itemCount: tools.length,
              itemBuilder: (context, index) {
                final tool = tools[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                  child: ItemButton(
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
                          'fromNext': true,
                        },
                        detailRoute: DetailRoute.branch,
                        direction: SlideDirection.right,
                        transitionType: TransitionType.slide,
                        replace: false,
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}
