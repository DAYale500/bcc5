import 'package:flutter/material.dart';
import '../../models/content_block.dart';
import '../../utils/logger.dart';

class ContentDetailScreen extends StatelessWidget {
  final String title;
  final List<ContentBlock> content;
  final VoidCallback? onPrevious;
  final VoidCallback? onNext;
  final VoidCallback? onBack;

  const ContentDetailScreen({
    super.key,
    required this.title,
    required this.content,
    this.onPrevious,
    this.onNext,
    this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    logger.i('🟪 Displaying ContentDetailScreen: $title');

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        backgroundColor: Colors.blueGrey[50],
        leading:
            onBack != null
                ? IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () {
                    logger.i('🔙 AppBar back tapped on $title');
                    onBack?.call();
                  },
                )
                : null,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: content.length,
              separatorBuilder: (_, __) => const SizedBox(height: 16),
              itemBuilder: (context, index) {
                final block = content[index];
                return _renderBlock(context, block);
              },
            ),
          ),
          const Divider(height: 1),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (onPrevious != null)
                TextButton.icon(
                  onPressed: onPrevious,
                  icon: const Icon(Icons.arrow_back),
                  label: const Text('Previous'),
                ),
              if (onNext != null)
                TextButton.icon(
                  onPressed: onNext,
                  icon: const Icon(Icons.arrow_forward),
                  label: const Text('Next'),
                ),
            ],
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }

  Widget _renderBlock(BuildContext context, ContentBlock block) {
    switch (block.type) {
      case ContentBlockType.heading:
        return Text(
          block.text ?? '',
          style: Theme.of(context).textTheme.headlineSmall,
        );
      case ContentBlockType.text:
        return Text(
          block.text ?? '',
          style: Theme.of(context).textTheme.bodyLarge,
        );
      case ContentBlockType.code:
        return Container(
          padding: const EdgeInsets.all(12),
          color: Colors.black87,
          child: Text(
            block.text ?? '',
            style: const TextStyle(
              color: Colors.greenAccent,
              fontFamily: 'monospace',
            ),
          ),
        );
      case ContentBlockType.bulletList:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children:
              block.bullets!.map((item) {
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('• ', style: TextStyle(fontSize: 16)),
                    Expanded(child: Text(item)),
                  ],
                );
              }).toList(),
        );
      case ContentBlockType.image:
        return Image.asset(
          block.imagePath!,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => const Placeholder(fallbackHeight: 150),
        );
    }
  }
}
