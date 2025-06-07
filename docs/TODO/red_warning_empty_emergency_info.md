Red Warning Banner in Emergency Reminder
🧭 Purpose (Why):
The emergency reminder is a critical prompt to ensure that vessel safety info is accurate and up to date. However, many users might dismiss the reminder without realizing that placeholder defaults (like "Unnamed Vessel" or "000-000-0000") are still present. A red warning banner serves as a visual alert to catch their attention and guide them toward correcting this data.

This helps:

Ensure meaningful data is used in emergencies (radio calls, handoffs, QR summaries).

Increase user confidence in the safety status of their vessel profile.

Encourage better onboarding by calling out "incomplete" emergency setups.

🛠 Implementation Strategy (How):
The red banner is added at the top of the emergency reminder dialog, only if certain key values are still using their known default placeholders.

✅ Step-by-step Implementation:
Determine if defaults are in use:
Define a flag like this:

dart
Copy code
final isUsingDefaults = boatName == 'Unnamed Vessel' ||
    vesselLength == '0' ||
    captainPhone == '000-000-0000' ||
    mmsi == '000000000';
Create a list of widgets (infoWidgets) for the dialog content:

Insert the red warning banner first if isUsingDefaults is true.

Add the rest of the emergency info below.

dart
Copy code
final List<Widget> infoWidgets = [];

if (isUsingDefaults) {
  infoWidgets.add(
    Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Text(
        '⚠️ Emergency info may still contain defaults. Please tap Edit to review and update.',
        style: const TextStyle(
          color: Colors.red,
          fontWeight: FontWeight.bold,
        ),
      ),
    ),
  );
}

infoWidgets.addAll([
  Text('$prefix $boatName'),
  Text('Length: $vesselLength $lengthUnit'),
  // ...rest of the fields...
]);
Update the Column(children:) inside showEmergencyReminderDialog() to use this list:

dart
Copy code
content: Column(
  mainAxisSize: MainAxisSize.min,
  crossAxisAlignment: CrossAxisAlignment.start,
  children: infoWidgets,
),
🧪 Optional Enhancements:
Background highlight (e.g. yellow card or colored box).

“Review Now” button embedded in the warning.

Warning persists until all defaults are replaced.