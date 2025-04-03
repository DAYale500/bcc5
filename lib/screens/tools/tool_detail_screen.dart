// 📄 lib/screens/tools/tool_detail_screen.dart

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:bcc5/data/models/render_item.dart';
import 'package:bcc5/utils/logger.dart';
import 'package:bcc5/widgets/custom_app_bar_widget.dart';
import 'package:bcc5/widgets/navigation_buttons.dart';
import 'package:bcc5/widgets/content_block_renderer.dart';

class ToolDetailScreen extends StatelessWidget {
  final List<RenderItem> renderItems;
  final int currentIndex;
  final int branchIndex;
  final String backDestination;
  final Map<String, dynamic>? backExtra; // ✅ NEW

  const ToolDetailScreen({
    super.key,
    required this.renderItems,
    required this.currentIndex,
    required this.branchIndex,
    required this.backDestination,
    this.backExtra, // ✅ NEW
  });

  @override
  Widget build(BuildContext context) {
    if (renderItems.isEmpty ||
        currentIndex < 0 ||
        currentIndex >= renderItems.length) {
      logger.e('❌ Invalid data in ToolDetailScreen: empty or out of bounds');
      return const Scaffold(body: Center(child: Text('Invalid tool data')));
    }

    final RenderItem item = renderItems[currentIndex];
    final String title = item.title;

    logger.i('🛠️ ToolDetailScreen: $title');
    logger.i('📄 Content blocks: ${item.content.length}');

    return Column(
      children: [
        CustomAppBarWidget(
          title: title,
          showBackButton: true,
          showSearchIcon: true,
          showSettingsIcon: true,
          onBack: () {
            final toolId =
                renderItems[currentIndex].id; // e.g. tool_procedures_1.00
            final toolbag = toolId.split('_')[1]; // procedures
            logger.i('🔙 Back tapped → /tools/items with toolbag: $toolbag');
            context.go(
              '/tools/items',
              extra: {'toolbag': toolbag, 'branchIndex': branchIndex},
            );
          },
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: ContentBlockRenderer(blocks: item.content),
          ),
        ),
        NavigationButtons(
          isPreviousEnabled: currentIndex > 0,
          isNextEnabled: currentIndex < renderItems.length - 1,
          onPrevious: () {
            logger.i('⬅️ Previous tapped on ToolDetailScreen');
            _navigateTo(context, currentIndex - 1);
          },
          onNext: () {
            logger.i('➡️ Next tapped on ToolDetailScreen');
            _navigateTo(context, currentIndex + 1);
          },
        ),
      ],
    );
  }

  void _navigateTo(BuildContext context, int newIndex) {
    if (newIndex < 0 || newIndex >= renderItems.length) {
      logger.w('⚠️ Navigation index out of bounds: $newIndex');
      return;
    }

    context.go(
      '/tools/detail',
      extra: {
        'renderItems': renderItems,
        'currentIndex': newIndex,
        'branchIndex': branchIndex,
        'backDestination': backDestination,
        'backExtra': backExtra, // ✅ preserve across navigation
      },
    );
  }
}
