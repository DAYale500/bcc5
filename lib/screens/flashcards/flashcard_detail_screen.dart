import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:bcc5/utils/logger.dart';
import 'package:bcc5/data/models/content_block.dart';
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
  late List<String> sequenceTitles;
  late Map<String, List<ContentBlock>> contentMap;
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
      sequenceTitles = widget.extra['sequenceTitles']?.cast<String>() ?? [];
      contentMap = (widget.extra['contentMap'] as Map).map(
        (key, value) => MapEntry(key.toString(), value.cast<ContentBlock>()),
      );
      currentIndex = widget.extra['startIndex'] as int? ?? 0;
      branchIndex = widget.extra['branchIndex'] as int? ?? 0;
      backDestination = widget.extra['backDestination'] as String? ?? '/';
      backExtra = widget.extra['backExtra'] as Map<String, dynamic>?;

      logger.i(
        '🟩 Loaded FlashcardDetailScreen: index=$currentIndex title=${sequenceTitles[currentIndex]}',
      );
    } catch (e, st) {
      logger.e(
        '❌ Error parsing FlashcardDetailScreen extra map: $e',
        error: e,
        stackTrace: st,
      );
      sequenceTitles = [];
      contentMap = {};
      currentIndex = 0;
      branchIndex = 0;
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
    if (newIndex >= 0 && newIndex < sequenceTitles.length) {
      setState(() {
        currentIndex = newIndex;
        showFront = true;
        _controller.reset();
      });
      logger.i('🔁 Navigated to flashcard index: $newIndex');
    }
  }

  void flipCard() {
    setState(() {
      showFront = !showFront;
      if (_controller.isCompleted || _controller.velocity > 0) {
        _controller.reverse();
      } else {
        _controller.forward();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final String title = sequenceTitles[currentIndex];
    final List<ContentBlock> content = contentMap[title] ?? [];
    final List<ContentBlock> front =
        content.takeWhile((b) => b.type != ContentBlockType.divider).toList();
    final List<ContentBlock> back =
        content
            .skipWhile((b) => b.type != ContentBlockType.divider)
            .skip(1)
            .toList();

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
                            child: FlipCardWidget(
                              front: front,
                              back: back,
                              showFront: isFront,
                              animation: _flipAnimation, // 🛠️ this was missing
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
              isNextEnabled: currentIndex < sequenceTitles.length - 1,
              onPrevious: () => goTo(currentIndex - 1),
              onNext: () => goTo(currentIndex + 1),
            ),
          ],
        ),
      ],
    );
  }
}
