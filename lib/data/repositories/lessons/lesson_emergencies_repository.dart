// 📄 lib/data/repositories/lessons/lesson_emergencies_repository.dart

import 'package:bcc5/data/models/content_block.dart';
import 'package:bcc5/data/models/lesson_model.dart';
import 'package:bcc5/data/models/flashcard_model.dart';

class EmergenciesLessonRepository {
  static final lessons = <Lesson>[
    Lesson(
      id: 'lesson_emer_1.00',
      title: 'Man Overboard Basics',
      content: [
        ContentBlock.text(
          'Learn how to respond swiftly and safely when someone falls overboard. Every second matters during a man overboard scenario.',
        ),
        ContentBlock.image('assets/images/fallback_image.jpeg'),
        ContentBlock.text(
          'Crew coordination and preparedness are key to a successful recovery. Assigning clear roles reduces panic.',
        ),
        ContentBlock.image('assets/images/fallback_image.jpeg'),
        ContentBlock.text(
          'Practice man overboard drills regularly to ensure readiness under pressure.',
        ),
      ],
      keywords: ['man overboard', 'emergency', 'safety'],
      isPaid: false,
      flashcards: [
        Flashcard(
          id: 'flashcard_lesson_emer_1.00',
          title: 'FC: Man Overboard Basics',
          sideA: [
            ContentBlock.text(
              'What is the first action to take in a man overboard situation?',
            ),
          ],
          sideB: [
            ContentBlock.text(
              'Alert the crew, assign a spotter, and prepare for recovery.',
            ),
          ],
          isPaid: false,
          showAFirst: true,
        ),
      ],
    ),
    Lesson(
      id: 'lesson_emer_2.00',
      title: 'Man Overboard Procedure',
      content: [
        ContentBlock.text(
          'IMMEDIATE ACTIONS for MOB: Alert the crew and assign a spotter.',
        ),
        ContentBlock.image('assets/images/fallback_image.jpeg'),
        ContentBlock.text(
          'Throw a flotation device and maintain visual contact. Circle around carefully.',
        ),
        ContentBlock.image('assets/images/fallback_image.jpeg'),
        ContentBlock.text(
          'Recover the person from the water safely, using equipment if needed.',
        ),
      ],
      keywords: ['man overboard', 'MOB', 'rescue', 'recovery'],
      isPaid: false,
      flashcards: [
        Flashcard(
          id: 'flashcard_lesson_emer_2.00',
          title: 'FC: Man Overboard Procedure',
          sideA: [
            ContentBlock.text(
              'What should the crew do immediately in a man overboard situation?',
            ),
          ],
          sideB: [
            ContentBlock.text(
              'Throw a flotation device, assign a spotter, turn the boat for recovery.',
            ),
          ],
          isPaid: false,
          showAFirst: true,
        ),
      ],
    ),
    Lesson(
      id: 'lesson_emer_3.00',
      title: 'Basic First Aid for Minor Injuries',
      content: [
        ContentBlock.text(
          'Be prepared to treat small injuries like cuts, bruises, or seasickness. A stocked first aid kit is essential.',
        ),
        ContentBlock.image('assets/images/fallback_image.jpeg'),
        ContentBlock.text(
          'Apply antiseptic and bandages promptly to avoid infection. Hydration helps with seasickness.',
        ),
        ContentBlock.image('assets/images/fallback_image.jpeg'),
        ContentBlock.text(
          'Keep first aid supplies accessible and review their use before setting sail.',
        ),
      ],
      keywords: ['first aid', 'injury', 'safety'],
      isPaid: false,
      flashcards: [
        Flashcard(
          id: 'flashcard_lesson_emer_3.00',
          title: 'FC: Basic First Aid',
          sideA: [
            ContentBlock.text('What are common minor injuries on a sailboat?'),
          ],
          sideB: [
            ContentBlock.text('Small cuts, bruises, seasickness, sunburns.'),
          ],
          isPaid: false,
          showAFirst: true,
        ),
      ],
    ),
    Lesson(
      id: 'lesson_emer_4.00',
      title: 'Safety Equipment',
      content: [
        ContentBlock.text(
          'Know where all safety equipment is located on board. Time is critical in an emergency.',
        ),
        ContentBlock.image('assets/images/fallback_image.jpeg'),
        ContentBlock.text(
          'Familiarize yourself with how to use life jackets, fire extinguishers, and radios.',
        ),
        ContentBlock.image('assets/images/fallback_image.jpeg'),
        ContentBlock.text(
          'Conduct safety walkthroughs at the beginning of each trip.',
        ),
      ],
      keywords: ['PFD', 'life sling', 'radio', 'fire extinguisher'],
      isPaid: false,
      flashcards: [
        Flashcard(
          id: 'flashcard_lesson_emer_4.00',
          title: 'FC: Safety Equipment',
          sideA: [
            ContentBlock.text(
              'What are essential pieces of safety equipment on a sailboat?',
            ),
          ],
          sideB: [
            ContentBlock.text(
              'Life jackets, throwable flotation devices, VHF radio, fire extinguisher.',
            ),
          ],
          isPaid: false,
          showAFirst: true,
        ),
      ],
    ),
    Lesson(
      id: 'lesson_emer_5.00',
      title: 'Advanced Safety',
      content: [
        ContentBlock.text(
          'Advanced safety techniques include using tethers and storm preparations.',
        ),
        ContentBlock.image('assets/images/fallback_image.jpeg'),
        ContentBlock.text(
          'Be proactive: identify risks early and communicate with the crew.',
        ),
        ContentBlock.image('assets/images/fallback_image.jpeg'),
        ContentBlock.text(
          'Participate in training for emergency signaling and abandon-ship scenarios.',
        ),
      ],
      keywords: ['advanced safety', 'safety protocols', 'crew safety'],
      isPaid: false,
      flashcards: [
        Flashcard(
          id: 'flashcard_lesson_emer_5.00',
          title: 'FC: Advanced Safety',
          sideA: [
            ContentBlock.text(
              'What are advanced safety measures every sailor should know?',
            ),
          ],
          sideB: [
            ContentBlock.text(
              'Tether use, emergency signaling, handling extreme weather.',
            ),
          ],
          isPaid: false,
          showAFirst: true,
        ),
      ],
    ),
    Lesson(
      id: 'lesson_emer_6.00',
      title: 'Advanced Emergency Procedures',
      content: [
        ContentBlock.text(
          'Emergencies require calm thinking, clear communication, and quick action.',
        ),
        ContentBlock.image('assets/images/fallback_image.jpeg'),
        ContentBlock.text(
          'Understand your emergency plan and assign roles in advance.',
        ),
        ContentBlock.image('assets/images/fallback_image.jpeg'),
        ContentBlock.text(
          'Practice drills to stay sharp and reduce panic in real scenarios.',
        ),
      ],
      keywords: ['emergency procedures', 'response', 'emergency response'],
      isPaid: false,
      flashcards: [
        Flashcard(
          id: 'flashcard_lesson_emer_6.00',
          title: 'FC: Advanced Emergency Procedures',
          sideA: [
            ContentBlock.text(
              'What are the steps to follow during a boat emergency?',
            ),
          ],
          sideB: [
            ContentBlock.text(
              'Assess the situation, communicate clearly, follow emergency protocols.',
            ),
          ],
          isPaid: false,
          showAFirst: true,
        ),
      ],
    ),
  ];
}
