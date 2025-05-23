import 'package:bcc5/data/models/render_item.dart';
import 'package:bcc5/data/repositories/flashcards/flashcard_repository_index.dart';
import 'package:bcc5/navigation/detail_route.dart';
import 'package:bcc5/theme/slide_direction.dart';
import 'package:bcc5/theme/transition_type.dart';
import 'package:bcc5/utils/string_extensions.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:bcc5/widgets/custom_app_bar_widget.dart';
import 'package:bcc5/utils/logger.dart';
import 'package:bcc5/theme/app_theme.dart';

class FlashcardCategoryScreen extends StatelessWidget {
  const FlashcardCategoryScreen({super.key});

  static const double appBarOffset = 80.0;

  @override
  Widget build(BuildContext context) {
    logger.i('🟦 Entered FlashcardCategoryScreen');

    final categories = getAllCategories();
    final sorted = [
      ...categories.where((c) => c == 'all' || c == 'random'),
      ...categories.where((c) => c != 'all' && c != 'random'),
    ];
    // logger.i('📇 Sorted flashcard categories: $sorted');

    // 🔑 Internally managed GlobalKeys
    final mobKey = GlobalKey(debugLabel: 'MOBKey');
    final settingsKey = GlobalKey(debugLabel: 'SettingsKey');
    final searchKey = GlobalKey(debugLabel: 'SearchKey');
    final titleKey = GlobalKey(debugLabel: 'TitleKey');

    return Stack(
      fit: StackFit.expand,
      children: [
        // AppBar
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: CustomAppBarWidget(
            title: 'Drills',
            showBackButton: false,
            showSearchIcon: true,
            showSettingsIcon: true,
            mobKey: mobKey,
            settingsKey: settingsKey,
            searchKey: searchKey,
            titleKey: titleKey,
          ),
        ),

        // 🔽 Breadcrumb: Insert right here
        const Positioned(
          top: appBarOffset + 30,
          left: 16,
          right: 16,
          child: Text(
            'Drills',
            style: AppTheme.branchBreadcrumbStyle,
            textAlign: TextAlign.left,
          ),
        ),

        // Instruction text
        Positioned(
          top: appBarOffset + 32,
          left: 62,
          right: 62,
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 2),
            decoration: BoxDecoration(
              color: Colors.white.withAlpha(217),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: Text(
                'Pick a Challenge!',
                style: AppTheme.subheadingStyle.copyWith(
                  color: AppTheme.primaryBlue,
                ),
              ),
            ),
          ),
        ),

        // Category buttons
        Positioned.fill(
          top: appBarOffset + 100,
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Center(
              child: Wrap(
                spacing: 12,
                runSpacing: 12,
                children:
                    sorted.map((category) {
                      final isSpecial =
                          category == 'all' || category == 'random';
                      final style =
                          isSpecial
                              ? AppTheme.highlightedGroupButtonStyle
                              : ElevatedButton.styleFrom(
                                backgroundColor: AppTheme.groupButtonUnselected,
                                padding: AppTheme.groupButtonPadding,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                    AppTheme.buttonCornerRadius,
                                  ),
                                ),
                              );

                      return SizedBox(
                        width: 160,
                        child: ElevatedButton(
                          onPressed: () {
                            logger.i('🟥 Tapped flashcard category: $category');

                            final flashcards = getFlashcardsForCategory(
                              category,
                            );
                            if (flashcards.isEmpty) {
                              logger.w(
                                '⚠️ No flashcards found in category: $category',
                              );
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    'No flashcards found in this category.',
                                  ),
                                ),
                              );
                              return;
                            }

                            final renderItems =
                                flashcards
                                    .map(RenderItem.fromFlashcard)
                                    .toList();

                            context.push(
                              '/flashcards/detail',
                              extra: {
                                'renderItems': renderItems,
                                'currentIndex': 0,
                                'branchIndex': 4,
                                'backDestination': '/flashcards',
                                'backExtra': {
                                  'category': category,
                                  'branchIndex': 4,
                                },
                                'transitionKey':
                                    'flashcards_detail_${category}_${DateTime.now().millisecondsSinceEpoch}',
                                'slideFrom': SlideDirection.right,
                                'transitionType': TransitionType.slide,
                                'detailRoute': DetailRoute.branch,
                              },
                            );
                          },
                          style: style,
                          child: Text(
                            category.toTitleCase(),
                            style: AppTheme.buttonTextStyle,
                            textAlign: TextAlign.center,
                          ),
                        ),
                      );
                    }).toList(),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
