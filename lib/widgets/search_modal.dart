// lib/widgets/search_modal.dart
import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:go_router/go_router.dart';

import 'package:bcc5/data/models/render_item.dart';
import 'package:bcc5/utils/render_item_helpers.dart';
import 'package:bcc5/navigation/detail_route.dart';

/// 🔁 Simple, in-memory persistence for the search modal.
class SearchMemory {
  static String lastQuery = '';
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

  String _buildHaystack(Map<String, dynamic> map, String title, String id) {
    final kws = _keywordsFromMap(map).join(' ');
    final text = _extractTextContent(map);
    return [title, id, kws, text].where((s) => s.trim().isNotEmpty).join(' • ');
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

  // ───────────────── Search / Scoring ─────────────────

  void _onQueryChanged(String q) {
    _debouncer?.cancel();
    _debouncer = Timer(_debounce, () => _runSearch(q));
  }

  void _runSearch(String query) {
    final q = query.trim().toLowerCase();
    SearchMemory.lastQuery = q; // 🔁 persist the current query

    if (q.isEmpty) {
      setState(() {
        _hits = _index.map((d) => SearchHit(d, 0, d.preview)).toList();
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
      final h = d.haystack;
      for (final t in terms) {
        final i = h.indexOf(t);
        if (i >= 0) {
          final start = (i - 50).clamp(0, h.length);
          final end = (i + t.length + 80).clamp(0, h.length);
          final slice = d.haystack.substring(start, end).trim();
          if (slice.isNotEmpty) return slice;
        }
      }
      return d.preview;
    }

    final hits = <SearchHit>[];
    for (final d in _index) {
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

    // OPTIONAL: if you later want the branch screen to auto-reopen the search
    // on Back, you can pass:
    // extra['backExtra'] = {'reopenSearch': true, 'query': SearchMemory.lastQuery};
    // Then, in those branch screens, check extras and showDialog(SearchModal()).
    // The router already supports `backExtra` on detail routes. :contentReference[oaicite:0]{index=0}
  }

  // ───────────────── UI (with highlights) ─────────────────

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
              decoration: const InputDecoration(
                labelText: 'Search…',
                border: OutlineInputBorder(),
              ),
            ),
          ),
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
                  final subtitle =
                      '${h.doc.type.name} • ${h.snippet.isEmpty ? h.doc.preview : h.snippet}';
                  final base = Theme.of(context).textTheme.bodyMedium!;
                  final hi = base.copyWith(fontWeight: FontWeight.w700);

                  return ListTile(
                    title: Text(h.doc.title),
                    subtitle: RichText(
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      text: _highlight(subtitle, terms, base, hi),
                    ),
                    onTap: () => _navigateTo(h.doc),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
}
