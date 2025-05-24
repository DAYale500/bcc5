import 'package:bcc5/utils/radio_helper.dart';
import 'package:flutter/material.dart';
import 'package:bcc5/theme/app_theme.dart';
import 'package:bcc5/utils/settings_manager.dart';
import 'package:bcc5/widgets/setting_input_fields.dart';

void showEmergencyInfoModal(BuildContext context) {
  showDialog(
    context: context,
    builder:
        (_) => AlertDialog(
          title: const Text('🚨 Emergency Info'),
          content: SizedBox(
            width: double.maxFinite,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 🔤 Boat Name Field (now first)
                  settingTextField(
                    label: 'Boat Name',
                    initialValueFuture: SettingsManager.getBoatName(),
                    onChanged: SettingsManager.setBoatName,
                  ),

                  // 🔡 Phonetic preview (below name field)
                  FutureBuilder<String>(
                    future: SettingsManager.getBoatName(),
                    builder: (context, snapshot) {
                      final name = snapshot.data ?? '';
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Text(
                          'Phonetic: ${formatPhonetic(name)}',
                          style: AppTheme.phoneticStyle,
                        ),
                      );
                    },
                  ),

                  // 🚢 Vessel Type Dropdown
                  FutureBuilder<String>(
                    future: SettingsManager.getVesselType(),
                    builder: (context, snapshot) {
                      final raw = snapshot.data;
                      final current =
                          (raw == null || raw == 'Other') ? 'Sailing' : raw;
                      final controller = TextEditingController(text: current);
                      final options = [
                        'Sailing',
                        'Motor',
                        'Catamaran',
                        'Other',
                      ];
                      return StatefulBuilder(
                        builder: (context, setState) {
                          return Column(
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
                                  setState(() {});
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
                                          SettingsManager.setVesselType(value),
                                ),
                            ],
                          );
                        },
                      );
                    },
                  ),

                  // 📏 Vessel Length
                  settingTextField(
                    label: 'Vessel Length',
                    initialValueFuture: SettingsManager.getVesselLength(),
                    onChanged: SettingsManager.setVesselLength,
                  ),

                  // 📋 Description
                  settingTextField(
                    label: 'Vessel Description (e.g., “sail number 56788”)',
                    initialValueFuture: SettingsManager.getVesselDescription(),
                    onChanged: SettingsManager.setVesselDescription,
                  ),

                  // 🧍 Adults & Children
                  settingIntField(
                    label: 'Souls Onboard (Adults)',
                    initialValueFuture: SettingsManager.getSoulsAdults(),
                    onChanged: SettingsManager.setSoulsAdults,
                  ),
                  settingIntField(
                    label: 'Souls Onboard (Children)',
                    initialValueFuture: SettingsManager.getSoulsChildren(),
                    onChanged: SettingsManager.setSoulsChildren,
                  ),

                  // 📞 Contacts
                  settingTextField(
                    label: 'MMSI (optional)',
                    initialValueFuture: SettingsManager.getMMSI(),
                    onChanged: SettingsManager.setMMSI,
                  ),
                  settingTextField(
                    label: 'Emergency Contact Phone',
                    initialValueFuture: SettingsManager.getEmergencyContact(),
                    onChanged: SettingsManager.setEmergencyContact,
                  ),
                  settingTextField(
                    label: "Captain's Phone",
                    initialValueFuture: SettingsManager.getCaptainPhone(),
                    onChanged: SettingsManager.setCaptainPhone,
                  ),

                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
          actions: [
            Padding(
              padding: EdgeInsets.zero,
              child: SizedBox(
                height: 44,
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
                  child: const Text('Close', style: AppTheme.dialogButtonText),
                ),
              ),
            ),
          ],
        ),
  );
}

// import 'package:bcc5/utils/radio_helper.dart';
// import 'package:flutter/material.dart';
// import 'package:bcc5/theme/app_theme.dart';
// import 'package:bcc5/utils/settings_manager.dart';
// import 'package:bcc5/widgets/setting_input_fields.dart';

// void showEmergencyInfoModal(BuildContext context) {
//   showDialog(
//     context: context,
//     builder:
//         (_) => AlertDialog(
//           title: const Text('🚨 Emergency Info'),
//           content: SizedBox(
//             width: double.maxFinite,
//             child: SingleChildScrollView(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   // 🚤 Combined Boat Name + Type with phonetic preview
//                   FutureBuilder<String>(
//                     future: SettingsManager.getBoatName(),
//                     builder: (context, boatSnap) {
//                       final boatName = boatSnap.data ?? '';
//                       return FutureBuilder<String>(
//                         future: SettingsManager.getVesselType(),
//                         builder: (context, typeSnap) {
//                           final vesselType = typeSnap.data ?? 'Sailing';
//                           final prefix =
//                               vesselType == 'Motor'
//                                   ? 'M/V'
//                                   : vesselType == 'Sailing'
//                                   ? 'S/V'
//                                   : '';
//                           final display =
//                               prefix.isNotEmpty
//                                   ? '$prefix $boatName'
//                                   : boatName;
//                           return Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Text(
//                                 'Boat Name + Type',
//                                 style: AppTheme.sectionTitle,
//                               ),
//                               Padding(
//                                 padding: const EdgeInsets.only(bottom: 8),
//                                 child: Text(
//                                   display,
//                                   style: AppTheme.textTheme.bodyLarge,
//                                 ),
//                               ),
//                               Padding(
//                                 padding: const EdgeInsets.only(bottom: 8),
//                                 child: Text(
//                                   'Phonetic: ${formatPhonetic(display)}',
//                                   style: AppTheme.phoneticStyle,
//                                 ),
//                               ),
//                             ],
//                           );
//                         },
//                       );
//                     },
//                   ),

//                   settingTextField(
//                     label: 'Boat Name',
//                     initialValueFuture: SettingsManager.getBoatName(),
//                     onChanged: SettingsManager.setBoatName,
//                   ),

//                   // ⛵ Vessel Type Picker with "Other" option
//                   FutureBuilder<String>(
//                     future: SettingsManager.getVesselType(),
//                     builder: (context, snapshot) {
//                       final raw = snapshot.data;
//                       final current =
//                           (raw == null || raw == 'Other') ? 'Sailing' : raw;
//                       final controller = TextEditingController(text: current);
//                       final options = [
//                         'Sailing',
//                         'Motor',
//                         'Catamaran',
//                         'Other',
//                       ];
//                       return StatefulBuilder(
//                         builder: (context, setState) {
//                           return Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               const Text('Vessel Type'),
//                               const SizedBox(height: 4),
//                               DropdownButtonFormField<String>(
//                                 value:
//                                     options.contains(current)
//                                         ? current
//                                         : 'Other',
//                                 items:
//                                     options
//                                         .map(
//                                           (type) => DropdownMenuItem(
//                                             value: type,
//                                             child: Text(type),
//                                           ),
//                                         )
//                                         .toList(),
//                                 onChanged: (value) {
//                                   if (value == 'Other') {
//                                     controller.text = '';
//                                   } else {
//                                     controller.text = value!;
//                                     SettingsManager.setVesselType(value);
//                                   }
//                                   setState(() {});
//                                 },
//                               ),
//                               const SizedBox(height: 6),
//                               if (controller.text.isEmpty ||
//                                   controller.text == 'Other')
//                                 TextField(
//                                   controller: controller,
//                                   decoration: const InputDecoration(
//                                     hintText: 'Enter vessel type',
//                                     border: OutlineInputBorder(),
//                                   ),
//                                   onChanged:
//                                       (value) =>
//                                           SettingsManager.setVesselType(value),
//                                 ),
//                             ],
//                           );
//                         },
//                       );
//                     },
//                   ),

//                   settingTextField(
//                     label: 'Vessel Length',
//                     initialValueFuture: SettingsManager.getVesselLength(),
//                     onChanged: SettingsManager.setVesselLength,
//                   ),
//                   settingTextField(
//                     label: 'Vessel Description (e.g., “sail number 56788”)',
//                     initialValueFuture: SettingsManager.getVesselDescription(),
//                     onChanged: SettingsManager.setVesselDescription,
//                   ),
//                   settingIntField(
//                     label: 'Souls Onboard (Adults)',
//                     initialValueFuture: SettingsManager.getSoulsAdults(),
//                     onChanged: SettingsManager.setSoulsAdults,
//                   ),
//                   settingIntField(
//                     label: 'Souls Onboard (Children)',
//                     initialValueFuture: SettingsManager.getSoulsChildren(),
//                     onChanged: SettingsManager.setSoulsChildren,
//                   ),
//                   settingTextField(
//                     label: 'MMSI (optional)',
//                     initialValueFuture: SettingsManager.getMMSI(),
//                     onChanged: SettingsManager.setMMSI,
//                   ),
//                   settingTextField(
//                     label: 'Emergency Contact Phone',
//                     initialValueFuture: SettingsManager.getEmergencyContact(),
//                     onChanged: SettingsManager.setEmergencyContact,
//                   ),
//                   settingTextField(
//                     label: "Captain's Phone",
//                     initialValueFuture: SettingsManager.getCaptainPhone(),
//                     onChanged: SettingsManager.setCaptainPhone,
//                   ),
//                   const SizedBox(height: 16),
//                 ],
//               ),
//             ),
//           ),
//           actions: [
//             Padding(
//               padding: EdgeInsets.zero,
//               child: SizedBox(
//                 height: 44,
//                 width: double.infinity,
//                 child: TextButton(
//                   style: TextButton.styleFrom(
//                     backgroundColor: AppTheme.primaryRed,
//                     foregroundColor: Colors.white,
//                     padding: EdgeInsets.zero,
//                     shape: const RoundedRectangleBorder(
//                       borderRadius: BorderRadius.zero,
//                     ),
//                   ),
//                   onPressed: () => Navigator.of(context).pop(),
//                   child: const Text('Close', style: AppTheme.dialogButtonText),
//                 ),
//               ),
//             ),
//           ],
//         ),
//   );
// }

// // import 'package:bcc5/utils/radio_helper.dart';
// // import 'package:flutter/material.dart';
// // import 'package:bcc5/theme/app_theme.dart';
// // import 'package:bcc5/utils/settings_manager.dart';
// // import 'package:bcc5/widgets/setting_input_fields.dart';

// // void showEmergencyInfoModal(BuildContext context) {
// //   showDialog(
// //     context: context,
// //     builder:
// //         (_) => AlertDialog(
// //           title: const Text('🚨 Emergency Info'),
// //           content: SizedBox(
// //             width: double.maxFinite,
// //             child: SingleChildScrollView(
// //               child: Column(
// //                 crossAxisAlignment: CrossAxisAlignment.start,
// //                 children: [
// //                   settingTextField(
// //                     label: 'Boat Name',
// //                     initialValueFuture: SettingsManager.getBoatName(),
// //                     onChanged: SettingsManager.setBoatName,
// //                   ),
// //                   FutureBuilder<String>(
// //                     future: SettingsManager.getBoatName(),
// //                     builder: (context, snapshot) {
// //                       final name = snapshot.data ?? '';
// //                       return Padding(
// //                         padding: const EdgeInsets.only(bottom: 8),
// //                         child: Text(
// //                           'Phonetic: ${formatPhonetic(name)}',
// //                           style: AppTheme.phoneticStyle,
// //                         ),
// //                       );
// //                     },
// //                   ),
// //                   FutureBuilder<String>(
// //                     future: SettingsManager.getVesselType(),
// //                     builder: (context, snapshot) {
// //                       final current = snapshot.data ?? 'Sailing';
// //                       final controller = TextEditingController(text: current);
// //                       final options = [
// //                         'Sailing',
// //                         'Motor',
// //                         'Catamaran',
// //                         'Other',
// //                       ];
// //                       return StatefulBuilder(
// //                         builder: (context, setState) {
// //                           return Column(
// //                             crossAxisAlignment: CrossAxisAlignment.start,
// //                             children: [
// //                               const Text('Vessel Type'),
// //                               const SizedBox(height: 4),
// //                               DropdownButtonFormField<String>(
// //                                 value:
// //                                     options.contains(current)
// //                                         ? current
// //                                         : 'Other',
// //                                 items:
// //                                     options
// //                                         .map(
// //                                           (type) => DropdownMenuItem(
// //                                             value: type,
// //                                             child: Text(type),
// //                                           ),
// //                                         )
// //                                         .toList(),
// //                                 onChanged: (value) {
// //                                   if (value == 'Other') {
// //                                     controller.text = '';
// //                                   } else {
// //                                     controller.text = value!;
// //                                     SettingsManager.setVesselType(value);
// //                                   }
// //                                   setState(() {});
// //                                 },
// //                               ),
// //                               const SizedBox(height: 6),
// //                               if (controller.text.isEmpty ||
// //                                   controller.text == 'Other')
// //                                 TextField(
// //                                   controller: controller,
// //                                   decoration: const InputDecoration(
// //                                     hintText: 'Enter vessel type',
// //                                     border: OutlineInputBorder(),
// //                                   ),
// //                                   onChanged:
// //                                       (value) =>
// //                                           SettingsManager.setVesselType(value),
// //                                 ),
// //                             ],
// //                           );
// //                         },
// //                       );
// //                     },
// //                   ),
// //                   settingTextField(
// //                     label: 'Vessel Length',
// //                     initialValueFuture: SettingsManager.getVesselLength(),
// //                     onChanged: SettingsManager.setVesselLength,
// //                   ),
// //                   settingTextField(
// //                     label: 'Vessel Description (e.g., “sail number 56788”)',
// //                     initialValueFuture: SettingsManager.getVesselDescription(),
// //                     onChanged: SettingsManager.setVesselDescription,
// //                   ),
// //                   settingIntField(
// //                     label: 'Souls Onboard (Adults)',
// //                     initialValueFuture: SettingsManager.getSoulsAdults(),
// //                     onChanged: SettingsManager.setSoulsAdults,
// //                   ),
// //                   settingIntField(
// //                     label: 'Souls Onboard (Children)',
// //                     initialValueFuture: SettingsManager.getSoulsChildren(),
// //                     onChanged: SettingsManager.setSoulsChildren,
// //                   ),
// //                   settingTextField(
// //                     label: 'MMSI (optional)',
// //                     initialValueFuture: SettingsManager.getMMSI(),
// //                     onChanged: SettingsManager.setMMSI,
// //                   ),
// //                   settingTextField(
// //                     label: 'Emergency Contact Phone',
// //                     initialValueFuture: SettingsManager.getEmergencyContact(),
// //                     onChanged: SettingsManager.setEmergencyContact,
// //                   ),
// //                   settingTextField(
// //                     label: "Captain's Phone",
// //                     initialValueFuture: SettingsManager.getCaptainPhone(),
// //                     onChanged: SettingsManager.setCaptainPhone,
// //                   ),
// //                   const SizedBox(height: 16),
// //                 ],
// //               ),
// //             ),
// //           ),
// //           actions: [
// //             Padding(
// //               padding: EdgeInsets.zero,
// //               child: SizedBox(
// //                 height: 44,
// //                 width: double.infinity,
// //                 child: TextButton(
// //                   style: TextButton.styleFrom(
// //                     backgroundColor: AppTheme.primaryRed,
// //                     foregroundColor: Colors.white,
// //                     padding: EdgeInsets.zero,
// //                     shape: const RoundedRectangleBorder(
// //                       borderRadius: BorderRadius.zero,
// //                     ),
// //                   ),
// //                   onPressed: () => Navigator.of(context).pop(),
// //                   child: const Text('Close', style: AppTheme.dialogButtonText),
// //                 ),
// //               ),
// //             ),
// //           ],
// //         ),
// //   );
// // }

// // // import 'package:bcc5/utils/radio_helper.dart';
// // // import 'package:flutter/material.dart';
// // // import 'package:bcc5/theme/app_theme.dart';
// // // import 'package:bcc5/utils/settings_manager.dart';
// // // import 'package:bcc5/widgets/setting_input_fields.dart';

// // // void showEmergencyInfoModal(BuildContext context) {
// // //   showDialog(
// // //     context: context,
// // //     builder:
// // //         (_) => AlertDialog(
// // //           title: const Text('🚨 Emergency Info'),
// // //           content: SizedBox(
// // //             width: double.maxFinite,
// // //             child: SingleChildScrollView(
// // //               child: Column(
// // //                 crossAxisAlignment: CrossAxisAlignment.start,
// // //                 children: [
// // //                   settingTextField(
// // //                     label: 'Boat Name',
// // //                     initialValueFuture: SettingsManager.getBoatName(),
// // //                     onChanged: SettingsManager.setBoatName,
// // //                   ),
// // //                   FutureBuilder<String>(
// // //                     future: SettingsManager.getBoatName(),
// // //                     builder: (context, snapshot) {
// // //                       final name = snapshot.data ?? '';
// // //                       return Padding(
// // //                         padding: const EdgeInsets.only(bottom: 8),
// // //                         child: Text(
// // //                           'Phonetic: ${formatPhonetic(name)}',
// // //                           style: AppTheme.phoneticStyle,
// // //                         ),
// // //                       );
// // //                     },
// // //                   ),

// // //                   settingTextField(
// // //                     label: 'Vessel Type',
// // //                     initialValueFuture: SettingsManager.getVesselType(),
// // //                     onChanged: SettingsManager.setVesselType,
// // //                   ),
// // //                   settingTextField(
// // //                     label: 'Vessel Length',
// // //                     initialValueFuture: SettingsManager.getVesselLength(),
// // //                     onChanged: SettingsManager.setVesselLength,
// // //                   ),
// // //                   settingTextField(
// // //                     label: 'Vessel Description (e.g., “sail number 56788”)',
// // //                     initialValueFuture: SettingsManager.getVesselDescription(),
// // //                     onChanged: SettingsManager.setVesselDescription,
// // //                   ),
// // //                   settingIntField(
// // //                     label: 'Souls Onboard (Adults)',
// // //                     initialValueFuture: SettingsManager.getSoulsAdults(),
// // //                     onChanged: SettingsManager.setSoulsAdults,
// // //                   ),
// // //                   settingIntField(
// // //                     label: 'Souls Onboard (Children)',
// // //                     initialValueFuture: SettingsManager.getSoulsChildren(),
// // //                     onChanged: SettingsManager.setSoulsChildren,
// // //                   ),
// // //                   settingTextField(
// // //                     label: 'MMSI (optional)',
// // //                     initialValueFuture: SettingsManager.getMMSI(),
// // //                     onChanged: SettingsManager.setMMSI,
// // //                   ),
// // //                   settingTextField(
// // //                     label: 'Emergency Contact Phone',
// // //                     initialValueFuture: SettingsManager.getEmergencyContact(),
// // //                     onChanged: SettingsManager.setEmergencyContact,
// // //                   ),
// // //                   settingTextField(
// // //                     label: "Captain's Phone",
// // //                     initialValueFuture: SettingsManager.getCaptainPhone(),
// // //                     onChanged: SettingsManager.setCaptainPhone,
// // //                   ),
// // //                   const SizedBox(height: 16),
// // //                 ],
// // //               ),
// // //             ),
// // //           ),
// // //           actions: [
// // //             Padding(
// // //               padding: EdgeInsets.zero,
// // //               child: SizedBox(
// // //                 height: 44,
// // //                 width: double.infinity,
// // //                 child: TextButton(
// // //                   style: TextButton.styleFrom(
// // //                     backgroundColor: AppTheme.primaryRed,
// // //                     foregroundColor: Colors.white,
// // //                     padding: EdgeInsets.zero,
// // //                     shape: const RoundedRectangleBorder(
// // //                       borderRadius: BorderRadius.zero,
// // //                     ),
// // //                   ),
// // //                   onPressed: () => Navigator.of(context).pop(),
// // //                   child: const Text('Close', style: AppTheme.dialogButtonText),
// // //                 ),
// // //               ),
// // //             ),
// // //           ],
// // //         ),
// // //   );
// // // }
