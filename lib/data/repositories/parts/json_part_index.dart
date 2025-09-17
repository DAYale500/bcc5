// // lib/data/repositories/parts/json_part_index.dart
// import 'dart:convert';
// import 'package:flutter/services.dart' show rootBundle;
// import 'package:bcc5/utils/logger.dart';

// class JsonPartIndex {
//   /// Auto-discovers part modules from the asset bundle.
//   /// Looks for: assets/json/parts/`<module>`.json
//   static Future<List<String>> getModuleNames() async {
//     final manifestRaw = await rootBundle.loadString('AssetManifest.json');
//     final Map<String, dynamic> manifest = jsonDecode(manifestRaw);

//     final partModulePaths =
//         manifest.keys
//             .where(
//               (k) => k.startsWith('assets/json/parts/') && k.endsWith('.json'),
//             )
//             .toList()
//           ..sort();

//     final modules = <String>{};
//     for (final p in partModulePaths) {
//       final fileName = p.split('/').last; // e.g., hull.json
//       final module = fileName.substring(0, fileName.length - '.json'.length);
//       modules.add(module);
//     }

//     final list = modules.toList()..sort();
//     logger.i('🧩 Discovered part modules: ${list.join(', ')}');
//     return list;
//   }

//   /// Returns lightweight rows for the module’s list UI: [{id, title}, ...]
//   /// Expects: assets/json/parts/`<module>`.json with a top-level "parts": [...]
//   static Future<List<Map<String, String>>> getPartsForModule(
//     String module,
//   ) async {
//     final path = 'assets/json/parts/$module.json';
//     logger.i('📄 Loading parts list from: $path');

//     try {
//       final raw = await rootBundle.loadString(path);
//       final Map<String, dynamic> map = jsonDecode(raw);
//       final List parts = (map['parts'] as List?) ?? const [];
//       logger.i('✅ $module.json parsed → ${parts.length} parts');

//       return parts
//           .map<Map<String, String>>(
//             (e) => {
//               'id': (e['id'] ?? '').toString(),
//               'title': (e['title'] ?? e['id'] ?? '').toString(),
//             },
//           )
//           .toList();
//     } catch (e, st) {
//       logger.w('❌ Could not load $path → $e\n$st');
//       return [];
//     }
//   }
// }
