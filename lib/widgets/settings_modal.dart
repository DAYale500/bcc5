// lib/widgets/settings_modal.dart

import 'package:bcc5/utils/logger.dart';
import 'package:flutter/material.dart';
import 'package:bcc5/theme/app_theme.dart';
import 'package:bcc5/utils/resume_manager.dart'; // ✅ Needed for reset
import 'package:bcc5/utils/settings_manager.dart';
import 'package:bcc5/utils/radio_helper.dart';
import 'package:shared_preferences/shared_preferences.dart';

void showSettingsModal(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: true,
    builder: (BuildContext context) {
      return Dialog(
        insetPadding: const EdgeInsets.fromLTRB(16, 40, 16, 40),
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SizedBox(
              height: constraints.maxHeight,
              width: constraints.maxWidth,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Settings', style: AppTheme.headingStyle),
                        const SizedBox(height: 12),
                        const Divider(),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: ListView(
                        children: [
                          _settingSwitch('Dark Mode', false),

                          // 📜 Boat Name w/ Phonetic Preview
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Boat Name',
                                  style: AppTheme.textTheme.bodyLarge,
                                ),
                                const SizedBox(height: 4),
                                FutureBuilder<String>(
                                  future: SettingsManager.getBoatName(),
                                  builder: (context, snapshot) {
                                    final controller = TextEditingController(
                                      text: snapshot.data ?? '',
                                    );
                                    return StatefulBuilder(
                                      builder: (context, setModalState) {
                                        return Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            TextField(
                                              controller: controller,
                                              decoration: const InputDecoration(
                                                border: OutlineInputBorder(),
                                                hintText: 'Enter boat name...',
                                              ),
                                              onChanged: (value) async {
                                                await SettingsManager.setBoatName(
                                                  value,
                                                );
                                                setModalState(() {});
                                              },
                                            ),
                                            const SizedBox(height: 6),
                                            Text(
                                              'Phonetic: ${formatPhonetic(controller.text)}',
                                              style: AppTheme
                                                  .textTheme
                                                  .bodySmall!
                                                  .copyWith(
                                                    color: Colors.grey[700],
                                                  ),
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),

                          _settingSwitch('Show Tour Wizard', true),

                          _settingButton(context, 'Legal & Privacy Docs'),
                          _settingDropdown('Units', ['Meters', 'Feet'], 'Feet'),
                          _settingDropdown('Wave Height', [
                            'Feet',
                            'Meters',
                          ], 'Feet'),
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
                                      snapshot.data ??
                                      GPSDisplayFormat.marineCompact;
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
                                      setState(() {});
                                    },
                                  );
                                },
                              );
                            },
                          ),

                          const Divider(height: 24),
                          const SizedBox(height: 8),
                          Text(
                            '🚨 Emergency Info',
                            style: AppTheme.textTheme.titleMedium,
                          ),
                          const SizedBox(height: 4),

                          FutureBuilder<String>(
                            future: SettingsManager.getVesselType(),
                            builder: (context, snapshot) {
                              final current = snapshot.data ?? '';
                              final controller = TextEditingController(
                                text: current,
                              );
                              final options = [
                                'Sailing Vessel',
                                'Motor Vessel',
                                'Catamaran',
                                'Other',
                              ];

                              return Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 4,
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text('Vessel Type'),
                                    const SizedBox(height: 4),
                                    DropdownButtonFormField<String>(
                                      value:
                                          options.contains(current)
                                              ? current
                                              : 'Other',
                                      items:
                                          options
                                              .map(
                                                (type) => DropdownMenuItem(
                                                  value: type,
                                                  child: Text(type),
                                                ),
                                              )
                                              .toList(),
                                      onChanged: (value) {
                                        if (value == 'Other') {
                                          controller.text = '';
                                        } else {
                                          controller.text = value!;
                                          SettingsManager.setVesselType(value);
                                        }
                                      },
                                    ),
                                    const SizedBox(height: 6),
                                    if (controller.text.isEmpty ||
                                        controller.text == 'Other')
                                      TextField(
                                        controller: controller,
                                        decoration: const InputDecoration(
                                          hintText: 'Enter vessel type',
                                          border: OutlineInputBorder(),
                                        ),
                                        onChanged:
                                            (value) =>
                                                SettingsManager.setVesselType(
                                                  value,
                                                ),
                                      ),
                                  ],
                                ),
                              );
                            },
                          ),

                          _settingTextField(
                            label: 'Vessel Length',
                            initialValueFuture:
                                SettingsManager.getVesselLength(),
                            onChanged: SettingsManager.setVesselLength,
                          ),
                          _settingTextField(
                            label:
                                'Vessel Description (e.g., “sail number 56788”)',
                            initialValueFuture:
                                SettingsManager.getVesselDescription(),
                            onChanged: SettingsManager.setVesselDescription,
                          ),
                          _settingIntField(
                            label: 'Souls Onboard (Adults)',
                            initialValueFuture:
                                SettingsManager.getSoulsAdults(),
                            onChanged: SettingsManager.setSoulsAdults,
                          ),
                          _settingIntField(
                            label: 'Souls Onboard (Children)',
                            initialValueFuture:
                                SettingsManager.getSoulsChildren(),
                            onChanged: SettingsManager.setSoulsChildren,
                          ),
                          _settingTextField(
                            label: 'MMSI (optional)',
                            initialValueFuture: SettingsManager.getMMSI(),
                            onChanged: SettingsManager.setMMSI,
                          ),
                          _settingTextField(
                            label: 'Emergency Contact Phone',
                            initialValueFuture:
                                SettingsManager.getEmergencyContact(),
                            onChanged: SettingsManager.setEmergencyContact,
                          ),
                          _settingTextField(
                            label: "Captain's Phone",
                            initialValueFuture:
                                SettingsManager.getCaptainPhone(),
                            onChanged: SettingsManager.setCaptainPhone,
                          ),
                          const SizedBox(height: 12),

                          // 🧪 DEV Reset Resume Point
                          ElevatedButton(
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

                          ListTile(
                            title: const Text('Reset App Tour Progress'),
                            trailing: ElevatedButton(
                              onPressed: () async {
                                final prefs =
                                    await SharedPreferences.getInstance();
                                await prefs.setBool('hasSeenTour', false);
                                logger.i('🔁 Tour reset via settings');
                                if (!context.mounted) return;
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('✅ Tour progress reset'),
                                  ),
                                );
                              },
                              child: const Text('Reset'),
                            ),
                          ),

                          const SizedBox(height: 8),

                          ElevatedButton(
                            style: AppTheme.navigationButton,
                            onPressed: () {
                              Navigator.of(
                                context,
                              ).pop(); // Close Settings Modal first
                              Future.delayed(
                                const Duration(milliseconds: 300),
                                () {
                                  logger.i(
                                    '🚩 Manual tour start from settings',
                                  );
                                  ResumeManager.manualStartTour(); // (We'll define this next)
                                },
                              );
                            },
                            child: const Text('Start App Tour'),
                          ),

                          const SizedBox(height: 12),
                          ElevatedButton(
                            style: AppTheme.navigationButton,
                            onPressed: () => Navigator.of(context).pop(),
                            child: const Text('Close Settings'),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
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
                Padding(
                  padding: EdgeInsets.zero,
                  child: SizedBox(
                    height: 44, // ⬅️ Tight fixed height
                    width: double.infinity,
                    child: TextButton(
                      style: TextButton.styleFrom(
                        backgroundColor: AppTheme.primaryRed,
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.zero,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.zero,
                        ),
                      ),
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text(
                        'Close',
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                ),
              ],
            ),
      );
    },
  );
}

// 🔤 Text field with Future initial value
Widget _settingTextField({
  required String label,
  required Future<String> initialValueFuture,
  required void Function(String) onChanged,
}) {
  return FutureBuilder<String>(
    future: initialValueFuture,
    builder: (context, snapshot) {
      final controller = TextEditingController(text: snapshot.data ?? '');
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: TextField(
          controller: controller,
          decoration: InputDecoration(labelText: label),
          onChanged: onChanged,
        ),
      );
    },
  );
}

// 🔢 Integer-only input field
Widget _settingIntField({
  required String label,
  required Future<int> initialValueFuture,
  required void Function(int) onChanged,
}) {
  return FutureBuilder<int>(
    future: initialValueFuture,
    builder: (context, snapshot) {
      final controller = TextEditingController(
        text: (snapshot.data ?? 0).toString(),
      );
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: TextField(
          controller: controller,
          decoration: InputDecoration(labelText: label),
          keyboardType: TextInputType.number,
          onChanged: (value) {
            final parsed = int.tryParse(value);
            if (parsed != null) onChanged(parsed);
          },
        ),
      );
    },
  );
}
