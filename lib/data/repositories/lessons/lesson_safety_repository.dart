// 📄 lib/data/repositories/lessons/safety_lessons_repository.dart

import 'package:bcc5/data/models/content_block.dart';
import 'package:bcc5/data/models/flashcard_model.dart';
import 'package:bcc5/data/models/lesson_model.dart';

class SafetyLessonRepository {
  static final lessons = <Lesson>[
    Lesson(
      id: "lesson_safe_1.00",
      title: "Packing List and Clothing",
      content: [
        ContentBlock.text(
          "Learn what to pack for a sailing trip, including clothing, gear, and safety essentials.",
        ),
      ],
      keywords: ["packing", "gear", "clothing", "preparation"],
      isPaid: false,
      flashcards: [
        Flashcard(
          id: "flashcard_lesson_safe_1.00",
          title: "FC: Packing List and Clothing",
          sideA: [
            ContentBlock.text(
              "What are essential items to pack for a sailing trip?",
            ),
          ],
          sideB: [
            ContentBlock.text(
              "Clothing layers, waterproof gear, life jackets, and safety essentials.",
            ),
          ],
          isPaid: false,
          showAFirst: true,
        ),
      ],
    ),
    Lesson(
      id: "lesson_safe_2.00",
      title: "Safety Briefing",
      content: [
        ContentBlock.text(
          "Understand basic safety procedures on board, including life jackets, emergency signals, and safety drills.",
        ),
      ],
      keywords: ["safety briefing", "life jackets", "emergency"],
      isPaid: false,
      flashcards: [
        Flashcard(
          id: "flashcard_lesson_safe_2.00",
          title: "FC: Safety Briefing",
          sideA: [
            ContentBlock.text(
              "What is a key topic covered in a safety briefing?",
            ),
          ],
          sideB: [
            ContentBlock.text(
              "Emergency procedures, life jackets, and crew responsibilities.",
            ),
          ],
          isPaid: false,
          showAFirst: true,
        ),
      ],
    ),
    Lesson(
      id: "lesson_safe_3.00",
      title: "Essential Safety Equipment",
      content: [
        ContentBlock.text(
          "Guidance on locating and understanding the use of life jackets, fire extinguishers, and throwable flotation devices to ensure basic onboard safety.",
        ),
      ],
      keywords: ["safety equipment", "life jacket", "fire extinguisher"],
      isPaid: false,
      flashcards: [
        Flashcard(
          id: "flashcard_lesson_safe_3.00",
          title: "FC: Essential Safety Equipment",
          sideA: [
            ContentBlock.text(
              "What is the purpose of a throwable flotation device?",
            ),
          ],
          sideB: [
            ContentBlock.text(
              "To assist a person overboard until they can be rescued.",
            ),
          ],
          isPaid: false,
          showAFirst: true,
        ),
      ],
    ),
    Lesson(
      id: "lesson_safe_4.00",
      title: "Man Overboard Procedure",
      content: [
        ContentBlock.text(
          "IMMEDIATE ACTIONS for MOB. If someone falls overboard, it's important to recover them quickly, especially in cold water.",
        ),
      ],
      keywords: ["man overboard", "MOB", "rescue", "recovery"],
      isPaid: false,
      flashcards: [
        Flashcard(
          id: "flashcard_lesson_safe_4.00",
          title: "FC: Man Overboard Procedure",
          sideA: [
            ContentBlock.text(
              "What should you do immediately if someone falls overboard?",
            ),
          ],
          sideB: [
            ContentBlock.text(
              "Shout 'Man Overboard', throw a flotation device, and maintain visual contact.",
            ),
          ],
          isPaid: false,
          showAFirst: true,
        ),
      ],
    ),
    Lesson(
      id: "lesson_safe_5.00",
      title: "Where to Sit on the Boat",
      content: [
        ContentBlock.text(
          "Sit in designated areas that are free from lines and equipment. Avoid sitting in areas like the bow (front) in rough conditions unless instructed.",
        ),
      ],
      keywords: ["safety", "seating", "safe zones"],
      isPaid: false,
      flashcards: [
        Flashcard(
          id: "flashcard_lesson_safe_5.00",
          title: "FC: Where to Sit on the Boat",
          sideA: [
            ContentBlock.text(
              "Why should you avoid sitting on the bow in rough conditions?",
            ),
          ],
          sideB: [
            ContentBlock.text(
              "The bow can become unstable and increase the risk of falling overboard.",
            ),
          ],
          isPaid: false,
          showAFirst: true,
        ),
      ],
    ),
    Lesson(
      id: "lesson_safe_6.00",
      title: "How to Move Around the Boat Safely",
      content: [
        ContentBlock.text(
          "Always hold onto something (known as 'one hand for the boat'). Move slowly and deliberately, and be aware of swinging sails or lines.",
        ),
      ],
      keywords: ["movement", "handrails", "safety"],
      isPaid: false,
      flashcards: [
        Flashcard(
          id: "flashcard_lesson_safe_6.00",
          title: "FC: How to Move Around the Boat Safely",
          sideA: [ContentBlock.text("What does 'one hand for the boat' mean?")],
          sideB: [
            ContentBlock.text(
              "Always keep one hand holding onto the boat to maintain stability.",
            ),
          ],
          isPaid: false,
          showAFirst: true,
        ),
      ],
    ),
    Lesson(
      id: "lesson_safe_7.00",
      title: "Advanced Safety",
      content: [
        ContentBlock.text(
          "Learn how to stay as safe as possible in various scenarios.",
        ),
      ],
      keywords: ["advanced safety", "safety protocols", "crew safety"],
      isPaid: false,
      flashcards: [
        Flashcard(
          id: "flashcard_lesson_safe_7.00",
          title: "FC: Advanced Safety",
          sideA: [
            ContentBlock.text(
              "What is one of the key aspects of advanced safety?",
            ),
          ],
          sideB: [
            ContentBlock.text(
              "Being prepared for multiple emergency situations and knowing protocols.",
            ),
          ],
          isPaid: false,
          showAFirst: true,
        ),
      ],
    ),
  ];
}
