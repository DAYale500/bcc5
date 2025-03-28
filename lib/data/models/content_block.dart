enum ContentBlockType { heading, text, code, bulletList, image }

class ContentBlock {
  final ContentBlockType type;
  final String? text;
  final List<String>? bulletList;
  final String? imagePath;

  const ContentBlock._({
    required this.type,
    this.text,
    this.bulletList,
    this.imagePath,
  });

  // Heading block
  factory ContentBlock.heading(String text) =>
      ContentBlock._(type: ContentBlockType.heading, text: text);

  // Text block
  factory ContentBlock.text(String text) =>
      ContentBlock._(type: ContentBlockType.text, text: text);

  // Code block
  factory ContentBlock.code(String codeText) =>
      ContentBlock._(type: ContentBlockType.code, text: codeText);

  // Bullet list block
  factory ContentBlock.bullets(List<String> bullets) =>
      ContentBlock._(type: ContentBlockType.bulletList, bulletList: bullets);

  // Image block
  factory ContentBlock.image(String imagePath) =>
      ContentBlock._(type: ContentBlockType.image, imagePath: imagePath);

  // Optional convenience getter
  List<String>? get bullets => bulletList;
}
