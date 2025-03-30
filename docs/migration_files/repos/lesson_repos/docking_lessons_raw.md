// Source: BCC4 raw repository
// Module: docking

import 'package:bcc4/data/models/flashcard_model.dart';
import 'package:bcc4/data/models/lesson_model.dart';

final List<Lesson> dockingLessons = [
  Lesson(
    id: "lesson_dock_1.00",
    moduleId: "docking",
    title: "L1: Handling Dock Lines",
    content: [
      "L1: Learn proper techniques for handling dock lines when leaving and returning to the dock."
    ],
    keywords: ["dock lines", "fenders", "cleats", "communication"],
    partIds: ["part_dock_lines"],
    flashcardIds: ["flashcard_lesson_dock_1.00"],
    isPaid: false,
    flashcards: [
      Flashcard(
        id: "flashcard_lesson_dock_1.00",
        title: "FC: Dock Line Basics",
        sideA: "What is a cleat hitch used for?",
        sideB: "Securing dock lines to cleats.",
        category: "Docking",
        referenceId: "lesson_dock_1.00",
        type: "lesson",
        isPaid: false,
      ),
    ],
  ),
  Lesson(
    id: "lesson_dock_2.00",
    moduleId: "docking",
    title: "L2: Anchoring - Setting Up",
    content: [
      "L2: should skip Learn the steps to safely set up an anchor before deployment."
    ],
    keywords: ["anchoring", "setup", "scope", "windlass"],
    partIds: ["part_anchor_windlass"],
    flashcardIds: ["flashcard_lesson_dock_2.00"],
    isPaid: false,
    flashcards: [
      Flashcard(
        id: "flashcard_lesson_dock_2.00",
        title: "FC: Anchor Types",
        sideA: "What is a Danforth anchor best suited for?",
        sideB: "Soft bottoms like sand or mud.",
        category: "Docking",
        referenceId: "lesson_dock_2.00",
        type: "lesson",
        isPaid: false,
      ),
    ],
  ),
  Lesson(
    id: "lesson_dock_3.00",
    moduleId: "docking",
    title: "Basics of Side Ties",
    content: [
      "L3: Learn how to properly moor to another boat using side ties."
    ],
    keywords: ["side tie", "dock lines", "fenders", "knots"],
    partIds: ["part_mooring_lines"],
    flashcardIds: ["flashcard_lesson_dock_3.00"],
    isPaid: false,
    flashcards: [
      Flashcard(
        id: "flashcard_lesson_dock_3.00",
        title: "FC: Side Tie Techniques",
        sideA: "What knot is commonly used for a side tie?",
        sideB: "A bowline or a clove hitch.",
        category: "Docking",
        referenceId: "lesson_dock_3.00",
        type: "lesson",
        isPaid: false,
      ),
    ],
  ),
  Lesson(
    id: "lesson_dock_4.00",
    moduleId: "docking",
    title: "Returning to Dock - Docking Procedure",
    content: ["L4: Step-by-step guide to safely docking a boat."],
    keywords: ["docking", "approach", "lines", "teamwork"],
    partIds: ["part_dock_fenders"],
    flashcardIds: ["flashcard_lesson_dock_4.00"],
    isPaid: false,
    flashcards: [
      Flashcard(
        id: "flashcard_lesson_dock_4.00",
        title: "FC: Docking Signals",
        sideA: "What hand signal indicates 'neutral'?",
        sideB: "A flat palm facing downward.",
        category: "Docking",
        referenceId: "lesson_dock_4.00",
        type: "lesson",
        isPaid: false,
      ),
    ],
  ),
  Lesson(
    id: "lesson_dock_5.00",
    moduleId: "docking",
    title: "Basic Deck Safety and Boom Awareness",
    content: [
      "Essential safety measures for moving safely on deck, keeping footing secure, and understanding the boom’s position to prevent accidents."
    ],
    keywords: ["safety", "deck", "boom awareness"],
    partIds: [],
    flashcardIds: ["flashcard_lesson_dock_5.00"],
    isPaid: false,
    flashcards: [
      Flashcard(
        id: "flashcard_lesson_dock_5.00",
        title: "Deck Safety",
        sideA: "What is the safest way to move on a boat?",
        sideB: "Always keep three points of contact.",
        category: "Docking",
        referenceId: "lesson_dock_5.00",
        type: "lesson",
        isPaid: false,
      ),
    ],
  ),
  Lesson(
    id: "lesson_dock_6.00",
    moduleId: "docking",
    title: "How to Assist in Docking",
    content: [
      "Be ready to handle lines and assist with docking procedures by following instructions."
    ],
    keywords: ["docking", "lines", "crew roles"],
    partIds: [],
    flashcardIds: ["flashcard_lesson_dock_6.00"],
    isPaid: false,
    flashcards: [
      Flashcard(
        id: "flashcard_lesson_dock_6.00",
        title: "FC: Crew Docking Roles",
        sideA: "What is a crew member's primary duty when docking?",
        sideB: "To secure the dock lines as directed.",
        category: "Docking",
        referenceId: "lesson_dock_6.00",
        type: "lesson",
        isPaid: false,
      ),
    ],
  ),
  Lesson(
    id: "lesson_dock_7.00",
    moduleId: "docking",
    title: "How to Assist in Anchoring",
    content: [
      "Follow the skipper’s instructions carefully when handling the anchor, ensuring a smooth and safe process."
    ],
    keywords: ["anchoring", "crew roles", "safety"],
    partIds: [],
    flashcardIds: ["flashcard_lesson_dock_7.00"],
    isPaid: false,
    flashcards: [
      Flashcard(
        id: "flashcard_lesson_dock_7.00",
        title: "FC: Anchoring Roles",
        sideA: "What should the crew do when the anchor is dropped?",
        sideB: "Communicate anchor set status to the helm.",
        category: "Docking",
        referenceId: "lesson_dock_7.00",
        type: "lesson",
        isPaid: false,
      ),
    ],
  ),
  Lesson(
    id: "lesson_dock_8.00",
    moduleId: "docking",
    title: "Lowering the Anchor Safely",
    content: [
      "To anchor a sailboat, first identify your desired anchoring spot and approach it into the wind."
    ],
    keywords: ["anchoring", "lowering anchor", "scope", "windlass"],
    partIds: [],
    flashcardIds: ["flashcard_lesson_dock_8.00"],
    isPaid: false,
    flashcards: [
      Flashcard(
        id: "flashcard_lesson_dock_8.00",
        title: "FC: Anchor Deployment",
        sideA: "What is the recommended anchor scope?",
        sideB: "5 to 7 times the depth in calm conditions.",
        category: "Docking",
        referenceId: "lesson_dock_8.00",
        type: "lesson",
        isPaid: false,
      ),
    ],
  ),
  Lesson(
    id: "lesson_dock_9.00",
    moduleId: "docking",
    title: "Raising the Anchor Safely",
    content: [
      "Raising an anchor safely requires careful coordination with the crew.",
      "assets/images/bunks_berths.png",
      "The windlass should always be used with caution to prevent injury.",
      "assets/images/electrical_system.jpg",
      "Once the anchor is fully retrieved, secure it properly to avoid accidental deployment."
    ],
    keywords: ["raising anchor", "retrieving", "windlass", "communication"],
    partIds: [],
    flashcardIds: ["flashcard_lesson_dock_9.00"],
    isPaid: false,
    flashcards: [
      Flashcard(
        id: "flashcard_lesson_dock_9.00",
        title: "FC: Anchor Retrieval",
        sideA: "What is the first step in raising an anchor?",
        sideB: "Drive the boat forward to reduce strain on the anchor.",
        category: "Docking",
        referenceId: "lesson_dock_9.00",
        type: "lesson",
        isPaid: false,
      ),
    ],
  ),
];