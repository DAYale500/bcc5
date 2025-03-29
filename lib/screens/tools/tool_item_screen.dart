import 'package:flutter/material.dart';
import 'package:bcc5/widgets/custom_app_bar_widget.dart';
import 'package:bcc5/utils/logger.dart';

class ToolItemScreen extends StatelessWidget {
  const ToolItemScreen({super.key});

  @override
  Widget build(BuildContext context) {
    logger.i('🛠️ Entered ToolItemScreen');

    return const Column(
      children: [
        CustomAppBarWidget(
          title: 'Tool Items',
          showBackButton: true,
          showSearchIcon: true,
          showSettingsIcon: true,
        ),
        Expanded(child: Center(child: Text('Tool Item Screen'))),
      ],
    );
  }
}
