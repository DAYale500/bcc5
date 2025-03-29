import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:bcc5/widgets/custom_app_bar_widget.dart';
import 'package:bcc5/utils/logger.dart';

class ToolsScreen extends StatelessWidget {
  const ToolsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    logger.i('🟦 Entered ToolsScreen');

    return Column(
      children: [
        const CustomAppBarWidget(
          title: 'Tools',
          showBackButton: false,
          showSearchIcon: true,
          showSettingsIcon: true,
        ),
        Expanded(
          child: Center(
            child: ElevatedButton(
              onPressed: () {
                logger.i('🛠️ Navigating to ToolItemScreen');
                context.push('/tools/items');
              },
              child: const Text('View Tools'),
            ),
          ),
        ),
      ],
    );
  }
}
