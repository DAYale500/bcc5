// 📄 lib/data/repositories/lessons/terminology_lessons_repository.dart

import 'package:bcc5/data/models/lesson_model.dart';
import 'package:bcc5/data/models/flashcard_model.dart';
import 'package:bcc5/data/models/content_block.dart';

class TerminologyLessonRepository {
  static final lessons = <Lesson>[
    Lesson(
      id: "lesson_term_1.00",
      title: "Free: Essential Terms",
      content: [ContentBlock.text("Introduction to essential sailing terms.")],
      keywords: ["essential terms", "sailing basics", "orientation"],
      isPaid: false,
      flashcards: [
        Flashcard(
          id: "flashcard_lesson_term_1.00",
          title: "Essential Terms",
          sideA: [
            ContentBlock.text(
              "What are some essential sailing terms every crew member should know?",
            ),
          ],
          sideB: [
            ContentBlock.text(
              "Terms like 'bow' (front), 'stern' (back), 'port' (left), 'starboard' (right).",
            ),
          ],
          isPaid: false,
          showAFirst: true,
        ),
      ],
    ),
    Lesson(
      id: "lesson_term_2.00",
      title: "Free: Common Nautical Terms",
      content: [
        ContentBlock.text(
          "Learn basic terms like “port” (left), “starboard” (right).",
        ),
      ],
      keywords: ["nautical terms", "port", "starboard"],
      isPaid: false,
      flashcards: [
        Flashcard(
          id: "flashcard_lesson_term_2.00",
          title: "Common Nautical Terms",
          sideA: [ContentBlock.text("What does 'port' and 'starboard' mean?")],
          sideB: [
            ContentBlock.text(
              "'Port' refers to the left side of the boat, 'starboard' refers to the right side.",
            ),
          ],
          isPaid: false,
          showAFirst: true,
        ),
      ],
    ),
    Lesson(
      id: "lesson_term_3.00",
      title: "Paid: Basic Parts of the Boat",
      content: [
        ContentBlock.text(
          "Understand the key parts: mast, boom, rudder, cockpit, and deck.",
        ),
      ],
      keywords: ["boat parts", "mast", "rudder"],
      isPaid: true,
      flashcards: [
        Flashcard(
          id: "flashcard_lesson_term_3.00",
          title: "Basic Parts of the Boat",
          sideA: [ContentBlock.text("What are the key parts of a sailboat?")],
          sideB: [
            ContentBlock.text(
              "Mast (holds sails), boom (controls sail angle), rudder (steering), cockpit (control area), deck (walking space).",
            ),
          ],
          isPaid: true,
          showAFirst: true,
        ),
      ],
    ),
    Lesson(
      id: "lesson_term_4.00",
      title: "Paid: Types of Sails",
      content: [
        ContentBlock.text(
          "Main sail, jib, and spinnaker are common types of sails.",
        ),
      ],
      keywords: ["sails", "types of sails", "spinnaker"],
      isPaid: true,
      flashcards: [
        Flashcard(
          id: "flashcard_lesson_term_4.00",
          title: "Types of Sails",
          sideA: [ContentBlock.text("What are the common types of sails?")],
          sideB: [
            ContentBlock.text(
              "Main sail (primary driving force), jib (front sail), spinnaker (large, balloon-like sail for downwind sailing).",
            ),
          ],
          isPaid: true,
          showAFirst: true,
        ),
      ],
    ),
    Lesson(
      id: "lesson_term_5.00",
      title: "Paid: Points of Sail",
      content: [
        ContentBlock.text(
          "The angle of the boat relative to the wind determines the \"point of sail\".",
        ),
      ],
      keywords: ["points of sail", "wind", "sailing"],
      isPaid: true,
      flashcards: [
        Flashcard(
          id: "flashcard_lesson_term_5.00",
          title: "Points of Sail",
          sideA: [ContentBlock.text("What are the main points of sail?")],
          sideB: [
            ContentBlock.text(
              "Close-hauled (into the wind), beam reach (90° to wind), broad reach (wind behind), run (directly downwind).",
            ),
          ],
          isPaid: true,
          showAFirst: true,
        ),
      ],
    ),
  ];
}
