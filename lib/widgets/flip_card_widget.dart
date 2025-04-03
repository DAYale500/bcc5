import 'package:flutter/material.dart';
import 'package:bcc5/data/models/content_block.dart';
import 'package:bcc5/widgets/content_block_renderer.dart';

class FlipCardWidget extends StatelessWidget {
  final List<ContentBlock> front;
  final List<ContentBlock> back;
  final bool showFront;
  final Animation<double> animation; // Required for flip, even if unused here

  const FlipCardWidget({
    super.key,
    required this.front,
    required this.back,
    required this.showFront,
    required this.animation,
  });

  @override
  Widget build(BuildContext context) {
    final visibleContent = showFront ? front : back;

    return Semantics(
      label: showFront ? 'Flashcard front' : 'Flashcard back',
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16),
        child: SingleChildScrollView(
          child: DefaultTextStyle.merge(
            style: const TextStyle(fontSize: 19),
            child: ContentBlockRenderer(blocks: visibleContent),
          ),
        ),
      ),
    );
  }
}
