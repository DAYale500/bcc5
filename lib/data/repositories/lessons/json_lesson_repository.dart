import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:bcc5/data/models/lesson_model.dart';
import 'package:bcc5/utils/logger.dart';

class JsonLessonRepository {
  static String? _moduleFor(String id) {
    if (id.startsWith('lesson_dock_')) {
      return 'docking';
    }
    if (id.startsWith('lesson_safety_')) {
      return 'safety';
    }
    if (id.startsWith('lesson_emer_')) {
      return 'emergencies';
    }
    if (id.startsWith('lesson_seam_')) {
      return 'seamanship';
    }
    if (id.startsWith('lesson_term_')) {
      return 'terminology';
    }
    if (id.startsWith('lesson_syst_')) {
      return 'systems';
    }
    if (id.startsWith('lesson_team_')) {
      return 'teamwork';
    }
    if (id.startsWith('lesson_knot_') || id.startsWith('lesson_knots_')) {
      return 'knots';
    }
    if (id.startsWith('lesson_nav_')) {
      return 'navigation';
    }
    return null;
  }

  /// Finds a single lesson by id inside the module file.
  static Future<Lesson?> loadById(String id) async {
    final module = _moduleFor(id);
    if (module != null) {
      final path = 'assets/json/lessons/$module.json';
      try {
        logger.i('🔎 Searching $id in $path');
        final raw = await rootBundle.loadString(path);
        final Map<String, dynamic> map = jsonDecode(raw);
        final List lessons = (map['lessons'] as List?) ?? const [];
        final match = lessons.cast<Map>().firstWhere(
          (e) => (e['id'] ?? '').toString() == id,
          orElse: () => const <String, dynamic>{},
        );
        if (match.isNotEmpty) {
          logger.i('📘 Found $id in $path');
          return Lesson.fromJson(Map<String, dynamic>.from(match));
        }
      } catch (e, st) {
        logger.w('❌ Failed module file $path → $e\n$st');
      }
    }
    logger.w('🕵️‍♂️ Could not find JSON for lesson $id');
    return null;
  }
}

// import 'dart:convert';
// import 'package:flutter/services.dart' show rootBundle;
// import 'package:bcc5/data/models/lesson_model.dart';
// import 'package:bcc5/utils/logger.dart';

// class JsonLessonRepository {
//   static Future<Lesson?> loadById(String id) async {
//     final possibleFolders = [
//       'assets/json/lessons/docking',
//       'assets/json/lessons/safety',
//       'assets/json/lessons/emergencies',
//       'assets/json/lessons/seamanship',
//       'assets/json/lessons/terminology',
//       'assets/json/lessons/systems',
//       'assets/json/lessons/teamwork',
//       'assets/json/lessons/knots',
//       'assets/json/lessons/navigation',
//     ];

//     for (final folder in possibleFolders) {
//       final path = '$folder/$id.json';
//       try {
//         logger.i('🔎 Trying to load $id from: $path');
//         final rawJson = await rootBundle.loadString(path);
//         final map = jsonDecode(rawJson);
//         final lesson = Lesson.fromJson(map);
//         logger.i('📘 Successfully loaded $id from $path');
//         return lesson;
//       } catch (e, stack) {
//         logger.w('❌ Failed to load $path → $e\n$stack');
//       }
//     }

//     logger.w('🕵️‍♂️ Could not find JSON for lesson $id');
//     return null;
//   }
// }
