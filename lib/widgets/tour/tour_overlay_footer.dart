import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TourOverlayFooter extends StatefulWidget {
  final VoidCallback onEnd;

  const TourOverlayFooter({super.key, required this.onEnd});

  @override
  State<TourOverlayFooter> createState() => _TourOverlayFooterState();
}

class _TourOverlayFooterState extends State<TourOverlayFooter> {
  bool _dontShowAgain = false;

  Future<void> _setPreference(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('hasSeenTour', value);
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 24,
      left: 24,
      right: 24,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
        decoration: BoxDecoration(
          color: Colors.black87,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: ElevatedButton(
                onPressed: widget.onEnd, // This calls _tourController.endTour()
                child: const Text('Close Tour'),
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Checkbox(
                  value: _dontShowAgain,
                  onChanged: (value) {
                    if (value != null) {
                      setState(() {
                        _dontShowAgain = value;
                      });
                      _setPreference(value);
                    }
                  },
                ),
                const Expanded(
                  child: Text(
                    "Don't show tour again",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
            const Padding(
              padding: EdgeInsets.only(left: 12.0),
              child: Text(
                "You can change this later in Settings",
                style: TextStyle(color: Colors.white70, fontSize: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
