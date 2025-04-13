import 'package:bcc5/data/repositories/tools/tool_repository_index.dart';
import 'package:bcc5/theme/slide_direction.dart';
import 'package:bcc5/theme/transition_type.dart';
import 'package:bcc5/utils/string_extensions.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:bcc5/widgets/custom_app_bar_widget.dart';
import 'package:bcc5/widgets/item_button.dart';
import 'package:bcc5/utils/logger.dart';
import 'package:bcc5/utils/render_item_helpers.dart';
import 'package:bcc5/theme/app_theme.dart';
import 'package:bcc5/navigation/detail_route.dart';

class ToolItemScreen extends StatelessWidget {
  final String toolbag;

  const ToolItemScreen({
    super.key,
    required this.toolbag,
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
    logger.i('🛠️ ToolItemScreen loaded for toolbag: $toolbag');

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
                final timestamp = DateTime.now().millisecondsSinceEpoch;

                return ItemButton(
                  label: tool.title,
                  onTap: () {
                    logger.i('🛠️ Tapped tool: ${tool.id}');
                    context.push(
                      '/tools/detail',
                      extra: {
                        'renderItems': renderItems,
                        'currentIndex': index,
                        'branchIndex': 3,
                        'backDestination': '/tools/items',
                        'backExtra': {'toolbag': toolbag},
                        'transitionKey': 'tool_${tool.id}_$timestamp',
                        'detailRoute': DetailRoute.branch,
                        'transitionType': TransitionType.slide,
                        'slideFrom': SlideDirection.right,
                      },
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
