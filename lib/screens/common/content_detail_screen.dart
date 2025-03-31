import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:bcc5/data/models/content_block.dart';
import 'package:bcc5/navigation/main_scaffold.dart';
import 'package:bcc5/widgets/custom_app_bar_widget.dart';
import 'package:bcc5/utils/logger.dart';
import 'package:bcc5/theme/app_theme.dart';

class ContentDetailScreen extends StatelessWidget {
  final String title;
  final List<ContentBlock> content;
  final VoidCallback? onPrevious;
  final VoidCallback? onNext;
  final VoidCallback? onBack;
  final int branchIndex;

  const ContentDetailScreen({
    super.key,
    required this.title,
    required this.content,
    this.onPrevious,
    this.onNext,
    this.onBack,
    this.branchIndex = 0,
  });

  @override
  Widget build(BuildContext context) {
    logger.i('🟪 Displaying ContentDetailScreen: $title');

    return MainScaffold(
      branchIndex: branchIndex,
      child: Column(
        children: [
          CustomAppBarWidget(
            title: title,
            showBackButton: true,
            showSearchIcon: true,
            showSettingsIcon: true,
            onBack:
                onBack ??
                () {
                  logger.i('🔙 Fallback back on ContentDetailScreen');
                  if (Navigator.of(context).canPop()) {
                    Navigator.of(context).pop();
                  } else {
                    context.go('/');
                  }
                },
          ),
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: content.length,
              separatorBuilder: (_, __) => const SizedBox(height: 16),
              itemBuilder:
                  (context, index) => _renderBlock(context, content[index]),
            ),
          ),
          ClipRect(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                decoration: BoxDecoration(color: Colors.white.withAlpha(76)),
                child: Row(
                  children: [
                    ConstrainedBox(
                      constraints: const BoxConstraints(minWidth: 160),
                      child: ElevatedButton.icon(
                        onPressed: onPrevious,
                        icon: const Icon(Icons.arrow_back),
                        label: const Text('Previous'),
                        style:
                            onPrevious != null
                                ? AppTheme.navigationButtonStyle
                                : AppTheme.disabledNavigationButtonStyle,
                      ),
                    ),
                    const Spacer(),
                    ConstrainedBox(
                      constraints: const BoxConstraints(minWidth: 160),
                      child: ElevatedButton(
                        onPressed: onNext,
                        style:
                            onNext != null
                                ? AppTheme.navigationButtonStyle
                                : AppTheme.disabledNavigationButtonStyle,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Text('Next'),
                            SizedBox(width: 8),
                            Icon(Icons.arrow_forward),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
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
              block.bulletList!
                  .map(
                    (item) => Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('• ', style: TextStyle(fontSize: 16)),
                        Expanded(child: Text(item)),
                      ],
                    ),
                  )
                  .toList(),
        );
      case ContentBlockType.image:
        return Image.asset(
          block.imagePath ?? 'assets/images/fallback_image.jpeg',
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => const Placeholder(fallbackHeight: 150),
        );
      case ContentBlockType.divider:
        return const Divider(thickness: 2);
    }
  }
}
