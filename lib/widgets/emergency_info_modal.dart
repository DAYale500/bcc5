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
                  settingTextField(
                    label: 'Boat Name',
                    initialValueFuture: SettingsManager.getBoatName(),
                    onChanged: SettingsManager.setBoatName,
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

                  settingTextField(
                    label: 'Vessel Type',
                    initialValueFuture: SettingsManager.getVesselType(),
                    onChanged: SettingsManager.setVesselType,
                  ),
                  settingTextField(
                    label: 'Vessel Length',
                    initialValueFuture: SettingsManager.getVesselLength(),
                    onChanged: SettingsManager.setVesselLength,
                  ),
                  settingTextField(
                    label: 'Vessel Description (e.g., “sail number 56788”)',
                    initialValueFuture: SettingsManager.getVesselDescription(),
                    onChanged: SettingsManager.setVesselDescription,
                  ),
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
