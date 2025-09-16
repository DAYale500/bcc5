import 'package:bcc5/data/models/render_item.dart';
import 'package:bcc5/theme/slide_direction.dart';
import 'package:bcc5/theme/transition_type.dart';
import 'package:bcc5/utils/transition_manager.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:bcc5/widgets/custom_app_bar_widget.dart';
import 'package:bcc5/widgets/item_button.dart';
import 'package:bcc5/utils/logger.dart';
// import 'package:bcc5/data/repositories/lessons/lesson_repository_index.dart';
import 'package:bcc5/utils/render_item_helpers.dart';
import 'package:bcc5/theme/app_theme.dart';
import 'package:bcc5/utils/string_extensions.dart';
import 'package:bcc5/navigation/detail_route.dart';
import 'package:bcc5/data/repositories/lessons/json_lesson_index.dart';

class LessonItemScreen extends StatelessWidget {
  final String module;

  const LessonItemScreen({super.key, required this.module});

  @override
  Widget build(BuildContext context) {
    final moduleTitle = module.toTitleCase();

    return FutureBuilder<List<Map<String, String>>>(
      future: JsonLessonIndex.getLessonsForModule(module),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        final items = snapshot.data!; // [{id,title}, ...]
        final ids = items.map((e) => e['id']!).toList();

        return FutureBuilder<List<RenderItem>>(
          future: buildRenderItems(ids: ids),
          builder: (context, renderSnap) {
            if (!renderSnap.hasData) {
              return const Center(child: CircularProgressIndicator());
            }
            final renderItems = renderSnap.data!;

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
                Padding(
                  padding: const EdgeInsets.only(
                    top: 16.0,
                    left: 16.0,
                    right: 16.0,
                  ),
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
                  style: AppTheme.subheadingStyle.copyWith(
                    color: AppTheme.primaryBlue,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: ListView.builder(
                      itemCount: items.length,
                      itemBuilder: (context, index) {
                        final id = items[index]['id']!;
                        final title = items[index]['title'] ?? id;
                        logger.i('🧭 Module $module → ${items.length} items');
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4.0),
                          child: ItemButton(
                            label: title,
                            onTap: () {
                              logger.i('📘 Tapped lesson: $id');
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
          },
        );
      },
    );
  }
}
