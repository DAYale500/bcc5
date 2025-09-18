// ─────────────────────────────────────────────────────────────────────────────
// lib/screens/parts/part_detail_screen.dart
// Detail flow is list-bound; "next zone" pulls from JsonPartRepository only.
// JSON-only for Paths as well (JsonPathRepository).
// ─────────────────────────────────────────────────────────────────────────────
import 'package:bcc5/data/repositories/parts/json_part_repository.dart';
import 'package:bcc5/navigation/detail_route.dart';
import 'package:bcc5/theme/slide_direction.dart';
import 'package:bcc5/theme/transition_type.dart';
import 'package:bcc5/utils/string_extensions.dart';
import 'package:bcc5/widgets/learning_path_progress_bar.dart';
import 'package:bcc5/widgets/navigation/last_group_button.dart';
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
import 'package:bcc5/utils/render_item_helpers.dart';
import 'package:bcc5/data/repositories/paths/json_path_repository.dart';

class PartDetailScreen extends StatefulWidget {
  final List<RenderItem> renderItems;
  final int currentIndex;
  final int branchIndex;
  final String backDestination;
  final Map<String, dynamic>? backExtra;
  final DetailRoute detailRoute;
  final String transitionKey;

  const PartDetailScreen({
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
  State<PartDetailScreen> createState() => _PartDetailScreenState();
}

class _PartDetailScreenState extends State<PartDetailScreen> {
  late int currentIndex;

  // Async-loaded when launched from a path
  String _chapterTitle = '';

  final GlobalKey mobKey = GlobalKey(debugLabel: 'MOBKey');
  final GlobalKey settingsKey = GlobalKey(debugLabel: 'SettingsKey');
  final GlobalKey searchKey = GlobalKey(debugLabel: 'SearchKey');
  final GlobalKey titleKey = GlobalKey(debugLabel: 'TitleKey');

  @override
  void initState() {
    super.initState();
    currentIndex = widget.currentIndex;

    final item = widget.renderItems[currentIndex];
    if (item.type != RenderItemType.part) {
      logger.w('⚠️ Redirecting from non-part type: ${item.id} (${item.type})');
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
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

    _maybeLoadChapterTitle();
  }

  Future<void> _maybeLoadChapterTitle() async {
    if (widget.detailRoute != DetailRoute.path) return;
    final pathName = widget.backExtra?['pathName'] as String?;
    final chapterId = widget.backExtra?['chapterId'] as String?;
    if (pathName == null || chapterId == null) return;

    final title =
        await JsonPathRepository.getChapterTitleForPath(pathName, chapterId) ??
        '';
    if (!mounted) return;
    setState(() {
      _chapterTitle = title.toTitleCase();
    });
  }

  void _navigateTo(int newIndex) {
    if (newIndex < 0 || newIndex >= widget.renderItems.length) return;
    final targetItem = widget.renderItems[newIndex];
    TransitionManager.goToDetailScreen(
      context: context,
      screenType: targetItem.type,
      renderItems: widget.renderItems,
      currentIndex: newIndex,
      branchIndex: widget.branchIndex,
      backDestination: widget.backDestination,
      backExtra: widget.backExtra,
      detailRoute: widget.detailRoute,
      direction: SlideDirection.none,
      transitionType: TransitionType.fadeScale,
      replace: true,
    );
  }

  Future<String?> _nextZoneId(String currentZone) async {
    final zones = await JsonPartRepository.getModuleNames();
    final idx = zones.indexOf(currentZone);
    if (idx == -1) return null;
    return (idx + 1 < zones.length) ? zones[idx + 1] : null;
  }

  @override
  Widget build(BuildContext context) {
    final item = widget.renderItems[currentIndex];
    if (item.type != RenderItemType.part) {
      return const Scaffold(body: SizedBox());
    }

    return PageTransitionSwitcher(
      duration: const Duration(milliseconds: 250),
      transitionBuilder: buildScaleFadeTransition,
      child: _buildScaffold(item, item.title, 'Parts'),
    );
  }

  Widget _buildScaffold(RenderItem item, String partTitle, String zoneTitle) {
    final backZone =
        (widget.backExtra?['module'] as String?) ??
        (widget.backExtra?['zone'] as String?);

    return Scaffold(
      key: ValueKey(widget.transitionKey),
      body: Stack(
        fit: StackFit.expand,
        children: [
          Opacity(
            opacity: 0.2,
            child: Image.asset(
              'assets/images/deck_parts_montage.webp',
              fit: BoxFit.cover,
            ),
          ),
          Column(
            children: [
              CustomAppBarWidget(
                title: zoneTitle,
                showBackButton: true,
                showSearchIcon: true,
                showSettingsIcon: true,
                mobKey: mobKey,
                settingsKey: settingsKey,
                searchKey: searchKey,
                titleKey: titleKey,
                onBack: () {
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
                padding: const EdgeInsets.only(top: 12.0),
                child: Align(
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
                                    : 'Parts',
                            style: AppTheme.branchBreadcrumbStyle,
                          ),
                          const TextSpan(
                            text: ' / ',
                            style: TextStyle(color: Colors.black87),
                          ),
                          TextSpan(
                            // Chapter title now comes from async JSON repo; rendered from state.
                            text:
                                widget.detailRoute == DetailRoute.path
                                    ? _chapterTitle
                                    : backZone?.toTitleCase() ?? '',
                            style: AppTheme.groupBreadcrumbStyle,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              Padding(
                padding: const EdgeInsets.only(top: 4.0, bottom: 8.0),
                child: Text(
                  partTitle,
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
                onPrevious: () => _navigateTo(currentIndex - 1),
                onNext: () => _navigateTo(currentIndex + 1),
                customNextButton:
                    (currentIndex == widget.renderItems.length - 1)
                        ? LastGroupButton(
                          type: RenderItemType.part,
                          detailRoute: widget.detailRoute,
                          backExtra: widget.backExtra,
                          branchIndex: widget.branchIndex,
                          backDestination:
                              widget.detailRoute == DetailRoute.path
                                  ? '/learning-paths/${(widget.backExtra?['pathName'] as String).replaceAll(' ', '-').toLowerCase()}/items'
                                  : '/parts',
                          label:
                              widget.detailRoute == DetailRoute.path
                                  ? 'chapter'
                                  : 'zone',
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
                                  await JsonPathRepository.getNextChapter(
                                    pathName,
                                    chapterId,
                                  );
                              if (nextChapter == null) return null;

                              return await buildRenderItems(
                                ids:
                                    nextChapter.items
                                        .map((e) => e.pathItemId)
                                        .toList(),
                              );
                            } else {
                              final currentZone = backZone;
                              if (currentZone == null) return null;

                              final nextZoneId = await _nextZoneId(currentZone);
                              if (nextZoneId == null) return null;

                              final nextParts =
                                  await JsonPartRepository.getPartsForModule(
                                    nextZoneId,
                                  );
                              return await buildRenderItems(
                                ids: nextParts.map((e) => e['id']!).toList(),
                              );
                            }
                          },
                          onNavigateToNextGroup: (renderItems) async {
                            if (renderItems.isEmpty) return;

                            if (widget.detailRoute == DetailRoute.path) {
                              final pathName =
                                  widget.backExtra?['pathName'] as String?;
                              final chapterId =
                                  widget.backExtra?['chapterId'] as String?;
                              if (pathName == null || chapterId == null) return;

                              final nextChapter =
                                  await JsonPathRepository.getNextChapter(
                                    pathName,
                                    chapterId,
                                  );
                              if (nextChapter == null) return;

                              if (!mounted) return;

                              final route =
                                  '/learning-paths/${pathName.replaceAll(' ', '-').toLowerCase()}/items';

                              TransitionManager.goToDetailScreen(
                                context: context,
                                screenType: RenderItemType.part,
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
                              final currentZone =
                                  (widget.backExtra?['module'] as String?) ??
                                  (widget.backExtra?['zone'] as String?);
                              if (currentZone == null) return;

                              final nextZoneId = await _nextZoneId(currentZone);
                              if (nextZoneId == null) return;

                              if (!mounted) return;

                              TransitionManager.goToDetailScreen(
                                context: context,
                                screenType: RenderItemType.part,
                                renderItems: renderItems,
                                currentIndex: 0,
                                branchIndex: widget.branchIndex,
                                backDestination: '/parts/items',
                                backExtra: {
                                  'module': nextZoneId, // prefer `module`
                                  'zone': nextZoneId, // legacy crumb support
                                  'branchIndex': widget.branchIndex,
                                },
                                detailRoute: widget.detailRoute,
                                direction: SlideDirection.right,
                                replace: true,
                              );
                            }
                          },
                          onRestartAtFirstGroup: () async {
                            // Restart Parts flow at the first JSON zone
                            final zones =
                                await JsonPartRepository.getModuleNames();
                            if (zones.isEmpty) return;
                            final firstZoneId = zones.first;

                            final firstItems =
                                await JsonPartRepository.getPartsForModule(
                                  firstZoneId,
                                );
                            final items = await buildRenderItems(
                              ids: firstItems.map((e) => e['id']!).toList(),
                            );

                            if (!mounted || items.isEmpty) return;

                            TransitionManager.goToDetailScreen(
                              context: context,
                              screenType: RenderItemType.part,
                              renderItems: items,
                              currentIndex: 0,
                              branchIndex: widget.branchIndex,
                              backDestination: '/parts/items',
                              backExtra: {
                                'module': firstZoneId,
                                'zone': firstZoneId,
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
