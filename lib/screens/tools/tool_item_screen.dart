import 'package:bcc5/data/repositories/tools/tool_repository_index.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:bcc5/widgets/custom_app_bar_widget.dart';
import 'package:bcc5/widgets/item_button.dart';
import 'package:bcc5/data/models/tool_model.dart';
import 'package:bcc5/navigation/main_scaffold.dart';
import 'package:bcc5/utils/logger.dart';
import 'package:bcc5/utils/render_item_helpers.dart';
import 'package:bcc5/theme/app_theme.dart';

class ToolItemScreen extends StatelessWidget {
  final String toolbag;

  const ToolItemScreen({super.key, required this.toolbag});

  static const double appBarOffset = 80.0;

  @override
  Widget build(BuildContext context) {
    logger.i('🛠️ Displaying ToolItemScreen (Toolbag: $toolbag)');

    if (toolbag.isEmpty) {
      logger.w(
        '⚠️ ToolItemScreen received empty toolbag — using fallback title.',
      );
    }

    final List<ToolItem> tools = ToolRepositoryIndex.getToolsForBag(toolbag);
    final List<String> sequenceIds = tools.map((t) => t.id).toList();

    return MainScaffold(
      branchIndex: 3,
      child: Stack(
        fit: StackFit.expand,
        children: [
          // 🔵 AppBar
          Column(
            children: [
              CustomAppBarWidget(
                title:
                    (toolbag.isNotEmpty)
                        ? '${toolbag[0].toUpperCase()}${toolbag.substring(1)} Tools'
                        : 'Tools',
                showBackButton: true,
                showSearchIcon: true,
                showSettingsIcon: true,
                onBack: () {
                  logger.i('🔙 AppBar back from ToolItemScreen');
                  context.go('/tools');
                },
              ),
              const SizedBox(height: 90), // leaves space for "Choose a Rule"
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: GridView.builder(
                    itemCount: tools.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
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
                              'renderItems': buildRenderItems(ids: sequenceIds),
                              'currentIndex': index,
                              'branchIndex': 3,
                              'backDestination': '/tools/items',
                              'backExtra': {'toolbag': toolbag},
                              'transitionKey': 'tool_${tool.id}_$timestamp',
                            },
                          );
                        },
                      );
                    },
                  ),
                ),
              ),
            ],
          ),

          // 🧭 Screen Instruction: "Choose a Rule"
          Positioned(
            top: appBarOffset + 32,
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
                  'Choose a Rule',
                  style: AppTheme.subheadingStyle.copyWith(
                    color: AppTheme.primaryBlue,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
