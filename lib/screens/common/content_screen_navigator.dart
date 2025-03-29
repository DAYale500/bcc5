import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:bcc5/data/models/content_block.dart';
import 'package:bcc5/screens/common/content_detail_screen.dart';
import 'package:bcc5/utils/logger.dart';

class ContentScreenNavigator extends StatefulWidget {
  final String title;
  final List<String> sequenceTitles;
  final Map<String, List<ContentBlock>> contentMap;
  final int startIndex;
  final VoidCallback? onBack;
  final int branchIndex; // 🟠 NEW: Needed for MainScaffold BNB

  const ContentScreenNavigator({
    super.key,
    required this.title,
    required this.sequenceTitles,
    required this.contentMap,
    required this.startIndex,
    this.onBack,
    this.branchIndex = 0, // 🟠 Fallback to Home
  });

  @override
  State<ContentScreenNavigator> createState() => _ContentScreenNavigatorState();
}

class _ContentScreenNavigatorState extends State<ContentScreenNavigator> {
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.startIndex;
    logger.i('🟧 Entered ContentScreenNavigator at index $_currentIndex');
  }

  void _goToPrevious() {
    if (_currentIndex > 0) {
      setState(() {
        _currentIndex--;
        logger.i(
          '⬅️ Navigated to previous content: ${widget.sequenceTitles[_currentIndex]}',
        );
      });
    }
  }

  void _goToNext() {
    if (_currentIndex < widget.sequenceTitles.length - 1) {
      setState(() {
        _currentIndex++;
        logger.i(
          '➡️ Navigated to next content: ${widget.sequenceTitles[_currentIndex]}',
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final title = widget.sequenceTitles[_currentIndex];
    final content = widget.contentMap[title] ?? [];

    logger.i('🟨 Rendering content: $title');

    return ContentDetailScreen(
      title: title,
      content: content,
      branchIndex: widget.branchIndex, // 🟠 Ensure proper BNB display
      onBack:
          widget.onBack ??
          () {
            logger.i('🔙 Back from content: $title (default pop)');
            if (Navigator.of(context).canPop()) {
              Navigator.of(context).pop();
            } else {
              context.go('/');
            }
          },
      onPrevious: _currentIndex > 0 ? _goToPrevious : null,
      onNext:
          _currentIndex < widget.sequenceTitles.length - 1 ? _goToNext : null,
    );
  }
}
