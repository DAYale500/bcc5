import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:bcc5/data/models/render_item.dart';
import 'package:bcc5/utils/logger.dart';
import 'package:bcc5/widgets/custom_app_bar_widget.dart';
import 'package:bcc5/widgets/navigation_buttons.dart';
import 'package:bcc5/widgets/content_block_renderer.dart';
import 'package:bcc5/utils/string_extensions.dart';
import 'package:bcc5/theme/app_theme.dart';

class ToolDetailScreen extends StatelessWidget {
  final List<RenderItem> renderItems;
  final int currentIndex;
  final int branchIndex;
  final String backDestination;
  final Map<String, dynamic>? backExtra;

  const ToolDetailScreen({
    super.key,
    required this.renderItems,
    required this.currentIndex,
    required this.branchIndex,
    required this.backDestination,
    this.backExtra,
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

    if (item.type != RenderItemType.tool) {
      logger.w('⚠️ Redirecting from non-tool type: ${item.id} (${item.type})');
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _navigateTo(context, currentIndex);
      });
      return const Scaffold(body: SizedBox());
    }

    final String toolTitle = item.title;
    final String toolbagTitle =
        (backExtra?['toolbag'] as String?)?.toTitleCase() ?? 'Tool';

    logger.i('🛠️ ToolDetailScreen: $toolTitle');
    logger.i('📄 Content blocks: ${item.content.length}');

    return Stack(
      fit: StackFit.expand,
      children: [
        Opacity(
          opacity: 0.2,
          child: Image.asset(
            'assets/images/navigation_lights.png',
            fit: BoxFit.cover,
          ),
        ),
        Column(
          children: [
            CustomAppBarWidget(
              title: toolbagTitle,
              showBackButton: true,
              showSearchIcon: true,
              showSettingsIcon: true,
              onBack: () {
                logger.i('🔙 Back tapped → $backDestination');
                if (backExtra != null) {
                  context.go(backDestination, extra: backExtra);
                } else {
                  context.go(backDestination);
                }
              },
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Text(
                toolTitle,
                style: AppTheme.scaledTextTheme.headlineMedium?.copyWith(
                  color: AppTheme.primaryBlue,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
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
        ),
      ],
    );
  }

  void _navigateTo(BuildContext context, int newIndex) {
    if (newIndex < 0 || newIndex >= renderItems.length) {
      logger.w('⚠️ Navigation index out of bounds: $newIndex');
      return;
    }

    final nextItem = renderItems[newIndex];
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final extra = {
      'renderItems': renderItems,
      'currentIndex': newIndex,
      'branchIndex': branchIndex,
      'backDestination': backDestination,
      'backExtra': backExtra,
      'transitionKey': 'tool_${nextItem.id}_$timestamp',
    };

    switch (nextItem.type) {
      case RenderItemType.tool:
        context.go('/tools/detail', extra: extra);
        break;
      case RenderItemType.lesson:
        context.go('/lessons/detail', extra: extra);
        break;
      case RenderItemType.part:
        context.go('/parts/detail', extra: extra);
        break;
      case RenderItemType.flashcard:
        context.go('/flashcards/detail', extra: extra);
        break;
    }
  }
}
