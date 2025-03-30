// From BCC4: lib/data/models/content_block.dart

// ✅ COMMENTARY:
// - Identical or very close to BCC5 version.
// - Already used in refactored ToolItem, PartItem, LessonItem models.
// - Clean and reusable as-is.

enum ContentType { text, image }

class ContentBlock {
  final ContentType type;
  final String data;

  ContentBlock.text(String text)
      : type = ContentType.text,
        data = text;

  ContentBlock.image(String path)
      : type = ContentType.image,
        data = path;
}
