import 'package:flutter/material.dart';
import 'package:bcc5/data/models/content_block.dart';
import 'package:bcc5/theme/app_theme.dart';

class ContentBlockRenderer extends StatelessWidget {
  final List<ContentBlock> blocks;

  const ContentBlockRenderer({required this.blocks, super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: blocks.map((block) => _renderBlock(context, block)).toList(),
    );
  }

  Widget _renderBlock(BuildContext context, ContentBlock block) {
    switch (block.type) {
      case ContentBlockType.heading:
        return Padding(
          padding: const EdgeInsets.only(top: 12, bottom: 4),
          child: Text(
            block.text ?? '',
            style: AppTheme.scaledTextTheme.headlineMedium,
          ),
        );

      case ContentBlockType.text:
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Text(
            block.text ?? '',
            style: AppTheme.scaledTextTheme.bodyLarge,
          ),
        );

      case ContentBlockType.code:
        return Container(
          margin: const EdgeInsets.symmetric(vertical: 4),
          padding: const EdgeInsets.all(8),
          color: Colors.grey.shade200,
          child: Text(
            block.text ?? '',
            style: const TextStyle(fontFamily: 'monospace'),
          ),
        );

      case ContentBlockType.bulletList:
        final bullets = block.bullets ?? [];
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children:
              bullets.map((b) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 2),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('• ', style: TextStyle(fontSize: 16)),
                      Expanded(
                        child: Text(
                          b,
                          style: AppTheme.scaledTextTheme.bodyLarge,
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
        );

      case ContentBlockType.image:
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Image.asset(
            block.imagePath ?? 'assets/images/fallback_image.jpeg',
            fit: BoxFit.cover,
          ),
        );

      case ContentBlockType.divider:
        return const Divider(thickness: 2);
    }
  }
}
