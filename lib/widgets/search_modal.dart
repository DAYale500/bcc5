// lib/widgets/search_modal.dart
import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:go_router/go_router.dart';
import 'package:bcc5/data/models/render_item.dart';
import 'package:bcc5/utils/render_item_helpers.dart';
import 'package:bcc5/navigation/detail_route.dart';
import 'package:bcc5/theme/app_theme.dart';

enum SearchFilter { all, lesson, part, tool }

/// 🔁 Simple, in-memory persistence for the search modal.
class SearchMemory {
  static String lastQuery = '';
  static SearchFilter lastFilter = SearchFilter.all;
}

class SearchDoc {
  final String id;
  final String title;
  final RenderItemType type;
  final String haystack; // lowercased searchable blob
  final String preview; // short human text for snippet

  SearchDoc({
    required this.id,
    required this.title,
    required this.type,
    required this.haystack,
    required this.preview,
  });
}

class SearchHit {
  final SearchDoc doc;
  final double score;
  final String snippet;

  SearchHit(this.doc, this.score, this.snippet);
}

class SearchModal extends StatefulWidget {
  const SearchModal({super.key});

  @override
  State<SearchModal> createState() => _SearchModalState();
}

class _SearchModalState extends State<SearchModal> {
  final TextEditingController _controller = TextEditingController();
  final _debounce = const Duration(milliseconds: 250);
  Timer? _debouncer;

  List<SearchDoc> _index = const [];
  List<SearchHit> _hits = const [];
  bool _loading = true;

  SearchFilter _filter = SearchFilter.all; // 👈 current UI filter

  @override
  void initState() {
    super.initState();
    _buildSearchIndex();
  }

  @override
  void dispose() {
    _debouncer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  // ───────────────── Indexing ─────────────────

  Future<void> _buildSearchIndex() async {
    final docs = <SearchDoc>[];
    final seen = <String>{};

    try {
      final manifestRaw = await rootBundle.loadString('AssetManifest.json');
      final Map<String, dynamic> manifest = jsonDecode(manifestRaw);

      final paths = manifest.keys.where((p) {
        if (!p.endsWith('.json')) return false;
        return p.contains('/json/lessons/') ||
            p.contains('/json/parts/') ||
            p.contains('/json/tools/');
      });

      for (final path in paths) {
        final type = _typeFromPath(path);
        if (type == null) continue;

        final raw = await rootBundle.loadString(path);
        final decoded = jsonDecode(raw);

        final items = _extractItems(decoded, type);

        if (items.isNotEmpty) {
          for (final item in items) {
            final id = _idFromMapOrPath(item, path);
            if (id.isEmpty) continue;

            final title = _titleFromMapOrId(item, id);
            final hay = _buildHaystack(item, title, id);
            final prev = _buildPreview(item, title);

            final key = '$id|${type.name}';
            if (seen.add(key)) {
              docs.add(
                SearchDoc(
                  id: id,
                  title: title,
                  type: type,
                  haystack: hay.toLowerCase(),
                  preview: prev,
                ),
              );
            }
          }
        } else if (decoded is Map<String, dynamic>) {
          final id = _idFromMapOrPath(decoded, path);
          if (id.isEmpty) continue;

          final title = _titleFromMapOrId(decoded, id);
          final hay = _buildHaystack(decoded, title, id);
          final prev = _buildPreview(decoded, title);

          final key = '$id|${type.name}';
          if (seen.add(key)) {
            docs.add(
              SearchDoc(
                id: id,
                title: title,
                type: type,
                haystack: hay.toLowerCase(),
                preview: prev,
              ),
            );
          }
        }
      }
    } catch (_) {}

    if (!mounted) return;
    setState(() {
      _index = docs;
      _loading = false;

      // 🔁 Restore previous query (if any) and run search
      _filter = SearchMemory.lastFilter;
      _controller.text = SearchMemory.lastQuery;
      _controller.selection = TextSelection.fromPosition(
        TextPosition(offset: _controller.text.length),
      );
      _runSearch(SearchMemory.lastQuery);
    });
  }

  RenderItemType? _typeFromPath(String path) {
    if (path.contains('/json/lessons/')) return RenderItemType.lesson;
    if (path.contains('/json/parts/')) return RenderItemType.part;
    if (path.contains('/json/tools/')) return RenderItemType.tool;
    return null;
  }

  List<Map<String, dynamic>> _extractItems(
    dynamic decoded,
    RenderItemType type,
  ) {
    if (decoded is! Map<String, dynamic>) return const [];
    final key = switch (type) {
      RenderItemType.lesson => 'lessons',
      RenderItemType.part => 'parts',
      RenderItemType.tool => 'tools',
      RenderItemType.flashcard => '__none__',
    };
    final v = decoded[key];
    if (v is List) return v.whereType<Map<String, dynamic>>().toList();
    return const [];
  }

  String _idFromMapOrPath(Map<String, dynamic> map, String path) {
    final raw = map['id'];
    if (raw is String && raw.trim().isNotEmpty) return raw.trim();
    final file = path.split('/').last;
    return file.replaceAll('.json', '');
  }

  String _titleFromMapOrId(Map<String, dynamic> map, String fallbackId) {
    final t = map['title'];
    if (t is String && t.trim().isNotEmpty) return t.trim();
    return fallbackId
        .replaceAll('_', ' ')
        .replaceAll('-', ' ')
        .split(' ')
        .map((w) => w.isEmpty ? w : '${w[0].toUpperCase()}${w.substring(1)}')
        .join(' ');
  }

  List<String> _keywordsFromMap(Map<String, dynamic> map) {
    List<String> coerceList(dynamic v) {
      if (v is List) {
        return v
            .map((e) => e is String ? e : e?.toString() ?? '')
            .where((s) => s.trim().isNotEmpty)
            .toList();
      }
      return const <String>[];
    }

    final kws = coerceList(map['keywords']);
    if (kws.isNotEmpty) return kws;

    final tags = coerceList(map['tags']);
    if (tags.isNotEmpty) return tags;

    final title = map['title'];
    return title is String && title.trim().isNotEmpty ? [title.trim()] : [];
  }

  String _extractTextContent(Map<String, dynamic> map) {
    final buf = StringBuffer();

    void add(dynamic v) {
      if (v is String) buf.write(' $v ');
    }

    add(map['summary']);
    add(map['description']);

    final content = map['content'];
    if (content is List) {
      for (final block in content) {
        if (block is Map<String, dynamic>) {
          add(block['content']);
          add(block['caption']);
        } else if (block is String) {
          add(block);
        }
      }
    }
    return buf.toString();
  }

  // Before you had [title, kws, text]. Drop title so the snippet never sees it.
  String _buildHaystack(Map<String, dynamic> map, String title, String id) {
    final kws = _keywordsFromMap(map).join(' ');
    final text = _extractTextContent(map);
    return [kws, text]
        .where((s) => s.trim().isNotEmpty)
        .join(' • ')
        .toLowerCase(); // keep as lc for match/search speed
  }

  String _buildPreview(Map<String, dynamic> map, String title) {
    final summary = (map['summary'] ?? map['description'])?.toString() ?? '';
    if (summary.trim().isNotEmpty) return summary.trim();
    final text = _extractTextContent(map).trim();
    if (text.isNotEmpty) {
      return text.length > 180 ? '${text.substring(0, 177)}…' : text;
    }
    return title;
  }

  String _sanitizeExcerpt(String s, String title) {
    if (s.isEmpty) return s;

    var out = s;

    // Remove obvious paths/URLs (assets/, http…)
    out = out.replaceAll(
      RegExp(r'\bassets\/[^\s,;]+', caseSensitive: false),
      '',
    );
    out = out.replaceAll(RegExp(r'https?:\/\/\S+', caseSensitive: false), '');

    // Strip simple markdown markers
    out = out.replaceAll(RegExp(r'(\*\*|__|`|~~)'), '');
    out = out.replaceAll(
      RegExp(r'(^|\s)[*_]([^\s][^*_]*?)\1'),
      r' $2',
    ); // _word_ or *word*

    // Remove the title if it sneaks back in (case-insensitive)
    if (title.isNotEmpty) {
      final esc = RegExp.escape(title);
      out = out.replaceAll(RegExp(esc, caseSensitive: false), '');
    }

    // Collapse whitespace / trim punctuation clutter
    out = out.replaceAll(RegExp(r'\s{2,}'), ' ').trim();
    out = out.replaceAll(RegExp(r'^[•\-\–\—\.\,;\s]+'), '');

    return out;
  }

  // ───────────────── Search / Scoring ─────────────────

  void _onQueryChanged(String q) {
    _debouncer?.cancel();

    // If query is empty, reset filter to All immediately (per-query behavior)
    if (q.trim().isEmpty && _filter != SearchFilter.all) {
      setState(() {
        _filter = SearchFilter.all;
      });
      SearchMemory.lastFilter = SearchFilter.all; // keep memory in sync
    }

    _debouncer = Timer(_debounce, () => _runSearch(q));
  }

  void _runSearch(String query) {
    final q = query.trim().toLowerCase();
    SearchMemory.lastQuery = q; // 🔁 persist the current query
    SearchMemory.lastFilter = _filter;

    if (q.isEmpty) {
      setState(() {
        _hits =
            _index
                .where(_matchesFilter)
                .map((d) => SearchHit(d, 0, d.preview))
                .toList();
      });
      return;
    }

    final terms = q.split(RegExp(r'\s+')).where((t) => t.isNotEmpty).toList();

    double scoreFor(SearchDoc d) {
      double s = 0;
      for (final t in terms) {
        final inTitle = d.title.toLowerCase();
        final inHay = d.haystack;

        if (RegExp(r'\b' + RegExp.escape(t) + r'\b').hasMatch(inTitle)) s += 6;
        if (inTitle.contains(t)) s += 4;
        if (inTitle.split(' ').any((w) => w.startsWith(t))) s += 2;

        if (RegExp(r'\b' + RegExp.escape(t) + r'\b').hasMatch(inHay)) s += 3;
        if (inHay.contains(t)) s += 1;
      }
      switch (d.type) {
        case RenderItemType.lesson:
          s += 0.6;
          break;
        case RenderItemType.part:
          s += 0.3;
          break;
        case RenderItemType.tool:
          s += 0.1;
          break;
        case RenderItemType.flashcard:
          break;
      }
      return s;
    }

    String makeSnippet(SearchDoc d) {
      // Haystack (lowercased), with possible 'keywords • text' split
      final h = d.haystack;
      final firstSep = h.indexOf(' • ');
      final afterTitleIdx = firstSep >= 0 ? firstSep + 3 : 0;

      // Helper: crop around idx with a provided lower bound for start
      String crop(String source, int idx, int minStart) {
        final start = (idx - 50).clamp(minStart, source.length);
        final end = (idx + 80).clamp(0, source.length);
        return source.substring(start, end).trim();
      }

      // 1) Prefer preview (original casing) if it contains any term
      final prev = d.preview;
      final prevLc = prev.toLowerCase();
      for (final t in terms) {
        final i = prevLc.indexOf(t);
        if (i >= 0) {
          final slice = crop(prev, i, 0); // ⬅️ clamp to 0 for preview
          final clean = _sanitizeExcerpt(slice, d.title);
          if (clean.isNotEmpty) return clean;
        }
      }

      // 2) Fall back to haystack (lowercased), then sanitize and return
      int bestIdx = -1;
      for (final t in terms) {
        final i = h.indexOf(t, afterTitleIdx); // stay out of keywords segment
        if (i >= 0 && (bestIdx == -1 || i < bestIdx)) bestIdx = i;
      }

      if (bestIdx >= 0) {
        // Crop from haystack with afterTitleIdx bound
        var slice = crop(h, bestIdx, afterTitleIdx);

        // Try to re-case from preview if the same window appears there
        final loose = prev.toLowerCase();
        final win = slice.toLowerCase();
        final j = loose.indexOf(win);
        if (j >= 0) {
          slice =
              prev.substring(j, (j + win.length).clamp(0, prev.length)).trim();
        }

        final clean = _sanitizeExcerpt(slice, d.title);
        if (clean.isNotEmpty) return clean;
      }

      // 3) Last resort
      final fallback = _sanitizeExcerpt(prev, d.title);
      return fallback.isEmpty ? '' : fallback;
    }

    final hits = <SearchHit>[];
    for (final d in _index) {
      if (!_matchesFilter(d)) continue; // 👈 skip non-matching types early
      final s = scoreFor(d);
      if (s > 0) hits.add(SearchHit(d, s, makeSnippet(d)));
    }
    hits.sort((a, b) => b.score.compareTo(a.score));

    setState(() => _hits = hits);
  }

  Future<void> _navigateTo(SearchDoc doc) async {
    final renderItems = await buildRenderItems(ids: [doc.id]);
    if (!mounted) return;

    final extra = {
      'renderItems': renderItems,
      'currentIndex': 0,
      'branchIndex': 0,
      'backDestination': '/', // will be overridden below
      'backExtra': {'reopenSearch': true, 'query': SearchMemory.lastQuery},
      'transitionKey':
          'search_${doc.id}_${DateTime.now().millisecondsSinceEpoch}',
      'detailRoute': DetailRoute.branch,
    };

    // Pick a sensible branch for "Back" (so you land near what you opened).
    switch (doc.type) {
      case RenderItemType.lesson:
        extra['backDestination'] = '/lessons';
        context.go('/lessons/detail', extra: extra);
        break;
      case RenderItemType.part:
        extra['backDestination'] = '/parts';
        context.go('/parts/detail', extra: extra);
        break;
      case RenderItemType.tool:
        extra['backDestination'] = '/tools';
        context.go('/tools/detail', extra: extra);
        break;
      case RenderItemType.flashcard:
        extra['backDestination'] = '/flashcards';
        context.go('/flashcards/detail', extra: extra);
        break;
    }
  }

  // ───────────────── UI (with highlights) ─────────────────

  Widget _buildHeaderChip(String query, int count, List<String> terms) {
    final typeLabel =
        _filter == SearchFilter.all
            ? 'results'
            : (_filter == SearchFilter.lesson
                ? (count == 1 ? 'lesson result' : 'lesson results')
                : _filter == SearchFilter.part
                ? (count == 1 ? 'part result' : 'part results')
                : (count == 1 ? 'tool result' : 'tool results'));

    final raw =
        query.isEmpty
            ? 'Showing $count $typeLabel'
            : 'Showing $count $typeLabel for “$query”';

    final base =
        Theme.of(
          context,
        ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600) ??
        const TextStyle(fontWeight: FontWeight.w600);

    final hi = base.copyWith(fontWeight: FontWeight.w800);

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.grey.shade200,
          borderRadius: BorderRadius.circular(12),
        ),
        child: RichText(text: _highlight(raw, terms, base, hi)),
      ),
    );
  }

  TextSpan _highlight(
    String text,
    List<String> terms,
    TextStyle base,
    TextStyle hi,
  ) {
    if (terms.isEmpty || text.isEmpty) return TextSpan(text: text, style: base);
    final lc = text.toLowerCase();
    int idx = 0;
    final spans = <TextSpan>[];

    while (idx < text.length) {
      int nextHitStart = -1;
      int nextHitEnd = -1;

      for (final t in terms) {
        final i = lc.indexOf(t, idx);
        if (i >= 0 && (nextHitStart == -1 || i < nextHitStart)) {
          nextHitStart = i;
          nextHitEnd = i + t.length;
        }
      }

      if (nextHitStart == -1) {
        spans.add(TextSpan(text: text.substring(idx), style: base));
        break;
      }

      if (nextHitStart > idx) {
        spans.add(
          TextSpan(text: text.substring(idx, nextHitStart), style: base),
        );
      }
      spans.add(
        TextSpan(text: text.substring(nextHitStart, nextHitEnd), style: hi),
      );
      idx = nextHitEnd;
    }

    return TextSpan(children: spans);
  }

  Color _typeTint(RenderItemType t, BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final alpha = isDark ? 0.22 : 0.10;

    switch (t) {
      case RenderItemType.lesson:
        // blue → brand primary
        return AppTheme.primaryBlue.withValues(alpha: alpha);

      case RenderItemType.part:
        // green → unified keypad accent green
        return AppTheme.keypadAccentGreen.withValues(alpha: alpha);

      case RenderItemType.tool:
        // red → brand primary red
        return AppTheme.primaryRed.withValues(alpha: alpha);

      case RenderItemType.flashcard:
        // neutral fallback (not used in list, but theme-aware)
        return AppTheme.disabledGray.withValues(alpha: isDark ? 0.20 : 0.08);
    }
  }

  // Color _typeTint(RenderItemType t, BuildContext context) {
  //   final isDark = Theme.of(context).brightness == Brightness.dark;
  //   switch (t) {
  //     case RenderItemType.lesson:
  //       // blue
  //       return (isDark ? const Color(0xFF0D47A1) : const Color(0xFF2196F3))
  //           .withOpacity(isDark ? 0.22 : 0.10);
  //     case RenderItemType.part:
  //       // green
  //       return (isDark ? const Color(0xFF1B5E20) : const Color(0xFF4CAF50))
  //           .withOpacity(isDark ? 0.22 : 0.10);
  //     case RenderItemType.tool:
  //       // red
  //       return (isDark ? const Color(0xFFB71C1C) : const Color(0xFFF44336))
  //           .withOpacity(isDark ? 0.22 : 0.10);
  //     case RenderItemType.flashcard:
  //       // not used in search list; keep neutral just in case
  //       return Colors.grey.withOpacity(isDark ? 0.20 : 0.08);
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    final query = _controller.text.trim().toLowerCase();
    final terms =
        query.isEmpty
            ? const <String>[]
            : query.split(RegExp(r'\s+')).where((t) => t.isNotEmpty).toList();

    return Dialog(
      backgroundColor: Colors.white,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: TextField(
              controller: _controller,
              autofocus: true,
              onChanged: _onQueryChanged,
              decoration: InputDecoration(
                labelText: 'Search…',
                border: OutlineInputBorder(),
                suffixIcon: _buildFilterButton(), // 👈 here’s the dropdown
              ),
            ),
          ),

          // ⬇️ Header chip goes here
          if (!_loading && _hits.isNotEmpty)
            _buildHeaderChip(_controller.text.trim(), _hits.length, terms),

          if (_loading)
            const Expanded(child: Center(child: CircularProgressIndicator()))
          else if (_hits.isEmpty)
            const Expanded(child: Center(child: Text('No matches')))
          else
            Expanded(
              child: ListView.separated(
                itemCount: _hits.length,
                separatorBuilder: (_, _) => const Divider(height: 1),

                itemBuilder: (context, i) {
                  final h = _hits[i];
                  final base = Theme.of(context).textTheme.bodyMedium!;
                  final hi = base.copyWith(fontWeight: FontWeight.w700);

                  final titleBase =
                      Theme.of(context).textTheme.titleMedium ??
                      Theme.of(context).textTheme.bodyLarge ??
                      const TextStyle(fontSize: 16);
                  final titleHi = titleBase.copyWith(
                    fontWeight: FontWeight.w700,
                  );

                  // ⬇️ no more "lesson/part/tool • " prefix — snippet only
                  final subRaw = h.snippet.isEmpty ? h.doc.preview : h.snippet;

                  return ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Container(
                      color: _typeTint(h.doc.type, context),
                      child: ListTile(
                        title: RichText(
                          text: _highlight(
                            h.doc.title,
                            terms,
                            titleBase,
                            titleHi,
                          ),
                        ),
                        subtitle: RichText(
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                          text: _highlight(subRaw, terms, base, hi),
                        ),
                        onTap: () => _navigateTo(h.doc),
                      ),
                    ),
                  );
                },

                // itemBuilder: (context, i) {
                //   final h = _hits[i];
                //   final subtitle =
                //       '${h.doc.type.name} • ${h.snippet.isEmpty ? h.doc.preview : h.snippet}';
                //   final titleBase =
                //       Theme.of(context).textTheme.titleMedium ??
                //       Theme.of(context).textTheme.bodyLarge ??
                //       const TextStyle(fontSize: 16);
                //   final titleHi = titleBase.copyWith(
                //     fontWeight: FontWeight.w700,
                //   );

                //   return ListTile(
                //     title: RichText(
                //       text: _highlight(h.doc.title, terms, titleBase, titleHi),
                //     ),
                //     subtitle: RichText(
                //       maxLines: 3,
                //       overflow: TextOverflow.ellipsis,
                //       text: _highlight(subtitle, terms, titleBase, titleHi),
                //     ),
                //     onTap: () => _navigateTo(h.doc),
                //   );
                // },
              ),
            ),
        ],
      ),
    );
  }

  //  for drop down filter
  Widget _buildFilterButton() {
    String labelFor(SearchFilter f) {
      switch (f) {
        case SearchFilter.all:
          return 'All';
        case SearchFilter.lesson:
          return 'Lessons';
        case SearchFilter.part:
          return 'Parts';
        case SearchFilter.tool:
          return 'Tools';
      }
    }

    IconData iconFor(SearchFilter f) {
      switch (f) {
        case SearchFilter.all:
          return Icons.filter_list;
        case SearchFilter.lesson:
          return Icons.menu_book_outlined;
        case SearchFilter.part:
          return Icons.directions_boat_outlined;
        case SearchFilter.tool:
          return Icons.build_outlined;
      }
    }

    return PopupMenuButton<SearchFilter>(
      tooltip: 'Filter results',
      icon: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(iconFor(_filter)),
          const SizedBox(width: 4),
          Text(labelFor(_filter), style: const TextStyle(fontSize: 12)),
          const Icon(Icons.arrow_drop_down),
        ],
      ),
      onSelected: (f) {
        setState(() => _filter = f);
        _runSearch(_controller.text); // re-run with new filter
      },
      itemBuilder:
          (context) => <PopupMenuEntry<SearchFilter>>[
            PopupMenuItem(
              value: SearchFilter.all,
              child: Row(
                children: [
                  Icon(iconFor(SearchFilter.all)),
                  const SizedBox(width: 8),
                  const Text('All'),
                  const Spacer(),
                  if (_filter == SearchFilter.all) const Icon(Icons.check),
                ],
              ),
            ),
            PopupMenuItem(
              value: SearchFilter.lesson,
              child: Row(
                children: [
                  Icon(iconFor(SearchFilter.lesson)),
                  const SizedBox(width: 8),
                  const Text('Lessons'),
                  const Spacer(),
                  if (_filter == SearchFilter.lesson) const Icon(Icons.check),
                ],
              ),
            ),
            PopupMenuItem(
              value: SearchFilter.part,
              child: Row(
                children: [
                  Icon(iconFor(SearchFilter.part)),
                  const SizedBox(width: 8),
                  const Text('Parts'),
                  const Spacer(),
                  if (_filter == SearchFilter.part) const Icon(Icons.check),
                ],
              ),
            ),
            PopupMenuItem(
              value: SearchFilter.tool,
              child: Row(
                children: [
                  Icon(iconFor(SearchFilter.tool)),
                  const SizedBox(width: 8),
                  const Text('Tools'),
                  const Spacer(),
                  if (_filter == SearchFilter.tool) const Icon(Icons.check),
                ],
              ),
            ),
          ],
    );
  }

  bool _matchesFilter(SearchDoc d) {
    switch (_filter) {
      case SearchFilter.all:
        return true;
      case SearchFilter.lesson:
        return d.type == RenderItemType.lesson;
      case SearchFilter.part:
        return d.type == RenderItemType.part;
      case SearchFilter.tool:
        return d.type == RenderItemType.tool;
    }
  }
}
