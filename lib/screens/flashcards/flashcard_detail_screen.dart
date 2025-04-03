// 📄 lib/screens/flashcards/flashcard_detail_screen.dart

import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:bcc5/utils/logger.dart';
import 'package:bcc5/data/models/render_item.dart';
import 'package:bcc5/utils/render_item_helpers.dart';
import 'package:bcc5/widgets/flip_card_widget.dart';
import 'package:bcc5/widgets/navigation_buttons.dart';
import 'package:bcc5/theme/app_theme.dart';
import 'package:bcc5/widgets/custom_app_bar_widget.dart';

class FlashcardDetailScreen extends StatefulWidget {
  final Map<String, dynamic> extra;

  const FlashcardDetailScreen({super.key, required this.extra});

  @override
  State<FlashcardDetailScreen> createState() => _FlashcardDetailScreenState();
}

class _FlashcardDetailScreenState extends State<FlashcardDetailScreen>
    with SingleTickerProviderStateMixin {
  late List<RenderItem> renderItems;
  late int currentIndex;
  late int branchIndex;
  late String backDestination;
  Map<String, dynamic>? backExtra;
  bool showFront = true;
  late AnimationController _controller;
  late Animation<double> _flipAnimation;

  @override
  void initState() {
    super.initState();
    try {
      final ids = List<String>.from(widget.extra['sequenceIds'] ?? []);
      currentIndex = widget.extra['startIndex'] ?? 0;
      branchIndex = widget.extra['branchIndex'] ?? 4;
      backDestination = widget.extra['backDestination'] ?? '/';
      backExtra = widget.extra['backExtra'] as Map<String, dynamic>?;

      renderItems = buildRenderItems(ids: ids);
      if (renderItems[currentIndex].type != RenderItemType.flashcard) {
        throw Exception(
          '⛔ FlashcardDetailScreen received non-flashcard type at index $currentIndex',
        );
      }

      logger.i(
        '🟩 FlashcardDetailScreen Loaded:\n'
        '  ├─ index: $currentIndex\n'
        '  ├─ id: ${renderItems[currentIndex].id}\n'
        '  ├─ sequenceIds: $ids\n'
        '  ├─ branchIndex: $branchIndex\n'
        '  ├─ backDestination: $backDestination\n'
        '  └─ backExtra: $backExtra',
      );
    } catch (e, st) {
      logger.e(
        '❌ Error loading FlashcardDetailScreen',
        error: e,
        stackTrace: st,
      );
      renderItems = [];
      currentIndex = 0;
      branchIndex = 4;
      backDestination = '/';
      backExtra = null;
    }

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );

    _flipAnimation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void goTo(int newIndex) {
    if (newIndex >= 0 && newIndex < renderItems.length) {
      logger.i('🔁 Switched index: $currentIndex → $newIndex');
      final sequenceIds = renderItems.map((item) => item.id).toList();

      context.go(
        '/flashcards/detail',
        extra: {
          'sequenceIds': sequenceIds,
          'startIndex': newIndex,
          'branchIndex': branchIndex,
          'backDestination': backDestination,
          'backExtra': backExtra,
        },
      );
    } else {
      logger.w('⛔ Invalid navigation attempt: $newIndex');
    }
  }

  void flipCard() {
    logger.i(showFront ? '🔃 Flipping to back' : '🔃 Flipping to front');
    setState(() {
      showFront = !showFront;
      _controller.isCompleted || _controller.velocity > 0
          ? _controller.reverse()
          : _controller.forward();
    });
  }

  @override
  Widget build(BuildContext context) {
    if (renderItems.isEmpty || renderItems[currentIndex].flashcards.isEmpty) {
      return const Scaffold(
        body: Center(child: Text('No flashcard content available')),
      );
    }

    final flashcard = renderItems[currentIndex].flashcards.first;
    final title = flashcard.title;
    final sideA = flashcard.sideA;
    final sideB = flashcard.sideB;

    logger.i(
      '🖼️ Rendering Flashcard:\n'
      '  ├─ title: $title\n'
      '  ├─ sideA: ${sideA.length} blocks\n'
      '  └─ sideB: ${sideB.length} blocks',
    );

    return Stack(
      fit: StackFit.expand,
      children: [
        Image.asset('assets/images/fallback_image.jpeg', fit: BoxFit.cover),
        Column(
          children: [
            CustomAppBarWidget(
              title: title,
              showBackButton: true,
              showSearchIcon: true,
              showSettingsIcon: true,
              onBack: () {
                logger.i('🔙 Returning from FlashcardDetailScreen');
                if (context.canPop()) {
                  context.pop();
                } else {
                  context.go(backDestination, extra: backExtra);
                }
              },
            ),
            Expanded(
              child: Center(
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Image.asset(
                      'assets/images/index_card.png',
                      width: 500,
                      height: 450,
                      fit: BoxFit.fill,
                    ),
                    SizedBox(
                      width: 500,
                      height: 450,
                      child: AnimatedBuilder(
                        animation: _flipAnimation,
                        builder: (context, child) {
                          final isFront = _flipAnimation.value < 0.5;
                          return Transform(
                            alignment: Alignment.center,
                            transform: Matrix4.rotationY(
                              _flipAnimation.value * math.pi,
                            ),
                            child:
                                isFront
                                    ? FlipCardWidget(
                                      front: sideA,
                                      back: sideB,
                                      showFront: true,
                                      animation: _flipAnimation,
                                    )
                                    : Transform(
                                      alignment: Alignment.center,
                                      transform: Matrix4.rotationY(math.pi),
                                      child: FlipCardWidget(
                                        front: sideA,
                                        back: sideB,
                                        showFront: false,
                                        animation: _flipAnimation,
                                      ),
                                    ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: ElevatedButton(
                onPressed: flipCard,
                style: AppTheme.navigationButton,
                child: Text(showFront ? 'Flip Over' : 'Flip Back'),
              ),
            ),
            NavigationButtons(
              isPreviousEnabled: currentIndex > 0,
              isNextEnabled: currentIndex < renderItems.length - 1,
              onPrevious: () => goTo(currentIndex - 1),
              onNext: () => goTo(currentIndex + 1),
            ),
          ],
        ),
      ],
    );
  }
}
