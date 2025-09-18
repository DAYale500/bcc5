// lib/widgets/settings_modal.dart

import 'package:bcc5/screens/landing_screen/landing_screen.dart';
import 'package:bcc5/utils/logger.dart';
import 'package:bcc5/widgets/emergency_info_modal.dart';
import 'package:bcc5/widgets/tour/landing_screen_tour.dart';
import 'package:flutter/material.dart';
import 'package:bcc5/theme/app_theme.dart';
import 'package:bcc5/utils/resume_manager.dart'; // ✅ Needed for reset
import 'package:bcc5/utils/settings_manager.dart';
import 'package:go_router/go_router.dart';

void showSettingsModal(BuildContext context, String currentRouteName) {
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
                    padding: const EdgeInsets.fromLTRB(16, 24, 16, 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          'Settings',
                          textAlign: TextAlign.center,
                          style: AppTheme.modalTitle.copyWith(
                            fontSize: 24, // slightly larger for this sheet
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 12),
                        const Divider(),
                      ],
                    ),
                  ),

                  const SizedBox(height: 8),

                  // 🚨 Emergency Information (primary action)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: AppTheme.navigationButton,
                        onPressed: () {
                          showEmergencyInfoModal(
                            context,
                            onChanged: () {
                              // no-op; modal manages its own state
                            },
                          );
                        },
                        child: const Text('Emergency Information'),
                      ),
                    ),
                  ),

                  const SizedBox(height: 8),

                  // 🚀 Restart Tour (secondary top action)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: AppTheme.navigationButton,
                        onPressed: () {
                          logger.i(
                            '🧭 SettingsModal tapped — route = $currentRouteName',
                          );
                          Navigator.of(context).pop();
                          WidgetsBinding.instance.addPostFrameCallback((_) {
                            if (currentRouteName == '/' ||
                                currentRouteName == '/landing') {
                              final state = LandingScreen.getState();
                              if (state != null && state.mounted) {
                                LandingScreenTour.restartNow(
                                  landingScreenState: state,
                                  mobKey: state.mobKey,
                                  settingsKey: state.settingsKey,
                                  titleKey: state.titleKey,
                                  searchKey: state.searchKey,
                                  harborKey: state.widget.harborKey,
                                  coursesKey: state.widget.coursesKey,
                                  partsKey: state.widget.partsKey,
                                  toolsKey: state.widget.toolsKey,
                                  drillsKey: state.widget.drillsKey,
                                  newCrewKey: state.widget.newCrewKey,
                                  advancedRefreshersKey:
                                      state.widget.advancedRefreshersKey,
                                );
                              } else {
                                logger.w(
                                  '⚠️ LandingScreen not mounted — cannot restart tour',
                                );
                              }
                            } else {
                              GoRouter.of(
                                context,
                              ).go('/', extra: {'startTour': true});
                            }
                          });
                        },
                        child: const Text('Restart Tour'),
                      ),
                    ),
                  ),

                  const SizedBox(height: 8),

                  // 🧪 DEV Reset Resume Point (third top action)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: SizedBox(
                      width: double.infinity,
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
                  ),

                  const SizedBox(height: 8),

                  // ▼ Scrollable settings list
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: ListView(
                        children: [
                          // Measurement settings
                          _settingDropdown('Units', ['Meters', 'Feet'], 'Feet'),
                          _settingDropdown('Wave Height', [
                            'Feet',
                            'Meters',
                          ], 'Feet'),
                          _settingDropdown('Temperature', [
                            'Fahrenheit',
                            'Celsius',
                          ], 'Fahrenheit'),

                          // GPS Format
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

                          // Dark mode switch
                          _settingSwitch('Dark Mode', false),

                          const SizedBox(height: 12),

                          // Legal & Privacy (left-aligned tile)
                          _settingButton(context, 'Legal & Privacy Docs'),

                          const SizedBox(height: 12),

                          // Close Settings button
                          ElevatedButton(
                            style: AppTheme.navigationButton,
                            onPressed: () => Navigator.of(context).pop(),
                            child: const Text('Close Settings'),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // // 🚀 Restart Tour Button
                  // Padding(
                  //   padding: const EdgeInsets.symmetric(horizontal: 16),
                  //   child: SizedBox(
                  //     width: double.infinity,
                  //     child: ElevatedButton(
                  //       style: AppTheme.navigationButton,
                  //       onPressed: () {
                  //         logger.i(
                  //           '🧭 SettingsModal tapped — route = $currentRouteName',
                  //         );
                  //         Navigator.of(context).pop();
                  //         WidgetsBinding.instance.addPostFrameCallback((_) {
                  //           if (currentRouteName == '/' ||
                  //               currentRouteName == '/landing') {
                  //             final state = LandingScreen.getState();
                  //             if (state != null && state.mounted) {
                  //               LandingScreenTour.restartNow(
                  //                 landingScreenState: state,
                  //                 mobKey: state.mobKey,
                  //                 settingsKey: state.settingsKey,
                  //                 titleKey: state.titleKey,
                  //                 searchKey: state.searchKey,
                  //                 harborKey: state.widget.harborKey,
                  //                 coursesKey: state.widget.coursesKey,
                  //                 partsKey: state.widget.partsKey,
                  //                 toolsKey: state.widget.toolsKey,
                  //                 drillsKey: state.widget.drillsKey,
                  //                 newCrewKey: state.widget.newCrewKey,
                  //                 advancedRefreshersKey:
                  //                     state.widget.advancedRefreshersKey,
                  //               );
                  //             } else {
                  //               logger.w(
                  //                 '⚠️ LandingScreen not mounted — cannot restart tour',
                  //               );
                  //             }
                  //           } else {
                  //             GoRouter.of(
                  //               context,
                  //             ).go('/', extra: {'startTour': true});
                  //           }
                  //         });
                  //       },
                  //       child: const Text('Restart Tour'),
                  //     ),
                  //   ),
                  // ),

                  // const SizedBox(height: 8),
                  // Expanded(
                  //   child: Padding(
                  //     padding: const EdgeInsets.symmetric(horizontal: 16),
                  //     child: ListView(
                  //       children: [
                  //         // // 🚢 Vessel Name display button
                  //         StatefulBuilder(
                  //           builder: (context, setState) {
                  //             return ListTile(
                  //               contentPadding: EdgeInsets.zero,
                  //               title: Text(
                  //                 'Emergency Info',
                  //                 style: AppTheme.textTheme.bodyLarge,
                  //               ),
                  //               trailing: const Icon(Icons.chevron_right),
                  //               onTap: () {
                  //                 showEmergencyInfoModal(
                  //                   context,
                  //                   onChanged: () => setState(() {}),
                  //                 );
                  //               },
                  //             );
                  //           },
                  //         ),
                  //         _settingButton(context, 'Legal & Privacy Docs'),
                  //         _settingDropdown('Units', ['Meters', 'Feet'], 'Feet'),
                  //         _settingDropdown('Wave Height', [
                  //           'Feet',
                  //           'Meters',
                  //         ], 'Feet'),
                  //         _settingDropdown('Temperature', [
                  //           'Fahrenheit',
                  //           'Celsius',
                  //         ], 'Fahrenheit'),

                  //         StatefulBuilder(
                  //           builder: (context, setState) {
                  //             return FutureBuilder<GPSDisplayFormat>(
                  //               future: SettingsManager.getGPSDisplayFormat(),
                  //               builder: (context, snapshot) {
                  //                 final current =
                  //                     snapshot.data ??
                  //                     GPSDisplayFormat.marineCompact;
                  //                 return _settingEnumDropdown(
                  //                   'GPS Format',
                  //                   {
                  //                     'DMM (Marine Style)':
                  //                         GPSDisplayFormat.marineCompact,
                  //                     'DMS (Older Charts)':
                  //                         GPSDisplayFormat.marineFull,
                  //                     'DD (Decimal)': GPSDisplayFormat.decimal,
                  //                   },
                  //                   current,
                  //                   (newFormat) async {
                  //                     await SettingsManager.setGPSDisplayFormat(
                  //                       newFormat,
                  //                     );
                  //                     setState(() {});
                  //                   },
                  //                 );
                  //               },
                  //             );
                  //           },
                  //         ),

                  //         const Divider(height: 24),
                  //         const SizedBox(height: 8),
                  //         const SizedBox(height: 12),

                  //         _settingSwitch('Dark Mode', false),

                  //         // 🧪 DEV Reset Resume Point
                  //         ElevatedButton(
                  //           style: AppTheme.navigationButton,
                  //           onPressed: () async {
                  //             await ResumeManager.clearResumePoint();
                  //             if (!context.mounted) return;
                  //             ScaffoldMessenger.of(context).showSnackBar(
                  //               const SnackBar(
                  //                 content: Text('✅ Resume point cleared'),
                  //               ),
                  //             );
                  //           },
                  //           child: const Text('Reset Resume Point'),
                  //         ),

                  //         const SizedBox(height: 12),
                  //         ElevatedButton(
                  //           style: AppTheme.navigationButton,
                  //           onPressed: () => Navigator.of(context).pop(),
                  //           child: const Text('Close Settings'),
                  //         ),
                  //       ],
                  //     ),
                  //   ),
                  // ),
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
    contentPadding: EdgeInsets.zero, // ⬅️ Add this to left-align text
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
                        style: AppTheme.dialogButtonText,
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
