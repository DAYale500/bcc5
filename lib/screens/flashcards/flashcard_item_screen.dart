import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:bcc5/widgets/custom_app_bar_widget.dart';
import 'package:bcc5/widgets/item_button.dart';
import 'package:bcc5/utils/logger.dart';

class FlashcardItemScreen extends StatelessWidget {
  final String category;

  const FlashcardItemScreen({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    logger.i('🟦 Entered FlashcardItemScreen for category: $category');

    // TO-DO: Replace with actual flashcard data filtering by category
    final List<String> dummyFlashcards = List.generate(
      10,
      (i) => 'Flashcard ${i + 1} - $category',
    );

    return Column(
      children: [
        const CustomAppBarWidget(
          title: 'Flashcards',
          showBackButton: true,
          showSearchIcon: true,
          showSettingsIcon: true,
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: GridView.builder(
              itemCount: dummyFlashcards.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 4,
                mainAxisSpacing: 4,
                childAspectRatio: 2.8,
              ),
              itemBuilder: (context, index) {
                final label = dummyFlashcards[index];
                return ItemButton(
                  label: label,
                  onTap: () {
                    logger.i('🟧 Tapped flashcard: $label');
                    context.push(
                      '/content',
                      extra: {
                        'title': label,
                        'content': [], // Replace with actual content
                        'backDestination': '/flashcards/items',
                        'backExtra': {'category': category},
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
