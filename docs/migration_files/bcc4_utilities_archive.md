# 📦 BCC4 Utility Files Archive (For BCC5 Migration)

This document captures utility files from BCC4 that may be useful in BCC5. Each file is included in its **original BCC4 form**, with commentary for migration potential. When needed, these can be extracted, cleaned, and adapted for use in BCC5.

---

## 🧭 Summary: Useful Utilities from BCC4

| File Name                       | Purpose / Use Case                                       | Recommended Action      |
|--------------------------------|----------------------------------------------------------|--------------------------|
| `app_constants.dart`           | Stores labels for modules, zones, learning paths        | ✅ Migrate (low effort)  |
| `lesson_content_builder.dart`  | Renders structured lesson content (text + images)       | ✅ Migrate and refactor  |
| `part_content_builder.dart`    | Renders structured part content                         | 🟠 May be merged later   |
| `path_item_content_helper.dart`| Renders lesson/part/flashcard/tool content              | ✅ Migrate and extend    |
| `debug_utils.dart`             | Lightweight logger wrappers                             | ✅ Optional migration     |

---

## 📄 File: `lib/constants/app_constants.dart`

```dart
// From BCC4: lib/constants/app_constants.dart

// 🟡 COMMENTARY:
// - Contains central names for lesson modules, part zones, learning paths.
// - Useful for dropdowns, filters, labels across the app.
// - Could be moved into `constants.dart` or equivalent in BCC5.

class AppConstants {
  static const List<String> lessonModules = [
    'docking',
    'emergencies',
    'knots',
    'navigation',
    'safety',
    'seamanship',
    'systems',
    'teamwork',
    'terminology',
  ];

  static const List<String> partZones = [
    'Deck',
    'Hull',
    'Interior',
    'Rigging',
    'Sails',
  ];

  static const List<String> learningPaths = [
    'competent_crew',
    'skipper_foundations',
    'master_ready',
  ];
}
```

---

## 📄 File: `lib/utils/content_builders/lesson_content_builder.dart`

```dart
// From BCC4: lib/utils/content_builders/lesson_content_builder.dart

// 🟡 COMMENTARY:
// - Rendered dynamic `List<dynamic>` lesson content into widgets.
// - Could be merged with ContentBlock rendering in BCC5.
// - Useful as a fallback for legacy-format content.

import 'package:flutter/material.dart';

List<Widget> buildLessonContent(List<dynamic> content) {
  return content.map((item) {
    if (item is String) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Text(item, style: const TextStyle(fontSize: 16)),
      );
    } else if (item is Map<String, dynamic> && item.containsKey('image')) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Image.asset(item['image']),
      );
    } else {
      return const SizedBox.shrink();
    }
  }).toList();
}
```

---

## 📄 File: `lib/utils/content_builders/part_content_builder.dart`

```dart
// From BCC4: lib/utils/content_builders/part_content_builder.dart

// 🟡 COMMENTARY:
// - Similar to `lesson_content_builder`, but for part content.
// - Might be redundant in BCC5 due to use of `ContentBlockRenderer`.
// - Useful if parts are stored in legacy formats or for quick previews.

import 'package:flutter/material.dart';

List<Widget> buildPartContent(List<dynamic> content) {
  return content.map((item) {
    if (item is String) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Text(item, style: const TextStyle(fontSize: 16)),
      );
    } else if (item is Map<String, dynamic> && item.containsKey('image')) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Image.asset(item['image']),
      );
    } else {
      return const SizedBox.shrink();
    }
  }).toList();
}
```

---

## 📄 File: `lib/utils/path_item_content_helper.dart`

```dart
// From BCC4: lib/utils/path_item_content_helper.dart

// 🟡 COMMENTARY:
// - Rendered the correct content format (lesson/part/flashcard) based on type.
// - Strong candidate for refactoring and unifying with ContentDetailScreen.
// - Can help generalize behavior of ContentScreenNavigator.

import 'package:flutter/material.dart';
import 'package:bcc4/data/models/lesson_model.dart';
import 'package:bcc4/data/models/part_model.dart';
import 'package:bcc4/data/models/flashcard_model.dart';

Widget buildPathItemContent(dynamic item) {
  if (item is Lesson) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: item.content.map((c) => Text(c)).toList(),
    );
  } else if (item is Part) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: item.content.map((c) => Text(c)).toList(),
    );
  } else if (item is Flashcard) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Q: ${item.sideA}"),
        const SizedBox(height: 12),
        Text("A: ${item.sideB}"),
      ],
    );
  } else {
    return const Text("Unsupported path item.");
  }
}
```

---

## 📄 File: `lib/utils/debug_utils.dart`

```dart
// From BCC4: lib/utils/debug_utils.dart

// 🟡 COMMENTARY:
// - Provided shorthand functions for debug logging.
// - Optional in BCC5 (logger.i(...) is used directly), but this wrapper adds clarity.

import 'package:bcc4/utils/logger.dart';

void logScreenEnter(String screenName) {
  logger.i('🟦 Entered $screenName');
}

void logAction(String action) {
  logger.i('✅ $action');
}
```

---