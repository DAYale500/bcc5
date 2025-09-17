// // lib/data/repositories/lessons/json_lesson_index.dart
// import 'dart:convert';
// import 'package:flutter/services.dart' show rootBundle;
// import 'package:bcc5/utils/logger.dart';

// class JsonLessonIndex {
//   static Future<List<String>> getModuleNames() async {
//     final manifestRaw = await rootBundle.loadString('AssetManifest.json');
//     final Map<String, dynamic> manifest = jsonDecode(manifestRaw);

//     // Find all assets like: assets/json/lessons/<module>.json
//     final lessonModulePaths =
//         manifest.keys
//             .where(
//               (k) =>
//                   k.startsWith('assets/json/lessons/') && k.endsWith('.json'),
//             )
//             .toList()
//           ..sort();

//     // Extract <module> from each path
//     final modules = <String>{};
//     for (final p in lessonModulePaths) {
//       // e.g. assets/json/lessons/terminology.json -> terminology
//       final fileName = p.split('/').last; // terminology.json
//       final module = fileName.substring(0, fileName.length - '.json'.length);
//       modules.add(module);
//     }

//     final list = modules.toList()..sort();
//     logger.i('📦 Discovered lesson modules: ${list.join(', ')}');
//     return list;
//   }

//   static Future<List<Map<String, String>>> getLessonsForModule(
//     String module,
//   ) async {
//     final path = 'assets/json/lessons/$module.json';
//     logger.i('📄 Loading module list from: $path');

//     final manifestRaw = await rootBundle.loadString('AssetManifest.json');
//     final Map<String, dynamic> manifest = jsonDecode(manifestRaw);
//     if (!manifest.keys.contains(path)) {
//       logger.e('🧩 AssetManifest does NOT list $path');
//       return [];
//     }

//     try {
//       final raw = await rootBundle.loadString(path);
//       logger.i('🧾 Read ${raw.length} chars from $path');
//       final Map<String, dynamic> map = jsonDecode(raw);
//       final List lessons = (map['lessons'] as List?) ?? const [];
//       logger.i('✅ $module.json parsed → ${lessons.length} lessons');

//       return lessons
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











// // import 'dart:convert';
// // import 'package:flutter/services.dart' show rootBundle;
// // import 'package:bcc5/utils/logger.dart';
// // import 'package:flutter/foundation.dart';

// // class JsonLessonIndex {
// //   static Future<List<String>> getModuleNames() async {
// //     return [
// //       'docking',
// //       'safety',
// //       'emergencies',
// //       'seamanship',
// //       'terminology',
// //       'systems',
// //       'teamwork',
// //       'knots',
// //       'navigation',
// //     ];
// //   }

// //   static Future<List<Map<String, String>>> getLessonsForModule(
// //     String module,
// //   ) async {
// //     final path =
// //         'assets/json/lessons/$module.json'; // ← keep or change to assets/json/$module.json
// //     logger.i('📄 Loading module list from: $path');

// //     final manifestRaw = await rootBundle.loadString('AssetManifest.json');
// //     final Map<String, dynamic> manifest = jsonDecode(manifestRaw);

// //     // Print everything under assets/json/ to confirm what's bundled
// //     final jsonAssets =
// //         manifest.keys.where((k) => k.startsWith('assets/json/')).toList()
// //           ..sort();
// //     logger.i(
// //       '📦 AssetManifest has ${jsonAssets.length} json assets:\n${jsonAssets.join('\n')}',
// //     );

// //     final key = 'assets/json/lessons/$module.json';
// //     if (!manifest.keys.contains(key)) {
// //       logger.e('🧩 AssetManifest does NOT list $key — bundle/pubspec issue.');
// //       return [];
// //     }
// //     final inBundle = manifest.keys.contains(key);
// //     if (kDebugMode) {
// //       if (!inBundle) {
// //         logger.e('🧩 AssetManifest does NOT list $key — bundle/pubspec issue.');
// //         return []; // bail early so the UI shows empty instead of throwing
// //       } else {
// //         logger.i('✅ AssetManifest contains $key');
// //       }
// //     }

// //     try {
// //       final raw = await rootBundle.loadString(path);
// //       logger.i('🧾 Read ${raw.length} chars from $path'); // sanity check

// //       final Map<String, dynamic> map = jsonDecode(raw);
// //       final List lessons = (map['lessons'] as List?) ?? const [];
// //       logger.i('✅ $module.json parsed → ${lessons.length} lessons');

// //       return lessons
// //           .map<Map<String, String>>(
// //             (e) => {
// //               'id': (e['id'] ?? '').toString(),
// //               'title': (e['title'] ?? e['id'] ?? '').toString(),
// //             },
// //           )
// //           .toList();
// //     } catch (e, st) {
// //       logger.w('❌ Could not load $path → $e\n$st');
// //       return [];
// //     }
// //   }
// // }







// // // import 'dart:convert';
// // // import 'package:flutter/services.dart' show rootBundle;
// // // import 'package:bcc5/utils/logger.dart'; // ⬅️ add this

// // // class JsonLessonIndex {
// // //   static Future<List<String>> getModuleNames() async {
// // //     return [
// // //       'docking',
// // //       'safety',
// // //       'emergencies',
// // //       'seamanship',
// // //       'terminology',
// // //       'systems',
// // //       'teamwork',
// // //       'knots',
// // //       'navigation',
// // //     ];
// // //   }

// // //   static Future<List<Map<String, String>>> getLessonsForModule(
// // //     String module,
// // //   ) async {
// // //     final path = 'assets/json/lessons/$module.json';
// // //     logger.i('📄 Loading module list from: $path');

// // //     try {
// // //       final raw = await rootBundle.loadString(path);
// // //       final Map<String, dynamic> map = jsonDecode(raw);
// // //       final List lessons = (map['lessons'] as List?) ?? const [];
// // //       logger.i('✅ $module.json parsed → ${lessons.length} lessons');

// // //       return lessons
// // //           .map<Map<String, String>>(
// // //             (e) => {
// // //               'id': (e['id'] ?? '').toString(),
// // //               'title': (e['title'] ?? e['id'] ?? '').toString(),
// // //             },
// // //           )
// // //           .toList();
// // //     } catch (e, st) {
// // //       logger.w('❌ Could not load $path → $e\n$st');
// // //       return [];
// // //     }
// // //   }
// // // }







// // // // import 'dart:convert';
// // // // import 'package:flutter/services.dart' show rootBundle;
// // // // import 'package:bcc5/utils/logger.dart'; // add

// // // // class JsonLessonIndex {
// // // //   static Future<List<String>> getModuleNames() async {
// // // //     // hardcode for now; we can auto-discover later
// // // //     return [
// // // //       'docking',
// // // //       'safety',
// // // //       'emergencies',
// // // //       'seamanship',
// // // //       'terminology',
// // // //       'systems',
// // // //       'teamwork',
// // // //       'knots',
// // // //       'navigation',
// // // //     ];
// // // //   }

// // // //   /// Reads one JSON file per module: assets/json/lessons/`<module>`.json
// // // //   /// import 'package:bcc5/utils/logger.dart'; // add

// // // //   static Future<List<Map<String, String>>> getLessonsForModule(
// // // //     String module,
// // // //   ) async {
// // // //     final path = 'assets/json/lessons/$module.json';
// // // //     try {
// // // //       final raw = await rootBundle.loadString(path);
// // // //       final Map<String, dynamic> map = jsonDecode(raw);
// // // //       final List lessons = (map['lessons'] as List?) ?? const [];
// // // //       logger.i('📚 $module: loaded ${lessons.length} lessons from $path');
// // // //       return lessons
// // // //           .map<Map<String, String>>(
// // // //             (e) => {
// // // //               'id': (e['id'] ?? '').toString(),
// // // //               'title': (e['title'] ?? e['id'] ?? '').toString(),
// // // //             },
// // // //           )
// // // //           .toList();
// // // //     } catch (e, st) {
// // // //       logger.e('❌ Failed to parse $path → $e\n$st');
// // // //       return [];
// // // //     }
// // // //   }

// // // //   // static Future<List<Map<String, String>>> getLessonsForModule(
// // // //   //   String module,
// // // //   // ) async {
// // // //   //   final path = 'assets/json/lessons/$module.json';
// // // //   //   try {
// // // //   //     final raw = await rootBundle.loadString(path);
// // // //   //     final Map<String, dynamic> map = jsonDecode(raw);
// // // //   //     final List lessons = (map['lessons'] as List?) ?? const [];
// // // //   //     return lessons
// // // //   //         .map<Map<String, String>>(
// // // //   //           (e) => {
// // // //   //             'id': (e['id'] ?? '').toString(),
// // // //   //             'title': (e['title'] ?? e['id'] ?? '').toString(),
// // // //   //           },
// // // //   //         )
// // // //   //         .toList();
// // // //   //   } catch (_) {
// // // //   //     return [];
// // // //   //   }
// // // //   // }
// // // // }




// // // // // import 'dart:convert';
// // // // // import 'package:flutter/services.dart' show rootBundle;



// // // // // class JsonLessonIndex {

// // // // // // lib/data/repositories/lessons/json_lesson_index.dart
// // // // // static Future<List<Map<String, String>>> getLessonsForModule(String module) async {
// // // // //   final path = 'assets/json/lessons/$module.json';
// // // // //   final raw = await rootBundle.loadString(path);
// // // // //   final Map map = jsonDecode(raw);
// // // // //   final List lessons = (map['lessons'] as List?) ?? const [];
// // // // //   return lessons.map<Map<String,String>>((e) => {
// // // // //     'id': (e['id'] ?? '').toString(),
// // // // //     'title': (e['title'] ?? e['id'] ?? '').toString(),
// // // // //   }).toList();
// // // // // }


// // // // // // lib/data/repositories/lessons/json_lesson_repository.dart
// // // // // static String? _moduleFor(String id) {
// // // // //   if (id.startsWith('lesson_term_')) return 'terminology';
// // // // //   // (add your other prefixes later)
// // // // //   return null;
// // // // // }

// // // // // static Future<Lesson?> loadById(String id) async {
// // // // //   final module = _moduleFor(id);
// // // // //   if (module != null) {
// // // // //     final raw = await rootBundle.loadString('assets/json/lessons/$module.json');
// // // // //     final Map map = jsonDecode(raw);
// // // // //     final List lessons = (map['lessons'] as List?) ?? const [];
// // // // //     final match = lessons.cast<Map>().firstWhere(
// // // // //       (e) => (e['id'] ?? '') == id,
// // // // //       orElse: () => {},
// // // // //     );
// // // // //     if (match.isNotEmpty) {
// // // // //       return Lesson.fromJson(Map<String, dynamic>.from(match));
// // // // //     }
// // // // //   }
// // // // //   return null; // (you can keep your old per-file fallback during migration if you want)
// // // // // }


// // // // //   static Future<List<String>> getModuleNames() async {
// // // // //     // keep your hardcoded list for now
// // // // //     return [
// // // // //       'docking',
// // // // //       'safety',
// // // // //       'emergencies',
// // // // //       'seamanship',
// // // // //       'terminology',
// // // // //       'systems',
// // // // //       'teamwork',
// // // // //       'knots',
// // // // //       'navigation',
// // // // //     ];
// // // // //   }

// // // // //   static Future<List<Map<String, String>>> getLessonsForModule(
// // // // //     String module,
// // // // //   ) async {
// // // // //     // Map module -> expected index filename
// // // // //     final indexName = switch (module) {
// // // // //       'docking' => 'index_lesson_dock.json',
// // // // //       'safety' => 'index_lesson_safety.json',
// // // // //       'emergencies' => 'index_lesson_emer.json',
// // // // //       'seamanship' => 'index_lesson_seamanship.json',
// // // // //       'terminology' => 'index_lesson_term.json',
// // // // //       'systems' => 'index_lesson_syst.json',
// // // // //       'teamwork' => 'index_lesson_team.json',
// // // // //       'knots' => 'index_lesson_knots.json',
// // // // //       'navigation' => 'index_lesson_navigation.json',
// // // // //       _ => 'index_lesson_$module.json',
// // // // //     };

// // // // //     final path = 'assets/json/lessons/$module/$indexName';

// // // // //     try {
// // // // //       final raw = await rootBundle.loadString(path);
// // // // //       final List list = jsonDecode(raw);
// // // // //       // index entries look like: {"id": "...", "title": "...", "description": "..."}
// // // // //       return list
// // // // //           .map<Map<String, String>>(
// // // // //             (e) => {'id': e['id'] as String, 'title': e['title'] as String},
// // // // //           )
// // // // //           .toList();
// // // // //     } catch (_) {
// // // // //       // If no index file yet, return empty for now (we’ll add manifest-scanning later)
// // // // //       return [];
// // // // //     }
// // // // //   }
// // // // // }
