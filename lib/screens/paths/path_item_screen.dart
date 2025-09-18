// lib/screens/paths/path_item_screen.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:bcc5/data/models/path_model.dart';
import 'package:bcc5/data/models/render_item.dart';
import 'package:bcc5/data/repositories/paths/json_path_repository.dart';
import 'package:bcc5/theme/app_theme.dart';
import 'package:bcc5/theme/slide_direction.dart';
import 'package:bcc5/theme/transition_type.dart';
import 'package:bcc5/navigation/detail_route.dart';
import 'package:bcc5/widgets/custom_app_bar_widget.dart';
import 'package:bcc5/widgets/item_button.dart';
import 'package:bcc5/widgets/navigation/path_ending_actions.dart';
import 'package:bcc5/utils/logger.dart';
import 'package:bcc5/utils/render_item_helpers.dart';
import 'package:bcc5/utils/string_extensions.dart';
import 'package:bcc5/utils/transition_manager.dart';

class PathItemScreen extends StatefulWidget {
  final String pathName;
  final String chapterId;

  const PathItemScreen({
    super.key,
    required this.pathName,
    required this.chapterId,
  });

  @override
  State<PathItemScreen> createState() => _PathItemScreenState();
}

class _ChapterData {
  final LearningPathChapter chapter;
  final List<RenderItem> items;
  final List<String> missingIds;
  final bool isLastChapter;

  _ChapterData({
    required this.chapter,
    required this.items,
    required this.missingIds,
    required this.isLastChapter,
  });
}

class _PathItemScreenState extends State<PathItemScreen> {
  final GlobalKey mobKey = GlobalKey(debugLabel: 'MOBKey');
  final GlobalKey settingsKey = GlobalKey(debugLabel: 'SettingsKey');
  final GlobalKey searchKey = GlobalKey(debugLabel: 'SearchKey');
  final GlobalKey titleKey = GlobalKey(debugLabel: 'TitleKey');

  late final Future<_ChapterData> _dataFuture;

  @override
  void initState() {
    super.initState();
    _dataFuture = _load();
  }

  Future<_ChapterData> _load() async {
    final chapter = await JsonPathRepository.getChapterById(
      widget.pathName,
      widget.chapterId,
    );
    if (chapter == null) {
      throw StateError(
        'Could not find chapter "${widget.chapterId}" in path "${widget.pathName}".',
      );
    }

    final ids = chapter.items.map((e) => e.pathItemId).toList();
    final items = await buildRenderItems(ids: ids);

    // Figure out what couldn't be resolved so we can inform the user.
    final resolved = items.map((e) => e.id).toSet();
    final missing = ids.where((id) => !resolved.contains(id)).toList();

    final chapters = await JsonPathRepository.getChaptersForPath(
      widget.pathName,
    );
    final isLast = chapters.isNotEmpty && chapters.last.id == widget.chapterId;

    if (missing.isNotEmpty) {
      logger.w('⚠️ Chapter "${chapter.id}" missing items: $missing');
    }

    return _ChapterData(
      chapter: chapter,
      items: items,
      missingIds: missing,
      isLastChapter: isLast,
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<_ChapterData>(
      future: _dataFuture,
      builder: (context, snap) {
        if (snap.connectionState != ConnectionState.done) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        if (snap.hasError) {
          logger.e('❌ PathItemScreen load error', error: snap.error);
          return Scaffold(
            body: Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Text(
                  'There was a problem loading this chapter.\n\n${snap.error}',
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          );
        }

        final data = snap.data!;
        final chapter = data.chapter;
        final renderItems = data.items;

        return Column(
          children: [
            CustomAppBarWidget(
              title: widget.pathName.toTitleCase(),
              showBackButton: true,
              showSearchIcon: true,
              showSettingsIcon: true,
              mobKey: mobKey,
              settingsKey: settingsKey,
              searchKey: searchKey,
              titleKey: titleKey,
              onBack: () {
                logger.i('🔙 Returning to PathChapterScreen');
                context.go(
                  '/learning-paths/${widget.pathName.replaceAll(' ', '-').toLowerCase()}',
                  extra: {
                    'slideFrom': SlideDirection.left,
                    'transitionType': TransitionType.slide,
                    'detailRoute': DetailRoute.path,
                  },
                );
              },
            ),

            const SizedBox(height: 16),
            Text(
              chapter.title,
              style: AppTheme.headingStyle.copyWith(
                fontSize: 20,
                color: AppTheme.primaryBlue,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),

            if (renderItems.length > 1)
              Text(
                'Select a starting point',
                style: AppTheme.subheadingStyle.copyWith(
                  color: AppTheme.primaryBlue,
                ),
                textAlign: TextAlign.center,
              ),

            if (data.missingIds.isNotEmpty) ...[
              const SizedBox(height: 12),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: _MissingIdsNotice(missing: data.missingIds),
              ),
            ],

            const SizedBox(height: 16),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child:
                    renderItems.isEmpty
                        ? const _EmptyChapter()
                        : ListView.separated(
                          itemCount: renderItems.length,
                          separatorBuilder:
                              (context, index) => const SizedBox(height: 8),
                          itemBuilder: (context, index) {
                            final item = renderItems[index];
                            return ItemButton(
                              label: item.title,
                              onTap: () {
                                logger.i('🟦 Tapped PathItem → ${item.title}');
                                TransitionManager.goToDetailScreen(
                                  context: context,
                                  screenType: item.type,
                                  renderItems: renderItems,
                                  currentIndex: index,
                                  branchIndex: 0,
                                  backDestination:
                                      '/learning-paths/${widget.pathName.replaceAll(' ', '-').toLowerCase()}/items',
                                  backExtra: {
                                    'pathName': widget.pathName,
                                    'chapterId': widget.chapterId,
                                  },
                                  detailRoute: DetailRoute.path,
                                  direction: SlideDirection.right,
                                  transitionType: TransitionType.slide,
                                );
                              },
                            );
                          },
                        ),
              ),
            ),

            if (chapter.showFlashcardEnding && data.isLastChapter)
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: PathEndingActions(
                  pathName: widget.pathName,
                  chapterId: widget.chapterId,
                ),
              ),
          ],
        );
      },
    );
  }
}

class _EmptyChapter extends StatelessWidget {
  const _EmptyChapter();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('This chapter has no available items yet.'),
    );
  }
}

class _MissingIdsNotice extends StatelessWidget {
  final List<String> missing;
  const _MissingIdsNotice({required this.missing});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.primaryBlue.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.all(12),
      child: Text(
        'Some items couldn’t be loaded:\n• ${missing.join('\n• ')}',
        style: AppTheme.subheadingStyle.copyWith(fontSize: 13),
      ),
    );
  }
}
