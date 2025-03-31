import 'package:flutter/material.dart';
import 'package:bcc5/data/models/content_block.dart';
import 'package:bcc5/widgets/content_block_renderer.dart';

class FlipCardWidget extends StatelessWidget {
  final List<ContentBlock> front;
  final List<ContentBlock> back;
  final bool showFront;
  final Animation<double> animation; // ✅ required

  const FlipCardWidget({
    super.key,
    required this.front,
    required this.back,
    required this.showFront,
    required this.animation,
  });

  @override
  Widget build(BuildContext context) {
    final content = showFront ? front : back;

    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: SingleChildScrollView(
        child: DefaultTextStyle.merge(
          style: const TextStyle(fontSize: 19), // 🧠 20% larger font
          child: ContentBlockRenderer(blocks: content),
        ),
      ),
    );
  }
}
