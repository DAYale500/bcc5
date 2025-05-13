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

FIELD = lambda block, key: re.search(rf'{key}:\s*["\']([^"\']+)["\']', block)

# Scan for top-level item blocks
START_REGEX = re.compile(r'(Lesson|PartItem|ToolItem)\s*\(', re.MULTILINE)

def extract_blocks(text):
    blocks = []
    for match in START_REGEX.finditer(text):
        start = match.start()
        type_ = match.group(1)
        i = match.end()
        parens = 1
        while i < len(text):
            if text[i] == '(':
                parens += 1
            elif text[i] == ')':
                parens -= 1
                if parens == 0:
                    if i + 1 < len(text) and text[i + 1] == ',':
                        i += 2
                    blocks.append((type_, text[start:i].strip()))
                    break
            i += 1
    return blocks

def extract_content_section(block):
    start_match = re.search(r'content:\s*\[', block)
    if not start_match:
        return "", [], []
    start = start_match.end()
    bracket_count = 1
    i = start
    while i < len(block):
        if block[i] == '[':
            bracket_count += 1
        elif block[i] == ']':
            bracket_count -= 1
            if bracket_count == 0:
                raw = block[start:i]
                parts = re.findall(r'(ContentBlock\.(?:text|image)\(\s*\".*?\"\s*\))', raw, re.DOTALL)
                texts = []
                images = []
                formatted = []
                for part in parts:
                    if part.startswith('ContentBlock.text'):
                        text_match = re.search(r'ContentBlock\.text\(\s*\"(.*?)\"\s*\)', part, re.DOTALL)
                        if text_match:
                            texts.append(text_match.group(1).strip())
                        formatted.append("Text:\n" + part.strip())
                    elif part.startswith('ContentBlock.image'):
                        img_match = re.search(r'ContentBlock\.image\(\s*\"(.*?)\"\s*\)', part, re.DOTALL)
                        if img_match:
                            images.append(img_match.group(1).strip())
                        formatted.append("Image:\n" + part.strip())
                return "\n\n".join(formatted), texts, images
        i += 1
    return "", [], []

repo_results = []

print(f"\n\U0001F4C2 Scanning {len(repo_files)} repositories...")
for filepath in repo_files:
    path = Path(filepath)
    if not path.exists():
        print(f"❌ File not found: {filepath}")
        continue

    repo_name = path.stem
    text = path.read_text(encoding="utf-8")
    matches = extract_blocks(text)
    print(f"✅ {repo_name}: Found {len(matches)} items")

    for type_, block in matches:
        item_id_match = FIELD(block, 'id')
        title_match = FIELD(block, 'title')

        item_id = item_id_match.group(1) if item_id_match else ""
        title = title_match.group(1) if title_match else ""
        raw_content, texts, images = extract_content_section(block)

        preview = raw_content[:120].replace('\n', ' ').strip()
        if raw_content:
            print(f"🧪 {item_id or '(no id)'} extracted content: {preview}...")
        else:
            print(f"🧪 {item_id or '(no id)'} extracted content: [no content found]")

        row = {
            "repository": repo_name,
            "type": type_,
            "id": item_id,
            "title": title,
            "content": raw_content,
        }
        for idx, txt in enumerate(texts):
            row[f"text_{idx+1}"] = txt
        for idx, img in enumerate(images):
            row[f"image_{idx+1}"] = img

        repo_results.append(row)

# Collect all possible fieldnames from all rows
fieldnames = set()
for row in repo_results:
    fieldnames.update(row.keys())

# Ensure standard columns are first
leading = ["repository", "type", "id", "title", "content"]
remaining = sorted(f for f in fieldnames if f not in leading)
fieldnames = leading + remaining

# Save to CSV
repo_output = f"y_extracted_repo_contents_{timestamp}.csv"
if repo_results:
    with open(repo_output, "w", newline='', encoding="utf-8") as f:
        writer = csv.DictWriter(f, fieldnames=fieldnames)
        writer.writeheader()
        writer.writerows(repo_results)
        f.write("\nHi Buddy\n")
    print(f"\n✅ Exported {len(repo_results)} content items to {repo_output}")
else:
    print("\n⚠️ No repository content found.")
