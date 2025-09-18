// lib/widgets/content_block_renderer.dart
import 'package:flutter/material.dart';
import 'package:bcc5/data/models/content_block.dart';
import 'package:bcc5/theme/app_theme.dart';

// ⬇️ new: renders the interactive GPS converter block
import 'package:bcc5/widgets/gps_converter.dart';

class ContentBlockRenderer extends StatelessWidget {
  final List<ContentBlock> blocks;
  const ContentBlockRenderer({super.key, required this.blocks});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: blocks.map((b) => _renderBlock(context, b)).toList(),
      ),
    );
  }

  Widget _renderBlock(BuildContext context, ContentBlock block) {
    switch (block.type) {
      case ContentBlockType.heading:
        return Padding(
          padding: const EdgeInsets.only(top: 12, bottom: 4),
          child: Text(block.text ?? '', style: AppTheme.detailTitleStyle),
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
        final bullets = block.bullets ?? const <String>[];
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children:
              bullets.map((line) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 2),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('• ', style: TextStyle(fontSize: 16)),
                      Expanded(child: Text(line)),
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

      case ContentBlockType.gpsConverter:
        // ⬇️ this renders the interactive converter UI
        return const Padding(
          padding: EdgeInsets.only(top: 8.0, bottom: 12.0),
          child: GpsConverterBlock(),
        );
    }
  }
}
