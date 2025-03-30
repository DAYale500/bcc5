// Source: BCC4 raw repository
// Module: knots

import 'package:bcc4/data/models/flashcard_model.dart';
import 'package:bcc4/data/models/lesson_model.dart';

final List<Lesson> knotsLessons = [
  Lesson(
    id: "lesson_knot_1.00",
    moduleId: "knots",
    title: "Introductory Knots",
    content: [
      "Introduction to two essential knots: figure-eight and cleat hitch."
    ],
    keywords: ["figure-eight", "cleat hitch", "basic knots"],
    partIds: [],
    flashcardIds: ["flashcard_lesson_knot_1.00"],
    isPaid: false,
    flashcards: [
      Flashcard(
        id: "flashcard_lesson_knot_1.00",
        title: "FC: Introductory Knots",
        sideA: "What is a figure-eight knot used for?",
        sideB: "To prevent a line from slipping through an opening.",
        category: "Knots",
        referenceId: "lesson_knot_1.00",
        type: "lesson",
        isPaid: false,
      ),
    ],
  ),
  Lesson(
    id: "lesson_knot_2.00",
    moduleId: "knots",
    title: "Essential Knots",
    content: [
      "Learn the bowline, cleat hitch, figure-eight, and two half-hitches."
    ],
    keywords: ["knots", "bowline", "cleat hitch"],
    partIds: [],
    flashcardIds: ["flashcard_lesson_knot_2.00"],
    isPaid: false,
    flashcards: [
      Flashcard(
        id: "flashcard_lesson_knot_2.00",
        title: "FC: Essential Knots",
        sideA: "Which knot is best for creating a secure loop that won’t slip?",
        sideB: "The bowline knot.",
        category: "Knots",
        referenceId: "lesson_knot_2.00",
        type: "lesson",
        isPaid: false,
      ),
    ],
  ),
  Lesson(
    id: "lesson_knot_3.00",
    moduleId: "knots",
    title: "Basic Knots for Sailing",
    content: ["Knowing basic knots is essential for securing lines."],
    keywords: ["knots", "rope_work", "sailing"],
    partIds: [],
    flashcardIds: ["flashcard_lesson_knot_3.00"],
    isPaid: false,
    flashcards: [
      Flashcard(
        id: "flashcard_lesson_knot_3.00",
        title: "FC: Knots for Sailing",
        sideA: "Why is the cleat hitch important in sailing?",
        sideB: "It secures a line to a cleat quickly and securely.",
        category: "Knots",
        referenceId: "lesson_knot_3.00",
        type: "lesson",
        isPaid: false,
      ),
    ],
  ),
  Lesson(
    id: "lesson_knot_4.00",
    moduleId: "knots",
    title: "How to Coil and Store Lines",
    content: [
      "Proper coiling and storage of lines prevent tangles and reduce wear."
    ],
    keywords: ["lines", "rope_work", "coiling"],
    partIds: [],
    flashcardIds: ["flashcard_lesson_knot_4.00"],
    isPaid: false,
    flashcards: [
      Flashcard(
        id: "flashcard_lesson_knot_4.00",
        title: "FC: Coiling and Storing Lines",
        sideA: "What is the benefit of properly coiling a line?",
        sideB: "Prevents tangles and makes deployment easier.",
        category: "Knots",
        referenceId: "lesson_knot_4.00",
        type: "lesson",
        isPaid: false,
      ),
    ],
  ),
  Lesson(
    id: "lesson_knot_5.00",
    moduleId: "knots",
    title: "Advanced Knots",
    content: ["Learn advanced knots like the sheet bend and alpine bend."],
    keywords: ["advanced knots", "sheet bend", "alpine bend"],
    partIds: [],
    flashcardIds: ["flashcard_lesson_knot_5.00"],
    isPaid: false,
    flashcards: [
      Flashcard(
        id: "flashcard_lesson_knot_5.00",
        title: "FC: Advanced Knots",
        sideA: "What is a sheet bend used for?",
        sideB: "Joining two ropes of different sizes.",
        category: "Knots",
        referenceId: "lesson_knot_5.00",
        type: "lesson",
        isPaid: false,
      ),
    ],
  ),
];