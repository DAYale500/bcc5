class AppConstants {
  static const List<String> moduleTitles = [
    'Docking',
    'Emergencies',
    'Knots',
    'Navigation',
    'Safety',
    'Seamanship',
    'Systems',
    'Teamwork',
    'Terminology',
  ];

  static const List<String> boatZones = [
    'Deck',
    'Interior',
    'Hull',
    'Rigging',
    'Sails',
  ];

  static const List<String> learningPaths = [
    'Competent Crew',
    'Anchoring Refresher',
    'Side Ties Mastery',
  ];
}

class FilterHelper {
//   /// ✅ Filters items based on a given condition
//   static List<T> filterItems<T>(
//       {required List<T> items, required bool Function(T) filterCondition}

class NavigationHelper {
//   // ------------------------------
//   // Lesson Navigation
//   // ------------------------------

//   static Lesson? getNextLesson(String currentLessonId, {String? moduleId}

class NavigationExtraMap {
  static Map<String, String?> create({
    String? backDestination,
    String? moduleId,
    String? moduleTitle,
    String? pathId,
    String? pathTitle,
    String? zoneId,
    String? zoneTitle,
    String? category,
    String? categoryTitle, // Added parameter for categoryTitle
  }

class WaveCalculator {
  static const double g = 32.2; // Gravity in ft/s²

  static Map<String, dynamic> analyzeWaveState({
    required double approachAngle,
    required double vesselSpeed,
    required double perceivedPeriod,
    required double waveHeight,
    required double windWaveHeight,
    required double waterDepth,
  }

class BackNavigationHelper {
  static Map<String, dynamic> computeBackNavigation({
    required String currentScreen,
    required Map<String, String?> contextInfo,
  }

class AppTheme {
  // ✅ Corrected Color Definitions
  static const Color primaryBlue = Color(0xFF163fe8); // Correct primary blue
  static const Color primaryRed = Color(0xFFFF5252); // Correct primary red
  static const Color background = Color(0xFFF5F5F5); // Background color
  static const Color textPrimary = Color(0xFF212121); // Primary text color
  static const Color textSecondary = Color(0xFF757575); // Secondary text color
  static const Color primaryGreen = Color(0xFF4CAF50);

  static const Color neutralGray =
      Color(0xFFB0BEC5); // Correct unselected BNB color
  static const Color textWhite = Colors.white; // ✅ Define white text color

  // ✅ BottomNavigationBar Colors
  static const Color bottomBarBackground = primaryBlue; // Navy blue background
  static const Color bottomBarSelected = primaryRed; // Red for selected item
  static const Color bottomBarUnselected =
      neutralGray; // Light gray for unselected items

  static const TextStyle headlineStyle = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: textPrimary,
  );

  static const TextStyle bodyStyle = TextStyle(
    fontSize: 18,
    color: textSecondary,
  );
  // ✅ Light Theme Configuration
  static final ThemeData lightTheme = ThemeData(
    colorScheme: ColorScheme.fromSeed(
      seedColor: primaryBlue,
      primary: primaryBlue,
      secondary: primaryRed,
      surface: background,
    ),
    scaffoldBackgroundColor: background,
    primaryColor: primaryBlue,
    textTheme: const TextTheme(
      titleLarge: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: textPrimary,
      ),
      bodyLarge: TextStyle(
        fontSize: 16,
        color: textPrimary,
      ),
      bodyMedium: TextStyle(
        // contentDetailScreen body font size
        fontSize: 34,
        color: textSecondary,
      ),
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: primaryBlue,
      titleTextStyle: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
      iconTheme: IconThemeData(color: Colors.white),
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: bottomBarBackground,
      selectedItemColor: bottomBarSelected,
      unselectedItemColor: bottomBarUnselected,
      selectedIconTheme: IconThemeData(size: 28),
      unselectedIconTheme: IconThemeData(size: 24),
      selectedLabelStyle: TextStyle(fontWeight: FontWeight.bold),
      unselectedLabelStyle: TextStyle(fontWeight: FontWeight.normal),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryRed,
        foregroundColor: Colors.white,
        textStyle: const TextStyle(fontWeight: FontWeight.bold),
      ),
    ),
  );
  static TextStyle get bodyLarge => lightTheme.textTheme.bodyLarge!;
}

class Module {
  final String id;
  final String title;

  Module({
    required this.id,
    required this.title,
  }

class PathItem {
  final String referenceId;
  final PathItemType type;
  final String id;
  final String chapterId;
  final String title;
  final double sequence;

  PathItem({required this.referenceId}

class PathItem {
//   final String referenceId;
//   final PathItemType type;
//   final String id;
//   final String chapterId;
//   final String title;
//   final double sequence;

//   PathItem({required this.referenceId}

class LearningPathChapter {
  final String id;
  final String title;
  final List<PathItem> items;

  LearningPathChapter({
    required this.id,
    required this.title,
    required this.items,
  }

class Lesson {
  final String id;
  final String moduleId;
  final String title;
  final List<dynamic> content; // ✅ Supports text + images
  final List<String> keywords;
  final List<String> partIds;
  final List<Flashcard> flashcards;
  final bool isPaid;

  Lesson({
    required this.id,
    required this.moduleId,
    required this.title,
    required this.content, // ✅ Now supports text + images
    required this.keywords,
    required this.partIds,
    required this.flashcards,
    required this.isPaid,
    required List flashcardIds,
  }

class BoatZone {
  final String id;
  final String title;

  BoatZone({required this.id, required this.title}

class PartContentItem {
  // ✅ New
  final PartContentType type;
  final String data; // For text: the string; for image: the asset path.

  PartContentItem({
    required this.type,
    required this.data,
  }

class BoatPart {
  final String id;
  final String title;
  final String zoneId;
  final List<String> flashcardIds;
  final List<Flashcard> flashcards;
  final List<PartContentItem> content; // ✅ New field for interleaved content

  BoatPart({
    required this.id,
    required this.title,
    required this.zoneId,
    required this.flashcardIds,
    required this.flashcards,
    required this.content, // ✅ Include in constructor
  }

class Flashcard {
  final String id; // Unique identifier
  final String title; // ✅ Add title field
  final String sideA; // First possible side
  final String sideB; // Second possible side
  final List<String> options; // Multiple-choice options (optional)
  final String category; // Module or Zone (e.g., "Navigation" or "Cockpit")
  final String referenceId; // ID of associated lesson or part
  final String type; // "lesson" or "part" to indicate source
  final bool isPaid; // Paid or free content
  final String? preferredFront; // ✅ "A" or "B", otherwise handled in UI

  Flashcard({
    required this.id,
    required this.title, // ✅ Ensure title is required
    required this.sideA,
    required this.sideB,
    this.options = const [],
    required this.category,
    required this.referenceId,
    required this.type,
    required this.isPaid,
    this.preferredFront, // ✅ Optional, determines default first side
  }

class FlashcardCategory {
  final String id;
  final String title;

  FlashcardCategory({required this.id, required this.title}