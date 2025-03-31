import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:bcc5/widgets/custom_app_bar_widget.dart';
import 'package:bcc5/widgets/item_button.dart';
import 'package:bcc5/utils/logger.dart';
import 'package:bcc5/data/models/flashcard_model.dart';
import 'package:bcc5/data/repositories/flashcards/flashcard_repository.dart';

class FlashcardItemScreen extends StatelessWidget {
  final String category;

  const FlashcardItemScreen({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    logger.i('🟦 Entered FlashcardItemScreen for category: $category');

    final List<Flashcard> flashcards = getFlashcardsForCategory(category);
    logger.i(
      '📘 Loaded ${flashcards.length} flashcards for category: $category',
    );

    if (flashcards.isEmpty) {
      return Column(
        children: [
          CustomAppBarWidget(
            title: 'Flashcards',
            showBackButton: true,
            showSearchIcon: true,
            showSettingsIcon: true,
            onBack: () {
              logger.i('🔙 AppBar back from FlashcardItemScreen');
              context.go('/flashcards');
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
          title: 'Flashcards',
          showBackButton: true,
          showSearchIcon: true,
          showSettingsIcon: true,
          onBack: () {
            logger.i('🔙 AppBar back from FlashcardItemScreen');
            context.go('/flashcards');
          },
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(16),
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
                    context.push(
                      '/flashcards/detail',
                      extra: {
                        'sequenceTitles':
                            flashcards.map((f) => f.title).toList(),
                        'contentMap': {
                          for (var f in flashcards)
                            f.title: {'sideA': f.sideA, 'sideB': f.sideB},
                        },
                        'startIndex': index,
                        'branchIndex': 3,
                        'backDestination': '/flashcards/items/$category',
                        'backExtra': {'category': category, 'branchIndex': 3},
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
