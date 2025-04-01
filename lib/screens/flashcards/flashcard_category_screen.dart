import 'package:bcc5/data/repositories/flashcards/flashcard_repository_index.dart';
import 'package:bcc5/widgets/item_button.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:bcc5/widgets/custom_app_bar_widget.dart';
import 'package:bcc5/utils/logger.dart';

class FlashcardCategoryScreen extends StatelessWidget {
  const FlashcardCategoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    logger.i('🟦 Entered FlashcardCategoryScreen');

    final categories = getAllCategories();
    logger.i(
      '📇 Loaded ${categories.length} flashcard categories: $categories',
    );

    return Column(
      children: [
        const CustomAppBarWidget(
          title: 'Flashcards',
          showBackButton: false,
          showSearchIcon: true,
          showSettingsIcon: true,
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: ListView.separated(
              itemCount: categories.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final category = categories[index];
                return ItemButton(
                  label: category[0].toUpperCase() + category.substring(1),
                  onTap: () {
                    logger.i('🟥 Tapped flashcard category: $category');
                    context.push(
                      '/flashcards/items/$category',
                      extra: {'category': category},
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
