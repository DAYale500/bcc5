// Source: BCC4 raw repository
// Module: safety

import 'package:bcc4/data/models/flashcard_model.dart';
import 'package:bcc4/data/models/lesson_model.dart';

final List<Lesson> safetyLessons = [
  Lesson(
    id: "lesson_safe_1.00",
    moduleId: "safety",
    title: "Packing List and Clothing",
    content: [
      "Learn what to pack for a sailing trip, including clothing, gear, and safety essentials."
    ],
    keywords: ["packing", "gear", "clothing", "preparation"],
    partIds: [],
    flashcardIds: ["flashcard_lesson_safe_1.00"],
    isPaid: false,
    flashcards: [
      Flashcard(
        id: "flashcard_lesson_safe_1.00",
        title: "FC: Packing List and Clothing",
        sideA: "What are essential items to pack for a sailing trip?",
        sideB:
            "Clothing layers, waterproof gear, life jackets, and safety essentials.",
        category: "Safety",
        referenceId: "lesson_safe_1.00",
        type: "lesson",
        isPaid: false,
      ),
    ],
  ),
  Lesson(
    id: "lesson_safe_2.00",
    moduleId: "safety",
    title: "Safety Briefing",
    content: [
      "Understand basic safety procedures on board, including life jackets, emergency signals, and safety drills."
    ],
    keywords: ["safety briefing", "life jackets", "emergency"],
    partIds: ["part_life_jacket"],
    flashcardIds: ["flashcard_lesson_safe_2.00"],
    isPaid: false,
    flashcards: [
      Flashcard(
        id: "flashcard_lesson_safe_2.00",
        title: "FC: Safety Briefing",
        sideA: "What is a key topic covered in a safety briefing?",
        sideB: "Emergency procedures, life jackets, and crew responsibilities.",
        category: "Safety",
        referenceId: "lesson_safe_2.00",
        type: "lesson",
        isPaid: false,
      ),
    ],
  ),
  Lesson(
    id: "lesson_safe_3.00",
    moduleId: "safety",
    title: "Essential Safety Equipment",
    content: [
      "Guidance on locating and understanding the use of life jackets, fire extinguishers, and throwable flotation devices to ensure basic onboard safety."
    ],
    keywords: ["safety equipment", "life jacket", "fire extinguisher"],
    partIds: [],
    flashcardIds: ["flashcard_lesson_safe_3.00"],
    isPaid: false,
    flashcards: [
      Flashcard(
        id: "flashcard_lesson_safe_3.00",
        title: "FC: Essential Safety Equipment",
        sideA: "What is the purpose of a throwable flotation device?",
        sideB: "To assist a person overboard until they can be rescued.",
        category: "Safety",
        referenceId: "lesson_safe_3.00",
        type: "lesson",
        isPaid: false,
      ),
    ],
  ),
  Lesson(
    id: "lesson_safe_4.00",
    moduleId: "safety",
    title: "Man Overboard Procedure",
    content: [
      "IMMEDIATE ACTIONS for MOB. If someone falls overboard, it's important to recover them quickly, especially in cold water."
    ],
    keywords: ["man overboard", "MOB", "rescue", "recovery"],
    partIds: [],
    flashcardIds: ["flashcard_lesson_safe_4.00"],
    isPaid: false,
    flashcards: [
      Flashcard(
        id: "flashcard_lesson_safe_4.00",
        title: "FC: Man Overboard Procedure",
        sideA: "What should you do immediately if someone falls overboard?",
        sideB:
            "Shout 'Man Overboard', throw a flotation device, and maintain visual contact.",
        category: "Safety",
        referenceId: "lesson_safe_4.00",
        type: "lesson",
        isPaid: false,
      ),
    ],
  ),
  Lesson(
    id: "lesson_safe_5.00",
    moduleId: "safety",
    title: "Where to Sit on the Boat",
    content: [
      "Sit in designated areas that are free from lines and equipment. Avoid sitting in areas like the bow (front) in rough conditions unless instructed."
    ],
    keywords: ["safety", "seating", "safe zones"],
    partIds: [],
    flashcardIds: ["flashcard_lesson_safe_5.00"],
    isPaid: false,
    flashcards: [
      Flashcard(
        id: "flashcard_lesson_safe_5.00",
        title: "FC: Where to Sit on the Boat",
        sideA: "Why should you avoid sitting on the bow in rough conditions?",
        sideB:
            "The bow can become unstable and increase the risk of falling overboard.",
        category: "Safety",
        referenceId: "lesson_safe_5.00",
        type: "lesson",
        isPaid: false,
      ),
    ],
  ),
  Lesson(
    id: "lesson_safe_6.00",
    moduleId: "safety",
    title: "How to Move Around the Boat Safely",
    content: [
      "Always hold onto something (known as 'one hand for the boat'). Move slowly and deliberately, and be aware of swinging sails or lines."
    ],
    keywords: ["movement", "handrails", "safety"],
    partIds: [],
    flashcardIds: ["flashcard_lesson_safe_6.00"],
    isPaid: false,
    flashcards: [
      Flashcard(
        id: "flashcard_lesson_safe_6.00",
        title: "FC: How to Move Around the Boat Safely",
        sideA: "What does 'one hand for the boat' mean?",
        sideB:
            "Always keep one hand holding onto the boat to maintain stability.",
        category: "Safety",
        referenceId: "lesson_safe_6.00",
        type: "lesson",
        isPaid: false,
      ),
    ],
  ),
  Lesson(
    id: "lesson_safe_7.00",
    moduleId: "safety",
    title: "Advanced Safety",
    content: ["Learn how to stay as safe as possible in various scenarios."],
    keywords: ["advanced safety", "safety protocols", "crew safety"],
    partIds: [],
    flashcardIds: ["flashcard_lesson_safe_7.00"],
    isPaid: false,
    flashcards: [
      Flashcard(
        id: "flashcard_lesson_safe_7.00",
        title: "FC: Advanced Safety",
        sideA: "What is one of the key aspects of advanced safety?",
        sideB:
            "Being prepared for multiple emergency situations and knowing protocols.",
        category: "Safety",
        referenceId: "lesson_safe_7.00",
        type: "lesson",
        isPaid: false,
      ),
    ],
  ),
];