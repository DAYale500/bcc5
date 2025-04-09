import 'package:bcc5/navigation/detail_route.dart';
import 'package:bcc5/theme/slide_direction.dart';
import 'package:bcc5/theme/transition_type.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:bcc5/widgets/group_button.dart';
import 'package:bcc5/widgets/custom_app_bar_widget.dart';
import 'package:bcc5/data/repositories/paths/path_repository_index.dart';
import 'package:bcc5/utils/logger.dart';
import 'package:bcc5/theme/app_theme.dart'; // ✅ Needed for AppTheme.primaryBlue
import 'package:bcc5/utils/string_extensions.dart'; // needed for title case

class PathChapterScreen extends StatelessWidget {
  final String pathName;

  const PathChapterScreen({super.key, required this.pathName});

  @override
  Widget build(BuildContext context) {
    logger.i('🟢 Entered PathChapterScreen for "$pathName"');

    final chapters = PathRepositoryIndex.getChaptersForPath(pathName);
    final titles = PathRepositoryIndex.getChapterTitles(pathName);
    logger.i('📚 Found ${titles.length} chapters for "$pathName"');

    return Column(
      children: [
        CustomAppBarWidget(
          title: pathName.toTitleCase(),
          showBackButton: true,
          showSearchIcon: true,
          showSettingsIcon: true,
          onBack: () {
            logger.i('🔙 Back tapped from PathChapterScreen');
            context.go(
              '/',
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
          'Navigate these in any order you want - circle back to any chapter at any time.',
          style: AppTheme.subheadingStyle.copyWith(color: AppTheme.primaryBlue),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 16),
        Expanded(
          child:
              titles.isEmpty
                  ? const Center(child: Text('No chapters found.'))
                  : ListView.separated(
                    padding: const EdgeInsets.all(16),
                    itemCount: titles.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      if (index >= chapters.length) {
                        logger.w(
                          '⚠️ Index $index out of range for chapters in "$pathName"',
                        );
                        return const SizedBox.shrink();
                      }

                      final title = titles[index];
                      final chapter = chapters[index];

                      return GroupButton(
                        label: title,
                        onTap: () {
                          logger.i('📗 Tapped Chapter: $title (${chapter.id})');
                          final timestamp =
                              DateTime.now().millisecondsSinceEpoch;
                          context.push(
                            '/learning-paths/${pathName.replaceAll(' ', '-').toLowerCase()}/items',
                            extra: {
                              'pathName': pathName,
                              'chapterId': chapter.id,
                              'transitionKey':
                                  'path_items_${chapter.id}_$timestamp',
                              'slideFrom': SlideDirection.right,
                              'detailRoute': DetailRoute.path,
                              'transitionType': TransitionType.slide,
                            },
                          );
                        },
                      );
                    },
                  ),
        ),
      ],
    );
  }
}
