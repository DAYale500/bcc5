import 'package:bcc5/data/models/render_item.dart';
import 'package:bcc5/navigation/detail_route.dart';
import 'package:bcc5/theme/slide_direction.dart';
import 'package:bcc5/theme/transition_type.dart';
import 'package:bcc5/utils/render_item_helpers.dart';
import 'package:bcc5/utils/string_extensions.dart';
import 'package:bcc5/utils/transition_manager.dart';
import 'package:flutter/material.dart';
import 'package:bcc5/data/repositories/tools/tool_repository_index.dart';
import 'package:bcc5/widgets/custom_app_bar_widget.dart';
import 'package:bcc5/widgets/group_button.dart';
import 'package:bcc5/theme/app_theme.dart';
import 'package:bcc5/utils/logger.dart';

class ToolBagScreen extends StatelessWidget {
  ToolBagScreen({super.key});

  final GlobalKey mobKey = GlobalKey(debugLabel: 'MOBKey');
  final GlobalKey settingsKey = GlobalKey(debugLabel: 'SettingsKey');
  final GlobalKey searchKey = GlobalKey(debugLabel: 'SearchKey');
  final GlobalKey titleKey = GlobalKey(debugLabel: 'TitleKey');

  static const double appBarOffset = 80.0;

  @override
  Widget build(BuildContext context) {
    final toolbags = ToolRepositoryIndex.getToolbagNames();
    logger.i('🟦 Displaying ToolsScreen');

    return Stack(
      fit: StackFit.expand,
      children: [
        // AppBar
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: CustomAppBarWidget(
            title: 'Tools',
            showBackButton: false,
            showSearchIcon: true,
            showSettingsIcon: true,
            mobKey: mobKey,
            settingsKey: settingsKey,
            searchKey: searchKey,
            titleKey: titleKey,
          ),
        ),

        // "Choose a Toolbag" title
        Positioned(
          top: appBarOffset + 24,
          left: 32,
          right: 32,
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.85),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: Text(
                'Which toolbag do you need?',
                style: AppTheme.subheadingStyle.copyWith(
                  color: AppTheme.primaryBlue,
                ),
              ),
            ),
          ),
        ),

        // Button list
        Positioned.fill(
          top: appBarOffset + 100,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: ListView.builder(
              itemCount: toolbags.length,
              itemBuilder: (context, index) {
                final toolbag = toolbags[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: GroupButton(
                    label: toolbag.toTitleCase(),
                    onTap: () {
                      logger.i('🛠️ Selected toolbag: $toolbag');

                      final tools = ToolRepositoryIndex.getToolsForBag(toolbag);
                      final renderItems = buildRenderItems(
                        ids: tools.map((tool) => tool.id).toList(),
                      );

                      if (renderItems.isEmpty) {
                        logger.w(
                          '⚠️ No tools found in selected toolbag: $toolbag',
                        );
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('No tools found in this toolbag.'),
                          ),
                        );
                        return;
                      }

                      TransitionManager.goToDetailScreen(
                        context: context,
                        screenType: RenderItemType.tool,
                        renderItems: renderItems,
                        currentIndex: 0,
                        branchIndex: 3,
                        backDestination: '/tools',
                        backExtra: {'toolbag': toolbag},
                        detailRoute: DetailRoute.branch,
                        direction: SlideDirection.right,
                        transitionType: TransitionType.slide,
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
