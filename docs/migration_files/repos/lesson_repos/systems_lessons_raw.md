// Source: BCC4 raw repository
// Module: systems

import 'package:bcc4/data/models/flashcard_model.dart';
import 'package:bcc4/data/models/lesson_model.dart';

final List<Lesson> systemsLessons = [
  Lesson(
    id: "lesson_syst_1.00",
    moduleId: "systems",
    title: "Get Oriented with the Boat",
    content: [
      "Explore key areas of a sailboat, including the cockpit, deck, and cabin."
    ],
    keywords: ["boat layout", "cockpit", "deck", "cabin"],
    partIds: ["part_cockpit"],
    flashcardIds: ["flashcard_lesson_syst_1.00"],
    isPaid: false,
    flashcards: [
      Flashcard(
        id: "flashcard_lesson_syst_1.00",
        title: "FC: Get Oriented with the Boat",
        sideA: "What are the key areas of a sailboat?",
        sideB: "The cockpit, deck, and cabin are primary areas of a sailboat.",
        category: "Systems",
        referenceId: "lesson_syst_1.00",
        type: "lesson",
        isPaid: false,
      ),
    ],
  ),
  Lesson(
    id: "lesson_syst_2.00",
    moduleId: "systems",
    title: "Free: Essential Boat Equipment",
    content: ["Understand the essential equipment on a boat."],
    keywords: ["equipment", "boat safety", "essentials"],
    partIds: [],
    flashcardIds: ["flashcard_lesson_syst_2.00"],
    isPaid: false,
    flashcards: [
      Flashcard(
        id: "flashcard_lesson_syst_2.00",
        title: "FC: Essential Boat Equipment",
        sideA: "What are examples of essential boat equipment?",
        sideB: "Life jackets, fire extinguishers, and navigation tools.",
        category: "Systems",
        referenceId: "lesson_syst_2.00",
        type: "lesson",
        isPaid: false,
      ),
    ],
  ),
  Lesson(
    id: "lesson_syst_3.00",
    moduleId: "systems",
    title: "Free: Winches",
    content: ["Overview of a winch’s purpose and safe handling techniques."],
    keywords: ["winches", "equipment", "handling"],
    partIds: [],
    flashcardIds: ["flashcard_lesson_syst_3.00"],
    isPaid: false,
    flashcards: [
      Flashcard(
        id: "flashcard_lesson_syst_3.00",
        title: "FC: Winches",
        sideA: "What is a winch used for on a boat?",
        sideB: "A winch provides mechanical advantage for tightening lines.",
        category: "Systems",
        referenceId: "lesson_syst_3.00",
        type: "lesson",
        isPaid: false,
      ),
    ],
  ),
  Lesson(
    id: "lesson_syst_4.00",
    moduleId: "systems",
    title: "Paid: Use of the Head (Toilet)",
    content: [
      "To use the head, pump a small amount of water into the bowl first, then pump 3–4 times after use."
    ],
    keywords: ["toilet", "head", "boat equipment"],
    partIds: [],
    flashcardIds: ["flashcard_lesson_syst_4.00"],
    isPaid: true,
    flashcards: [
      Flashcard(
        id: "flashcard_lesson_syst_4.00",
        title: "FC: Use of the Head (Toilet)",
        sideA: "How do you properly use a marine toilet?",
        sideB: "Pump water in, use the toilet, then pump 3-4 times after use.",
        category: "Systems",
        referenceId: "lesson_syst_4.00",
        type: "lesson",
        isPaid: true,
      ),
    ],
  ),
  Lesson(
    id: "lesson_syst_5.00",
    moduleId: "systems",
    title: "Paid: Introduction to Boat Equipment",
    content: [
      "This lesson covers essential boat equipment every crew member should know."
    ],
    keywords: ["equipment", "boat safety", "introduction"],
    partIds: [],
    flashcardIds: ["flashcard_lesson_syst_5.00"],
    isPaid: true,
    flashcards: [
      Flashcard(
        id: "flashcard_lesson_syst_5.00",
        title: "FC: Introduction to Boat Equipment",
        sideA: "Why is it important to know boat equipment?",
        sideB:
            "Understanding equipment improves safety and efficiency on board.",
        category: "Systems",
        referenceId: "lesson_syst_5.00",
        type: "lesson",
        isPaid: true,
      ),
    ],
  ),
  Lesson(
    id: "lesson_syst_6.00",
    moduleId: "systems",
    title: "Free: Parts of the Boat",
    content: [
      "Familiarize yourself with key parts of the boat: bow, stern, port, starboard, and boom."
    ],
    keywords: ["bow", "stern", "port", "starboard", "boom"],
    partIds: [],
    flashcardIds: ["flashcard_lesson_syst_6.00"],
    isPaid: false,
    flashcards: [
      Flashcard(
        id: "flashcard_lesson_syst_6.00",
        title: "FC: Parts of the Boat",
        sideA: "What are the key directional terms on a boat?",
        sideB: "Bow (front), stern (back), port (left), starboard (right).",
        category: "Systems",
        referenceId: "lesson_syst_6.00",
        type: "lesson",
        isPaid: false,
      ),
    ],
  ),
];