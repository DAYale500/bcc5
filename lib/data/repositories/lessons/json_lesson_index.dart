import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:bcc5/utils/logger.dart'; // add

class JsonLessonIndex {
  static Future<List<String>> getModuleNames() async {
    // hardcode for now; we can auto-discover later
    return [
      'docking',
      'safety',
      'emergencies',
      'seamanship',
      'terminology',
      'systems',
      'teamwork',
      'knots',
      'navigation',
    ];
  }

  /// Reads one JSON file per module: assets/json/lessons/`<module>`.json
  /// import 'package:bcc5/utils/logger.dart'; // add

  static Future<List<Map<String, String>>> getLessonsForModule(
    String module,
  ) async {
    final path = 'assets/json/lessons/$module.json';
    try {
      final raw = await rootBundle.loadString(path);
      final Map<String, dynamic> map = jsonDecode(raw);
      final List lessons = (map['lessons'] as List?) ?? const [];
      logger.i('📚 $module: loaded ${lessons.length} lessons from $path');
      return lessons
          .map<Map<String, String>>(
            (e) => {
              'id': (e['id'] ?? '').toString(),
              'title': (e['title'] ?? e['id'] ?? '').toString(),
            },
          )
          .toList();
    } catch (e, st) {
      logger.e('❌ Failed to parse $path → $e\n$st');
      return [];
    }
  }

  // static Future<List<Map<String, String>>> getLessonsForModule(
  //   String module,
  // ) async {
  //   final path = 'assets/json/lessons/$module.json';
  //   try {
  //     final raw = await rootBundle.loadString(path);
  //     final Map<String, dynamic> map = jsonDecode(raw);
  //     final List lessons = (map['lessons'] as List?) ?? const [];
  //     return lessons
  //         .map<Map<String, String>>(
  //           (e) => {
  //             'id': (e['id'] ?? '').toString(),
  //             'title': (e['title'] ?? e['id'] ?? '').toString(),
  //           },
  //         )
  //         .toList();
  //   } catch (_) {
  //     return [];
  //   }
  // }
}




// import 'dart:convert';
// import 'package:flutter/services.dart' show rootBundle;



// class JsonLessonIndex {

// // lib/data/repositories/lessons/json_lesson_index.dart
// static Future<List<Map<String, String>>> getLessonsForModule(String module) async {
//   final path = 'assets/json/lessons/$module.json';
//   final raw = await rootBundle.loadString(path);
//   final Map map = jsonDecode(raw);
//   final List lessons = (map['lessons'] as List?) ?? const [];
//   return lessons.map<Map<String,String>>((e) => {
//     'id': (e['id'] ?? '').toString(),
//     'title': (e['title'] ?? e['id'] ?? '').toString(),
//   }).toList();
// }


// // lib/data/repositories/lessons/json_lesson_repository.dart
// static String? _moduleFor(String id) {
//   if (id.startsWith('lesson_term_')) return 'terminology';
//   // (add your other prefixes later)
//   return null;
// }

// static Future<Lesson?> loadById(String id) async {
//   final module = _moduleFor(id);
//   if (module != null) {
//     final raw = await rootBundle.loadString('assets/json/lessons/$module.json');
//     final Map map = jsonDecode(raw);
//     final List lessons = (map['lessons'] as List?) ?? const [];
//     final match = lessons.cast<Map>().firstWhere(
//       (e) => (e['id'] ?? '') == id,
//       orElse: () => {},
//     );
//     if (match.isNotEmpty) {
//       return Lesson.fromJson(Map<String, dynamic>.from(match));
//     }
//   }
//   return null; // (you can keep your old per-file fallback during migration if you want)
// }


//   static Future<List<String>> getModuleNames() async {
//     // keep your hardcoded list for now
//     return [
//       'docking',
//       'safety',
//       'emergencies',
//       'seamanship',
//       'terminology',
//       'systems',
//       'teamwork',
//       'knots',
//       'navigation',
//     ];
//   }

//   static Future<List<Map<String, String>>> getLessonsForModule(
//     String module,
//   ) async {
//     // Map module -> expected index filename
//     final indexName = switch (module) {
//       'docking' => 'index_lesson_dock.json',
//       'safety' => 'index_lesson_safety.json',
//       'emergencies' => 'index_lesson_emer.json',
//       'seamanship' => 'index_lesson_seamanship.json',
//       'terminology' => 'index_lesson_term.json',
//       'systems' => 'index_lesson_syst.json',
//       'teamwork' => 'index_lesson_team.json',
//       'knots' => 'index_lesson_knots.json',
//       'navigation' => 'index_lesson_navigation.json',
//       _ => 'index_lesson_$module.json',
//     };

//     final path = 'assets/json/lessons/$module/$indexName';

//     try {
//       final raw = await rootBundle.loadString(path);
//       final List list = jsonDecode(raw);
//       // index entries look like: {"id": "...", "title": "...", "description": "..."}
//       return list
//           .map<Map<String, String>>(
//             (e) => {'id': e['id'] as String, 'title': e['title'] as String},
//           )
//           .toList();
//     } catch (_) {
//       // If no index file yet, return empty for now (we’ll add manifest-scanning later)
//       return [];
//     }
//   }
// }
