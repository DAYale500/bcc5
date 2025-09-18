import 'package:bcc5/utils/vessel_formatting.dart';
import 'package:flutter/material.dart';
import 'package:bcc5/theme/app_theme.dart';
import 'package:bcc5/utils/settings_manager.dart';
import 'package:bcc5/widgets/setting_input_fields.dart';
import 'package:bcc5/widgets/setting_unit_picker.dart';
import 'package:bcc5/widgets/setting_int_picker.dart';
import 'package:bcc5/widgets/setting_depth_picker.dart';

void showEmergencyInfoModal(BuildContext context, {VoidCallback? onChanged}) {
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
                  settingTextField(
                    label: 'Boat Name',
                    initialValueFuture: SettingsManager.getBoatName(),
                    onChanged: (value) async {
                      await SettingsManager.setBoatName(value);
                      if (onChanged != null) onChanged();
                    },
                  ),
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
                  FutureBuilder<String>(
                    future: SettingsManager.getVesselType(),
                    builder: (context, snapshot) {
                      final raw = snapshot.data;
                      final current =
                          (raw == null || raw.isEmpty || raw == 'Other')
                              ? 'Sailing'
                              : raw;
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
                                initialValue:
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
                                    if (onChanged != null) onChanged();
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
                                  onChanged: (value) async {
                                    await SettingsManager.setVesselType(value);
                                    if (onChanged != null) onChanged();
                                  },
                                ),
                            ],
                          );
                        },
                      );
                    },
                  ),
                  settingTextFieldWithUnitPicker(
                    label: 'Vessel Length',
                    initialValueFuture: SettingsManager.getVesselLength(),
                    unitOptions: ['feet', 'meters'],
                    defaultUnit: 'feet',
                    getUnitFuture: SettingsManager.getLengthUnit,
                    setUnit: SettingsManager.setLengthUnit,
                    onChanged: (value) async {
                      await SettingsManager.setVesselLength(value);
                      if (onChanged != null) onChanged();
                    },
                  ),
                  settingDepthPickerField(
                    label: 'Minimum Depth / Boat Draft',
                    initialValueFuture: SettingsManager.getMinimumDepth(),
                    getUnitFuture: SettingsManager.getLengthUnit,
                    onChanged: (value) async {
                      await SettingsManager.setMinimumDepth(value);
                      if (onChanged != null) onChanged();
                    },
                  ),

                  // settingDepthPickerField(
                  //   label: 'Minimum Depth / Boat Draft',
                  //   initialValueFuture: SettingsManager.getMinimumDepth(),
                  //   getUnitFuture: SettingsManager.getLengthUnit,
                  //   onChanged: (value) async {
                  //     await SettingsManager.setMinimumDepth(value);
                  //     if (onChanged != null) onChanged();
                  //   },
                  // ),
                  settingTextField(
                    label: 'Vessel Description',
                    initialValueFuture: SettingsManager.getVesselDescription(),
                    onChanged: (value) async {
                      await SettingsManager.setVesselDescription(value);
                      if (onChanged != null) onChanged();
                    },
                  ),
                  settingIntPickerField(
                    label: 'Souls Onboard (Adults)',
                    minValue: 0,
                    maxValue: 10,
                    initialValueFuture: SettingsManager.getSoulsAdults(),
                    onChanged: (value) async {
                      await SettingsManager.setSoulsAdults(value);
                      if (onChanged != null) onChanged();
                    },
                  ),
                  settingIntPickerField(
                    label: 'Souls Onboard (Children)',
                    minValue: 0,
                    maxValue: 10,
                    initialValueFuture: SettingsManager.getSoulsChildren(),
                    onChanged: (value) async {
                      await SettingsManager.setSoulsChildren(value);
                      if (onChanged != null) onChanged();
                    },
                  ),
                  settingTextField(
                    label: 'MMSI (optional)',
                    initialValueFuture: SettingsManager.getMMSI(),
                    onChanged: (value) async {
                      await SettingsManager.setMMSI(value);
                      if (onChanged != null) onChanged();
                    },
                  ),
                  settingTextField(
                    label: 'Coast Guard Emergency Number',
                    initialValueFuture: SettingsManager.getCoastGuardPhone(),
                    onChanged: (value) async {
                      await SettingsManager.setCoastGuardPhone(value);
                      if (onChanged != null) onChanged();
                    },
                  ),
                  settingTextField(
                    label: "Captain's Phone",
                    initialValueFuture: SettingsManager.getCaptainPhone(),
                    onChanged: (value) async {
                      await SettingsManager.setCaptainPhone(value);
                      if (onChanged != null) onChanged();
                    },
                  ),
                  settingTextField(
                    label: 'Emergency Contact Name',
                    initialValueFuture:
                        SettingsManager.getEmergencyContactName(),
                    onChanged: (value) async {
                      await SettingsManager.setEmergencyContactName(value);
                      if (onChanged != null) onChanged();
                    },
                  ),
                  settingTextField(
                    label: 'Emergency Contact Phone',
                    initialValueFuture: SettingsManager.getEmergencyContact(),
                    onChanged: (value) async {
                      await SettingsManager.setEmergencyContact(value);
                      if (onChanged != null) onChanged();
                    },
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



