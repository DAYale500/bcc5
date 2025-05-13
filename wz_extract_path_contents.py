import re
import csv
from pathlib import Path
from datetime import datetime

# Generate timestamp suffix
timestamp = datetime.now().strftime("%Y%m%d_%H%M%S")

# Repositories to scan for matching content
repo_files = [
    "lib/data/repositories/lessons/lesson_docking_repository.dart",
    "lib/data/repositories/lessons/lesson_emergencies_repository.dart",
    "lib/data/repositories/lessons/lesson_knots_repository.dart",
    "lib/data/repositories/lessons/lesson_navigation_repository.dart",
    "lib/data/repositories/lessons/lesson_safety_repository.dart",
    "lib/data/repositories/lessons/lesson_seamanship_repository.dart",
    "lib/data/repositories/lessons/lesson_systems_repository.dart",
    "lib/data/repositories/lessons/lesson_teamwork_repository.dart",
    "lib/data/repositories/lessons/lesson_terminology_repository.dart",
    "lib/data/repositories/parts/part_deck_repository.dart",
    "lib/data/repositories/parts/part_hull_repository.dart",
    "lib/data/repositories/parts/part_interior_repository.dart",
    "lib/data/repositories/parts/part_rigging_repository.dart",
    "lib/data/repositories/parts/part_sails_repository.dart",
    "lib/data/repositories/tools/tool_checklists_repository.dart",
    "lib/data/repositories/tools/tool_colregs_repository.dart",
    "lib/data/repositories/tools/tool_procedures_repository.dart",
    "lib/data/repositories/tools/tool_references_repository.dart",
]

ITEM_REGEX = re.compile(r'(Lesson|PartItem|ToolItem)\s*\((.*?)\n\s*\),', re.DOTALL)
FLASHCARD_REGEX = re.compile(r'Flashcard\((.*?)\n\s*\),', re.DOTALL)
FIELD = lambda block, key: re.search(rf'{key}:\s*["\']([^"\']+)["\']', block)
TEXT_CONTENT = lambda block: re.findall(r'ContentBlock\.text\(\s*["\']{1,3}([\s\S]*?)["\']{1,3}\)', block)
IMAGE_CONTENT = lambda block: re.findall(r'ContentBlock\.image\(\s*["\']{1,3}([\s\S]*?\.jpe?g|\.png)["\']{1,3}\)', block)
FC_SIDE = lambda block, side: re.findall(rf'{side}:\s*\[([\s\S]*?)\]', block)
FC_TEXT = lambda side: re.findall(r'ContentBlock\.text\(\s*["\']{1,3}([\s\S]*?)["\']{1,3}\)', side)

repo_results = []

print(f"\n📂 Scanning {len(repo_files)} repositories...")
for filepath in repo_files:
    path = Path(filepath)
    if not path.exists():
        print(f"❌ File not found: {filepath}")
        continue

    repo_name = path.stem
    text = path.read_text(encoding="utf-8")
    matches = ITEM_REGEX.findall(text)
    print(f"✅ {repo_name}: Found {len(matches)} items")

    for type_, block in matches:
        item_id_match = FIELD(block, 'id')
        if not item_id_match:
            continue

        item_id = item_id_match.group(1)
        title = FIELD(block, 'title')
        isPaid = FIELD(block, 'isPaid')
        text_blocks = TEXT_CONTENT(block)
        image_blocks = IMAGE_CONTENT(block)
        combined_content = text_blocks + [f"[image: {img}]" for img in image_blocks]
        print(f"🧪 {item_id} content blocks:")
        print(f"  - text: {len(text_blocks)} found → {text_blocks}")
        print(f"  - images: {len(image_blocks)} found → {image_blocks}")
        print(f"  - combined: {len(combined_content)} total → {combined_content}")

        flashcards = FLASHCARD_REGEX.findall(block)
        fc_sideA_all, fc_sideB_all = [], []

        for fc in flashcards:
            sidesA = FC_SIDE(fc, "sideA")
            sidesB = FC_SIDE(fc, "sideB")
            for sa in sidesA:
                fc_sideA_all += FC_TEXT(sa)
            for sb in sidesB:
                fc_sideB_all += FC_TEXT(sb)

        repo_results.append({
            "repository": repo_name,
            "type": type_,
            "id": item_id,
            "title": title.group(1) if title else "",
            "content": " | ".join(combined_content),
            "isPaid": isPaid.group(1) if isPaid else "false",
            "has_flashcards": "TRUE" if flashcards else "FALSE",
            "flashcard_sideA": " || ".join(fc_sideA_all),
            "flashcard_sideB": " || ".join(fc_sideB_all),
        })

# Save extracted repo content
repo_output = f"y_extracted_repo_contents_{timestamp}.csv"
if repo_results:
    with open(repo_output, "w", newline='', encoding='utf-8') as f:
        writer = csv.DictWriter(f, fieldnames=repo_results[0].keys())
        writer.writeheader()
        writer.writerows(repo_results)
    print(f"\n✅ Exported {len(repo_results)} content items to {repo_output}")
else:
    print("\n⚠️ No repository content found.")

# Parse learning paths
learning_path_file = Path("lib/data/repositories/learning_paths/competent_crew_repository.dart")
path_results = []
if learning_path_file.exists():
    text = learning_path_file.read_text(encoding="utf-8")
    chapter_blocks = re.findall(r'LearningPathChapter\((.*?)\),\s*', text, re.DOTALL)
    for block in chapter_blocks:
        chap_id = FIELD(block, 'id')
        chap_title = FIELD(block, 'title')
        item_ids = re.findall(r"PathItem\(pathItemId:\s*'([^']+)'\)", block)
        for item_id in item_ids:
            path_results.append({
                "chapter_id": chap_id.group(1) if chap_id else "",
                "chapter_title": chap_title.group(1) if chap_title else "",
                "pathItem_id": item_id,
            })

# Save learning path structure
path_output = f"y_extracted_path_contents_{timestamp}.csv"
if path_results:
    with open(path_output, "w", newline='', encoding="utf-8") as f:
        writer = csv.DictWriter(f, fieldnames=path_results[0].keys())
        writer.writeheader()
        writer.writerows(path_results)
    print(f"✅ Exported {len(path_results)} path items to {path_output}")
else:
    print("⚠️ No learning path items found.")
