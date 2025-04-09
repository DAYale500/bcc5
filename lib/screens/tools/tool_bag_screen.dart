import 'package:bcc5/navigation/detail_route.dart';
import 'package:bcc5/theme/slide_direction.dart';
import 'package:bcc5/theme/transition_type.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:bcc5/data/repositories/tools/tool_repository_index.dart';
import 'package:bcc5/widgets/custom_app_bar_widget.dart';
import 'package:bcc5/widgets/group_button.dart';
import 'package:bcc5/theme/app_theme.dart';
import 'package:bcc5/utils/logger.dart';

class ToolBagScreen extends StatelessWidget {
  const ToolBagScreen({super.key});

  static const double appBarOffset = 80.0;

  @override
  Widget build(BuildContext context) {
    final toolbags = ToolRepositoryIndex.getToolbagNames();
    logger.i('🟦 Displaying ToolsScreen');

    return Stack(
      fit: StackFit.expand,
      children: [
        // Background (optional: can add if needed)
        // Opacity(
        //   opacity: 0.2,
        //   child: Image.asset(
        //     'assets/images/some_background.png',
        //     fit: BoxFit.cover,
        //   ),
        // ),

        // AppBar
        const Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: CustomAppBarWidget(
            title: 'Tools',
            showBackButton: false,
            showSearchIcon: true,
            showSettingsIcon: true,
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
                'Choose a Toolbag',
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
                    label: toolbag[0].toUpperCase() + toolbag.substring(1),
                    onTap: () {
                      logger.i('🛠️ Selected toolbag: $toolbag');
                      final timestamp = DateTime.now().millisecondsSinceEpoch;
                      context.push(
                        '/tools/items',
                        extra: {
                          'toolbag': toolbag,
                          'slideFrom': SlideDirection.right, // ✅ NEW
                          'transitionType': TransitionType.slide, // ✅ NEW
                          'transitionKey': 'tool_items_${toolbag}_$timestamp',
                          'detailRoute': DetailRoute.branch,
                        },
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
