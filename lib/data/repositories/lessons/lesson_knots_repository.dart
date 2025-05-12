// 📄 lib/data/repositories/lessons/knots_lessons_repository.dart

import 'package:bcc5/data/models/content_block.dart';
import 'package:bcc5/data/models/flashcard_model.dart';
import 'package:bcc5/data/models/lesson_model.dart';

class KnotsLessonRepository {
  static final lessons = <Lesson>[
    Lesson(
      id: "lesson_knot_1.00",
      title: "Introductory Knots",
      content: [
        ContentBlock.text(
          "Introduction to two essential knots: figure-eight and cleat hitch.",
        ),
      ],
      keywords: ["figure-eight", "cleat hitch", "basic knots"],
      isPaid: false,
      flashcards: [
        Flashcard(
          id: "flashcard_lesson_knot_1.00",
          title: "Introductory Knots",
          sideA: [ContentBlock.text("What is a figure-eight knot used for?")],
          sideB: [
            ContentBlock.text(
              "To prevent a line from slipping through an opening.",
            ),
          ],
          isPaid: false,
          showAFirst: true,
        ),
      ],
    ),
    Lesson(
      id: "lesson_knot_2.00",
      title: "Essential Knots",
      content: [
        ContentBlock.text(
          "Learn the bowline, cleat hitch, figure-eight, and two half-hitches.",
        ),
      ],
      keywords: ["knots", "bowline", "cleat hitch"],
      isPaid: false,
      flashcards: [
        Flashcard(
          id: "flashcard_lesson_knot_2.00",
          title: "Essential Knots",
          sideA: [
            ContentBlock.text(
              "Which knot is best for creating a secure loop that won’t slip?",
            ),
          ],
          sideB: [ContentBlock.text("The bowline knot.")],
          isPaid: false,
          showAFirst: true,
        ),
      ],
    ),
    Lesson(
      id: "lesson_knot_3.00",
      title: "Basic Knots for Sailing",
      content: [
        ContentBlock.text(
          "Knowing basic knots is essential for securing lines.",
        ),
      ],
      keywords: ["knots", "rope_work", "sailing"],
      isPaid: false,
      flashcards: [
        Flashcard(
          id: "flashcard_lesson_knot_3.00",
          title: "Knots for Sailing",
          sideA: [
            ContentBlock.text("Why is the cleat hitch important in sailing?"),
          ],
          sideB: [
            ContentBlock.text(
              "It secures a line to a cleat quickly and securely.",
            ),
          ],
          isPaid: false,
          showAFirst: true,
        ),
      ],
    ),
    Lesson(
      id: "lesson_knot_4.00",
      title: "How to Coil and Store Lines",
      content: [
        ContentBlock.text(
          "Proper coiling and storage of lines prevent tangles and reduce wear.",
        ),
      ],
      keywords: ["lines", "rope_work", "coiling"],
      isPaid: false,
      flashcards: [
        Flashcard(
          id: "flashcard_lesson_knot_4.00",
          title: "Coiling and Storing Lines",
          sideA: [
            ContentBlock.text(
              "What is the benefit of properly coiling a line?",
            ),
          ],
          sideB: [
            ContentBlock.text("Prevents tangles and makes deployment easier."),
          ],
          isPaid: false,
          showAFirst: true,
        ),
      ],
    ),
    Lesson(
      id: "lesson_knot_5.00",
      title: "Advanced Knots",
      content: [
        ContentBlock.text(
          "Learn advanced knots like the sheet bend and alpine bend.",
        ),
      ],
      keywords: ["advanced knots", "sheet bend", "alpine bend"],
      isPaid: false,
      flashcards: [
        Flashcard(
          id: "flashcard_lesson_knot_5.00",
          title: "Advanced Knots",
          sideA: [ContentBlock.text("What is a sheet bend used for?")],
          sideB: [ContentBlock.text("Joining two ropes of different sizes.")],
          isPaid: false,
          showAFirst: true,
        ),
      ],
    ),
  ];
}
