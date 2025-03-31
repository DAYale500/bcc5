// 📄 lib/data/repositories/lessons/systems_lessons_repository.dart

import 'package:bcc5/data/models/content_block.dart';
import 'package:bcc5/data/models/lesson_model.dart';
import 'package:bcc5/data/models/flashcard_model.dart';

class SystemsLessonRepository {
  static final lessons = <Lesson>[
    Lesson(
      id: "lesson_syst_1.00",
      title: "Get Oriented with the Boat",
      content: [
        ContentBlock.text(
          "Explore key areas of a sailboat, including the cockpit, deck, and cabin.",
        ),
      ],
      keywords: ["boat layout", "cockpit", "deck", "cabin"],
      isPaid: false,
      flashcards: [
        Flashcard(
          id: "flashcard_lesson_syst_1.00",
          title: "FC: Get Oriented with the Boat",
          sideA: [ContentBlock.text("What are the key areas of a sailboat?")],
          sideB: [
            ContentBlock.text(
              "The cockpit, deck, and cabin are primary areas of a sailboat.",
            ),
          ],
          isPaid: false,
          showAFirst: true,
        ),
      ],
    ),
    Lesson(
      id: "lesson_syst_2.00",
      title: "Free: Essential Boat Equipment",
      content: [
        ContentBlock.text("Understand the essential equipment on a boat."),
      ],
      keywords: ["equipment", "boat safety", "essentials"],
      isPaid: false,
      flashcards: [
        Flashcard(
          id: "flashcard_lesson_syst_2.00",
          title: "FC: Essential Boat Equipment",
          sideA: [
            ContentBlock.text("What are examples of essential boat equipment?"),
          ],
          sideB: [
            ContentBlock.text(
              "Life jackets, fire extinguishers, and navigation tools.",
            ),
          ],
          isPaid: false,
          showAFirst: true,
        ),
      ],
    ),
    Lesson(
      id: "lesson_syst_3.00",
      title: "Free: Winches",
      content: [
        ContentBlock.text(
          "Overview of a winch’s purpose and safe handling techniques.",
        ),
      ],
      keywords: ["winches", "equipment", "handling"],
      isPaid: false,
      flashcards: [
        Flashcard(
          id: "flashcard_lesson_syst_3.00",
          title: "FC: Winches",
          sideA: [ContentBlock.text("What is a winch used for on a boat?")],
          sideB: [
            ContentBlock.text(
              "A winch provides mechanical advantage for tightening lines.",
            ),
          ],
          isPaid: false,
          showAFirst: true,
        ),
      ],
    ),
    Lesson(
      id: "lesson_syst_4.00",
      title: "Paid: Use of the Head (Toilet)",
      content: [
        ContentBlock.text(
          "To use the head, pump a small amount of water into the bowl first, then pump 3–4 times after use.",
        ),
      ],
      keywords: ["toilet", "head", "boat equipment"],
      isPaid: true,
      flashcards: [
        Flashcard(
          id: "flashcard_lesson_syst_4.00",
          title: "FC: Use of the Head (Toilet)",
          sideA: [
            ContentBlock.text("How do you properly use a marine toilet?"),
          ],
          sideB: [
            ContentBlock.text(
              "Pump water in, use the toilet, then pump 3–4 times after use.",
            ),
          ],
          isPaid: true,
          showAFirst: true,
        ),
      ],
    ),
    Lesson(
      id: "lesson_syst_5.00",
      title: "Paid: Introduction to Boat Equipment",
      content: [
        ContentBlock.text(
          "This lesson covers essential boat equipment every crew member should know.",
        ),
      ],
      keywords: ["equipment", "boat safety", "introduction"],
      isPaid: true,
      flashcards: [
        Flashcard(
          id: "flashcard_lesson_syst_5.00",
          title: "FC: Introduction to Boat Equipment",
          sideA: [
            ContentBlock.text("Why is it important to know boat equipment?"),
          ],
          sideB: [
            ContentBlock.text(
              "Understanding equipment improves safety and efficiency on board.",
            ),
          ],
          isPaid: true,
          showAFirst: true,
        ),
      ],
    ),
    Lesson(
      id: "lesson_syst_6.00",
      title: "Free: Parts of the Boat",
      content: [
        ContentBlock.text(
          "Familiarize yourself with key parts of the boat: bow, stern, port, starboard, and boom.",
        ),
      ],
      keywords: ["bow", "stern", "port", "starboard", "boom"],
      isPaid: false,
      flashcards: [
        Flashcard(
          id: "flashcard_lesson_syst_6.00",
          title: "FC: Parts of the Boat",
          sideA: [
            ContentBlock.text("What are the key directional terms on a boat?"),
          ],
          sideB: [
            ContentBlock.text(
              "Bow (front), stern (back), port (left), starboard (right).",
            ),
          ],
          isPaid: false,
          showAFirst: true,
        ),
      ],
    ),
  ];
}
