import 'package:bcc5/data/models/render_item.dart';
import 'package:bcc5/data/repositories/flashcards/flashcard_repository_index.dart';
import 'package:bcc5/navigation/detail_route.dart';
import 'package:bcc5/theme/app_theme.dart';
import 'package:bcc5/theme/slide_direction.dart';
import 'package:bcc5/theme/transition_type.dart';
import 'package:bcc5/utils/logger.dart';
import 'package:bcc5/utils/render_item_helpers.dart';
import 'package:bcc5/utils/string_extensions.dart';
import 'package:bcc5/utils/transition_manager.dart';
import 'package:bcc5/widgets/custom_app_bar_widget.dart';
import 'package:bcc5/widgets/item_button.dart';
import 'package:bcc5/navigation/main_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class FlashcardItemScreen extends StatelessWidget {
  final String category;
  final GlobalKey harborKey;
  final GlobalKey coursesKey;
  final GlobalKey partsKey;
  final GlobalKey toolsKey;
  final GlobalKey drillsKey;

  const FlashcardItemScreen({
    super.key,
    required this.category,
    required this.harborKey,
    required this.coursesKey,
    required this.partsKey,
    required this.toolsKey,
    required this.drillsKey,
  });

  @override
  Widget build(BuildContext context) {
    final mobKey = GlobalKey(debugLabel: 'MOBKey');
    final settingsKey = GlobalKey(debugLabel: 'SettingsKey');
    final searchKey = GlobalKey(debugLabel: 'SearchKey');
    final titleKey = GlobalKey(debugLabel: 'TitleKey');

    logger.i('🟦 Entered FlashcardItemScreen for category: $category');

    final flashcards = getFlashcardsForCategory(category);
    final renderItems = buildRenderItems(
      ids: flashcards.map((fc) => fc.id).toList(),
    );
    final categoryTitle = category.toTitleCase();

    final appBar = CustomAppBarWidget(
      title: 'Drills',
      showBackButton: true,
      showSearchIcon: true,
      showSettingsIcon: true,
      mobKey: mobKey,
      settingsKey: settingsKey,
      searchKey: searchKey,
      titleKey: titleKey,
      onBack: () {
        logger.i('🔙 AppBar back from FlashcardItemScreen');
        context.go(
          '/flashcards',
          extra: {
            'slideFrom': SlideDirection.left,
            'transitionType': TransitionType.slide,
            'detailRoute': DetailRoute.branch,
          },
        );
      },
    );

    if (flashcards.isEmpty) {
      return MainScaffold(
        branchIndex: 4,
        harborKey: harborKey,
        coursesKey: coursesKey,
        partsKey: partsKey,
        toolsKey: toolsKey,
        drillsKey: drillsKey,
        child: Column(
          children: [
            appBar,
            const Expanded(
              child: Center(
                child: Text('No flashcards found for this category.'),
              ),
            ),
          ],
        ),
      );
    }

    return MainScaffold(
      branchIndex: 4,
      harborKey: harborKey,
      coursesKey: coursesKey,
      partsKey: partsKey,
      toolsKey: toolsKey,
      drillsKey: drillsKey,
      child: Column(
        children: [
          appBar,
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: 'Drills',
                      style: AppTheme.branchBreadcrumbStyle,
                    ),
                    const TextSpan(
                      text: ' / ',
                      style: TextStyle(color: Colors.black87),
                    ),
                    TextSpan(
                      text: categoryTitle,
                      style: AppTheme.groupBreadcrumbStyle,
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Dive into a challenge.',
            style: AppTheme.subheadingStyle.copyWith(
              color: AppTheme.primaryBlue,
            ),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 16),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: GridView.builder(
                itemCount: flashcards.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 4,
                  mainAxisSpacing: 4,
                  childAspectRatio: 2.8,
                ),
                itemBuilder: (context, index) {
                  final card = flashcards[index];
                  logger.i('📗 Rendering flashcard: ${card.title}');

                  return ItemButton(
                    label: card.title,
                    onTap: () {
                      logger.i('🟧 Tapped flashcard: ${card.title}');
                      TransitionManager.goToDetailScreen(
                        context: context,
                        screenType: RenderItemType.flashcard,
                        renderItems: renderItems,
                        currentIndex: index,
                        branchIndex: 4,
                        backDestination: '/flashcards/items',
                        backExtra: {'category': category, 'branchIndex': 4},
                        detailRoute: DetailRoute.branch,
                        direction: SlideDirection.right,
                        transitionType: TransitionType.slide,
                        replace: false,
                      );
                    },
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
