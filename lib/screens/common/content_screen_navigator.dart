import 'package:flutter/material.dart';
import 'package:bcc5/data/models/render_item.dart' as model;
import 'package:bcc5/screens/common/content_detail_screen.dart';
import 'package:bcc5/screens/flashcards/flashcard_detail_screen.dart';
import 'package:bcc5/utils/render_item_helpers.dart' as helpers;
import 'package:bcc5/utils/logger.dart';

class ContentScreenNavigator extends StatefulWidget {
  final List<String> sequenceIds;
  final int startIndex;
  final int branchIndex;
  final String backDestination;

  const ContentScreenNavigator({
    super.key,
    required this.sequenceIds,
    required this.startIndex,
    required this.branchIndex,
    required this.backDestination,
  });

  @override
  State<ContentScreenNavigator> createState() => _ContentScreenNavigatorState();
}

class _ContentScreenNavigatorState extends State<ContentScreenNavigator> {
  late int _currentIndex;
  late List<model.RenderItem> _items;

  @override
  void initState() {
    super.initState();

    logger.i(
      '🌀 ContentScreenNavigator initState\n'
      '  • sequenceIds: ${widget.sequenceIds}\n'
      '  • startIndex: ${widget.startIndex}',
    );

    _currentIndex = widget.startIndex;

    // Create placeholders for lazy loading
    _items =
        widget.sequenceIds.map((id) {
          return model.RenderItem(
            id: id,
            type: _inferType(id),
            title: 'Loading...',
            content: const [],
            flashcards: const [],
          );
        }).toList();
  }

  model.RenderItemType _inferType(String id) {
    if (id.startsWith('lesson_')) return model.RenderItemType.lesson;
    if (id.startsWith('part_')) return model.RenderItemType.part;
    if (id.startsWith('tool_')) return model.RenderItemType.tool;
    if (id.startsWith('flashcard_')) return model.RenderItemType.flashcard;
    return model.RenderItemType.lesson; // fallback to something safe
  }

  void _goTo(int newIndex) {
    logger.i(
      '🔁 Switching index: $_currentIndex → $newIndex '
      '(of ${_items.length} items)',
    );
    setState(() => _currentIndex = newIndex);
  }

  void onPrevious() {
    if (_currentIndex > 0) {
      logger.i('⬅️ Previous tapped: ${_currentIndex - 1}');
      _goTo(_currentIndex - 1);
    } else {
      logger.i('⛔ At first item — cannot go back');
    }
  }

  void onNext() {
    if (_currentIndex < _items.length - 1) {
      logger.i('➡️ Next tapped: ${_currentIndex + 1}');
      _goTo(_currentIndex + 1);
    } else {
      logger.i('⛔ At last item — cannot go forward');
    }
  }

  void onBack() {
    logger.i('🔙 Back tapped → navigating to ${widget.backDestination}');
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    if (_items.isEmpty) {
      return const Scaffold(body: Center(child: Text('No content available')));
    }

    if (_currentIndex < 0 || _currentIndex >= _items.length) {
      return Scaffold(
        body: Center(
          child: Text(
            'Invalid start index: $_currentIndex (length: ${_items.length})',
          ),
        ),
      );
    }

    var currentItem = _items[_currentIndex];

    logger.i(
      '🖥️ Rendering item\n'
      '  • index: $_currentIndex\n'
      '  • id: ${currentItem.id}\n'
      '  • type: ${currentItem.type}',
    );

    // Lazy-resolve if not done already
    if (!currentItem.isResolved) {
      final resolved = helpers.getContentObject(currentItem.id);
      if (resolved != null) {
        logger.i('🧩 Resolved content for ${currentItem.id}');
        _items[_currentIndex] = resolved;
        currentItem = resolved; // use the resolved one immediately
      } else {
        logger.e('❌ Could not resolve content for ${currentItem.id}');
        return const Scaffold(
          body: Center(child: Text('Error loading content')),
        );
      }
    }

    if (currentItem.type == model.RenderItemType.flashcard) {
      logger.i('🧠 Showing FlashcardDetailScreen for ${currentItem.id}');
      return FlashcardDetailScreen(
        extra: {
          'flashcards': currentItem.flashcards,
          'initialIndex': 0,
          'branchIndex': widget.branchIndex,
          'onBack': onBack,
          'onPrevious': onPrevious,
          'onNext': onNext,
        },
      );
    }

    logger.i('📘 Showing ContentDetailScreen for ${currentItem.id}');
    return ContentDetailScreen(
      title: currentItem.title,
      content: currentItem.content,
      flashcards: currentItem.flashcards,
      startIndex: 0,
      onBack: onBack,
      onPrevious: onPrevious,
      onNext: onNext,
      branchIndex: widget.branchIndex,
    );
  }
}
