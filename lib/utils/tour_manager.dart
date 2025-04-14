// class TourManager {
//   static const _hasSeenLandingTourKey = 'hasSeenLandingTour';

//   static Future<bool> hasSeenLandingTour() async {
//     final prefs = await SharedPreferences.getInstance();
//     return prefs.getBool(_hasSeenLandingTourKey) ?? false;
//   }

//   static Future<void> markLandingTourSeen() async {
//     final prefs = await SharedPreferences.getInstance();
//     await prefs.setBool(_hasSeenLandingTourKey, true);
//   }

//   static Future<void> resetLandingTour() async {
//     final prefs = await SharedPreferences.getInstance();
//     await prefs.remove(_hasSeenLandingTourKey);
//   }
// }
