import re
import json

# Parses Dart repository code and converts each Lesson(...) 
# into a structured JSON object

# Best used on formatted, cleaned Dart lesson definitions 
# like those in DockingLessonRepository

def dart_to_json(dart_text):
    lessons = []
    lesson_blocks = re.split(r'Lesson\(', dart_text)[1:]

    for block in lesson_blocks:
        lesson = {}
        lesson['id'] = re.search(r"id: '([^']+)'", block).group(1)
        lesson['title'] = re.search(r"title: '([^']+)'", block).group(1)
        content_blocks = []
        for m in re.finditer(r"ContentBlock\.(text|image)\(\s*'([^']+)'\s*\)", block):
            content_blocks.append({"type": m.group(1), "content": m.group(2)})
        lesson['content'] = content_blocks
        lesson['keywords'] = []
        lesson['isPaid'] = False
        flashcard = {}
        flash_match = re.search(r"Flashcard\((.*?)\)", block, re.DOTALL)
        if flash_match:
            flash_block = flash_match.group(1)
            flashcard['id'] = re.search(r"id: '([^']+)'", flash_block).group(1)
            flashcard['title'] = re.search(r"title: '([^']+)'", flash_block).group(1)
            side_a = re.search(r"sideA: \[.*?ContentBlock.text\(\s*'([^']+)'\s*\)", flash_block)
            side_b = re.search(r"sideB: \[.*?ContentBlock.text\(\s*'([^']+)'\s*\)", flash_block)
            flashcard['sideA'] = [{"type": "text", "content": side_a.group(1)}] if side_a else []
            flashcard['sideB'] = [{"type": "text", "content": side_b.group(1)}] if side_b else []
            flashcard['isPaid'] = False
            flashcard['showAFirst'] = True
            lesson['flashcards'] = [flashcard]
        else:
            lesson['flashcards'] = []
        lessons.append(lesson)

    return lessons

# Example usage:
# dart_code = open("docking_repo.dart").read()
# jsons = dart_to_json(dart_code)
# for l in jsons: json.dump(l, open(f"{l['id']}.json", "w"), indent=2)