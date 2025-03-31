// 📄 lib/data/repositories/lessons/teamwork_lessons_repository.dart

import 'package:bcc5/data/models/flashcard_model.dart';
import 'package:bcc5/data/models/lesson_model.dart';
import 'package:bcc5/data/models/content_block.dart';

class TeamworkLessonRepository {
  static final lessons = <Lesson>[
    Lesson(
      id: "lesson_team_1.00",
      title: "Boarding Etiquette",
      content: [
        ContentBlock.text(
          "Learn the proper way to board a sailboat and where to stow gear.",
        ),
      ],
      keywords: ["boarding", "etiquette", "gear storage"],
      isPaid: false,
      flashcards: [
        Flashcard(
          id: "flashcard_lesson_team_1.00",
          title: "FC: Boarding Etiquette",
          sideA: [
            ContentBlock.text("What is the proper way to board a sailboat?"),
          ],
          sideB: [
            ContentBlock.text(
              "Step carefully, distribute weight evenly, and secure gear immediately.",
            ),
          ],
          isPaid: false,
          showAFirst: true,
        ),
      ],
    ),
    Lesson(
      id: "lesson_team_2.00",
      title: "Free: Welcome Aboard: Expectations and Basic Boat Etiquette",
      content: [
        ContentBlock.text("Brief introduction to crew roles and expectations."),
      ],
      keywords: ["boat etiquette", "crew expectations", "onboard"],
      isPaid: false,
      flashcards: [
        Flashcard(
          id: "flashcard_lesson_team_2.00",
          title: "FC: Basic Boat Etiquette",
          sideA: [ContentBlock.text("Why is boat etiquette important?")],
          sideB: [
            ContentBlock.text(
              "It ensures safety, smooth operations, and harmony among crew members.",
            ),
          ],
          isPaid: false,
          showAFirst: true,
        ),
      ],
    ),
    Lesson(
      id: "lesson_team_3.00",
      title: "Free: Basic Crew Responsibilities",
      content: [ContentBlock.text("Understand the roles of each crew member.")],
      keywords: ["crew", "roles", "responsibilities"],
      isPaid: false,
      flashcards: [
        Flashcard(
          id: "flashcard_lesson_team_3.00",
          title: "FC: Basic Crew Responsibilities",
          sideA: [
            ContentBlock.text(
              "What are the primary responsibilities of a crew member?",
            ),
          ],
          sideB: [
            ContentBlock.text(
              "Assisting in navigation, keeping watch, handling lines, and maintaining safety.",
            ),
          ],
          isPaid: false,
          showAFirst: true,
        ),
      ],
    ),
    Lesson(
      id: "lesson_team_4.00",
      title: "Paid: Crew Roles and Communication",
      content: [
        ContentBlock.text(
          "Clear communication is crucial for coordination and safety.",
        ),
      ],
      keywords: ["crew", "communication", "roles"],
      isPaid: true,
      flashcards: [
        Flashcard(
          id: "flashcard_lesson_team_4.00",
          title: "FC: Crew Roles and Communication",
          sideA: [
            ContentBlock.text(
              "Why is communication essential among crew members?",
            ),
          ],
          sideB: [
            ContentBlock.text(
              "Clear communication prevents accidents and ensures smooth operations.",
            ),
          ],
          isPaid: true,
          showAFirst: true,
        ),
      ],
    ),
    Lesson(
      id: "lesson_team_5.00",
      title: "Paid: Assist in Docking and Anchoring",
      content: [
        ContentBlock.text("Be ready to handle lines and follow directions."),
      ],
      keywords: ["docking", "anchoring", "crew roles"],
      isPaid: true,
      flashcards: [
        Flashcard(
          id: "flashcard_lesson_team_5.00",
          title: "FC: Assist in Docking and Anchoring",
          sideA: [
            ContentBlock.text(
              "What is a crew member's role in docking and anchoring?",
            ),
          ],
          sideB: [
            ContentBlock.text(
              "Handling lines, securing the boat, and following skipper instructions.",
            ),
          ],
          isPaid: true,
          showAFirst: true,
        ),
      ],
    ),
  ];
}
