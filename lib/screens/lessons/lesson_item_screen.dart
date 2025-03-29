import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:bcc5/widgets/custom_app_bar_widget.dart';
import 'package:bcc5/widgets/item_button.dart';
import 'package:bcc5/utils/logger.dart';
import 'package:bcc5/data/repositories/lessons/lesson_repository_index.dart';

class LessonItemScreen extends StatelessWidget {
  final String module;

  const LessonItemScreen({super.key, required this.module});

  @override
  Widget build(BuildContext context) {
    logger.i('📘 LessonItemScreen loaded for module: $module');
    final lessons = LessonRepositoryIndex.getLessonsForModule(module);

    return Column(
      children: [
        CustomAppBarWidget(
          title: 'Lessons',
          showBackButton: true,
          showSearchIcon: true,
          showSettingsIcon: true,
          onBack: () {
            logger.i('🔙 AppBar back from LessonItemScreen');
            context.go('/lessons');
          },
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: GridView.builder(
              itemCount: lessons.length,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 4,
                mainAxisSpacing: 4,
                childAspectRatio: 2.8,
              ),
              itemBuilder: (context, index) {
                final lesson = lessons[index];
                return ItemButton(
                  label: lesson.title,
                  onTap: () {
                    logger.i('📘 Tapped lesson: ${lesson.id}');
                    context.push(
                      '/content',
                      extra: {
                        'sequenceTitles': lessons.map((l) => l.title).toList(),
                        'contentMap': {
                          for (var l in lessons) l.title: l.content,
                        },
                        'startIndex': index,
                        'branchIndex': 1,
                        'backDestination': '/lessons/items',
                        'backExtra': {'module': module, 'branchIndex': 1},
                      },
                    );
                  },
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}
