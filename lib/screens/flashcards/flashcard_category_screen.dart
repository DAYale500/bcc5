import 'package:bcc5/data/models/render_item.dart';
import 'package:bcc5/navigation/detail_route.dart';
import 'package:bcc5/theme/slide_direction.dart';
import 'package:bcc5/theme/transition_type.dart';
import 'package:bcc5/utils/string_extensions.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:bcc5/widgets/custom_app_bar_widget.dart';
import 'package:bcc5/utils/logger.dart';
import 'package:bcc5/theme/app_theme.dart';

// ✅ JSON-backed repo (replaces legacy)
import 'package:bcc5/data/repositories/flashcards/json_flashcard_repository.dart';

class FlashcardCategoryScreen extends StatefulWidget {
  const FlashcardCategoryScreen({super.key});

  static const double appBarOffset = 80.0;

  @override
  State<FlashcardCategoryScreen> createState() =>
      _FlashcardCategoryScreenState();
}

class _FlashcardCategoryScreenState extends State<FlashcardCategoryScreen> {
  late Future<List<String>> _futureCategories;

  @override
  void initState() {
    super.initState();
    _futureCategories = _loadCategories();
  }

  Future<List<String>> _loadCategories() async {
    final categories = await JsonFlashcardRepository.getAllCategories();
    // Keep 'all' and 'random' first, everything else after (preserves your UX)
    final specials = categories.where((c) => c == 'all' || c == 'random');
    final rest = categories.where((c) => c != 'all' && c != 'random');
    final sorted = [...specials, ...rest].toList();
    logger.i('📇 Sorted flashcard categories (JSON): $sorted');
    return sorted;
  }

  Future<void> _refresh() async {
    JsonFlashcardRepository.invalidateIndex();
    setState(() {
      _futureCategories = _loadCategories();
    });
    await _futureCategories;
  }

  Future<void> _onCategoryTap(BuildContext context, String category) async {
    logger.i('🟥 Tapped flashcard category: $category (JSON)');
    final flashcards = await JsonFlashcardRepository.getFlashcardsForCategory(
      category,
    );

    if (!context.mounted) return; // ✅ guard the specific BuildContext

    if (flashcards.isEmpty) {
      logger.w('⚠️ No flashcards found in category: $category');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No flashcards found in this category.')),
      );
      return;
    }

    final renderItems = flashcards.map(RenderItem.fromFlashcard).toList();

    if (!context.mounted) return; // ✅ guard before navigation
    context.push(
      '/flashcards/detail',
      extra: {
        'renderItems': renderItems,
        'currentIndex': 0,
        'branchIndex': 4,
        'backDestination': '/flashcards',
        'backExtra': {'category': category, 'branchIndex': 4},
        'transitionKey':
            'flashcards_detail_${category}_${DateTime.now().millisecondsSinceEpoch}',
        'slideFrom': SlideDirection.right,
        'transitionType': TransitionType.slide,
        'detailRoute': DetailRoute.branch,
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    logger.i('🟦 Entered FlashcardCategoryScreen (JSON)');

    // 🔑 Internally managed GlobalKeys
    final mobKey = GlobalKey(debugLabel: 'MOBKey');
    final settingsKey = GlobalKey(debugLabel: 'SettingsKey');
    final searchKey = GlobalKey(debugLabel: 'SearchKey');
    final titleKey = GlobalKey(debugLabel: 'TitleKey');

    return FutureBuilder<List<String>>(
      future: _futureCategories,
      builder: (context, snap) {
        // AppBar
        final appBar = Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: CustomAppBarWidget(
            title: 'Drills',
            showBackButton: false,
            showSearchIcon: true,
            showSettingsIcon: true,
            mobKey: mobKey,
            settingsKey: settingsKey,
            searchKey: searchKey,
            titleKey: titleKey,
          ),
        );

        // Breadcrumb
        final crumb = const Positioned(
          top: FlashcardCategoryScreen.appBarOffset + 30,
          left: 16,
          right: 16,
          child: Text(
            'Drills',
            style: AppTheme.branchBreadcrumbStyle,
            textAlign: TextAlign.left,
          ),
        );

        // Instruction chip
        final instruction = Positioned(
          top: FlashcardCategoryScreen.appBarOffset + 32,
          left: 62,
          right: 62,
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 2),
            decoration: BoxDecoration(
              color: Colors.white.withAlpha(217),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: Text(
                'Pick a Challenge!',
                style: AppTheme.subheadingStyle.copyWith(
                  color: AppTheme.primaryBlue,
                ),
              ),
            ),
          ),
        );

        if (snap.connectionState != ConnectionState.done) {
          return Stack(
            fit: StackFit.expand,
            children: [
              appBar,
              crumb,
              instruction,
              Positioned.fill(
                top: FlashcardCategoryScreen.appBarOffset + 100,
                child: const Center(child: CircularProgressIndicator()),
              ),
            ],
          );
        }

        final categories = snap.data ?? const <String>[];
        if (categories.isEmpty) {
          return Stack(
            fit: StackFit.expand,
            children: [
              appBar,
              crumb,
              instruction,
              Positioned.fill(
                top: FlashcardCategoryScreen.appBarOffset + 120,
                child: const Center(
                  child: Text('No flashcard categories found'),
                ),
              ),
            ],
          );
        }

        // Category buttons (unchanged layout & styling)
        return Stack(
          fit: StackFit.expand,
          children: [
            appBar,
            crumb,
            instruction,
            Positioned.fill(
              top: FlashcardCategoryScreen.appBarOffset + 100,
              child: RefreshIndicator(
                onRefresh: _refresh, // ← uses your method
                child: SingleChildScrollView(
                  physics:
                      const AlwaysScrollableScrollPhysics(), // allows pull even if short
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Center(
                    child: Wrap(
                      spacing: 12,
                      runSpacing: 12,
                      children:
                          categories.map((category) {
                            final isSpecial =
                                category == 'all' || category == 'random';
                            final style =
                                isSpecial
                                    ? AppTheme.highlightedGroupButtonStyle
                                    : ElevatedButton.styleFrom(
                                      backgroundColor:
                                          AppTheme.groupButtonUnselected,
                                      padding: AppTheme.groupButtonPadding,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(
                                          AppTheme.buttonCornerRadius,
                                        ),
                                      ),
                                    );

                            return SizedBox(
                              width: 160,
                              child: ElevatedButton(
                                onPressed:
                                    () => _onCategoryTap(context, category),
                                style: style,
                                child: Text(
                                  category.toTitleCase(),
                                  style: AppTheme.buttonTextStyle,
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            );
                          }).toList(),
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
