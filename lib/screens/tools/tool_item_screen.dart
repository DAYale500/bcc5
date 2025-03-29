// 📄 lib/screens/tools/tool_item_screen.dart

import 'package:bcc5/data/repositories/tools/tool_repository.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:bcc5/widgets/custom_app_bar_widget.dart';
import 'package:bcc5/widgets/item_button.dart';
import 'package:bcc5/utils/logger.dart';
import 'package:bcc5/data/models/tool_model.dart';
import 'package:bcc5/navigation/main_scaffold.dart'; // ✅ Needed for BNB

class ToolItemScreen extends StatelessWidget {
  final String toolbag;

  const ToolItemScreen({super.key, required this.toolbag});

  @override
  Widget build(BuildContext context) {
    logger.i('🛠️ Entered ToolItemScreen for toolbag: $toolbag');

    final List<ToolItem> tools = getToolsForBag(toolbag);

    return MainScaffold(
      branchIndex: 4, // ✅ Ensures BNB highlights the "Tools" tab
      child: Column(
        children: [
          CustomAppBarWidget(
            title: 'Tool Items',
            showBackButton: true,
            showSearchIcon: true,
            showSettingsIcon: true,
            onBack: () {
              logger.i('🔙 AppBar back from ToolItemScreen');
              context.go('/tools');
            },
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16),
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
                      logger.i('🛠️ Tapped tool: ${tool.title}');
                      context.push(
                        '/content',
                        extra: {
                          'sequenceTitles': tools.map((t) => t.title).toList(),
                          'contentMap': {
                            for (var t in tools) t.title: t.content,
                          },
                          'startIndex': index,
                          'branchIndex': 4,
                          'backDestination': '/tools/items',
                          'backExtra': {'toolbag': toolbag, 'branchIndex': 4},
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
    );
  }
}
