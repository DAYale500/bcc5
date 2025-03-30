// 📄 lib/screens/tools/tools_screen.dart

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:bcc5/widgets/custom_app_bar_widget.dart';
import 'package:bcc5/widgets/group_button.dart';
import 'package:bcc5/utils/logger.dart';
import 'package:bcc5/data/repositories/tools/tool_repository_index.dart';

class ToolsScreen extends StatelessWidget {
  const ToolsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    logger.i('🟦 Displaying ToolsScreen');

    final toolbags = getToolbagNames();

    return Column(
      children: [
        const CustomAppBarWidget(
          title: 'Tools',
          showBackButton: false,
          showSearchIcon: true,
          showSettingsIcon: true,
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: ListView.builder(
              itemCount: toolbags.length,
              itemBuilder: (context, index) {
                final toolbag = toolbags[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: GroupButton(
                    label: toolbag[0].toUpperCase() + toolbag.substring(1),
                    onTap: () {
                      logger.i('🛠️ Selected toolbag: $toolbag');
                      context.push('/tools/items', extra: {'toolbag': toolbag});
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
