import 'package:flutter/material.dart';
import 'package:bcc5/navigation/main_scaffold.dart';
import 'package:bcc5/widgets/custom_app_bar_widget.dart';
import 'package:bcc5/utils/logger.dart';

class ToolsScreen extends StatelessWidget {
  const ToolsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    logger.i('🟦 Entered ToolsScreen');

    return MainScaffold(
      branchIndex: 4,
      child: const Column(
        children: [
          CustomAppBarWidget(
            title: 'Tools',
            showBackButton: false,
            showSearchIcon: true,
            showSettingsIcon: true,
          ),
          Expanded(child: Center(child: Text('Tools Screen'))),
        ],
      ),
    );
  }
}
