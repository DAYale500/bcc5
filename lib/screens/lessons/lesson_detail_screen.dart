import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:bcc5/data/models/render_item.dart';
import 'package:bcc5/utils/logger.dart';
import 'package:bcc5/widgets/custom_app_bar_widget.dart';
import 'package:bcc5/widgets/navigation_buttons.dart';
import 'package:bcc5/widgets/content_block_renderer.dart';

class LessonDetailScreen extends StatelessWidget {
  final List<RenderItem> renderItems;
  final int currentIndex;
  final int branchIndex;
  final String backDestination;
  final Map<String, dynamic>? backExtra;

  const LessonDetailScreen({
    super.key,
    required this.renderItems,
    required this.currentIndex,
    required this.branchIndex,
    required this.backDestination,
    this.backExtra, // 👈 NEW
  });

  @override
  Widget build(BuildContext context) {
    final RenderItem item = renderItems[currentIndex];
    final String title = item.title;

    logger.i('📘 LessonDetailScreen: $title');
    logger.i('🧩 Content blocks: ${item.content.length}');
    logger.i('🧠 Flashcards: ${item.flashcards.length}');

    return Column(
      children: [
        CustomAppBarWidget(
          title: title,
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
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: ListView.separated(
              itemCount: item.content.length,
              separatorBuilder: (_, __) => const SizedBox(height: 16),
              itemBuilder: (context, index) {
                return ContentBlockRenderer(blocks: [item.content[index]]);
              },
            ),
          ),
        ),
        NavigationButtons(
          isPreviousEnabled: currentIndex > 0,
          isNextEnabled: currentIndex < renderItems.length - 1,
          onPrevious: () {
            logger.i('⬅️ Previous tapped on LessonDetailScreen');
            _navigateTo(context, currentIndex - 1);
          },
          onNext: () {
            logger.i('➡️ Next tapped on LessonDetailScreen');
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
      '/lessons/detail',
      extra: {
        'renderItems': renderItems,
        'currentIndex': newIndex,
        'branchIndex': branchIndex,
        'backDestination': backDestination,
        'backExtra': backExtra, // ✅ Pass it forward!
      },
    );
  }
}
