// 📄 lib/data/repositories/lessons/navigation_lessons_repository.dart

import 'package:bcc5/data/models/content_block.dart';
import 'package:bcc5/data/models/flashcard_model.dart';
import 'package:bcc5/data/models/lesson_model.dart';

class NavigationLessonRepository {
  static final lessons = <Lesson>[
    Lesson(
      id: "lesson_navi_1.00",
      title: "Being a Good Lookout",
      content: [
        ContentBlock.text(
          "Understand the responsibilities of a lookout, including spotting hazards and maintaining awareness.",
        ),
      ],
      keywords: ["navigation", "lookout", "hazards", "awareness"],
      isPaid: false,
      flashcards: [
        Flashcard(
          id: "flashcard_lesson_navi_1.00",
          title: "FC: Being a Good Lookout",
          sideA: [
            ContentBlock.text("What is a key responsibility of a lookout?"),
          ],
          sideB: [
            ContentBlock.text(
              "Spotting hazards and maintaining situational awareness.",
            ),
          ],
          isPaid: false,
          showAFirst: true,
        ),
      ],
    ),
    Lesson(
      id: "lesson_navi_2.00",
      title: "Weather Awareness Basics",
      content: [
        ContentBlock.text(
          "Introduction to basic weather cues, like cloud patterns and wind shifts, which can impact safety and comfort on the water.",
        ),
      ],
      keywords: ["weather awareness", "basic weather cues", "safety"],
      isPaid: false,
      flashcards: [
        Flashcard(
          id: "flashcard_lesson_navi_2.00",
          title: "FC: Weather Awareness Basics",
          sideA: [
            ContentBlock.text("Why is recognizing cloud patterns important?"),
          ],
          sideB: [
            ContentBlock.text(
              "Cloud patterns can indicate changing weather conditions.",
            ),
          ],
          isPaid: false,
          showAFirst: true,
        ),
      ],
    ),
    Lesson(
      id: "lesson_navi_3.00",
      title: "Understanding Weather on the Water",
      content: [
        ContentBlock.text(
          "Weather conditions can change quickly on the water, affecting sailing safety and comfort.",
        ),
      ],
      keywords: ["weather", "navigation", "safety"],
      isPaid: false,
      flashcards: [
        Flashcard(
          id: "flashcard_lesson_navi_3.00",
          title: "FC: Understanding Weather on the Water",
          sideA: [
            ContentBlock.text("What weather conditions can impact sailing?"),
          ],
          sideB: [
            ContentBlock.text(
              "Wind shifts, sudden temperature drops, and cloud formations.",
            ),
          ],
          isPaid: false,
          showAFirst: true,
        ),
      ],
    ),
    Lesson(
      id: "lesson_navi_4.00",
      title: "How to Read Wind Direction",
      content: [
        ContentBlock.text(
          "Reading the wind direction is crucial for effective sailing and anticipating shifts in boat movement.",
        ),
      ],
      keywords: ["wind direction", "sailing", "navigation"],
      isPaid: false,
      flashcards: [
        Flashcard(
          id: "flashcard_lesson_navi_4.00",
          title: "FC: Reading Wind Direction",
          sideA: [
            ContentBlock.text("Why is wind direction important in sailing?"),
          ],
          sideB: [
            ContentBlock.text(
              "It determines how you adjust the sails and steer the boat.",
            ),
          ],
          isPaid: false,
          showAFirst: true,
        ),
      ],
    ),
    Lesson(
      id: "lesson_navi_5.00",
      title: "Advanced Weather Forecasting",
      content: [
        ContentBlock.text(
          "Getting and interpreting GRIB files for detailed weather forecasts, useful for planning long passages.",
        ),
      ],
      keywords: ["weather", "forecast", "GRIB files", "weather patterns"],
      isPaid: false,
      flashcards: [
        Flashcard(
          id: "flashcard_lesson_navi_5.00",
          title: "FC: Advanced Weather Forecasting",
          sideA: [ContentBlock.text("What is a GRIB file used for?")],
          sideB: [
            ContentBlock.text(
              "Providing detailed weather forecast data for sailors.",
            ),
          ],
          isPaid: false,
          showAFirst: true,
        ),
      ],
    ),
    Lesson(
      id: "lesson_navi_6.00",
      title: "Weather Awareness",
      content: [
        ContentBlock.text(
          "Recognize signs of approaching weather changes like cloud formations, temperature drops, and sudden wind shifts.",
        ),
      ],
      keywords: ["weather awareness", "weather changes", "safety"],
      isPaid: false,
      flashcards: [
        Flashcard(
          id: "flashcard_lesson_navi_6.00",
          title: "FC: Weather Awareness",
          sideA: [ContentBlock.text("What are signs of an approaching storm?")],
          sideB: [
            ContentBlock.text(
              "Darkening clouds, dropping temperatures, and increasing wind speed.",
            ),
          ],
          isPaid: false,
          showAFirst: true,
        ),
      ],
    ),
  ];
}
