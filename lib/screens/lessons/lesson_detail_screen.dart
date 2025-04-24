import 'package:bcc5/data/repositories/lessons/lesson_repository_index.dart';
import 'package:bcc5/data/repositories/paths/path_repository_index.dart';
import 'package:bcc5/navigation/detail_route.dart';
import 'package:bcc5/theme/slide_direction.dart';
import 'package:bcc5/theme/transition_type.dart';
import 'package:bcc5/utils/render_item_helpers.dart';
import 'package:bcc5/utils/string_extensions.dart';
import 'package:bcc5/widgets/learning_path_progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:animations/animations.dart';

import 'package:bcc5/data/models/render_item.dart';
import 'package:bcc5/utils/logger.dart';
import 'package:bcc5/widgets/custom_app_bar_widget.dart';
import 'package:bcc5/widgets/navigation_buttons.dart';
import 'package:bcc5/widgets/content_block_renderer.dart';
import 'package:bcc5/theme/app_theme.dart';
import 'package:bcc5/utils/transition_manager.dart';

import 'package:bcc5/widgets/navigation/last_group_button.dart';

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

  // 🔐 Local GlobalKeys preserved for onboarding tour targeting
  // Avoid relying on internal AppBar key generation in this screen
  final GlobalKey mobKey = GlobalKey(debugLabel: 'MOBKey');
  final GlobalKey settingsKey = GlobalKey(debugLabel: 'SettingsKey');
  final GlobalKey searchKey = GlobalKey(debugLabel: 'SearchKey');
  final GlobalKey titleKey = GlobalKey(debugLabel: 'TitleKey');

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
          replace: true,
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
      transitionType: TransitionType.fadeScale,
    );
  }

  @override
  Widget build(BuildContext context) {
    final item = widget.renderItems[currentIndex];

    if (item.type != RenderItemType.lesson) {
      return const Scaffold(body: SizedBox());
    }

    const moduleTitle = 'Courses';
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
                mobKey: mobKey,
                settingsKey: settingsKey,
                searchKey: searchKey,
                titleKey: titleKey,
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

              if (widget.detailRoute == DetailRoute.path)
                LearningPathProgressBar(
                  pathName: widget.backExtra?['pathName'] ?? '',
                ),

              Padding(
                padding: const EdgeInsets.only(
                  top: 8.0,
                  left: 16.0,
                  right: 16.0,
                ),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    widget.detailRoute == DetailRoute.path
                        ? (widget.backExtra?['chapterId']
                                ?.toString()
                                .toTitleCase() ??
                            '')
                        : '${widget.backExtra?['module']?.toString().toTitleCase() ?? ''} →',
                    style: AppTheme.scaledTextTheme.bodySmall?.copyWith(
                      fontStyle: FontStyle.italic,
                      color: Colors.black54,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 4.0, bottom: 8.0),
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
                        ? LastGroupButton(
                          type: RenderItemType.lesson,
                          detailRoute: widget.detailRoute,
                          backExtra: widget.backExtra,
                          branchIndex: widget.branchIndex,
                          backDestination:
                              widget.detailRoute == DetailRoute.path
                                  ? '/learning-paths/${(widget.backExtra?['pathName'] as String).replaceAll(' ', '-').toLowerCase()}'
                                  : '/lessons',
                          label:
                              widget.detailRoute == DetailRoute.path
                                  ? 'chapter'
                                  : 'module',
                          getNextRenderItems: () async {
                            if (widget.detailRoute == DetailRoute.path) {
                              final pathName =
                                  widget.backExtra?['pathName'] as String?;
                              final chapterId =
                                  widget.backExtra?['chapterId'] as String?;
                              if (pathName == null || chapterId == null) {
                                return null;
                              }

                              final nextChapter =
                                  PathRepositoryIndex.getNextChapter(
                                    pathName,
                                    chapterId,
                                  );
                              if (nextChapter == null) return null;

                              return buildRenderItems(
                                ids:
                                    nextChapter.items
                                        .map((e) => e.pathItemId)
                                        .toList(),
                              );
                            } else {
                              final currentModuleId =
                                  widget.backExtra?['module'] as String?;
                              if (currentModuleId == null) return null;

                              final nextModuleId =
                                  LessonRepositoryIndex.getNextModule(
                                    currentModuleId,
                                  );
                              if (nextModuleId == null) return null;

                              final nextLessons =
                                  LessonRepositoryIndex.getLessonsForModule(
                                    nextModuleId,
                                  );
                              return buildRenderItems(
                                ids: nextLessons.map((l) => l.id).toList(),
                              );
                            }
                          },
                          onNavigateToNextGroup: (renderItems) {
                            if (renderItems.isEmpty) return;

                            if (widget.detailRoute == DetailRoute.path) {
                              final pathName =
                                  widget.backExtra?['pathName'] as String?;
                              final chapterId =
                                  widget.backExtra?['chapterId'] as String?;
                              if (pathName == null || chapterId == null) return;

                              final nextChapter =
                                  PathRepositoryIndex.getNextChapter(
                                    pathName,
                                    chapterId,
                                  );
                              if (nextChapter == null) return;

                              final route =
                                  '/learning-paths/${pathName.replaceAll(' ', '-').toLowerCase()}/items';

                              TransitionManager.goToDetailScreen(
                                context: context,
                                screenType: RenderItemType.lesson,
                                renderItems: renderItems,
                                currentIndex: 0,
                                branchIndex: widget.branchIndex,
                                backDestination: route,
                                backExtra: {
                                  'pathName': pathName,
                                  'chapterId': nextChapter.id,
                                  'branchIndex': widget.branchIndex,
                                },
                                detailRoute: widget.detailRoute,
                                direction: SlideDirection.right,
                                replace: true,
                              );
                            } else {
                              final nextModuleId =
                                  LessonRepositoryIndex.getNextModule(
                                    widget.backExtra?['module'],
                                  );
                              if (nextModuleId == null) return;

                              TransitionManager.goToDetailScreen(
                                context: context,
                                screenType: RenderItemType.lesson,
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
                                replace: true,
                              );
                            }
                          },
                          onRestartAtFirstGroup: () {
                            final firstModuleId =
                                LessonRepositoryIndex.getModuleNames().first;
                            final firstLessons =
                                LessonRepositoryIndex.getLessonsForModule(
                                  firstModuleId,
                                );
                            final renderItems = buildRenderItems(
                              ids: firstLessons.map((l) => l.id).toList(),
                            );

                            if (renderItems.isEmpty) return;

                            TransitionManager.goToDetailScreen(
                              context: context,
                              screenType: RenderItemType.lesson,
                              renderItems: renderItems,
                              currentIndex: 0,
                              branchIndex: widget.branchIndex,
                              backDestination: '/lessons/items',
                              backExtra: {
                                'module': firstModuleId,
                                'branchIndex': widget.branchIndex,
                              },
                              detailRoute: widget.detailRoute,
                              direction: SlideDirection.right,
                              replace: true,
                            );
                          },
                        )
                        : null,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
