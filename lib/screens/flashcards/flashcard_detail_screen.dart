import 'dart:math' as math;
import 'package:bcc5/data/repositories/paths/path_repository_index.dart';
import 'package:bcc5/navigation/detail_route.dart';
import 'package:bcc5/theme/slide_direction.dart';
import 'package:bcc5/theme/transition_type.dart';
import 'package:bcc5/utils/render_item_helpers.dart';
import 'package:bcc5/utils/string_extensions.dart';
import 'package:bcc5/widgets/learning_path_progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:bcc5/data/models/render_item.dart';
import 'package:bcc5/utils/logger.dart';
import 'package:bcc5/widgets/flip_card_widget.dart';
import 'package:bcc5/widgets/navigation_buttons.dart';
import 'package:bcc5/theme/app_theme.dart';
import 'package:bcc5/widgets/custom_app_bar_widget.dart';
import 'package:bcc5/utils/transition_manager.dart';
import 'package:bcc5/data/repositories/flashcards/flashcard_repository_index.dart';

import 'package:bcc5/widgets/navigation/last_group_button.dart';

class FlashcardDetailScreen extends StatefulWidget {
  final List<RenderItem> renderItems;
  final int currentIndex;
  final int branchIndex;
  final String backDestination;
  final Map<String, dynamic>? backExtra;
  final DetailRoute detailRoute;
  final String transitionKey;

  const FlashcardDetailScreen({
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
  State<FlashcardDetailScreen> createState() => _FlashcardDetailScreenState();
}

class _FlashcardDetailScreenState extends State<FlashcardDetailScreen>
    with SingleTickerProviderStateMixin {
  late int currentIndex;
  late AnimationController _controller;
  late Animation<double> _flipAnimation;
  bool showFront = true;

  final GlobalKey mobKey = GlobalKey(debugLabel: 'MOBKey');
  final GlobalKey settingsKey = GlobalKey(debugLabel: 'SettingsKey');
  final GlobalKey searchKey = GlobalKey(debugLabel: 'SearchKey');
  final GlobalKey titleKey = GlobalKey(debugLabel: 'TitleKey');

  @override
  void initState() {
    super.initState();
    currentIndex = widget.currentIndex;

    if (widget.renderItems.isEmpty) {
      logger.e('❌ FlashcardDetailScreen received empty renderItems');
    } else {
      final item = widget.renderItems[currentIndex];
      logger.i(
        '🟩 FlashcardDetailScreen Loaded:\n'
        '  ├─ index: $currentIndex\n'
        '  ├─ id: ${item.id}\n'
        '  ├─ type: ${item.type}\n'
        '  ├─ renderItems.length: ${widget.renderItems.length}\n'
        '  ├─ branchIndex: ${widget.branchIndex}\n'
        '  ├─ backDestination: ${widget.backDestination}\n'
        '  └─ backExtra: ${widget.backExtra}',
      );

      if (item.type != RenderItemType.flashcard) {
        logger.w(
          '⚠️ Redirecting from non-flashcard type: ${item.id} (${item.type})',
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

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );

    _flipAnimation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void flipCard() {
    logger.i(showFront ? '🔃 Flipping to back' : '🔃 Flipping to front');
    setState(() {
      showFront = !showFront;
      _controller.isCompleted || _controller.velocity > 0
          ? _controller.reverse()
          : _controller.forward();
    });
  }

  void _navigateTo(int newIndex) {
    if (newIndex < 0 || newIndex >= widget.renderItems.length) {
      logger.w('⛔ Invalid navigation attempt: $newIndex');
      return;
    }

    final target = widget.renderItems[newIndex];
    TransitionManager.goToDetailScreen(
      context: context,
      screenType: target.type,
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
    if (widget.renderItems.isEmpty) {
      return const Scaffold(
        body: Center(child: Text('No flashcard content available')),
      );
    }

    final item = widget.renderItems[currentIndex];
    if (item.type != RenderItemType.flashcard || item.flashcards.isEmpty) {
      return const Scaffold(
        body: Center(child: Text('No flashcard content available')),
      );
    }

    final flashcard = item.flashcards.first;
    final title = flashcard.title;
    final sideA = flashcard.sideA;
    final sideB = flashcard.sideB;
    const categoryTitle = 'Drills';
    // final categoryId = widget.backExtra?['category'] as String?;

    // logger.i(
    //   '🖼️ Rendering Flashcard:\n'
    //   '  ├─ title: $title\n'
    //   '  ├─ sideA: ${sideA.length} blocks\n'
    //   '  └─ sideB: ${sideB.length} blocks',
    // );

    return Scaffold(
      key: ValueKey(widget.transitionKey),
      body: Stack(
        fit: StackFit.expand,
        children: [
          Opacity(
            opacity: 0.2,
            child: Image.asset(
              'assets/images/sailboat_cartoon.jpg',
              fit: BoxFit.cover,
            ),
          ),
          Column(
            children: [
              CustomAppBarWidget(
                title: categoryTitle,
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

              const SizedBox(height: 12),
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text:
                              widget.detailRoute == DetailRoute.path
                                  ? (widget.backExtra?['pathName'] as String?)
                                          ?.toTitleCase() ??
                                      ''
                                  : 'Drills',
                          style: AppTheme.branchBreadcrumbStyle,
                        ),
                        const TextSpan(
                          text: ' / ',
                          style: TextStyle(color: Colors.black87),
                        ),
                        TextSpan(
                          text:
                              widget.detailRoute == DetailRoute.path
                                  ? PathRepositoryIndex.getChapterTitleForPath(
                                        widget.backExtra?['pathName'] ?? '',
                                        widget.backExtra?['chapterId'] ?? '',
                                      )?.toTitleCase() ??
                                      ''
                                  : (widget.backExtra?['category'] as String?)
                                          ?.toTitleCase() ??
                                      '',
                          style: AppTheme.groupBreadcrumbStyle,
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 4),
              Text(
                title,
                style: AppTheme.scaledTextTheme.headlineMedium?.copyWith(
                  color: AppTheme.primaryBlue,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),

              const SizedBox(height: 12),
              Expanded(
                child: Center(
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Image.asset(
                        'assets/images/index_card.png',
                        width: 360,
                        height: 420,
                        fit: BoxFit.fill,
                      ),
                      SizedBox(
                        width: 360,
                        height: 420,
                        child: AnimatedBuilder(
                          animation: _flipAnimation,
                          builder: (context, child) {
                            final isFront = _flipAnimation.value < 0.5;
                            return Transform(
                              alignment: Alignment.center,
                              transform: Matrix4.rotationY(
                                _flipAnimation.value * math.pi,
                              ),
                              child:
                                  isFront
                                      ? Padding(
                                        padding: const EdgeInsets.only(top: 32),
                                        child: FlipCardWidget(
                                          front: sideA,
                                          back: sideB,
                                          showFront: true,
                                          animation: _flipAnimation,
                                        ),
                                      )
                                      : Transform(
                                        alignment: Alignment.center,
                                        transform: Matrix4.rotationY(math.pi),
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                            top: 32,
                                          ),
                                          child: FlipCardWidget(
                                            front: sideA,
                                            back: sideB,
                                            showFront: false,
                                            animation: _flipAnimation,
                                          ),
                                        ),
                                      ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: ElevatedButton(
                  onPressed: flipCard,
                  style: AppTheme.navigationButton,
                  child: Text(showFront ? 'Flip Over' : 'Flip Back'),
                ),
              ),
              NavigationButtons(
                isPreviousEnabled: currentIndex > 0,
                isNextEnabled: currentIndex < widget.renderItems.length - 1,
                onPrevious: () => _navigateTo(currentIndex - 1),
                onNext: () => _navigateTo(currentIndex + 1),
                customNextButton:
                    currentIndex == widget.renderItems.length - 1
                        ? LastGroupButton(
                          type: RenderItemType.flashcard,
                          detailRoute: widget.detailRoute,
                          backExtra: widget.backExtra,
                          branchIndex: widget.branchIndex,
                          backDestination:
                              widget.detailRoute == DetailRoute.path
                                  ? '/learning-paths/${(widget.backExtra?['pathName'] as String).replaceAll(' ', '-').toLowerCase()}/items'
                                  : '/flashcards/items',
                          label:
                              widget.detailRoute == DetailRoute.path
                                  ? 'chapter'
                                  : 'category',
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
                              final currentCategory =
                                  widget.backExtra?['category'] as String?;
                              if (currentCategory == null) return null;

                              final nextCategory = getNextCategory(
                                currentCategory,
                              );
                              if (nextCategory == null) return null;

                              final nextFlashcards = getFlashcardsForCategory(
                                nextCategory,
                              );
                              if (nextFlashcards.isEmpty) return [];

                              return nextFlashcards
                                  .map(RenderItem.fromFlashcard)
                                  .toList();
                            }
                          },
                          onNavigateToNextGroup: (renderItems) {
                            if (renderItems.isEmpty) return;

                            final isPath =
                                widget.detailRoute == DetailRoute.path;
                            final route =
                                isPath
                                    ? '/learning-paths/${(widget.backExtra?['pathName'] as String).replaceAll(' ', '-').toLowerCase()}/items'
                                    : '/flashcards/items';

                            final backExtra = {
                              if (isPath)
                                'chapterId':
                                    PathRepositoryIndex.getNextChapter(
                                      widget.backExtra?['pathName'],
                                      widget.backExtra?['chapterId'],
                                    )?.id,
                              if (isPath)
                                'pathName': widget.backExtra?['pathName'],
                              if (!isPath)
                                'category': getNextCategory(
                                  widget.backExtra?['category'],
                                ),
                              'branchIndex': widget.branchIndex,
                            };

                            TransitionManager.goToDetailScreen(
                              context: context,
                              screenType: RenderItemType.flashcard,
                              renderItems: renderItems,
                              currentIndex: 0,
                              branchIndex: widget.branchIndex,
                              backDestination: route,
                              backExtra: backExtra,
                              detailRoute: widget.detailRoute,
                              direction: SlideDirection.right,
                              replace: true,
                            );
                          },
                          onRestartAtFirstGroup: () {
                            if (widget.detailRoute == DetailRoute.path) {
                              final pathName =
                                  widget.backExtra?['pathName'] as String?;
                              final firstChapter =
                                  pathName == null
                                      ? null
                                      : PathRepositoryIndex.getChaptersForPath(
                                        pathName,
                                      ).first;

                              if (pathName == null || firstChapter == null) {
                                return;
                              }

                              final renderItems = buildRenderItems(
                                ids:
                                    firstChapter.items
                                        .map((e) => e.pathItemId)
                                        .toList(),
                              );

                              if (renderItems.isEmpty) return;

                              TransitionManager.goToDetailScreen(
                                context: context,
                                screenType: RenderItemType.flashcard,
                                renderItems: renderItems,
                                currentIndex: 0,
                                branchIndex: widget.branchIndex,
                                backDestination:
                                    '/learning-paths/${pathName.replaceAll(' ', '-').toLowerCase()}/items',
                                backExtra: {
                                  'chapterId': firstChapter.id,
                                  'pathName': pathName,
                                  'branchIndex': widget.branchIndex,
                                },
                                detailRoute: widget.detailRoute,
                                direction: SlideDirection.right,
                                replace: true,
                              );
                            } else {
                              final firstCategory = getAllCategories().first;
                              final firstFlashcards = getFlashcardsForCategory(
                                firstCategory,
                              );
                              final renderItems =
                                  firstFlashcards
                                      .map((f) => RenderItem.fromFlashcard(f))
                                      .toList();

                              if (renderItems.isEmpty) return;

                              TransitionManager.goToDetailScreen(
                                context: context,
                                screenType: RenderItemType.flashcard,
                                renderItems: renderItems,
                                currentIndex: 0,
                                branchIndex: widget.branchIndex,
                                backDestination: '/flashcards/items',
                                backExtra: {
                                  'category': firstCategory,
                                  'branchIndex': widget.branchIndex,
                                },
                                detailRoute: widget.detailRoute,
                                direction: SlideDirection.right,
                                replace: true,
                              );
                            }
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
