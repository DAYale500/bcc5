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
          title: "Packing List and Clothing",
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

    // Before You Board
    Lesson(
      id: "lesson_safe_1.11",
      title: "Confirm Before You Go",
      content: [
        ContentBlock.text(
          "Before heading to the dock, confirm the trip details such as meeting time, marina location, parking instructions, and weather forecast. Knowing what to expect ensures you're fully prepared and on time.",
        ),
      ],
      keywords: ["trip details", "meeting point", "forecast", "arrival"],
      isPaid: false,
      flashcards: [
        Flashcard(
          id: "flashcard_lesson_safe_1.11",
          title: "Trip Confirmation",
          sideA: [
            ContentBlock.text(
              "What should you confirm the night before a sail?",
            ),
          ],
          sideB: [
            ContentBlock.text(
              "Time, location, weather, parking, and what to bring.",
            ),
          ],
          isPaid: false,
          showAFirst: true,
        ),
      ],
    ),
    Lesson(
      id: "lesson_safe_1.12",
      title: "Packing Smart for a Day Sail",
      content: [
        ContentBlock.text(
          "Packing thoughtfully helps you stay safe, comfortable, and useful aboard. Include:\n"
          "- A bag that closes (e.g. zippered)\n"
          "- layered, non-cotton clothing\n"
          "- waterproof jacket or coat\n"
          "- sunscreen\n"
          "- food and water\n"
          "- snacks\n"
          "- non-marking deck shoes (sneakers work well)\n"
          "- seasickness remedy\n"
          "- dry bag\n"
          "- personal essentials like medication and sunglasses",
        ),
      ],
      keywords: ["gear", "packing", "bag", "equipment"],
      isPaid: false,
      flashcards: [
        Flashcard(
          id: "flashcard_lesson_safe_1.12",
          title: "Packing List",
          sideA: [
            ContentBlock.text("What are key items to pack for a day sail?"),
          ],
          sideB: [
            ContentBlock.text(
              "Non-cotton clothes, waterproof jacket, sunscreen, water, snacks, deck shoes, seasickness remedy, dry bag.",
            ),
          ],
          isPaid: false,
          showAFirst: true,
        ),
      ],
    ),
    Lesson(
      id: "lesson_safe_1.13",
      title: "Choosing the Right Clothing",
      content: [
        ContentBlock.text(
          "Layering is key on the water. Use synthetic or wool base layers, add insulation for warmth, and finish with waterproof outerwear. Avoid cotton—it stays wet and cold.",
        ),
      ],
      keywords: ["clothing", "layers", "weather", "comfort"],
      isPaid: false,
      flashcards: [
        Flashcard(
          id: "flashcard_lesson_safe_1.13",
          title: "Sailing Clothing",
          sideA: [ContentBlock.text("Why is layering important for sailing?")],
          sideB: [
            ContentBlock.text(
              "Conditions change; layering helps regulate body temp and stay dry.",
            ),
          ],
          isPaid: false,
          showAFirst: true,
        ),
      ],
    ),
    Lesson(
      id: "lesson_safe_1.14",
      title: "Morning Routine Before Sailing",
      content: [
        ContentBlock.text(
          "Start your day with a solid breakfast, hydration, and a final gear check. Avoid rushing by leaving with time to spare and using the bathroom before heading to the dock.",
        ),
      ],
      keywords: ["morning", "routine", "breakfast", "hydration"],
      isPaid: false,
      flashcards: [
        Flashcard(
          id: "flashcard_lesson_safe_1.14",
          title: "Morning Checklist",
          sideA: [
            ContentBlock.text(
              "What should your morning before sailing include?",
            ),
          ],
          sideB: [
            ContentBlock.text(
              "Light breakfast, water, bathroom stop, and final check of gear.",
            ),
          ],
          isPaid: false,
          showAFirst: true,
        ),
      ],
    ),
    Lesson(
      id: "lesson_safe_1.15",
      title: "Understanding Motion Sickness and Prevention",
      content: [
        ContentBlock.text(
          "Motion sickness is a common challenge for new and seasoned sailors alike. It occurs when your inner ear senses movement that your eyes don't see—like the rocking of a boat—which confuses the brain and causes nausea, dizziness, and fatigue. \n\n"
          "Understanding how your body responds at sea is the first step to building your 'sea legs.' Fortunately, there are several simple ways to prevent or reduce symptoms:\n"
          "- Stay on deck and focus on the horizon.\n"
          "- Avoid heavy meals, alcohol, and dehydration.\n"
          "- Try natural remedies like ginger or acupressure bands.\n"
          "- Use over-the-counter medications like Dramamine or Bonine if needed.\n\n"
          "Most importantly, don’t panic—motion sickness usually improves with time, and your body can adapt quickly to life on the water.",
        ),
      ],
      keywords: [
        "motion sickness",
        "nausea",
        "prevention",
        "sea legs",
        "remedies",
        "adaptation",
      ],

      isPaid: false,
      flashcards: [
        Flashcard(
          id: "flashcard_lesson_safe_1.15",
          title: "Motion Sickness and Prevention",
          sideA: [
            ContentBlock.text("What causes motion sickness while sailing?"),
          ],
          sideB: [
            ContentBlock.text(
              "A mismatch between what your eyes see and what your inner ear senses, often triggered by boat motion.",
            ),
          ],
          isPaid: false,
          showAFirst: true,
        ),
        Flashcard(
          id: "flashcard_lesson_safe_1.15_b",
          title: "Motion Sickness Prevention",
          sideA: [
            ContentBlock.text(
              "How can you prevent or reduce motion sickness while sailing?",
            ),
          ],
          sideB: [
            ContentBlock.text(
              "Stay above deck with eyes on the horizon, avoid greasy foods, stay hydrated, and consider remedies like ginger, wristbands, or medication.",
            ),
          ],
          isPaid: false,
          showAFirst: true,
        ),
      ],
    ),
    Lesson(
      id: "lesson_safe_1.16",
      title: "Departure Readiness",
      content: [
        ContentBlock.text(
          "Give yourself extra time, double-check your gear, and know how to reach the boat from the parking area. Calm, unhurried arrivals make for a smoother start to the sail.",
        ),
      ],
      keywords: ["departure", "arrival", "timing", "checklist"],
      isPaid: false,
      flashcards: [
        Flashcard(
          id: "flashcard_lesson_safe_1.16",
          title: "Getting to the Boat",
          sideA: [
            ContentBlock.text("What makes for a smooth departure morning?"),
          ],
          sideB: [
            ContentBlock.text(
              "Leave early, confirm directions, double-check gear, and avoid rushing.",
            ),
          ],
          isPaid: false,
          showAFirst: true,
        ),
      ],
    ),

    // Dockside: Board and Prepare
    Lesson(
      id: "lesson_safe_2.11",
      title: "Find and Approach the Boat",
      content: [
        ContentBlock.text(
          "Arriving at the marina is the first step in joining a sailing trip. Knowing how to safely locate and approach your assigned boat helps set the tone for the day.",
        ),
        ContentBlock.text(
          "• Locate the correct slip or dock using the information provided ahead of time.\n"
          "• If small children are with you, they must wear a life jacket on the dock.\n"
          "• Walk calmly—docks can be slippery and contain tripping hazards.\n"
          "• Observe activity aboard the boat to see whether preparations are underway or if the crew is still gathering.",
        ),
      ],
      keywords: ["arrival", "dock", "slip", "safety", "first steps"],
      isPaid: false,
      flashcards: [
        Flashcard(
          id: "flashcard_lesson_safe_2.11",
          title: "Finding the Boat",
          sideA: [
            ContentBlock.text(
              "What should you do upon arriving at the marina?",
            ),
          ],
          sideB: [
            ContentBlock.text(
              "Locate the assigned slip or dock, walk calmly, and observe what’s happening on the boat.",
            ),
          ],
          isPaid: false,
          showAFirst: true,
        ),
      ],
    ),
    Lesson(
      id: "lesson_safe_2.12",
      title: "Introduce Yourself and Ask to Board",
      content: [
        ContentBlock.text(
          "Proper boarding etiquette keeps you safe and shows respect for the skipper and crew. Always wait to be invited aboard and make a courteous introduction.",
        ),
        ContentBlock.text(
          "• Wait at the dock until invited aboard.\n"
          "• Ask for the safest way to board—there is often a designated step or boarding point.\n"
          "• Pass or place your bag on board before climbing on, keeping hands free.\n"
          "• Introduce yourself to the skipper and crew if you're new.\n"
          "• Ask how you can help—be willing without assuming responsibilities.",
        ),
      ],
      keywords: ["boarding", "etiquette", "crew", "welcome"],
      isPaid: false,
      flashcards: [
        Flashcard(
          id: "flashcard_lesson_safe_2.12",
          title: "Boarding Etiquette",
          sideA: [
            ContentBlock.text("What’s the proper way to board a sailboat?"),
          ],
          sideB: [
            ContentBlock.text(
              "Wait for invitation, ask for the safest method, pass your bag first, and keep hands free while boarding.",
            ),
          ],
          isPaid: false,
          showAFirst: true,
        ),
      ],
    ),
    Lesson(
      id: "lesson_safe_2.13",
      title: "Stow Your Gear",
      content: [
        ContentBlock.text(
          "Where and how you store your belongings aboard a sailboat can impact comfort and safety for the whole crew.",
        ),
        ContentBlock.text(
          "• Ask where to stow your gear—likely inside on a berth.\n"
          "• Avoid blocking key areas like the cockpit or companionway.\n"
          "• Keep water, sunscreen, and hat accessible.\n"
          "• Secure loose items so they don’t move or fall while underway.\n"
          "• Maintain a tidy, organized space for shared comfort and safety.",
        ),
      ],
      keywords: ["gear", "storage", "tidy", "safety"],
      isPaid: false,
      flashcards: [
        Flashcard(
          id: "flashcard_lesson_safe_2.13",
          title: "Stowing Gear",
          sideA: [
            ContentBlock.text(
              "Where should you stow your belongings on a boat?",
            ),
          ],
          sideB: [
            ContentBlock.text(
              "Usually on a berth below deck, away from key walkways like the cockpit or companionway.",
            ),
          ],
          isPaid: false,
          showAFirst: true,
        ),
      ],
    ),
    Lesson(
      id: "lesson_safe_2.14",
      title: "Use the Facilities Early",
      content: [
        ContentBlock.text(
          "Restroom access is more predictable before departure. If using the boat’s head, follow strict etiquette to avoid clogs and discomfort.",
        ),
        ContentBlock.text(
          "• Use shore-based facilities before the boat leaves the dock.\n"
          "• If needed, ask how to use the boat’s head (toilet).\n"
          "• Rule 1: If it didn’t go in your mouth, it doesn’t go in the head.\n"
          "• Rule 2: Everyone sits when using the head.\n"
          "• All other items should go in the trash bag or designated container.",
        ),
      ],
      keywords: ["bathroom", "head", "rules", "comfort"],
      isPaid: false,
      flashcards: [
        Flashcard(
          id: "flashcard_lesson_safe_2.14",
          title: "Boat Head Etiquette",
          sideA: [
            ContentBlock.text(
              "What are the two golden rules for using the head?",
            ),
          ],
          sideB: [
            ContentBlock.text(
              "1: If it didn’t go in your mouth, don’t put it in the head. 2: Everyone sits when using the head.",
            ),
          ],
          isPaid: false,
          showAFirst: true,
        ),
      ],
    ),
    Lesson(
      id: "lesson_safe_2.15",
      title: "Get Oriented to the Boat",
      content: [
        ContentBlock.text(
          "Understanding the layout and terminology of the boat will help you navigate safely and participate more effectively.",
        ),
        ContentBlock.text(
          "• Ask where lifejackets, fire extinguishers, and first aid supplies are stored.\n"
          "• Learn key boat areas: bow, stern, cockpit, galley, and head.\n"
          "• Identify important equipment: lines (ropes), winches, cleats, and fenders.",
        ),
      ],
      keywords: ["orientation", "layout", "equipment", "safety gear"],
      isPaid: false,
      flashcards: [
        Flashcard(
          id: "flashcard_lesson_safe_2.15",
          title: "Boat Layout",
          sideA: [
            ContentBlock.text(
              "What are the main areas of a sailboat you should know?",
            ),
          ],
          sideB: [ContentBlock.text("Bow, stern, cockpit, galley, and head.")],
          isPaid: false,
          showAFirst: true,
        ),
      ],
    ),
    Lesson(
      id: "lesson_safe_2.16",
      title: "Safety Briefing and Expectations",
      content: [
        ContentBlock.text(
          "A safety briefing gives everyone the tools to stay safe and know what to do in an emergency or active maneuver.",
        ),
        ContentBlock.text(
          "• Participate in or request a safety briefing.\n"
          "• Learn where it’s safe to sit or stand.\n"
          "• Understand what to do if someone falls overboard.\n"
          "• Rule: One hand for you, one hand for the boat.\n"
          "• When using the companionway ladder, always face the steps.",
        ),
      ],
      keywords: ["safety", "briefing", "mob", "movement"],
      isPaid: false,
      flashcards: [
        Flashcard(
          id: "flashcard_lesson_safe_2.16",
          title: "Safety Aboard",
          sideA: [ContentBlock.text("What does 'One hand for the boat' mean?")],
          sideB: [
            ContentBlock.text(
              "Always keep one hand holding the boat when moving, to prevent falls.",
            ),
          ],
          isPaid: false,
          showAFirst: true,
        ),
      ],
    ),
    Lesson(
      id: "lesson_safe_2.17",
      title: "Assist with Final Prep",
      content: [
        ContentBlock.text(
          "Helping with final preparations gets you involved, shows initiative, and gets the boat ready to sail.",
        ),
        ContentBlock.text(
          "• Help remove sail covers and protective canvas.\n"
          "• Coil and organize dock lines.\n"
          "• Set or stow fenders as directed.\n"
          "• Walk the deck and secure anything loose.\n"
          "• Listen closely to instructions during the pre-departure checklist.",
        ),
      ],
      keywords: ["preparation", "departure", "fenders", "sails"],
      isPaid: false,
      flashcards: [
        Flashcard(
          id: "flashcard_lesson_safe_2.17",
          title: "Final Boat Prep",
          sideA: [
            ContentBlock.text(
              "What are examples of final prep tasks before departure?",
            ),
          ],
          sideB: [
            ContentBlock.text(
              "Removing sail covers, coiling lines, setting/stowing fenders, securing loose gear.",
            ),
          ],
          isPaid: false,
          showAFirst: true,
        ),
      ],
    ),
    Lesson(
      id: "lesson_safe_2.18",
      title: "Practice Good Communication",
      content: [
        ContentBlock.text(
          "Clear, respectful communication helps the crew operate smoothly and safely, especially during maneuvers.",
        ),
        ContentBlock.text(
          "• Use people’s names and eye contact.\n"
          "• Confirm instructions (‘Got it,’ ‘Ready on port line’).\n"
          "• Ask if something is unclear.\n"
          "• During maneuvers, stay calm and quiet unless spoken to.",
        ),
      ],
      keywords: ["communication", "crew", "manners", "clarity"],
      isPaid: false,
      flashcards: [
        Flashcard(
          id: "flashcard_lesson_safe_2.18",
          title: "Communicating Effectively",
          sideA: [
            ContentBlock.text(
              "What’s an example of clear communication on a sailboat?",
            ),
          ],
          sideB: [
            ContentBlock.text(
              "Using names, confirming instructions like 'Ready on port line,' and asking if unclear.",
            ),
          ],
          isPaid: false,
          showAFirst: true,
        ),
      ],
    ),

    Lesson(
      id: "lesson_safe_2.99",
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
          id: "flashcard_lesson_safe_2.99",
          title: "Safety Briefing",
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
          title: "Essential Safety Equipment",
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
          title: "Man Overboard Procedure",
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
          title: "Where to Sit on the Boat",
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
          title: "How to Move Around the Boat Safely",
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
          title: "Advanced Safety",
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
