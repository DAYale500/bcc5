import 'dart:math' as math;
import 'package:bcc5/utils/string_extensions.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:bcc5/data/models/render_item.dart';
import 'package:bcc5/utils/logger.dart';
import 'package:bcc5/widgets/flip_card_widget.dart';
import 'package:bcc5/widgets/navigation_buttons.dart';
import 'package:bcc5/theme/app_theme.dart';
import 'package:bcc5/widgets/custom_app_bar_widget.dart';

class FlashcardDetailScreen extends StatefulWidget {
  final List<RenderItem> renderItems;
  final int currentIndex;
  final int branchIndex;
  final String backDestination;
  final Map<String, dynamic>? backExtra;

  const FlashcardDetailScreen({
    super.key,
    required this.renderItems,
    required this.currentIndex,
    required this.branchIndex,
    required this.backDestination,
    this.backExtra,
  });

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

    renderItems = widget.renderItems;
    currentIndex = widget.currentIndex;
    branchIndex = widget.branchIndex;
    backDestination = widget.backDestination;
    backExtra = widget.backExtra;

    if (renderItems.isEmpty) {
      logger.e('❌ FlashcardDetailScreen received empty renderItems');
    } else {
      final item = renderItems[currentIndex];
      logger.i(
        '🟩 FlashcardDetailScreen Loaded:\n'
        '  ├─ index: $currentIndex\n'
        '  ├─ id: ${item.id}\n'
        '  ├─ type: ${item.type}\n'
        '  ├─ renderItems.length: ${renderItems.length}\n'
        '  ├─ branchIndex: $branchIndex\n'
        '  ├─ backDestination: $backDestination\n'
        '  └─ backExtra: $backExtra',
      );
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

  void flipCard() {
    logger.i(showFront ? '🔃 Flipping to back' : '🔃 Flipping to front');
    setState(() {
      showFront = !showFront;
      _controller.isCompleted || _controller.velocity > 0
          ? _controller.reverse()
          : _controller.forward();
    });
  }

  void goTo(int newIndex) {
    if (newIndex < 0 || newIndex >= renderItems.length) {
      logger.w('⛔ Invalid navigation attempt: $newIndex');
      return;
    }

    final next = renderItems[newIndex];
    logger.i('🔁 Switching to index: $newIndex (${next.id})');

    switch (next.type) {
      case RenderItemType.flashcard:
        context.go(
          '/flashcards/detail',
          extra: {
            'renderItems': renderItems,
            'currentIndex': newIndex,
            'branchIndex': branchIndex,
            'backDestination': backDestination,
            'backExtra': backExtra,
          },
        );
        break;
      case RenderItemType.lesson:
        context.go(
          '/lessons/detail',
          extra: {
            'renderItems': renderItems,
            'currentIndex': newIndex,
            'branchIndex': branchIndex,
            'backDestination': backDestination,
            'backExtra': backExtra,
          },
        );
        break;
      case RenderItemType.part:
        context.go(
          '/parts/detail',
          extra: {
            'renderItems': renderItems,
            'currentIndex': newIndex,
            'branchIndex': branchIndex,
            'backDestination': backDestination,
            'backExtra': backExtra,
          },
        );
        break;
      case RenderItemType.tool:
        context.go(
          '/tools/detail',
          extra: {
            'renderItems': renderItems,
            'currentIndex': newIndex,
            'branchIndex': branchIndex,
            'backDestination': backDestination,
            'backExtra': backExtra,
          },
        );
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (renderItems.isEmpty) {
      return const Scaffold(
        body: Center(child: Text('No flashcard content available')),
      );
    }

    final currentItem = renderItems[currentIndex];

    if (currentItem.type != RenderItemType.flashcard) {
      logger.w('⚠️ Redirecting to correct screen for: ${currentItem.type}');
      WidgetsBinding.instance.addPostFrameCallback((_) {
        goTo(currentIndex);
      });
      return const Scaffold(body: SizedBox());
    }

    if (currentItem.flashcards.isEmpty) {
      return const Scaffold(
        body: Center(child: Text('No flashcard content available')),
      );
    }

    final flashcard = currentItem.flashcards.first;
    final title = flashcard.title;
    final sideA = flashcard.sideA;
    final sideB = flashcard.sideB;
    final category =
        (backExtra?['category'] as String?)?.toTitleCase() ?? 'Flashcards';

    logger.i(
      '🖼️ Rendering Flashcard:\n'
      '  ├─ title: $title\n'
      '  ├─ sideA: ${sideA.length} blocks\n'
      '  └─ sideB: ${sideB.length} blocks',
    );

    return Stack(
      fit: StackFit.expand,
      children: [
        Opacity(
          opacity: 0.2,
          child: Image.asset(
            'assets/images/sailboat_cartoon.jpg',
            fit: BoxFit.cover,
          ),
        ),
        Column(
          children: [
            CustomAppBarWidget(
              title: category,
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
            const SizedBox(height: 16),
            Text(
              title,
              style: AppTheme.scaledTextTheme.headlineMedium?.copyWith(
                color: AppTheme.primaryBlue,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Expanded(
              child: Center(
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Image.asset(
                      'assets/images/index_card.png',
                      width: 360,
                      height: 420,
                      fit: BoxFit.fill,
                    ),
                    SizedBox(
                      width: 360,
                      height: 420,
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
                                    ? Padding(
                                      padding: const EdgeInsets.only(top: 32),
                                      child: FlipCardWidget(
                                        front: sideA,
                                        back: sideB,
                                        showFront: true,
                                        animation: _flipAnimation,
                                      ),
                                    )
                                    : Transform(
                                      alignment: Alignment.center,
                                      transform: Matrix4.rotationY(math.pi),
                                      child: Padding(
                                        padding: const EdgeInsets.only(top: 32),
                                        child: FlipCardWidget(
                                          front: sideA,
                                          back: sideB,
                                          showFront: false,
                                          animation: _flipAnimation,
                                        ),
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

  Map<String, dynamic> get debugState => {
    'currentIndex': currentIndex,
    'totalItems': renderItems.length,
    'currentId': renderItems.isNotEmpty ? renderItems[currentIndex].id : 'n/a',
    'currentType':
        renderItems.isNotEmpty
            ? renderItems[currentIndex].type.toString()
            : 'n/a',
    'hasFlashcards':
        renderItems.isNotEmpty
            ? renderItems[currentIndex].flashcards.isNotEmpty
            : false,
    'flashcardCount':
        renderItems.isNotEmpty
            ? renderItems[currentIndex].flashcards.length
            : 0,
  };
}
