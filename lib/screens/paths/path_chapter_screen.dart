import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:bcc5/widgets/group_button.dart';
import 'package:bcc5/widgets/custom_app_bar_widget.dart';
import 'package:bcc5/data/repositories/paths/path_repository_index.dart';
import 'package:bcc5/utils/logger.dart';

class PathChapterScreen extends StatelessWidget {
  final String pathName;

  const PathChapterScreen({super.key, required this.pathName});

  @override
  Widget build(BuildContext context) {
    logger.i('🟢 Entered PathChapterScreen for "$pathName"');

    final titles = PathRepositoryIndex.getChapterTitles(pathName);
    logger.i('📚 Found ${titles.length} chapters for "$pathName": $titles');

    return Column(
      children: [
        const CustomAppBarWidget(
          title: 'Choose a Chapter',
          showBackButton: true,
          showSearchIcon: true,
          showSettingsIcon: true,
        ),
        Expanded(
          child:
              titles.isEmpty
                  ? const Center(child: Text('No chapters found.'))
                  : ListView.separated(
                    padding: const EdgeInsets.all(16),
                    itemCount: titles.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final title = titles[index];
                      final chapters = PathRepositoryIndex.getChaptersForPath(
                        pathName,
                      );
                      if (index >= chapters.length) {
                        logger.w(
                          '⚠️ Index $index out of range for chapters in "$pathName"',
                        );
                        return const SizedBox.shrink();
                      }

                      final chapter = chapters[index];
                      logger.i(
                        '🔹 Rendering button for chapter: ${chapter.id}',
                      );

                      return GroupButton(
                        label: title,
                        onTap: () {
                          logger.i('📗 Tapped Chapter: $title (${chapter.id})');
                          context.push(
                            '/learning-paths/${pathName.replaceAll(' ', '-').toLowerCase()}/items',
                            extra: {
                              'pathName': pathName,
                              'chapterId': chapter.id,
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
