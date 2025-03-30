// From BCC4: lib/data/models/tool_model.dart

// 🟡 COMMENTARY:
// - Very simple: id, title, toolbag.
// - No content or payload in BCC4 version—was UI label only.
// 🔁 Needs to evolve into current BCC5 ToolItem (which includes content blocks).

class Tool {
  final String id;
  final String title;
  final String toolbag;

  Tool({required this.id, required this.title, required this.toolbag});
}
