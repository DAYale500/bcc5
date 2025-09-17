// tool/csv_to_json.dart
import 'dart:convert';
import 'dart:io';
import 'package:csv/csv.dart';

bool get _verbose => Platform.executableArguments.contains('--verbose');

Future<List<Map<String, String>>> _readCsv(String path) async {
  final f = File(path);
  if (!await f.exists()) return [];
  final rows = const CsvToListConverter(
    eol: '\n',
    shouldParseNumbers: false,
  ).convert(await f.readAsString());
  if (rows.isEmpty) return [];
  final headers = rows.first.map((e) => e.toString()).toList();
  return rows.skip(1).map((r) {
    final m = <String, String>{};
    for (var i = 0; i < headers.length && i < r.length; i++) {
      m[headers[i]] = (r[i] ?? '').toString();
    }
    return m;
  }).toList();
}

/// Very small MD -> blocks parser for our allowed syntax:
/// ## heading, plain text paragraphs, - bullets, ![alt](path) images.
List<Map<String, dynamic>> _blocksFromMarkdown(String md) {
  final lines = md.replaceAll('\r\n', '\n').split('\n');
  final blocks = <Map<String, dynamic>>[];

  void addParagraph(StringBuffer buf) {
    final text = buf.toString().trim();
    if (text.isNotEmpty) {
      blocks.add({'type': 'text', 'content': text});
    }
    buf.clear();
  }

  var bulletBuffer = <String>[];
  final para = StringBuffer();

  void flushBullets() {
    if (bulletBuffer.isNotEmpty) {
      blocks.add({'type': 'bullets', 'items': List.of(bulletBuffer)});
      bulletBuffer.clear();
    }
  }

  for (final raw in lines) {
    final line = raw.trimRight();

    if (line.isEmpty) {
      flushBullets();
      addParagraph(para);
      continue;
    }

    // heading
    if (line.startsWith('#')) {
      flushBullets();
      addParagraph(para);
      final text = line.replaceFirst(RegExp(r'^#{1,6}\s*'), '').trim();
      blocks.add({'type': 'heading', 'content': text});
      continue;
    }

    // image ![alt](path)
    final img = RegExp(r'!\[[^\]]*\]\(([^)]+)\)').firstMatch(line);
    if (img != null) {
      flushBullets();
      addParagraph(para);
      blocks.add({'type': 'image', 'content': img.group(1)});
      continue;
    }

    // bullet "- "
    if (line.trimLeft().startsWith('- ')) {
      addParagraph(para);
      bulletBuffer.add(line.trimLeft().substring(2).trim());
      continue;
    }

    // paragraph line
    if (para.isNotEmpty) para.write('\n');
    para.write(line.trim());
  }

  flushBullets();
  addParagraph(para);
  return blocks;
}

Future<List<Map<String, String>>> _readDirCsv(String dirPath) async {
  final dir = Directory(dirPath);
  if (!await dir.exists()) return [];
  final all = <Map<String, String>>[];
  await for (final e in dir.list()) {
    if (e is File && e.path.toLowerCase().endsWith('.csv')) {
      if (_verbose) stdout.writeln('↪︎ reading ${e.path}');
      all.addAll(await _readCsv(e.path));
    }
  }
  return all;
}

String _basenameNoExt(String path) {
  final name = path.split(Platform.pathSeparator).last;
  final dot = name.lastIndexOf('.');
  return dot == -1 ? name : name.substring(0, dot);
}

Future<void> _emitLessonsFromDir() async {
  final dir = Directory('data_csv/lessons');
  if (!await dir.exists()) return;

  // Group rows by module derived from filename.
  // We read file-by-file to know the module for each row.
  await for (final e in dir.list()) {
    if (e is! File || !e.path.endsWith('.csv')) continue;
    final fileRows = await _readCsv(e.path);
    if (fileRows.isEmpty) continue;

    // prefer explicit module column; else filename after "lessons_"
    String module = '';
    final fname = _basenameNoExt(e.path);
    final m = RegExp(r'^lessons_(.+)$').firstMatch(fname);
    if (m != null) module = m.group(1)!;

    final items = <Map<String, dynamic>>[];
    for (final r in fileRows) {
      final id = r['id']?.trim() ?? '';
      if (id.isEmpty) continue;

      final lessonModule = (r['module'] ?? '').trim();
      final usedModule = lessonModule.isNotEmpty ? lessonModule : module;

      final title = r['title'] ?? '';
      final keywords =
          (r['keywords'] ?? '')
              .split(RegExp(r'[;,]'))
              .map((s) => s.trim())
              .where((s) => s.isNotEmpty)
              .toList();
      final isPaid = (r['isPaid'] ?? '').toLowerCase() == 'true';
      final contentMd = (r['content_md'] ?? '').trim();
      final contentFile = (r['content_file'] ?? '').trim();

      String md = contentMd;
      if (md.isEmpty && contentFile.isNotEmpty) {
        final f = File(contentFile);
        if (await f.exists()) {
          md = await f.readAsString();
        } else {
          stderr.writeln('⚠️  content_file missing for $id → $contentFile');
        }
      }
      final blocks = _blocksFromMarkdown(md);

      final json = {
        'id': id,
        'title': title,
        'content': blocks,
        'keywords': keywords,
        'isPaid': isPaid,
      };

      final fids = (r['flashcard_ids'] ?? '').trim();
      if (fids.isNotEmpty) {
        json['flashcards'] =
            fids
                .split(RegExp(r'[;,]'))
                .map((s) => s.trim())
                .where((s) => s.isNotEmpty)
                .toList();
      }

      items.add(json);

      if (_verbose) {
        stdout.writeln(
          '  • lesson $id (${usedModule.isEmpty ? 'unknown' : usedModule}) '
          'blocks=${blocks.length}',
        );
      }
    }

    final usedModule = module.isEmpty ? 'general' : module;
    final out = {'module': usedModule, 'lessons': items};
    final outPath = 'assets/json/lessons/$usedModule.json';
    await File(outPath).create(recursive: true);
    await File(
      outPath,
    ).writeAsString(const JsonEncoder.withIndent('  ').convert(out));
    stdout.writeln('✅ wrote $outPath  (lessons: ${items.length})');
  }
}

Future<void> _emitPaths() async {
  final paths = await _readCsv('data_csv/paths/paths.csv');
  final pathItems = await _readCsv('data_csv/paths/path_items.csv');

  final byChapter = <String, List<Map<String, String>>>{};
  for (final pi in pathItems) {
    final chap = (pi['chapter_id'] ?? '').trim();
    if (chap.isEmpty) continue;
    byChapter.putIfAbsent(chap, () => []).add(pi);
  }
  for (final list in byChapter.values) {
    list.sort(
      (a, b) => int.tryParse(
        a['order'] ?? '0',
      )!.compareTo(int.tryParse(b['order'] ?? '0')!),
    );
  }

  final byPath = <String, Map<String, dynamic>>{};
  for (final p in paths) {
    final pathName = (p['path_name'] ?? '').trim().toLowerCase();
    if (pathName.isEmpty) continue;
    final chapterId = (p['chapter_id'] ?? '').trim();
    final title = (p['chapter_title'] ?? '').trim();
    final showEnding =
        (p['showFlashcardEnding'] ?? 'true').toLowerCase() == 'true';
    final items =
        (byChapter[chapterId] ?? [])
            .map((r) => {'pathItemId': (r['item_id'] ?? '').trim()})
            .toList();

    final chapterJson = {
      'id': chapterId,
      'title': title,
      'showFlashcardEnding': showEnding,
      'items': items,
    };

    final pathJson = byPath.putIfAbsent(
      pathName,
      () => {'chapters': <dynamic>[]},
    );
    (pathJson['chapters'] as List).add(chapterJson);
  }

  for (final e in byPath.entries) {
    final slug = e.key.replaceAll(' ', '-');
    final outPath = 'assets/json/paths/$slug.json';
    await File(outPath).create(recursive: true);
    await File(
      outPath,
    ).writeAsString(const JsonEncoder.withIndent('  ').convert(e.value));
    stdout.writeln(
      '✅ wrote $outPath  (chapters: ${(e.value['chapters'] as List).length})',
    );
  }
}

Future<void> main(List<String> args) async {
  stdout.writeln('🚢 CSV → JSON starting…');
  await _emitLessonsFromDir();
  await _emitPaths();
  stdout.writeln('🎉 Done.');
}


// Usage (one-time or anytime you update the sheet):
// Export each sheet as CSV into data_csv/.
// Run: dart run tool/csv_to_json.dart
// Commit the generated JSON under assets/json/... (your app already reads from there).
// Optional: run printValidation('<path name>') to sanity-check before shipping.