// 📄 lib/data/repositories/lessons/lesson_seamanship_repository.dart

import 'package:bcc5/data/models/lesson_model.dart';
import 'package:bcc5/data/models/flashcard_model.dart';
import 'package:bcc5/data/models/content_block.dart';

class SeamanshipLessonRepository {
  static final lessons = <Lesson>[
    Lesson(
      id: "lesson_seam_1.00",
      title: "Raising the Sails",
      content: [
        ContentBlock.heading("Teamwork & Terminology"),
        ContentBlock.text(
          "Learn the names of sails and the teamwork required to raise them properly.",
        ),
      ],
      keywords: ["sails", "halyards", "winches"],
      isPaid: false,
      flashcards: [
        Flashcard(
          id: "flashcard_lesson_seam_1.00",
          title: "Raising the Sails",
          sideA: [
            ContentBlock.text("What is the primary function of halyards?"),
          ],
          sideB: [
            ContentBlock.text("Halyards are used to hoist sails up the mast."),
          ],
          isPaid: false,
          showAFirst: true,
        ),
      ],
    ),
    Lesson(
      id: "lesson_seam_2.00",
      title: "Sailing Along - Trimming Sails",
      content: [
        ContentBlock.heading("Trim for Speed"),
        ContentBlock.text(
          "Learn how to trim sails to optimize performance based on wind conditions.",
        ),
      ],
      keywords: ["sail trim", "tacking", "jibing"],
      isPaid: false,
      flashcards: [
        Flashcard(
          id: "flashcard_lesson_seam_2.00",
          title: "Sailing Along - Trimming Sails",
          sideA: [ContentBlock.text("What does proper sail trimming achieve?")],
          sideB: [
            ContentBlock.text(
              "It optimizes boat speed and efficiency by adjusting sails to wind conditions.",
            ),
          ],
          isPaid: false,
          showAFirst: true,
        ),
      ],
    ),
    Lesson(
      id: "lesson_seam_3.00",
      title: "Understanding Wind and Sail Interaction",
      content: [
        ContentBlock.heading("Harnessing Wind Power"),
        ContentBlock.text(
          "Gain an understanding of how sails interact with the wind to generate propulsion.",
        ),
      ],
      keywords: ["wind", "aerodynamics", "sail force"],
      isPaid: false,
      flashcards: [
        Flashcard(
          id: "flashcard_lesson_seam_3.00",
          title: "Understanding Wind and Sail Interaction",
          sideA: [
            ContentBlock.text(
              "How does wind generate propulsion on a sailboat?",
            ),
          ],
          sideB: [
            ContentBlock.text(
              "Wind flows over the sails, creating lift and pushing the boat forward.",
            ),
          ],
          isPaid: false,
          showAFirst: true,
        ),
      ],
    ),
    Lesson(
      id: "lesson_seam_4.00",
      title: "Heaving-To: How to Stop a Sailboat",
      content: [
        ContentBlock.heading("Pausing in Open Water"),
        ContentBlock.text(
          "Learn how to heave-to, an essential sailing maneuver to pause in open water.",
        ),
      ],
      keywords: ["heaving-to", "stopping", "storm tactics"],
      isPaid: false,
      flashcards: [
        Flashcard(
          id: "flashcard_lesson_seam_4.00",
          title: "Heaving-To: How to Stop a Sailboat",
          sideA: [ContentBlock.text("What is heaving-to?")],
          sideB: [
            ContentBlock.text(
              "A maneuver where the sails and rudder are adjusted to keep the boat nearly stationary in the water.",
            ),
          ],
          isPaid: false,
          showAFirst: true,
        ),
      ],
    ),
  ];
}
