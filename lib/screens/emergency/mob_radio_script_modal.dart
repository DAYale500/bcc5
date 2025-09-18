import 'package:flutter/material.dart';
import 'package:bcc5/theme/app_theme.dart';
import 'package:bcc5/utils/vessel_formatting.dart';

class MOBRadioScriptModal extends StatelessWidget {
  final String boatName;
  final String vesselType;
  final String gpsSpoken;
  final String description;
  final String mmsi;

  const MOBRadioScriptModal({
    super.key,
    required this.boatName,
    required this.vesselType,
    required this.gpsSpoken,
    required this.description,
    required this.mmsi,
  });

  @override
  Widget build(BuildContext context) {
    final gpsLines = gpsSpoken.split('\n');
    final prefix = getVesselPrefix(vesselType);
    final phonetic = formatPhonetic(boatName);

    return AlertDialog(
      title: const Text('Report MAYDAY to the Coast Guard: '),
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Ensure radio is on channel 16, press and hold the microphone transmit button while speaking slowly and clearly the following:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            // 🔊 Step-by-step script
            SelectableText(
              '1. Mayday, Mayday, Mayday.\n\n'
              '2. $prefix $boatName\n   Phonetic: $phonetic\n\n'
              '3. We have a man overboard at position:\n'
              '  • ${gpsLines[0]}\n'
              '  • ${gpsLines[1]}\n\n'
              '4. We are located near [SAY HELPFUL NEARBY LANDMARK IF YOU CAN], 📍e.g., ‘In the north bay, two miles east of Pelican Rock.’\n\n'
              '5. $description\n\n'
              '6. We have four adults and one child onboard, all wearing life jackets.\n\n'
              '7. We need immediate assistance recovering the person in the water.\n\n'
              '8. Over. (LET GO of the microphone button)\n\n'
              '9. Wait for a response from the Coast Guard. If no response, repeat the message.',
              style: AppTheme.textTheme.bodyMedium,
            ),

            const SizedBox(height: 24),
            const Divider(thickness: 10), // separation line
            const SizedBox(height: 12),

            // 📌 Optional Details Section
            const Text(
              'Optional Follow-Up Details',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'You may offer and/or the Coast Guard may ask you about any other relevant details, such as :',
            ),
            const SizedBox(height: 6),
            const Text('- Any injuries onboard.'),
            const Text('- If any flares were fired.'),
            if (mmsi.trim().isNotEmpty) Text('- Your MMSI: ${mmsi.trim()}'),
            const Text(
              '- Typically, they will want to call you if there is cell service. Be prepared to provide your cell phone number. Remember to slowly and clearly.',
            ),
          ],
        ),
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.only(top: 12),
          child: SizedBox(
            height: 44,
            width: double.infinity,
            child: TextButton(
              style: TextButton.styleFrom(
                backgroundColor: AppTheme.primaryRed,
                foregroundColor: Colors.white,
                shape: const RoundedRectangleBorder(),
                padding: EdgeInsets.zero,
              ),
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Close', style: TextStyle(fontSize: 16)),
            ),
          ),
        ),
      ],
    );
  }
}
