// lib/screens/parts/part_item_screen.dart
import 'package:bcc5/data/models/render_item.dart';
import 'package:bcc5/data/repositories/parts/json_part_repository.dart';
import 'package:bcc5/theme/slide_direction.dart';
import 'package:bcc5/theme/transition_type.dart';
import 'package:bcc5/utils/string_extensions.dart';
import 'package:bcc5/utils/transition_manager.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:bcc5/widgets/custom_app_bar_widget.dart';
import 'package:bcc5/widgets/item_button.dart';
import 'package:bcc5/utils/logger.dart';
import 'package:bcc5/utils/render_item_helpers.dart';
import 'package:bcc5/theme/app_theme.dart';
import 'package:bcc5/navigation/detail_route.dart';

class PartItemScreen extends StatelessWidget {
  final String module; // e.g., "hull", "deck", "rigging", ...
  const PartItemScreen({super.key, required this.module});

  @override
  Widget build(BuildContext context) {
    final moduleTitle = module.toTitleCase();

    return FutureBuilder<List<Map<String, String>>>(
      future: JsonPartRepository.getPartsForModule(module),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        final items = snapshot.data!; // [{id,title}, ...]
        logger.i('🧭 Parts module "$module" → ${items.length} items');

        final ids = items.map((e) => e['id']!).toList();

        return FutureBuilder<List<RenderItem>>(
          future: buildRenderItems(ids: ids),
          builder: (context, renderSnap) {
            if (!renderSnap.hasData) {
              return const Scaffold(
                body: Center(child: CircularProgressIndicator()),
              );
            }
            final renderItems = renderSnap.data!;

            return Column(
              children: [
                CustomAppBarWidget(
                  title: 'Parts',
                  showBackButton: true,
                  showSearchIcon: true,
                  showSettingsIcon: true,
                  onBack: () {
                    logger.i('🔙 Back tapped → /parts');
                    context.go(
                      '/parts',
                      extra: {
                        'slideFrom': SlideDirection.left,
                        'transitionType': TransitionType.slide,
                        'detailRoute': DetailRoute.branch,
                      },
                    );
                  },
                ),
                const SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: 'Parts',
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
                const SizedBox(height: 12),
                Text(
                  'Choose a Part',
                  style: AppTheme.subheadingStyle.copyWith(
                    color: AppTheme.primaryBlue,
                  ),
                ),
                const SizedBox(height: 12),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: ListView.builder(
                      itemCount: items.length,
                      itemBuilder: (context, index) {
                        final id = items[index]['id']!;
                        final title = items[index]['title'] ?? id;

                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4.0),
                          child: ItemButton(
                            label: title,
                            onTap: () {
                              logger.i('🟥 Part tapped: $id');
                              TransitionManager.goToDetailScreen(
                                context: context,
                                screenType: renderItems[index].type,
                                renderItems: renderItems,
                                currentIndex: index,
                                branchIndex: 2,
                                backDestination: '/parts/items',
                                backExtra: {'module': module},
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
