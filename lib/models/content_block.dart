enum ContentBlockType { text, heading, image, bulletList, code }

class ContentBlock {
  final ContentBlockType type;
  final String? text;
  final List<String>? bullets;
  final String? imagePath;

  ContentBlock._({required this.type, this.text, this.bullets, this.imagePath});

  // Factory constructors
  factory ContentBlock.text(String text) =>
      ContentBlock._(type: ContentBlockType.text, text: text);

  factory ContentBlock.heading(String heading) =>
      ContentBlock._(type: ContentBlockType.heading, text: heading);

  factory ContentBlock.image(String path) =>
      ContentBlock._(type: ContentBlockType.image, imagePath: path);

  factory ContentBlock.bullets(List<String> items) =>
      ContentBlock._(type: ContentBlockType.bulletList, bullets: items);

  factory ContentBlock.code(String code) =>
      ContentBlock._(type: ContentBlockType.code, text: code);
}
