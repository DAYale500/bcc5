// lib/screens/lessons/lesson_detail_screen.dart

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:animations/animations.dart'; // ✅ For PageTransitionSwitcher

import 'package:bcc5/data/models/render_item.dart';
import 'package:bcc5/utils/logger.dart';
import 'package:bcc5/widgets/custom_app_bar_widget.dart';
import 'package:bcc5/widgets/navigation_buttons.dart';
import 'package:bcc5/widgets/content_block_renderer.dart';
import 'package:bcc5/utils/string_extensions.dart';
import 'package:bcc5/theme/app_theme.dart';
import 'package:bcc5/utils/transition_manager.dart'; // ✅ For buildScaleFadeTransition

class LessonDetailScreen extends StatefulWidget {
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
    this.backExtra,
  });

  @override
  State<LessonDetailScreen> createState() => _LessonDetailScreenState();
}

class _LessonDetailScreenState extends State<LessonDetailScreen> {
  late int currentIndex;

  @override
  void initState() {
    super.initState();
    currentIndex = widget.currentIndex;
  }

  void _navigateTo(int newIndex) {
    if (newIndex < 0 || newIndex >= widget.renderItems.length) {
      logger.w('⚠️ Navigation index out of bounds: $newIndex');
      return;
    }

    final nextItem = widget.renderItems[newIndex];
    final extra = {
      'renderItems': widget.renderItems,
      'currentIndex': newIndex,
      'branchIndex': widget.branchIndex,
      'backDestination': widget.backDestination,
      'backExtra': widget.backExtra,
    };

    switch (nextItem.type) {
      case RenderItemType.lesson:
        context.go('/lessons/detail', extra: extra);
        break;
      case RenderItemType.flashcard:
        context.go('/flashcards/detail', extra: extra);
        break;
      case RenderItemType.part:
        context.go('/parts/detail', extra: extra);
        break;
      case RenderItemType.tool:
        context.go('/tools/detail', extra: extra);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.renderItems.isEmpty ||
        currentIndex < 0 ||
        currentIndex >= widget.renderItems.length) {
      logger.e('❌ Invalid data in LessonDetailScreen');
      return const Scaffold(body: Center(child: Text('Invalid lesson data')));
    }

    final item = widget.renderItems[currentIndex];

    // 🚨 Redirect if this isn't a lesson
    if (item.type != RenderItemType.lesson) {
      logger.w(
        '⚠️ LessonDetailScreen received non-lesson item: ${item.id} (${item.type})',
      );
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _navigateTo(currentIndex);
      });
      return const Scaffold(body: SizedBox());
    }

    final moduleTitle =
        (widget.backExtra?['module'] as String?)?.toTitleCase() ?? 'Lesson';
    final lessonTitle = item.title;

    logger.i('📘 LessonDetailScreen: $lessonTitle');
    logger.i('🧩 Content blocks: ${item.content.length}');
    logger.i('🧠 Flashcards: ${item.flashcards.length}');

    return Stack(
      fit: StackFit.expand,
      children: [
        Opacity(
          opacity: 0.2,
          child: Image.asset(
            'assets/images/boat_overview_new.png',
            fit: BoxFit.cover,
          ),
        ),
        Column(
          children: [
            CustomAppBarWidget(
              title: moduleTitle,
              showBackButton: true,
              showSearchIcon: true,
              showSettingsIcon: true,
              onBack: () {
                logger.i('🔙 Back tapped → ${widget.backDestination}');
                if (widget.backExtra != null) {
                  context.go(widget.backDestination, extra: widget.backExtra);
                } else {
                  context.go(widget.backDestination);
                }
              },
            ),

            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Text(
                lessonTitle,
                style: AppTheme.scaledTextTheme.headlineMedium?.copyWith(
                  color: AppTheme.primaryBlue,
                ),
                textAlign: TextAlign.center,
              ),
            ),

            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: PageTransitionSwitcher(
                  duration: const Duration(milliseconds: 300),
                  transitionBuilder: buildScaleFadeTransition,
                  child: ContentBlockRenderer(
                    key: ValueKey(item.id),
                    blocks: item.content,
                  ),
                ),
              ),
            ),

            NavigationButtons(
              isPreviousEnabled: currentIndex > 0,
              isNextEnabled: currentIndex < widget.renderItems.length - 1,
              onPrevious: () {
                logger.i('⬅️ Previous tapped on LessonDetailScreen');
                setState(() => currentIndex--);
              },
              onNext: () {
                logger.i('➡️ Next tapped on LessonDetailScreen');
                setState(() => currentIndex++);
              },
            ),
          ],
        ),
      ],
    );
  }
}
