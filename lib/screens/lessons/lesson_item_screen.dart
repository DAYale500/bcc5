import 'package:bcc5/theme/slide_direction.dart';
import 'package:bcc5/theme/transition_type.dart';
import 'package:bcc5/utils/transition_manager.dart';
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

  const LessonItemScreen({super.key, required this.module});

  @override
  Widget build(BuildContext context) {
    // logger.i('📘 LessonItemScreen loaded for module: $module');

    final lessons = LessonRepositoryIndex.getLessonsForModule(module);
    final renderItems = buildRenderItems(
      ids: lessons.map((l) => l.id).toList(),
    );
    final moduleTitle = module.toTitleCase();

    return Column(
      children: [
        CustomAppBarWidget(
          title: 'Courses',
          showBackButton: true,
          showSearchIcon: true,
          showSettingsIcon: true,
          onBack: () {
            logger.i('🔙 Back tapped → /lessons');
            context.go(
              '/lessons',
              extra: {
                'transitionKey':
                    'return_from_items_${DateTime.now().millisecondsSinceEpoch}',
                'slideFrom': SlideDirection.left,
                'transitionType': TransitionType.slide,
              },
            );
          },
        ),

        // 🧭 Breadcrumb below AppBar
        Padding(
          padding: const EdgeInsets.only(top: 16.0, left: 16.0, right: 16.0),
          child: Align(
            alignment: Alignment.centerLeft,
            child: RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: 'Courses',
                    style: AppTheme.branchBreadcrumbStyle,
                  ),
                  const TextSpan(
                    text: ' / ',
                    style: TextStyle(color: Colors.black87),
                  ),
                  TextSpan(
                    text: moduleTitle,
                    style: AppTheme.groupBreadcrumbStyle,
                  ),
                ],
              ),
            ),
          ),
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
            child: ListView.builder(
              itemCount: lessons.length,
              itemBuilder: (context, index) {
                final lesson = lessons[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                  child: ItemButton(
                    label: lesson.title,
                    onTap: () {
                      logger.i('📘 Tapped lesson: ${lesson.id}');
                      TransitionManager.goToDetailScreen(
                        context: context,
                        screenType: renderItems[index].type,
                        renderItems: renderItems,
                        currentIndex: index,
                        branchIndex: 1,
                        backDestination: '/lessons/items',
                        backExtra: {
                          'module': module,
                          'branchIndex': 1,
                          'detailRoute': DetailRoute.branch,
                        },
                        detailRoute: DetailRoute.branch,
                        direction: SlideDirection.right,
                        transitionType: TransitionType.slide,
                        replace: false,
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}
