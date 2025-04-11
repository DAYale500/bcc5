import 'package:bcc5/data/repositories/flashcards/flashcard_repository_index.dart';
import 'package:bcc5/navigation/detail_route.dart';
import 'package:bcc5/theme/app_theme.dart';
import 'package:bcc5/theme/slide_direction.dart';
import 'package:bcc5/theme/transition_type.dart';
import 'package:bcc5/utils/logger.dart';
import 'package:bcc5/utils/render_item_helpers.dart';
import 'package:bcc5/utils/string_extensions.dart';
import 'package:bcc5/widgets/custom_app_bar_widget.dart';
import 'package:bcc5/widgets/item_button.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class FlashcardItemScreen extends StatelessWidget {
  final String category;

  const FlashcardItemScreen({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    logger.i('🟦 Entered FlashcardItemScreen for category: $category');

    final flashcards = getFlashcardsForCategory(category);
    final renderItems = buildRenderItems(
      ids: flashcards.map((fc) => fc.id).toList(),
    );
    final categoryTitle = category.toTitleCase();

    if (flashcards.isEmpty) {
      return Column(
        children: [
          CustomAppBarWidget(
            title: 'Drills',
            showBackButton: true,
            showSearchIcon: true,
            showSettingsIcon: true,
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
          ),
          const Expanded(
            child: Center(
              child: Text('No flashcards found for this category.'),
            ),
          ),
        ],
      );
    }

    return Column(
      children: [
        CustomAppBarWidget(
          title: 'Drills',
          showBackButton: true,
          showSearchIcon: true,
          showSettingsIcon: true,
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
        ),
        const SizedBox(height: 16),
        Text(
          '$categoryTitle:\nDive into a challenge.',
          style: AppTheme.subheadingStyle.copyWith(color: AppTheme.primaryBlue),
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
                final timestamp = DateTime.now().millisecondsSinceEpoch;

                return ItemButton(
                  label: card.title,
                  onTap: () {
                    logger.i('🟧 Tapped flashcard: ${card.title}');
                    context.push(
                      '/flashcards/detail',
                      extra: {
                        'renderItems': renderItems,
                        'currentIndex': index,
                        'branchIndex': 4,
                        'backDestination': '/flashcards/items',
                        'backExtra': {'category': category, 'branchIndex': 4},
                        'transitionKey': 'flashcard_detail_${index}_$timestamp',
                        'detailRoute': DetailRoute.branch,
                        'transitionType': TransitionType.slide,
                        'slideFrom': SlideDirection.right,
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
