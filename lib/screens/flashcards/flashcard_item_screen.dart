import 'package:bcc5/theme/slide_direction.dart';
import 'package:bcc5/theme/transition_type.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:bcc5/widgets/custom_app_bar_widget.dart';
import 'package:bcc5/widgets/item_button.dart';
import 'package:bcc5/utils/logger.dart';
import 'package:bcc5/theme/app_theme.dart';
import 'package:bcc5/utils/string_extensions.dart';
import 'package:bcc5/data/models/flashcard_model.dart';
import 'package:bcc5/data/repositories/flashcards/flashcard_repository_index.dart';
import 'package:bcc5/utils/render_item_helpers.dart'; // ✅ needed for buildRenderItems
import 'package:bcc5/navigation/detail_route.dart'; // ✅ PATCHED

class FlashcardItemScreen extends StatelessWidget {
  final String category;

  const FlashcardItemScreen({super.key, required this.category});

  static const double appBarOffset = 80.0;

  @override
  Widget build(BuildContext context) {
    logger.i('🟦 Entered FlashcardItemScreen for category: $category');

    final List<Flashcard> flashcards = getFlashcardsForCategory(category);
    final renderItems = buildRenderItems(
      ids: flashcards.map((fc) => fc.id).toList(),
    );

    logger.i(
      '📘 Loaded ${flashcards.length} flashcards for category: $category',
    );

    final titleCaseCategory = category.toTitleCase();

    if (flashcards.isEmpty) {
      return Column(
        children: [
          CustomAppBarWidget(
            title: titleCaseCategory,
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
                  'detailRoute':
                      DetailRoute
                          .branch, // optional if TransitionManager relies on it
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

    return Stack(
      fit: StackFit.expand,
      children: [
        // 🔵 AppBar
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: CustomAppBarWidget(
            title: titleCaseCategory,
            showBackButton: true,
            showSearchIcon: true,
            showSettingsIcon: true,
            onBack: () {
              logger.i('🔙 AppBar back from FlashcardItemScreen');
              context.go('/flashcards');
            },
          ),
        ),

        // 🧭 Instruction Text
        Positioned(
          top: appBarOffset + 32,
          left: 32,
          right: 32,
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
            decoration: BoxDecoration(
              color: Colors.white.withAlpha(217),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: Text(
                'Choose a Flashcard',
                style: AppTheme.subheadingStyle.copyWith(
                  color: AppTheme.primaryBlue,
                ),
              ),
            ),
          ),
        ),

        // 🧩 Flashcard Grid
        Positioned.fill(
          top: appBarOffset + 100,
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
                    final timestamp = DateTime.now().millisecondsSinceEpoch;
                    context.push(
                      '/flashcards/detail',
                      extra: {
                        'renderItems': renderItems,
                        'currentIndex': index,
                        'branchIndex': 4,
                        'backDestination': '/flashcards/items',
                        'backExtra': {'category': category},
                        'transitionKey': 'flashcard_detail_${index}_$timestamp',
                        'detailRoute': DetailRoute.branch,
                        'slideFrom': SlideDirection.right, // ✅ NEW
                        'transitionType': TransitionType.slide, // ✅ NEW
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
