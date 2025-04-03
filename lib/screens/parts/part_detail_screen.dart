import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:bcc5/data/models/render_item.dart';
import 'package:bcc5/utils/logger.dart';
import 'package:bcc5/widgets/custom_app_bar_widget.dart';
import 'package:bcc5/widgets/navigation_buttons.dart';
import 'package:bcc5/widgets/content_block_renderer.dart';

class PartDetailScreen extends StatelessWidget {
  final List<RenderItem> renderItems;
  final int currentIndex;
  final int branchIndex;
  final String backDestination;
  final Map<String, dynamic>? backExtra;

  const PartDetailScreen({
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
      logger.e('❌ Invalid data in PartDetailScreen: empty or out of bounds');
      return const Scaffold(body: Center(child: Text('Invalid part data')));
    }

    final RenderItem item = renderItems[currentIndex];

    // 🚨 Redirect if not part
    if (item.type != RenderItemType.part) {
      logger.w('⚠️ Redirecting from non-part type: ${item.id} (${item.type})');
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _navigateTo(context, currentIndex);
      });
      return const Scaffold(body: SizedBox());
    }

    final String title = item.title;

    logger.i('🧩 PartDetailScreen: $title');
    logger.i('📄 Content blocks: ${item.content.length}');

    return Stack(
      fit: StackFit.expand,
      children: [
        Image.asset('assets/images/boat_overview.png', fit: BoxFit.cover),
        Column(
          children: [
            CustomAppBarWidget(
              title: title,
              showBackButton: true,
              showSearchIcon: true,
              showSettingsIcon: true,
              onBack: () {
                logger.i('🔙 Back tapped → $backDestination');
                context.go(backDestination, extra: backExtra);
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
                logger.i('⬅️ Previous tapped on PartDetailScreen');
                _navigateTo(context, currentIndex - 1);
              },
              onNext: () {
                logger.i('➡️ Next tapped on PartDetailScreen');
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
    final extra = {
      'renderItems': renderItems,
      'currentIndex': newIndex,
      'branchIndex': branchIndex,
      'backDestination': backDestination,
      'backExtra': backExtra,
    };

    switch (nextItem.type) {
      case RenderItemType.part:
        context.go('/parts/detail', extra: extra);
        break;
      case RenderItemType.lesson:
        context.go('/lessons/detail', extra: extra);
        break;
      case RenderItemType.tool:
        context.go('/tools/detail', extra: extra);
        break;
      case RenderItemType.flashcard:
        context.go('/flashcards/detail', extra: extra);
        break;
      // default:
      //   logger.e('⛔ Unknown RenderItemType: ${nextItem.type}');
    }
  }
}
