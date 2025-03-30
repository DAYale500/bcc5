// Source: BCC4 raw repository
// Module: terminology

import 'package:bcc4/data/models/flashcard_model.dart';
import 'package:bcc4/data/models/lesson_model.dart';

final List<Lesson> terminologyLessons = [
  Lesson(
    id: "lesson_term_1.00",
    moduleId: "terminology",
    title: "Free: Essential Terms",
    content: ["Introduction to essential sailing terms."],
    keywords: ["essential terms", "sailing basics", "orientation"],
    partIds: [],
    flashcardIds: ["flashcard_lesson_term_1.00"],
    isPaid: false,
    flashcards: [
      Flashcard(
        id: "flashcard_lesson_term_1.00",
        title: "FC: Essential Terms",
        sideA:
            "What are some essential sailing terms every crew member should know?",
        sideB:
            "Terms like 'bow' (front), 'stern' (back), 'port' (left), 'starboard' (right).",
        category: "Terminology",
        referenceId: "lesson_term_1.00",
        type: "lesson",
        isPaid: false,
      ),
    ],
  ),
  Lesson(
    id: "lesson_term_2.00",
    moduleId: "terminology",
    title: "Free: Common Nautical Terms",
    content: ["Learn basic terms like “port” (left), “starboard” (right)."],
    keywords: ["nautical terms", "port", "starboard"],
    partIds: [],
    flashcardIds: ["flashcard_lesson_term_2.00"],
    isPaid: false,
    flashcards: [
      Flashcard(
        id: "flashcard_lesson_term_2.00",
        title: "FC: Common Nautical Terms",
        sideA: "What does 'port' and 'starboard' mean?",
        sideB:
            "'Port' refers to the left side of the boat, 'starboard' refers to the right side.",
        category: "Terminology",
        referenceId: "lesson_term_2.00",
        type: "lesson",
        isPaid: false,
      ),
    ],
  ),
  Lesson(
    id: "lesson_term_3.00",
    moduleId: "terminology",
    title: "Paid: Basic Parts of the Boat",
    content: [
      "Understand the key parts: mast, boom, rudder, cockpit, and deck."
    ],
    keywords: ["boat parts", "mast", "rudder"],
    partIds: [],
    flashcardIds: ["flashcard_lesson_term_3.00"],
    isPaid: true,
    flashcards: [
      Flashcard(
        id: "flashcard_lesson_term_3.00",
        title: "FC: Basic Parts of the Boat",
        sideA: "What are the key parts of a sailboat?",
        sideB:
            "Mast (holds sails), boom (controls sail angle), rudder (steering), cockpit (control area), deck (walking space).",
        category: "Terminology",
        referenceId: "lesson_term_3.00",
        type: "lesson",
        isPaid: true,
      ),
    ],
  ),
  Lesson(
    id: "lesson_term_4.00",
    moduleId: "terminology",
    title: "Paid: Types of Sails",
    content: ["Main sail, jib, and spinnaker are common types of sails."],
    keywords: ["sails", "types of sails", "spinnaker"],
    partIds: [],
    flashcardIds: ["flashcard_lesson_term_4.00"],
    isPaid: true,
    flashcards: [
      Flashcard(
        id: "flashcard_lesson_term_4.00",
        title: "FC: Types of Sails",
        sideA: "What are the common types of sails?",
        sideB:
            "Main sail (primary driving force), jib (front sail), spinnaker (large, balloon-like sail for downwind sailing).",
        category: "Terminology",
        referenceId: "lesson_term_4.00",
        type: "lesson",
        isPaid: true,
      ),
    ],
  ),
  Lesson(
    id: "lesson_term_5.00",
    moduleId: "terminology",
    title: "Paid: Points of Sail",
    content: [
      "The angle of the boat relative to the wind determines the \"point of sail\"."
    ],
    keywords: ["points of sail", "wind", "sailing"],
    partIds: [],
    flashcardIds: ["flashcard_lesson_term_5.00"],
    isPaid: true,
    flashcards: [
      Flashcard(
        id: "flashcard_lesson_term_5.00",
        title: "FC: Points of Sail",
        sideA: "What are the main points of sail?",
        sideB:
            "Close-hauled (into the wind), beam reach (90° to wind), broad reach (wind behind), run (directly downwind).",
        category: "Terminology",
        referenceId: "lesson_term_5.00",
        type: "lesson",
        isPaid: true,
      ),
    ],
  ),
];