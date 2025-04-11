// lib/widgets/settings_modal.dart

import 'package:flutter/material.dart';
import 'package:bcc5/theme/app_theme.dart';
import 'package:bcc5/utils/resume_manager.dart'; // ✅ Needed for reset
import 'package:bcc5/utils/settings_manager.dart';

void showSettingsModal(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: true,
    builder: (BuildContext context) {
      return Dialog(
        insetPadding: const EdgeInsets.fromLTRB(16, 80, 16, 80),
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Text('Settings', style: AppTheme.headingStyle),
              const SizedBox(height: 12),
              const Divider(),

              // 📜 Scrollable List of Settings
              Expanded(
                child: ListView(
                  children: [
                    _settingSwitch('Dark Mode', false),
                    _settingSwitch('Show Tour Wizard', true),
                    // 🧪 DEV: Reset Resume Point Button
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: ElevatedButton(
                        style: AppTheme.navigationButton,
                        onPressed: () async {
                          await ResumeManager.clearResumePoint();
                          if (!context.mounted) return;
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('✅ Resume point cleared'),
                            ),
                          );
                        },

                        child: const Text('Reset Resume Point'),
                      ),
                    ),

                    _settingSwitch('Enable Paid Content', false),
                    _settingButton(context, 'Legal & Privacy Docs'),
                    _settingDropdown('Units', ['Meters', 'Feet'], 'Feet'),
                    _settingDropdown('Wave Height', ['Feet', 'Meters'], 'Feet'),
                    _settingDropdown('Temperature', [
                      'Fahrenheit',
                      'Celsius',
                    ], 'Fahrenheit'),

                    StatefulBuilder(
                      builder: (context, setState) {
                        return FutureBuilder<GPSDisplayFormat>(
                          future: SettingsManager.getGPSDisplayFormat(),
                          builder: (context, snapshot) {
                            final current =
                                snapshot.data ?? GPSDisplayFormat.marineCompact;

                            return _settingEnumDropdown(
                              'GPS Format',
                              {
                                'DMM (Marine Style)':
                                    GPSDisplayFormat.marineCompact,
                                'DMS (Older Charts)':
                                    GPSDisplayFormat.marineFull,
                                'DD (Decimal)': GPSDisplayFormat.decimal,
                              },
                              current,
                              (newFormat) async {
                                await SettingsManager.setGPSDisplayFormat(
                                  newFormat,
                                );
                                setState(
                                  () {},
                                ); // ⬅️ Rebuilds the dropdown with updated value
                              },
                            );
                          },
                        );
                      },
                    ),

                    // Additional dummy settings
                    _settingSwitch('Enable Sound Effects', true),
                    _settingSwitch('Auto-Download Lessons', false),
                    _settingSwitch('Offline Mode', false),
                    _settingSwitch('Sync Across Devices', true),
                    _settingSwitch('Show Hints During Navigation', true),
                    _settingDropdown('Language', [
                      'English',
                      'Spanish',
                      'French',
                    ], 'English'),
                    _settingSwitch('Enable Animations', true),
                    _settingSwitch('Beta Features', false),
                  ],
                ),
              ),

              const Divider(height: 24),
              ElevatedButton(
                style: AppTheme.navigationButton,
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Close Settings'),
              ),
            ],
          ),
        ),
      );
    },
  );
}

// 🔘 Switch Row
Widget _settingSwitch(String label, bool value) {
  return SwitchListTile(
    title: Text(label, style: AppTheme.textTheme.bodyLarge),
    value: value,
    onChanged: (_) {},
    contentPadding: const EdgeInsets.symmetric(horizontal: 0),
  );
}

// 📂 Dropdown Selector
// 📂 Static Dropdown for legacy settings (read-only)
Widget _settingDropdown(String label, List<String> options, String selected) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 4),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: AppTheme.textTheme.bodyLarge),
        DropdownButton<String>(
          value: selected,
          items:
              options
                  .map((o) => DropdownMenuItem(value: o, child: Text(o)))
                  .toList(),
          onChanged: (_) {},
        ),
      ],
    ),
  );
}

// 🧭 Dynamic Enum Dropdown
Widget _settingEnumDropdown<T>(
  String label,
  Map<String, T> options,
  T selected,
  void Function(T) onChanged,
) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 4),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: AppTheme.textTheme.bodyLarge),
        DropdownButton<T>(
          value: selected,
          items:
              options.entries
                  .map(
                    (e) =>
                        DropdownMenuItem<T>(value: e.value, child: Text(e.key)),
                  )
                  .toList(),
          onChanged: (val) {
            if (val != null) onChanged(val);
          },
        ),
      ],
    ),
  );
}

// 📄 Legal Docs Button
Widget _settingButton(BuildContext context, String label) {
  return ListTile(
    title: Text(label, style: AppTheme.textTheme.bodyLarge),
    trailing: const Icon(Icons.chevron_right),
    onTap: () {
      showDialog(
        context: context,
        builder:
            (_) => AlertDialog(
              title: const Text('Legal & Privacy Documents'),
              content: const Text('This would display legal info...'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Close'),
                ),
              ],
            ),
      );
    },
  );
}
