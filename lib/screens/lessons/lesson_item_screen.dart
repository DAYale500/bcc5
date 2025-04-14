import 'package:bcc5/theme/slide_direction.dart';
import 'package:bcc5/theme/transition_type.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:bcc5/widgets/custom_app_bar_widget.dart';
import 'package:bcc5/widgets/item_button.dart';
import 'package:bcc5/utils/logger.dart';
import 'package:bcc5/data/repositories/lessons/lesson_repository_index.dart';
import 'package:bcc5/utils/render_item_helpers.dart';
import 'package:bcc5/theme/app_theme.dart';
import 'package:bcc5/utils/string_extensions.dart';
import 'package:bcc5/navigation/detail_route.dart';

class LessonItemScreen extends StatelessWidget {
  final String module;

  const LessonItemScreen({
    super.key,
    required this.module,
    required this.mobKey,
    required this.settingsKey,
    required this.searchKey,
    required this.titleKey,
  });

  final GlobalKey mobKey;
  final GlobalKey settingsKey;
  final GlobalKey searchKey;
  final GlobalKey titleKey;

  @override
  Widget build(BuildContext context) {
    logger.i('📘 LessonItemScreen loaded for module: $module');
    final lessons = LessonRepositoryIndex.getLessonsForModule(module);
    final lessonIds = lessons.map((l) => l.id).toList();
    final renderItems = buildRenderItems(ids: lessonIds);

    final moduleTitle = module.toTitleCase();

    return Column(
      children: [
        CustomAppBarWidget(
          title: 'Courses',
          showBackButton: true,
          showSearchIcon: true,
          showSettingsIcon: true,
          mobKey: mobKey,
          settingsKey: settingsKey,
          searchKey: searchKey,
          titleKey: titleKey,
          onBack: () {
            logger.i('🔙 Back tapped → /lessons');
            context.go(
              '/lessons',
              extra: {
                'transitionKey':
                    'return_from_items_${DateTime.now().millisecondsSinceEpoch}',
                'slideFrom': SlideDirection.left,
                'transitionType': TransitionType.slide,
                'mobKey': mobKey,
                'settingsKey': settingsKey,
                'searchKey': searchKey,
                'titleKey': titleKey,
              },
            );
          },
        ),

        const SizedBox(height: 16),
        Text(
          '$moduleTitle:\nDive in to any course below.',
          style: AppTheme.subheadingStyle.copyWith(color: AppTheme.primaryBlue),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 16),
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
                final timestamp = DateTime.now().millisecondsSinceEpoch;

                return ItemButton(
                  label: lesson.title,
                  onTap: () {
                    logger.i('📘 Tapped lesson: ${lesson.id}');
                    final transitionKey = 'lesson_${lesson.id}_$timestamp';

                    context.push(
                      '/lessons/detail',
                      extra: {
                        'renderItems': renderItems,
                        'currentIndex': index,
                        'branchIndex': 1,
                        'detailRoute': DetailRoute.branch,
                        'backDestination': '/lessons/items',
                        'backExtra': {
                          'module': module,
                          'branchIndex': 1,
                          'mobKey': mobKey,
                          'settingsKey': settingsKey,
                          'searchKey': searchKey,
                          'titleKey': titleKey,
                          'transitionKey':
                              transitionKey, // ✅ Ensures LessonItemScreen can be matched on return
                        },
                        'transitionKey': transitionKey,
                        'transitionType': TransitionType.slide,
                        'slideFrom': SlideDirection.right,
                        'mobKey': mobKey,
                        'settingsKey': settingsKey,
                        'searchKey': searchKey,
                        'titleKey': titleKey,
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
