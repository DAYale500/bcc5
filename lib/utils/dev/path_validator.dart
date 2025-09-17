// lib/utils/dev/path_validator.dart
import 'package:bcc5/utils/logger.dart';
import 'package:bcc5/data/repositories/paths/json_path_repository.dart';
import 'package:bcc5/utils/render_item_helpers.dart';

class ChapterIssues {
  final String chapterId;
  final List<String> missingIds;
  ChapterIssues(this.chapterId, this.missingIds);
  bool get hasIssues => missingIds.isNotEmpty;
}

class PathValidationReport {
  final String pathName;
  final List<ChapterIssues> chapters;
  PathValidationReport(this.pathName, this.chapters);

  bool get ok => chapters.every((c) => !c.hasIssues);

  @override
  String toString() {
    final b = StringBuffer('🔎 Validation for "$pathName"\n');
    if (ok) {
      b.writeln('✅ All chapters are consistent.');
    } else {
      for (final ch in chapters.where((c) => c.hasIssues)) {
        b.writeln(
          '• Chapter ${ch.chapterId} has missing IDs: ${ch.missingIds}',
        );
      }
    }
    return b.toString();
  }
}

Future<PathValidationReport> validatePath(String pathName) async {
  final chapters = await JsonPathRepository.getChaptersForPath(pathName);
  final results = <ChapterIssues>[];

  for (final chapter in chapters) {
    final ids = chapter.items.map((e) => e.pathItemId).toList();

    // Resolve to RenderItems using the same helper the UI uses.
    final renderItems = await buildRenderItems(ids: ids);
    final resolved = renderItems.map((r) => r.id).toSet();
    final missing = ids.where((id) => !resolved.contains(id)).toList();

    results.add(ChapterIssues(chapter.id, missing));
  }

  return PathValidationReport(pathName, results);
}

Future<void> printValidation(String pathName) async {
  final report = await validatePath(pathName);
  if (report.ok) {
    logger.i(report.toString());
  } else {
    logger.w(report.toString());
  }
}


///Call it from anywhere in debug 
///(e.g., after app start, behind a dev-only button, 
///or a quick one-liner):
///
///
// // Example: in a debug-only branch
// assert(() {
//   printValidation('competent crew'); // or any path key
//   return true;
// }());

///You’ll get a log listing any missing 
///IDs per chapter (the same check your 
///UI does, without tapping through).




// Path Validator
// Drop this anywhere in your debug area to list missing 
//item IDs referenced by a path:


// import 'package:bcc5/data/repositories/paths/json_path_repository.dart';
// import 'package:bcc5/utils/render_item_helpers.dart';
// import 'package:bcc5/utils/logger.dart';

// class PathValidator {
//   static Future<void> validate(String pathName) async {
//     final chapters = await JsonPathRepository.getChaptersForPath(pathName);
//     if (chapters.isEmpty) {
//       logger.w('No chapters for "$pathName"');
//       return;
//     }

//     final allKnownIds = await getAllKnownRenderableIds(); // you likely already have this helper; if not, expose it from your loaders
//     for (final c in chapters) {
//       final unknown = <String>[];
//       for (final item in c.items) {
//         if (!allKnownIds.contains(item.pathItemId)) {
//           unknown.add(item.pathItemId);
//         }
//       }
//       if (unknown.isEmpty) {
//         logger.i('✅ ${c.id} "${c.title}" — all IDs resolve');
//       } else {
//         logger.e('❌ ${c.id} "${c.title}" — missing IDs: $unknown');
//       }
//     }
//   }
// }
