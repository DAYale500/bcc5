import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:bcc5/widgets/custom_app_bar_widget.dart';
import 'package:bcc5/utils/logger.dart';

class FlashcardCategoryScreen extends StatelessWidget {
  const FlashcardCategoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    logger.i('🟦 Entered FlashcardCategoryScreen');

    return Column(
      children: [
        const CustomAppBarWidget(
          title: 'Flashcards',
          showBackButton: false,
          showSearchIcon: true,
          showSettingsIcon: true,
        ),
        Expanded(
          child: Center(
            child: ElevatedButton(
              onPressed: () {
                logger.i('📇 Navigating to FlashcardItemScreen');
                context.push(
                  '/flashcards/items',
                  extra: {'category': 'TestCategory'},
                );
              },
              child: const Text('View Flashcards'),
            ),
          ),
        ),
      ],
    );
  }
}
