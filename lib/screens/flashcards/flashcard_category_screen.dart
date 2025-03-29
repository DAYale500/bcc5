import 'package:flutter/material.dart';
import 'package:bcc5/navigation/main_scaffold.dart';
import 'package:bcc5/widgets/custom_app_bar_widget.dart';
import 'package:bcc5/utils/logger.dart';

class FlashcardCategoryScreen extends StatelessWidget {
  const FlashcardCategoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    logger.i('🟦 Entered FlashcardCategoryScreen');

    return MainScaffold(
      branchIndex: 3,
      child: const Column(
        children: [
          CustomAppBarWidget(
            title: 'Flashcards',
            showBackButton: false,
            showSearchIcon: true,
            showSettingsIcon: true,
          ),
          Expanded(child: Center(child: Text('Flashcard Category Screen'))),
        ],
      ),
    );
  }
}
