// // universal_convert.dart
// // Universal CSV <-> JSON converter for BCC5: lessons, parts, tools (+ optional flashcards).
// //
// // Directory-first workflow (recommended):
// //   CSV -> JSON:
// //     dart run tool/universal_convert.dart to-json --type=lessons
// //     dart run tool/universal_convert.dart to-json --type=parts
// //     dart run tool/universal_convert.dart to-json --type=tools
// //
// //   JSON -> CSV:
// //     dart run tool/universal_convert.dart to-csv --type=lessons
// //     dart run tool/universal_convert.dart to-csv --type=parts
// //     dart run tool/universal_convert.dart to-csv --type=tools
// //
// // Conventions
// // ----------
// // CSV input folders (place your exported sheets here):
// //   data_csv/lessons/*.csv
// //   data_csv/parts/*.csv
// //   data_csv/tools/*.csv
// //   data_csv/flashcards/*.csv   (optional)
// //
// // Naming suggests module (but you can also provide a 'module' column):
// //   lessons_seamanship.csv   -> module 'seamanship'
// //   parts_engine.csv         -> module 'engine'
// //   tools_docking.csv        -> module 'docking'
// //
// // Core CSV columns for items (per-row):
// //   id,title,keywords,isPaid,content_md,content_file,module
// //   - keywords: split on ',' or ';'
// //   - content_md: inline markdown (## headings, paragraphs, '- ' bullets, ![alt](path) images)
// //   - content_file: optional path to .md file if content_md is empty
// //   - module: optional explicit override (else inferred from filename)
// //   - isPaid: true/false
// //
// // Optional flashcards CSV(s):
// //   Columns: parent_id,card_id,title,sideA_text,sideB_text,isPaid,showAFirst,module
// //   - parent_id: id of the parent item (lesson/part/tool)
// //   - module: optional explicit override (else we try to infer from filename suffix)
// //   One file per module (e.g., flashcards_lessons_seamanship.csv)
// //   OR one combined file data_csv/flashcards/flashcards.csv with 'type' and 'module' columns.
// //
// // JSON output format mirrors current lessons JSON (embedding flashcards):
// //   assets/json/<type>/<module>.json:
// //     { "module": "<module>", "<type>": [ ...items... ] }
// //
// // Requirements
// // ------------
// // Add to pubspec.yaml:
// // dependencies:
// //   csv: ^6.0.0
// //
// // Then: dart pub get
// //
// // Notes
// // -----
// // - The markdown <-> blocks conversion intentionally supports a small subset:
// //   ## heading, paragraphs, '- ' bullets, and images ![alt](path).
// // - If you need richer types later, you can extend the MD parser/renderer below.
// // - This tool is branch-agnostic and standardizes your authoring pipeline.
// //
// // (c) BCC5 authoring utility

// import 'dart:convert';
// import 'dart:io';
// import 'package:csv/csv.dart';

// bool get _verbose => Platform.executableArguments.contains('--verbose');

// // --------------------- CSV helpers ---------------------
// Future<List<Map<String, String>>> _readCsv(String path) async {
//   final f = File(path);
//   if (!await f.exists()) return [];
//   final rows = const CsvToListConverter(
//     eol: '\n',
//     shouldParseNumbers: false,
//   ).convert(await f.readAsString());
//   if (rows.isEmpty) return [];
//   final headers = rows.first.map((e) => e.toString()).toList();
//   return rows.skip(1).map((r) {
//     final m = <String, String>{};
//     for (var i = 0; i < headers.length && i < r.length; i++) {
//       m[headers[i]] = (r[i] ?? '').toString();
//     }
//     return m;
//   }).toList();
// }

// Future<void> _writeCsv(String path, List<List<dynamic>> rows) async {
//   await File(path).create(recursive: true);
//   await File(path).writeAsString(const ListToCsvConverter().convert(rows));
// }

// String _basenameNoExt(String path) {
//   final name = path.split(Platform.pathSeparator).last;
//   final dot = name.lastIndexOf('.');
//   return dot == -1 ? name : name.substring(0, dot);
// }

// String _inferModuleFromName(String fileStem, String type) {
//   // e.g., lessons_seamanship -> seamanship
//   final re = RegExp('^' + RegExp.escape(type) + '_(.+)\$');
//   final m = re.firstMatch(fileStem);
//   if (m != null) return m.group(1)!;
//   // e.g., flashcards_lessons_seamanship -> seamanship
//   final re2 = RegExp('^flashcards_' + RegExp.escape(type) + '_(.+)\$');
//   final m2 = re2.firstMatch(fileStem);
//   if (m2 != null) return m2.group(1)!;
//   return '';
// }

// // --------------------- Markdown <-> blocks ---------------------
// List<Map<String, dynamic>> _blocksFromMarkdown(String md) {
//   final lines = md.replaceAll('\r\n', '\n').split('\n');
//   final blocks = <Map<String, dynamic>>[];

//   void addParagraph(StringBuffer buf) {
//     final text = buf.toString().trim();
//     if (text.isNotEmpty) {
//       blocks.add({'type': 'text', 'content': text});
//     }
//     buf.clear();
//   }

//   var bulletBuffer = <String>[];
//   final para = StringBuffer();

//   void flushBullets() {
//     if (bulletBuffer.isNotEmpty) {
//       blocks.add({'type': 'bullets', 'items': List.of(bulletBuffer)});
//       bulletBuffer.clear();
//     }
//   }

//   for (final raw in lines) {
//     final line = raw.trimRight();

//     if (line.isEmpty) {
//       flushBullets();
//       addParagraph(para);
//       continue;
//     }

//     // heading
//     if (line.startsWith('#')) {
//       flushBullets();
//       addParagraph(para);
//       final text = line.replaceFirst(RegExp(r'^#{1,6}\s*'), '').trim();
//       blocks.add({'type': 'heading', 'content': text});
//       continue;
//     }

//     // image ![alt](path)
//     final img = RegExp(r'!\[[^\]]*\]\(([^)]+)\)').firstMatch(line);
//     if (img != null) {
//       flushBullets();
//       addParagraph(para);
//       blocks.add({'type': 'image', 'content': img.group(1)});
//       continue;
//     }

//     // bullet "- "
//     if (line.trimLeft().startsWith('- ')) {
//       addParagraph(para);
//       bulletBuffer.add(line.trimLeft().substring(2).trim());
//       continue;
//     }

//     // paragraph line
//     if (para.isNotEmpty) para.write('\n');
//     para.write(line.trim());
//   }

//   flushBullets();
//   addParagraph(para);
//   return blocks;
// }

// String _markdownFromBlocks(List blocks) {
//   final buf = StringBuffer();
//   for (final b in blocks) {
//     if (b is! Map) continue;
//     final type = (b['type'] ?? '').toString();
//     switch (type) {
//       case 'heading':
//         buf.writeln('## ${b['content'] ?? ''}');
//         buf.writeln();
//         break;
//       case 'bullets':
//         final items = (b['items'] as List?) ?? const [];
//         for (final it in items) {
//           buf.writeln('- ${it ?? ''}');
//         }
//         buf.writeln();
//         break;
//       case 'image':
//         final path = b['content'] ?? '';
//         buf.writeln('![]($path)');
//         buf.writeln();
//         break;
//       case 'text':
//       default:
//         final t = b['content'] ?? '';
//         if ('$t'.trim().isNotEmpty) {
//           buf.writeln('$t');
//           buf.writeln();
//         }
//         break;
//     }
//   }
//   return buf.toString().trimRight();
// }

// // --------------------- Flashcards helpers ---------------------
// class _FlashIndex {
//   final Map<String, List<Map<String, dynamic>>> byParent = {};
//   void add(String parentId, Map<String, dynamic> card) {
//     (byParent[parentId] ??= []).add(card);
//   }
// }

// // Reads flashcards from files under data_csv/flashcards/, supports:
// //  - flashcards_<type>_<module>.csv
// //  - flashcards.csv (with 'type' and 'module' columns)
// Future<_FlashIndex> _readFlashDir(String type) async {
//   final idx = _FlashIndex();
//   final dir = Directory('data_csv/flashcards');
//   if (!await dir.exists()) return idx;

//   await for (final e in dir.list()) {
//     if (e is! File || !e.path.toLowerCase().endsWith('.csv')) continue;
//     final stem = _basenameNoExt(e.path);
//     final rows = await _readCsv(e.path);
//     if (rows.isEmpty) continue;

//     // detect mode
//     bool combined = rows.first.containsKey('type') || rows.first.containsKey('module');

//     if (combined) {
//       for (final r in rows) {
//         final rType = (r['type'] ?? '').trim().toLowerCase();
//         if (rType.isNotEmpty && rType != type.toLowerCase()) continue;
//         final parentId = (r['parent_id'] ?? '').trim();
//         if (parentId.isEmpty) continue;
//         idx.add(parentId, {
//           'id': (r['card_id'] ?? '').trim(),
//           'title': (r['title'] ?? '').trim(),
//           'sideA': [
//             {'type': 'text', 'content': (r['sideA_text'] ?? '').toString()}
//           ],
//           'sideB': [
//             {'type': 'text', 'content': (r['sideB_text'] ?? '').toString()}
//           ],
//           'isPaid': ((r['isPaid'] ?? '').toLowerCase() == 'true'),
//           'showAFirst': ((r['showAFirst'] ?? 'true').toLowerCase() == 'true'),
//         });
//       }
//     } else {
//       // infer module from filename; we don't need it for grouping, just add cards
//       for (final r in rows) {
//         final parentId = (r['parent_id'] ?? '').trim();
//         if (parentId.isEmpty) continue;
//         idx.add(parentId, {
//           'id': (r['card_id'] ?? '').trim(),
//           'title': (r['title'] ?? '').trim(),
//           'sideA': [
//             {'type': 'text', 'content': (r['sideA_text'] ?? '').toString()}
//           ],
//           'sideB': [
//             {'type': 'text', 'content': (r['sideB_text'] ?? '').toString()}
//           ],
//           'isPaid': ((r['isPaid'] ?? '').toLowerCase() == 'true'),
//           'showAFirst': ((r['showAFirst'] ?? 'true').toLowerCase() == 'true'),
//         });
//       }
//     }
//   }
//   return idx;
// }

// // --------------------- Emit JSON from CSVs ---------------------
// Future<void> _emitTypeFromDir(String type) async {
//   final dir = Directory('data_csv/' + type);
//   if (!await dir.exists()) {
//     stderr.writeln('No directory data_csv/' + type + ' — skipping.');
//     return;
//   }

//   final flashIndex = await _readFlashDir(type);
//   await for (final e in dir.list()) {
//     if (e is! File || !e.path.toLowerCase().endsWith('.csv')) continue;
//     final fileRows = await _readCsv(e.path);
//     if (fileRows.isEmpty) continue;

//     var module = '';
//     final stem = _basenameNoExt(e.path);
//     module = _inferModuleFromName(stem, type);
//     if (_verbose) stdout.writeln('↪︎ reading ' + e.path + ' (module: ' + (module.isEmpty ? '(infer later)' : module) + ')');

//     final items = <Map<String, dynamic>>[];
//     for (final r in fileRows) {
//       final id = (r['id'] ?? '').trim();
//       if (id.isEmpty) continue;

//       final rowModule = (r['module'] ?? '').trim();
//       final usedModule = rowModule.isNotEmpty ? rowModule : module;

//       final title = r['title'] ?? '';
//       final keywords = ((r['keywords'] ?? ''))
//           .split(RegExp(r'[;,]'))
//           .map((s) => s.trim())
//           .where((s) => s.isNotEmpty)
//           .toList();
//       final isPaid = ((r['isPaid'] ?? '').toLowerCase() == 'true');

//       // content
//       String md = (r['content_md'] ?? '').toString().trim();
//       final contentFile = (r['content_file'] ?? '').toString().trim();
//       if (md.isEmpty && contentFile.isNotEmpty) {
//         final f = File(contentFile);
//         if (await f.exists()) {
//           md = await f.readAsString();
//         } else {
//           stderr.writeln('⚠️  content_file missing for ' + id + ' → ' + contentFile);
//         }
//       }
//       final blocks = _blocksFromMarkdown(md);

//       final json = {
//         'id': id,
//         'title': title,
//         'content': blocks,
//         'keywords': keywords,
//         'isPaid': isPaid,
//       };

//       // attach flashcards if any
//       final fc = flashIndex.byParent[id];
//       if (fc != null && fc.isNotEmpty) {
//         json['flashcards'] = fc;
//       }

//       items.add(json);

//       if (_verbose) {
//         stdout.writeln('  • ' + type + ' ' + id + ' (' + (usedModule.isEmpty ? 'unknown' : usedModule) + ') blocks=' + blocks.length.toString() + ' flash=' + (fc?.length ?? 0).toString());
//       }
//     }

//     final usedModule = module.isEmpty ? 'general' : module;
//     final out = {'module': usedModule, type: items};
//     final outPath = 'assets/json/' + type + '/' + usedModule + '.json';
//     await File(outPath).create(recursive: true);
//     await File(outPath).writeAsString(const JsonEncoder.withIndent('  ').convert(out));
//     stdout.writeln('✅ wrote ' + outPath + '  (' + type + ': ' + items.length.toString() + ')');
//   }
// }

// // --------------------- Emit CSVs from JSON bundles ---------------------
// Future<void> _emitCsvFromJson(String type) async {
//   final dir = Directory('assets/json/' + type);
//   if (!await dir.exists()) {
//     stderr.writeln('No directory assets/json/' + type + ' — skipping.');
//     return;
//   }

//   await for (final e in dir.list()) {
//     if (e is! File || !e.path.toLowerCase().endsWith('.json')) continue;
//     final stem = _basenameNoExt(e.path); // module
//     final module = stem;

//     final obj = jsonDecode(await File(e.path).readAsString()) as Map;
//     final list = (obj[type] as List?) ?? const [];

//     // Items CSV
//     final itemRows = <List<dynamic>>[
//       ['id','title','keywords','isPaid','content_md','content_file','module']
//     ];

//     // Flashcards CSV
//     final flashRows = <List<dynamic>>[
//       ['parent_id','card_id','title','sideA_text','sideB_text','isPaid','showAFirst','module']
//     ];

//     for (final it in list) {
//       if (it is! Map) continue;
//       final id = it['id'] ?? '';
//       final title = it['title'] ?? '';
//       final isPaid = it['isPaid'] ?? false;
//       final keywords = ((it['keywords'] as List?) ?? const []).join(', ');
//       final md = _markdownFromBlocks((it['content'] as List?) ?? const []);

//       itemRows.add([
//         id, title, keywords, isPaid, md, '', module
//       ]);

//       final cards = (it['flashcards'] as List?) ?? const [];
//       for (final c in cards) {
//         if (c is! Map) continue;
//         String sideText(List? side) {
//           if (side == null) return '';
//           final buf = StringBuffer();
//           for (final seg in side) {
//             if (seg is Map && seg['type'] == 'text') {
//               if (buf.isNotEmpty) buf.writeln();
//               buf.write(seg['content'] ?? '');
//             } else {
//               if (buf.isNotEmpty) buf.writeln();
//               buf.write(jsonEncode(seg));
//             }
//           }
//           return buf.toString();
//         }
//         flashRows.add([
//           id,
//           c['id'] ?? '',
//           c['title'] ?? '',
//           sideText(c['sideA'] as List?),
//           sideText(c['sideB'] as List?),
//           c['isPaid'] ?? false,
//           c['showAFirst'] ?? true,
//           module,
//         ]);
//       }
//     }

//     final outItems = 'data_csv/' + type + '/' + type + '_' + module + '.csv';
//     final outFlash = 'data_csv/flashcards/flashcards_' + type + '_' + module + '.csv';
//     await _writeCsv(outItems, itemRows);
//     await _writeCsv(outFlash, flashRows);
//     stdout.writeln('✅ wrote ' + outItems + ' and ' + outFlash);
//   }
// }

// // --------------------- CLI ---------------------
// Map<String, String> _parseArgs(List<String> args) {
//   final map = <String, String>{};
//   for (final a in args) {
//     final i = a.indexOf('=');
//     if (i > 0 && a.startsWith('--')) {
//       map[a.substring(2, i)] = a.substring(i + 1);
//     }
//   }
//   return map;
// }

// String _mustType(Map<String, String> opts) {
//   final v = (opts['type'] ?? '').trim().toLowerCase();
//   if (v.isEmpty || !['lessons','parts','tools'].contains(v)) {
//     stderr.writeln("Missing or invalid --type. Use one of: lessons, parts, tools");
//     exit(64);
//   }
//   return v;
// }

// Future<void> main(List<String> args) async {
//   if (args.isEmpty) {
//     stderr.writeln('Usage: to-json|to-csv --type=lessons|parts|tools [--verbose]');
//     exit(64);
//   }
//   final mode = args.first;
//   final opts = _parseArgs(args.skip(1).toList());
//   final type = _mustType(opts);

//   if (mode == 'to-json') {
//     await _emitTypeFromDir(type);
//   } else if (mode == 'to-csv') {
//     await _emitCsvFromJson(type);
//   } else {
//     stderr.writeln('Unknown mode: ' + mode);
//     exit(64);
//   }
// }
