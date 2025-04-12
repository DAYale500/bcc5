// 📄 lib/widgets/search_modal.dart

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:bcc5/data/models/render_item.dart';
import 'package:bcc5/utils/render_item_helpers.dart';
import 'package:bcc5/data/repositories/lessons/lesson_repository_index.dart';
import 'package:bcc5/data/repositories/parts/part_repository_index.dart';

// 🚫 No need to import flashcards until keyword support is added

class SearchResult {
  final String id;
  final String title;
  final RenderItemType type;

  SearchResult({required this.id, required this.title, required this.type});
}

class SearchModal extends StatefulWidget {
  const SearchModal({super.key});

  @override
  State<SearchModal> createState() => _SearchModalState();
}

class _SearchModalState extends State<SearchModal> {
  final TextEditingController _controller = TextEditingController();
  late List<SearchResult> _allResults;
  List<SearchResult> _filteredResults = [];

  @override
  void initState() {
    super.initState();
    _allResults = _buildSearchIndex();
    _filteredResults = _allResults;
  }

  List<SearchResult> _buildSearchIndex() {
    final results = <SearchResult>[];

    for (final lesson in LessonRepositoryIndex.getAllLessons()) {
      for (final keyword in lesson.keywords) {
        results.add(
          SearchResult(
            id: lesson.id,
            title: keyword,
            type: RenderItemType.lesson,
          ),
        );
      }
    }

    for (final part in PartRepositoryIndex.getAllParts()) {
      for (final keyword in part.keywords) {
        results.add(
          SearchResult(id: part.id, title: keyword, type: RenderItemType.part),
        );
      }
    }

    // 🚧 Flashcard keywords not yet available in model
    // Future-proof logic:
    // for (final flashcard in FlashcardRepository.getAllFlashcards()) {
    //   for (final keyword in flashcard.keywords ?? []) {
    //     results.add(SearchResult(
    //       id: flashcard.id,
    //       title: keyword,
    //       type: RenderItemType.flashcard,
    //     ));
    //   }
    // }

    return results;
  }

  void _onSearchChanged(String query) {
    setState(() {
      _filteredResults =
          _allResults
              .where((r) => r.title.toLowerCase().contains(query.toLowerCase()))
              .toList();
    });
  }

  void _navigateToResult(SearchResult result) {
    final renderItems = buildRenderItems(ids: [result.id]);
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final extra = {
      'renderItems': renderItems,
      'currentIndex': 0,
      'branchIndex': 0,
      'backDestination': '/',
      'transitionKey': 'search_${result.id}_$timestamp',
    };

    switch (result.type) {
      case RenderItemType.lesson:
        context.go('/lessons/detail', extra: extra);
        break;
      case RenderItemType.part:
        context.go('/parts/detail', extra: extra);
        break;
      case RenderItemType.tool:
        context.go('/tools/detail', extra: extra);
        break;
      case RenderItemType.flashcard:
        context.go('/flashcards/detail', extra: extra);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _controller,
              onChanged: _onSearchChanged,
              decoration: const InputDecoration(
                labelText: 'Search...',
                border: OutlineInputBorder(),
              ),
            ),
          ),
          Expanded(
            child: ListView.separated(
              itemCount: _filteredResults.length,
              separatorBuilder: (_, __) => const Divider(height: 1),
              itemBuilder: (context, index) {
                final result = _filteredResults[index];
                return ListTile(
                  title: Text(result.title),
                  subtitle: Text(result.type.name),
                  onTap: () => _navigateToResult(result),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
