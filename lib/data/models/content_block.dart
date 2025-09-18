// lib/data/models/content_block.dart

enum ContentBlockType {
  heading,
  text,
  code,
  bulletList,
  image,
  divider,
  gpsConverter, // ⬅️ new
}

class ContentBlock {
  final ContentBlockType type;
  final String? text; // used by heading/text/code
  final List<String>? bulletList; // used by bulletList
  final String? imagePath; // used by image

  const ContentBlock._({
    required this.type,
    this.text,
    this.bulletList,
    this.imagePath,
  });

  // ── Factories ──────────────────────────────────────────────
  factory ContentBlock.heading(String text) =>
      ContentBlock._(type: ContentBlockType.heading, text: text);

  factory ContentBlock.text(String text) =>
      ContentBlock._(type: ContentBlockType.text, text: text);

  factory ContentBlock.code(String codeText) =>
      ContentBlock._(type: ContentBlockType.code, text: codeText);

  factory ContentBlock.bullets(List<String> bullets) =>
      ContentBlock._(type: ContentBlockType.bulletList, bulletList: bullets);

  factory ContentBlock.image(String imagePath) =>
      ContentBlock._(type: ContentBlockType.image, imagePath: imagePath);

  factory ContentBlock.divider() =>
      ContentBlock._(type: ContentBlockType.divider);

  // ⬇️ new: block with no payload
  factory ContentBlock.gpsConverter() =>
      ContentBlock._(type: ContentBlockType.gpsConverter);

  // Convenience
  static List<ContentBlock> dividerList() => [ContentBlock.divider()];
  List<String>? get bullets => bulletList;

  /// Robust JSON parser:
  /// - Accepts "content" | "value" | "data"
  /// - Handles bullet lists as List`<String>` OR line-broken String
  /// - Tolerates minor type aliases
  factory ContentBlock.fromJson(Map<String, dynamic> json) {
    final rawType = (json['type'] ?? '').toString().trim().toLowerCase();
    final type = _parseType(rawType);

    // Pull payload from any of the supported keys
    final dynamic payload =
        json.containsKey('content')
            ? json['content']
            : (json.containsKey('value')
                ? json['value']
                : (json.containsKey('data') ? json['data'] : null));

    switch (type) {
      case ContentBlockType.heading:
        return ContentBlock.heading(_asString(payload) ?? '');
      case ContentBlockType.text:
        return ContentBlock.text(_asString(payload) ?? '');
      case ContentBlockType.code:
        return ContentBlock.code(_asString(payload) ?? '');
      case ContentBlockType.image:
        return ContentBlock.image(_asString(payload) ?? '');
      case ContentBlockType.bulletList:
        return ContentBlock.bullets(_asStringList(payload));
      case ContentBlockType.divider:
        return ContentBlock.divider();
      case ContentBlockType.gpsConverter:
        return ContentBlock.gpsConverter();
    }
  }

  // ── helpers ────────────────────────────────────────────────
  static ContentBlockType _parseType(String raw) {
    switch (raw) {
      case 'heading':
        return ContentBlockType.heading;
      case 'text':
        return ContentBlockType.text;
      case 'code':
        return ContentBlockType.code;
      case 'image':
        return ContentBlockType.image;
      case 'divider':
        return ContentBlockType.divider;
      case 'gpsconverter':
      case 'gps_converter':
      case 'gps-converter':
        return ContentBlockType.gpsConverter;
      case 'bulletlist':
      case 'bullets':
      case 'bullet_list':
      case 'bullet-list':
        return ContentBlockType.bulletList;
      default:
        // Default to text if unknown (prevents crashes on new types)
        return ContentBlockType.text;
    }
  }

  static String? _asString(dynamic v) {
    if (v == null) return null;
    if (v is String) return v;
    return v.toString(); // allow numbers/bools to stringify
  }

  static List<String> _asStringList(dynamic v) {
    if (v == null) return const [];

    // If already a list, coerce each element to string.
    if (v is List) {
      return v
          .map((e) => _asString(e) ?? '')
          .where((s) => s.isNotEmpty)
          .toList();
    }

    // If a single string, split by common delimiters (newline / bullets / commas)
    if (v is String) {
      final s = v.trim();
      if (s.isEmpty) return const [];
      final sep =
          s.contains('\n')
              ? '\n'
              : (s.contains('•') ? '•' : (s.contains(',') ? ',' : '\n'));
      return s
          .split(sep)
          .map((e) => e.trim())
          .where((e) => e.isNotEmpty)
          .toList();
    }

    // Fallback
    return const [];
  }
}

// enum ContentBlockType {
//   heading,
//   text,
//   code,
//   bulletList,
//   image,
//   divider,
//   gpsConverter,
// }

// class ContentBlock {
//   final ContentBlockType type;
//   final String? text; // used by heading/text/code
//   final List<String>? bulletList; // used by bulletList
//   final String? imagePath; // used by image

//   const ContentBlock._({
//     required this.type,
//     this.text,
//     this.bulletList,
//     this.imagePath,
//   });

//   // Factories
//   factory ContentBlock.heading(String text) =>
//       ContentBlock._(type: ContentBlockType.heading, text: text);

//   factory ContentBlock.text(String text) =>
//       ContentBlock._(type: ContentBlockType.text, text: text);

//   factory ContentBlock.code(String codeText) =>
//       ContentBlock._(type: ContentBlockType.code, text: codeText);

//   factory ContentBlock.bullets(List<String> bullets) =>
//       ContentBlock._(type: ContentBlockType.bulletList, bulletList: bullets);

//   factory ContentBlock.image(String imagePath) =>
//       ContentBlock._(type: ContentBlockType.image, imagePath: imagePath);

//   factory ContentBlock.divider() =>
//       ContentBlock._(type: ContentBlockType.divider);

//   factory ContentBlock.gpsConverter() =>
//       ContentBlock._(type: ContentBlockType.gpsConverter);

//   // Convenience
//   static List<ContentBlock> dividerList() => [ContentBlock.divider()];
//   List<String>? get bullets => bulletList;

//   /// Robust JSON parser:
//   /// - Accepts "content" | "value" | "data"
//   /// - Handles bullet lists as `List<String>` OR line-broken String
//   /// - Tolerates minor type aliases
//   factory ContentBlock.fromJson(Map<String, dynamic> json) {
//     final rawType = (json['type'] ?? '').toString().trim().toLowerCase();
//     final type = _parseType(rawType);

//     // Pull payload from any of the supported keys
//     final dynamic payload =
//         json.containsKey('content')
//             ? json['content']
//             : (json.containsKey('value')
//                 ? json['value']
//                 : (json.containsKey('data') ? json['data'] : null));

//     switch (type) {
//       case ContentBlockType.heading:
//         return ContentBlock.heading(_asString(payload) ?? '');
//       case ContentBlockType.text:
//         return ContentBlock.text(_asString(payload) ?? '');
//       case ContentBlockType.code:
//         return ContentBlock.code(_asString(payload) ?? '');
//       case ContentBlockType.image:
//         return ContentBlock.image(_asString(payload) ?? '');
//       case ContentBlockType.bulletList:
//         return ContentBlock.bullets(_asStringList(payload));
//       case ContentBlockType.divider:
//         return ContentBlock.divider();
//       case ContentBlockType.gpsConverter:
//         return ContentBlock.gpsConverter();
//     }
//   }

//   // --- helpers ---

//   static ContentBlockType _parseType(String raw) {
//     switch (raw) {
//       case 'heading':
//         return ContentBlockType.heading;
//       case 'text':
//         return ContentBlockType.text;
//       case 'code':
//         return ContentBlockType.code;
//       case 'image':
//         return ContentBlockType.image;
//       case 'divider':
//         return ContentBlockType.divider;
//       case 'gpsconverter':
//       case 'gps_converter':
//       case 'gps-converter':
//         return ContentBlockType.gpsConverter;
//       case 'bulletlist':
//       case 'bullets':
//       case 'bullet_list':
//       case 'bullet-list':
//         return ContentBlockType.bulletList;
//       default:
//         // Default to text if unknown (prevents hard crashes on new types)
//         return ContentBlockType.text;
//     }
//   }

//   static String? _asString(dynamic v) {
//     if (v == null) return null;
//     if (v is String) return v;
//     // Allow numbers/bools to stringify if ever present
//     return v.toString();
//   }

//   static List<String> _asStringList(dynamic v) {
//     if (v == null) return const [];

//     // If already a list, coerce each element to string.
//     if (v is List) {
//       return v
//           .map((e) => _asString(e) ?? '')
//           .where((s) => s.isNotEmpty)
//           .toList();
//     }

//     // If a single string, split by common delimiters (newline / bullets / commas)
//     if (v is String) {
//       final s = v.trim();
//       if (s.isEmpty) return const [];
//       // split on newlines first; if none, try bullets or commas
//       final sep =
//           s.contains('\n')
//               ? '\n'
//               : (s.contains('•') ? '•' : (s.contains(',') ? ',' : '\n'));
//       return s
//           .split(sep)
//           .map((e) => e.trim())
//           .where((e) => e.isNotEmpty)
//           .toList();
//     }

//     // Fallback
//     return const [];
//   }
// }
