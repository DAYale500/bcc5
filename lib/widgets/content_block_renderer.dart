import 'package:flutter/material.dart';
import 'package:bcc5/data/models/content_block.dart';

class ContentBlockRenderer extends StatelessWidget {
  final List<ContentBlock> blocks;

  const ContentBlockRenderer({required this.blocks, super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children:
          blocks.map((block) {
            switch (block.type) {
              case ContentBlockType.heading:
                return Padding(
                  padding: const EdgeInsets.only(top: 12.0, bottom: 4),
                  child: Text(
                    block.text ?? '',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                );
              case ContentBlockType.text:
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Text(
                    block.text ?? '',
                    style: Theme.of(context).textTheme.bodyLarge,
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
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children:
                      block.bullets!
                          .map(
                            (b) => Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  '• ',
                                  style: TextStyle(fontSize: 16),
                                ),
                                Expanded(child: Text(b)),
                              ],
                            ),
                          )
                          .toList(),
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
          }).toList(),
    );
  }
}
