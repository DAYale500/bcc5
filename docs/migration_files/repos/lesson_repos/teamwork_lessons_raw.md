// Source: BCC4 raw repository
// Module: teamwork

import 'package:bcc4/data/models/flashcard_model.dart';
import 'package:bcc4/data/models/lesson_model.dart';

final List<Lesson> teamworkLessons = [
  Lesson(
    id: "lesson_team_1.00",
    moduleId: "teamwork",
    title: "Boarding Etiquette",
    content: [
      "Learn the proper way to board a sailboat and where to stow gear."
    ],
    keywords: ["boarding", "etiquette", "gear storage"],
    partIds: [],
    flashcardIds: ["flashcard_lesson_team_1.00"],
    isPaid: false,
    flashcards: [
      Flashcard(
        id: "flashcard_lesson_team_1.00",
        title: "FC: Boarding Etiquette",
        sideA: "What is the proper way to board a sailboat?",
        sideB:
            "Step carefully, distribute weight evenly, and secure gear immediately.",
        category: "Teamwork",
        referenceId: "lesson_team_1.00",
        type: "lesson",
        isPaid: false,
      ),
    ],
  ),
  Lesson(
    id: "lesson_team_2.00",
    moduleId: "teamwork",
    title: "Free: Welcome Aboard: Expectations and Basic Boat Etiquette",
    content: ["Brief introduction to crew roles and expectations."],
    keywords: ["boat etiquette", "crew expectations", "onboard"],
    partIds: [],
    flashcardIds: ["flashcard_lesson_team_2.00"],
    isPaid: false,
    flashcards: [
      Flashcard(
        id: "flashcard_lesson_team_2.00",
        title: "FC: Basic Boat Etiquette",
        sideA: "Why is boat etiquette important?",
        sideB:
            "It ensures safety, smooth operations, and harmony among crew members.",
        category: "Teamwork",
        referenceId: "lesson_team_2.00",
        type: "lesson",
        isPaid: false,
      ),
    ],
  ),
  Lesson(
    id: "lesson_team_3.00",
    moduleId: "teamwork",
    title: "Free: Basic Crew Responsibilities",
    content: ["Understand the roles of each crew member."],
    keywords: ["crew", "roles", "responsibilities"],
    partIds: [],
    flashcardIds: ["flashcard_lesson_team_3.00"],
    isPaid: false,
    flashcards: [
      Flashcard(
        id: "flashcard_lesson_team_3.00",
        title: "FC: Basic Crew Responsibilities",
        sideA: "What are the primary responsibilities of a crew member?",
        sideB:
            "Assisting in navigation, keeping watch, handling lines, and maintaining safety.",
        category: "Teamwork",
        referenceId: "lesson_team_3.00",
        type: "lesson",
        isPaid: false,
      ),
    ],
  ),
  Lesson(
    id: "lesson_team_4.00",
    moduleId: "teamwork",
    title: "Paid: Crew Roles and Communication",
    content: ["Clear communication is crucial for coordination and safety."],
    keywords: ["crew", "communication", "roles"],
    partIds: [],
    flashcardIds: ["flashcard_lesson_team_4.00"],
    isPaid: true,
    flashcards: [
      Flashcard(
        id: "flashcard_lesson_team_4.00",
        title: "FC: Crew Roles and Communication",
        sideA: "Why is communication essential among crew members?",
        sideB:
            "Clear communication prevents accidents and ensures smooth operations.",
        category: "Teamwork",
        referenceId: "lesson_team_4.00",
        type: "lesson",
        isPaid: true,
      ),
    ],
  ),
  Lesson(
    id: "lesson_team_5.00",
    moduleId: "teamwork",
    title: "Paid: Assist in Docking and Anchoring",
    content: ["Be ready to handle lines and follow directions."],
    keywords: ["docking", "anchoring", "crew roles"],
    partIds: [],
    flashcardIds: ["flashcard_lesson_team_5.00"],
    isPaid: true,
    flashcards: [
      Flashcard(
        id: "flashcard_lesson_team_5.00",
        title: "FC: Assist in Docking and Anchoring",
        sideA: "What is a crew member's role in docking and anchoring?",
        sideB:
            "Handling lines, securing the boat, and following skipper instructions.",
        category: "Teamwork",
        referenceId: "lesson_team_5.00",
        type: "lesson",
        isPaid: true,
      ),
    ],
  ),
];