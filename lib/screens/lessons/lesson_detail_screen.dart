import 'package:bcc5/data/repositories/lessons/lesson_repository_index.dart';
import 'package:bcc5/navigation/detail_route.dart';
import 'package:bcc5/theme/slide_direction.dart';
import 'package:bcc5/theme/transition_type.dart';
import 'package:bcc5/utils/render_item_helpers.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:animations/animations.dart';

import 'package:bcc5/data/models/render_item.dart';
import 'package:bcc5/utils/logger.dart';
import 'package:bcc5/widgets/custom_app_bar_widget.dart';
import 'package:bcc5/widgets/navigation_buttons.dart';
import 'package:bcc5/widgets/content_block_renderer.dart';
import 'package:bcc5/utils/string_extensions.dart';
import 'package:bcc5/theme/app_theme.dart';
import 'package:bcc5/utils/transition_manager.dart';
import 'package:bcc5/data/repositories/paths/path_repository_index.dart';

class LessonDetailScreen extends StatefulWidget {
  final List<RenderItem> renderItems;
  final int currentIndex;
  final int branchIndex;
  final String backDestination;
  final Map<String, dynamic>? backExtra;
  final DetailRoute detailRoute;
  final String transitionKey;

  const LessonDetailScreen({
    super.key,
    required this.renderItems,
    required this.currentIndex,
    required this.branchIndex,
    required this.backDestination,
    required this.backExtra,
    required this.detailRoute,
    required this.transitionKey,
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

    final item = widget.renderItems[currentIndex];
    if (item.type != RenderItemType.lesson) {
      logger.w(
        '⚠️ Redirecting from non-lesson type: ${item.id} (${item.type})',
      );
      WidgetsBinding.instance.addPostFrameCallback((_) {
        TransitionManager.goToDetailScreen(
          context: context,
          screenType: item.type,
          renderItems: widget.renderItems,
          currentIndex: currentIndex,
          branchIndex: widget.branchIndex,
          backDestination: widget.backDestination,
          backExtra: widget.backExtra,
          detailRoute: widget.detailRoute,
          direction: SlideDirection.none,
        );
      });
    }
  }

  void _navigateTo(int newIndex) {
    if (newIndex < 0 || newIndex >= widget.renderItems.length) {
      logger.w('⚠️ Navigation index out of bounds: $newIndex');
      return;
    }

    final nextItem = widget.renderItems[newIndex];
    TransitionManager.goToDetailScreen(
      context: context,
      screenType: nextItem.type,
      renderItems: widget.renderItems,
      currentIndex: newIndex,
      branchIndex: widget.branchIndex,
      backDestination: widget.backDestination,
      backExtra: widget.backExtra,
      detailRoute: widget.detailRoute,
      direction: SlideDirection.none,
      transitionType: TransitionType.fadeScale, // ✅ NEW
    );
  }

  @override
  Widget build(BuildContext context) {
    final item = widget.renderItems[currentIndex];

    if (item.type != RenderItemType.lesson) {
      return const Scaffold(body: SizedBox());
    }

    final moduleTitle =
        (widget.backExtra?['module'] as String?)?.toTitleCase() ?? 'Course';
    final lessonTitle = item.title;

    logger.i('📘 LessonDetailScreen: $lessonTitle');
    logger.i('🧩 Content blocks: ${item.content.length}');
    logger.i('🧠 Flashcards: ${item.flashcards.length}');

    return PageTransitionSwitcher(
      duration: const Duration(milliseconds: 250),
      transitionBuilder: buildScaleFadeTransition,
      child: _buildScaffold(item, moduleTitle, lessonTitle),
    );
  }

  Widget _buildScaffold(
    RenderItem item,
    String moduleTitle,
    String lessonTitle,
  ) {
    return Scaffold(
      key: ValueKey(widget.transitionKey),
      body: Stack(
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
                  context.go(
                    widget.backDestination,
                    extra: {
                      ...?widget.backExtra,
                      'transitionKey': UniqueKey().toString(),
                      'slideFrom': SlideDirection.left,
                      'transitionType': TransitionType.slide,
                    },
                  );
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
                  child: ContentBlockRenderer(
                    key: ValueKey(item.id),
                    blocks: item.content,
                  ),
                ),
              ),
              Column(
                children: [
                  NavigationButtons(
                    isPreviousEnabled: currentIndex > 0,
                    isNextEnabled: currentIndex < widget.renderItems.length - 1,
                    onPrevious: () {
                      logger.i('⬅️ Previous tapped on LessonDetailScreen');
                      _navigateTo(currentIndex - 1);
                    },
                    onNext: () {
                      if (currentIndex < widget.renderItems.length - 1) {
                        logger.i('➡️ Next tapped on LessonDetailScreen');
                        _navigateTo(currentIndex + 1);
                      }
                    },
                    customNextButton:
                        (currentIndex == widget.renderItems.length - 1)
                            ? ElevatedButton(
                              onPressed: () {
                                logger.i(
                                  '⏭️ Next Chapter tapped on LessonDetailScreen',
                                );

                                if (widget.detailRoute == DetailRoute.branch) {
                                  final currentModuleId =
                                      widget.backExtra?['module'] as String?;
                                  if (currentModuleId == null) {
                                    logger.w(
                                      '⚠️ No module ID found in backExtra',
                                    );
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                          'Cannot find next module.',
                                        ),
                                      ),
                                    );
                                    return;
                                  }

                                  final nextModuleId =
                                      LessonRepositoryIndex.getNextModule(
                                        currentModuleId,
                                      );

                                  if (nextModuleId == null) {
                                    logger.i(
                                      '⛔ No more modules after $currentModuleId',
                                    );
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                          'You’ve reached the final module.',
                                        ),
                                      ),
                                    );
                                    return;
                                  }

                                  final renderItems = buildRenderItems(
                                    ids:
                                        LessonRepositoryIndex.getLessonsForModule(
                                          nextModuleId,
                                        ).map((l) => l.id).toList(),
                                  );

                                  if (renderItems.isEmpty) {
                                    logger.w(
                                      '⚠️ Next module has no renderable items',
                                    );
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                          'Next module has no items.',
                                        ),
                                      ),
                                    );
                                    return;
                                  }

                                  TransitionManager.goToDetailScreen(
                                    context: context,
                                    screenType: renderItems.first.type,
                                    renderItems: renderItems,
                                    currentIndex: 0,
                                    branchIndex: widget.branchIndex,
                                    backDestination: '/lessons/items',
                                    backExtra: {
                                      'module': nextModuleId,
                                      'branchIndex': widget.branchIndex,
                                    },
                                    detailRoute: widget.detailRoute,
                                    direction: SlideDirection.right,
                                  );
                                } else if (widget.detailRoute ==
                                    DetailRoute.path) {
                                  final currentChapterId =
                                      widget.backExtra?['chapterId'] as String?;
                                  final pathName =
                                      widget.backExtra?['pathName'] as String?;

                                  if (currentChapterId == null ||
                                      pathName == null) {
                                    logger.w(
                                      '⚠️ Missing path context in backExtra',
                                    );
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text('No path context found.'),
                                      ),
                                    );
                                    return;
                                  }

                                  final nextChapter =
                                      PathRepositoryIndex.getNextChapter(
                                        pathName,
                                        currentChapterId,
                                      );

                                  if (nextChapter == null) {
                                    logger.i(
                                      '⛔ No next chapter in $pathName after $currentChapterId',
                                    );
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                          'You’ve reached the final chapter.',
                                        ),
                                      ),
                                    );
                                    return;
                                  }

                                  final renderItems = buildRenderItems(
                                    ids:
                                        nextChapter.items
                                            .map((item) => item.pathItemId)
                                            .toList(),
                                  );

                                  if (renderItems.isEmpty) {
                                    logger.w(
                                      '⚠️ Next chapter has no renderable items',
                                    );
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                          'Next chapter has no items.',
                                        ),
                                      ),
                                    );
                                    return;
                                  }

                                  TransitionManager.goToDetailScreen(
                                    context: context,
                                    screenType: renderItems.first.type,
                                    renderItems: renderItems,
                                    currentIndex: 0,
                                    branchIndex: widget.branchIndex,
                                    backDestination:
                                        '/learning-paths/${pathName.replaceAll(' ', '-').toLowerCase()}/items',
                                    backExtra: {
                                      'chapterId': nextChapter.id,
                                      'pathName': pathName,
                                      'branchIndex': widget.branchIndex,
                                    },
                                    detailRoute: widget.detailRoute,
                                    direction: SlideDirection.right,
                                  );
                                }
                              },
                              style: AppTheme.navigationButton,
                              child: const Text('Next Chapter'),
                            )
                            : null,
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
