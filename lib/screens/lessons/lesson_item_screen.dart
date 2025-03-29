import 'package:bcc5/data/repositories/lessons/lesson_repository_index.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:bcc5/navigation/main_scaffold.dart';
import 'package:bcc5/widgets/item_button.dart';
import 'package:bcc5/widgets/custom_app_bar_widget.dart'; // 🟠 Added
import 'package:bcc5/utils/logger.dart';

class LessonItemScreen extends StatelessWidget {
  final String module;

  const LessonItemScreen({super.key, required this.module});

  @override
  Widget build(BuildContext context) {
    logger.i('📘 LessonItemScreen loaded for module: $module');
    const int branchIndex = 1;
    final lessons = LessonRepositoryIndex.getLessonsForModule(module);

    return PopScope(
      canPop: true,
      onPopInvokedWithResult: (didPop, context) {
        if (didPop == true && context is BuildContext) {
          logger.i('🔙 Back button pressed on LessonItemScreen');
          context.go('/lessons');
        }
      },
      child: MainScaffold(
        branchIndex: branchIndex,
        child: Column(
          children: [
            const CustomAppBarWidget(
              title: 'Lessons',
              showBackButton: true,
              showSearchIcon: true,
              showSettingsIcon: true,
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: GridView.builder(
                  shrinkWrap: true,
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
                            'contentId': lesson.id,
                            'contentType': 'lesson',
                            'backDestination': '/lessons',
                            'backExtra': {
                              'module': module,
                              'branchIndex': branchIndex,
                            },
                            'sequenceList': lessons,
                            'branchIndex': index,
                          },
                        );
                      },
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
