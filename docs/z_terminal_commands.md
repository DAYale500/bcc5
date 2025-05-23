generic run command
flutter run >> BCC4_logs.txt 2>&1

-------------------------------------------------------------------------------------------------------------------------

simulator, run command

alias runsim='flutter run -d "iPhone 13" >> ZZ_BCC5_logs.txt 2>&1'

runsim=$'gstdbuf -oL flutter run -d 3A04C62A-C78C-4470-A174-DD9285589BCA 2>&1 \\\n  | sed -E "s/^[[:space:]]*flutter:[[:space:]]*//" \\\n  | perl -pe "s/\\\\\\\\\\\\^\\\\[\\\\[[0-9;]+m//g" \\\n  | sed -E "s/^[[:space:]]*│[[:space:]]*//" \\\n  | grep -vE "^[┌├└]" \\\n  | awk \'{ printf "[%04d] %s\\n", NR, $0 }\' \\\n  | tee ZZ_BCC5_logs.txt'


runsim

runsim() {
  gstdbuf -oL flutter run -d 3A04C62A-C78C-4470-A174-DD9285589BCA 2>&1 \
    | sed -E "s/^[[:space:]]*flutter:[[:space:]]*//" \
    | perl -pe "s/\x1B\[[0-9;]*m//g" \
    | sed -E "s/^[[:space:]]*│[[:space:]]*//" \
    | grep -vE "^[┌├└]" \
    | awk '{ printf "[%04d] %s\n", NR, $0 }' \
    > ZZ_BCC5_logs.txt
}



-------------------------------------------------------------------------------------------------------------------------


physical iPhone one command

runphone

echo 'alias runphone="flutter run -d 00008110-001E41122183801E >> ZZ_BCC4_z_logs.txt 2>&1"' >> ~/.zshrc



-------------------------------------------------------------------------------------------------------------------------

OOutput files -all at once - (run from bcc4):

file_away

timestamp=$(date +"%Y%m%d_%H%M%S") && \
tree lib -a -I ".*" > "Z_bcc4_file_structure_${timestamp}.txt" && \
find lib -type f -path "lib/data/repositories/*" -not -name ".*" -exec sh -c 'echo -e "\n\n\n\n\n\n\n\n\n\nFile: {}" >> "Z_bcc4_repositories_'"${timestamp}"'.txt" && cat "{}" >> "Z_bcc4_repositories_'"${timestamp}"'.txt"' \; && \
find lib -type f -not -path "lib/data/repositories/*" -not -name ".*" -exec sh -c 'echo -e "\n\n\n\n\n\n\n\n\n\nFile: {}" >> "Z_bcc4_all_others_'"${timestamp}"'.txt" && cat "{}" >> "Z_bcc4_all_others_'"${timestamp}"'.txt"' \;


-------------------------------------------------------------------------------------------------------------------------



Run flutter clean to remove old build files.
Run flutter pub get to fetch dependencies.
Run runsim (which starts the iPhone simulator).
echo 'alias reset_app="flutter clean && flutter pub get && runsim"' >> ~/.zshrc && source ~/.zshrc

reset_app


start Ollama (in terminal)
ollama serve




-------------------------------------------------------------------------------------------------------------------------

for lesson part tool output


import re
import csv
from pathlib import Path

# 🔍 Files to extract from
files = [
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

ITEM_REGEX = re.compile(r'(Lesson|PartItem|ToolItem)\((.*?)\),?\s*\)', re.DOTALL)
FIELD = lambda block, key: re.search(rf'{key}:\s*"([^"]+)"', block)
KEYWORDS = lambda block: re.search(r'keywords:\s*\[(.*?)\]', block)
CONTENT = lambda block: re.findall(r'ContentBlock\.text\(\s*["\']{1,3}([\s\S]*?)["\']{1,3}\)', block)
FLASHCARDS = re.compile(r'Flashcard\((.*?)\)', re.DOTALL)
FC_FIELD = lambda block, key: re.search(rf'{key}:\s*"([^"]+)"', block)
FC_SIDE = lambda block, side: re.findall(rf'{side}:\s*\[(.*?)\]', block, re.DOTALL)

rows = []

for file in files:
    path = Path(file)
    if not path.exists():
        print(f"❌ Skipping missing file: {file}")
        continue

    data = path.read_text(encoding='utf-8')
    matches = ITEM_REGEX.findall(data)

    for type_, block in matches:
        id_ = FIELD(block, 'id')
        title = FIELD(block, 'title')
        keywords = KEYWORDS(block)
        isPaid = FIELD(block, 'isPaid')
        content = CONTENT(block)
        flashcards = FLASHCARDS.findall(block)

        # Take only the first flashcard for now
        fc_block = flashcards[0] if flashcards else ""
        fc_id = FC_FIELD(fc_block, 'id')
        fc_title = FC_FIELD(fc_block, 'title')
        sideA_match = FC_SIDE(fc_block, 'sideA')
        sideB_match = FC_SIDE(fc_block, 'sideB')
        fc_isPaid = FC_FIELD(fc_block, 'isPaid')
        fc_showAFirst = FC_FIELD(fc_block, 'showAFirst')

        def clean_side(text_block):
            return re.sub(r'ContentBlock\.text\(["\']{1,3}(.*?)["\']{1,3}\)', r'\1', text_block).strip()

        row = {
            "repository": path.stem,
            "type": type_,
            "id": id_.group(1) if id_ else "",
            "title": title.group(1) if title else "",
            "content": " | ".join(c.strip().replace("\n", " ") for c in content),
            "keywords": keywords.group(1).replace('"', '') if keywords else "",
            "isPaid": isPaid.group(1) if isPaid else "false",
            "flashcard_id": fc_id.group(1) if fc_id else "",
            "flashcard_title": fc_title.group(1) if fc_title else "",
            "sideA": clean_side(sideA_match[0]) if sideA_match else "",
            "sideB": clean_side(sideB_match[0]) if sideB_match else "",
            "flashcard_isPaid": fc_isPaid.group(1) if fc_isPaid else "",
            "flashcard_showAFirst": fc_showAFirst.group(1) if fc_showAFirst else "",
        }
        rows.append(row)

# 📝 Write to CSV
output_path = "Extracted Lessons, Parts, and Tools.csv"
with open(output_path, "w", newline='', encoding="utf-8") as f:
    writer = csv.DictWriter(f, fieldnames=row.keys())
    writer.writeheader()
    writer.writerows(rows)

print(f"✅ Extracted {len(rows)} items to: {output_path}")
