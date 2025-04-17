I wrote this:
the next thing I'd like is a new button in the appBar, visible on every page. We'll move the search and setting icons to the left side of the title with the backbutton (fixed positions so same spot even when the backbutton isn't there, the search and setting icons don't shift), then to the right of the title is a bright red life buoy icon that triggers a man overboard modal which:

1. records/displays the GPS coordinates at the moment the button was pressed
2. the immediate steps to take in a MOB procedure
2.1 some might be links to lessons/parts/tools should the user want more information on that topic
3. has a button for "Other Emergencies" so it acts as a quick access to them too...
4. has a close button when done

a Good response was this:
Got it! Your new AppBar layout and Man Overboard (MOB) modal plan are now locked in. We'll follow these priorities:

### 🔧 AppBar Changes
- Move **search** and **settings** icons to the left of the title.
- Ensure their positions are fixed relative to the left edge, regardless of back button presence.
- Add a **bright red life buoy icon** to the right of the title:
  - Tapping it opens the MOB modal.

### 🚨 Man Overboard Modal
On trigger:
1. 📍 Records and displays GPS coordinates.
2. 📋 Shows MOB procedure steps (with some linked to lessons/parts/tools).
3. 🧭 Includes a button for “Other Emergencies” access.
4. ❌ Includes a close button.

We'll take this step-by-step. Ready to start with a clean AppBar layout refactor? This includes:
- Structuring left and right icon sections
- Reserving space for the MOB button
- Making sure it's universally applied

Let me know if you’d like to begin there or work on the MOB modal functionality first.

and I'd like begin with adjusting the appBar layout refactor.









updated 4/10/25 1447
Absolutely. Here's the **revised Emergency Features Progress Tracker**, incorporating your clarifications and improvements:

---

### ✅ Completed
- **4.1**: Move phonetic/GPS formatting logic into `radio_helper.dart`
- **4.2**: Integrate formatted radio script in MOB modal with boat name and GPS (via Radio Script button)
- **4.3**: Add vessel info inputs in Settings modal:
  - **4.3.1**: Fields include:
    - 🚢 Vessel name
    - 🚩 Vessel type (e.g., sailing vessel, motor vessel)
    - 📏 Vessel length (optional, for future)
    - 📝 Vessel description (e.g., "white sailboat with orange sails")
    - 👨‍👩‍👧‍👦 Souls onboard (split into adults + children)

---

### 🔜 In Progress / Up Next

#### **4.5: Reminder System on App Launch**
- [ ] On every app open:
  - **Show reminder unless user disables it in Settings** (default = **enabled**)
- [ ] If enabled, show either:
  - ✅ A **popup modal** with:
    - ⚠️ Message:  
      > “Review your vessel info to ensure emergency details are up-to-date.”
    - ✏️ Inline editable fields (optional: if quick updates are feasible without leaving the modal)
    - ✅ Button: **“Update Now”** (opens Settings or saves inline changes)
    - ✅ Button: **“Information is Accurate”** (dismisses without saving)
    - ⚙️ Small button: **“Settings”** (opens modal settings pane)
    - ℹ️ Footer:  
      > “You can disable this reminder in Settings.”
- [ ] Add toggle in Settings:
  - **Label**: “Show emergency info reminder at app launch”
  - **Default**: ON

---

#### **4.6: MOB Radio Script Enhancements**
- [ ] Include:
  - ✅ **Vessel Type** in phonetic line:
    - > “This is *sailing vessel Charlie-Alpha-Tango space Whiskey-Alpha-Romeo-Sierra*”
    - ✅ Ensure **spaces** in names are spelled as "space" in phonetic string
- [ ] Add **Souls Onboard** line:
  - > “We have *4 adults and 2 children* onboard.”
- [ ] Improve **spoken GPS format**:
  - Format:  
    > “Three-seven degrees decimal four-five minutes North,  
    > One-two-two degrees one-seven decimal two-three minutes West”
  - Use natural pauses and groupings for readability

---

Would you like to **start building 4.5 next** (modal logic and toggle in Settings), or proceed with **implementing 4.6** (vessel + souls + GPS phrase in the MOB script)?



re: 4.5.1: Fields to Verify
4.5.1: Fields to Verify
Boat Name
Vessel Type
Vessel Description
Souls Onboard (split into:
Adults
Children)
let's add boat length (and this value can/will be used in other places, so there might be a separate file where all the user input goes that persists between app restarts, like where they left off in their learning path progress? and allow other places to use the boat length value...)
add an optional MMSI, emergency contact number, Captai2215n's cell phone








update 4/11/25 

Thanks, David — here's a full QA-style breakdown of the **Man Overboard (MOB) radio script system**: how it's designed, how it's wired, what it should do, what likely regressed, and how we’ll restore it.

---

## ✅ Overview of How the MOB System Works (Narrative)

When the user taps the **MOB life ring button**, the app:

1. **Locks GPS coordinates** and timestamp.
2. Opens a dedicated **`MOBEmergencyScreen`**, a red-highlighted full-screen emergency mode.
3. Displays:
   - Timestamp
   - Current GPS location (formatted based on user settings: DMM, DMS, or decimal)
   - Dropdown for changing GPS display format
   - A list of **immediate MOB steps**
   - Buttons for:
     - **"Radio Script"** → opens a modal with phonetic distress script
     - **"Other Emergencies"** → navigates to the toolbag: procedures
     - **"Update GPS"** or **"Clear GPS"**

When the **Radio Script** button is tapped:

4. The app builds a formatted message using:
   - `buildPhoneticVesselIntro()` → Phonetic name like:  
     > *This is the Sailing Vessel Fernweh Rising: Foxtrot-Echo-Romeo-November-Whiskey-Echo-Hotel space Romeo-India-Sierra-India-November-Golf*
   - `buildSpokenVesselDescription()` → Spoken description like:  
     > *We are a three-seven foot sailing vessel, center cockpit, sail number three-four-five-six.*
   - `formatGPSForRadio()` → Spoken coordinates like:  
     > *• three-seven degrees decimal four-seven decimal one-five-zero minutes North*

---

## 🧩 File Structure and Wiring

### Core Files Involved

- `lib/screens/emergency/mob_emergency_screen.dart`
  - Main UI and controller for the MOB screen
  - Triggers dialog and reads GPS/settings

- `lib/utils/radio_helper.dart`
  - All phonetic/spoken formatting
  - Builds the scripted strings

- `lib/utils/settings_manager.dart`
  - Retrieves stored user vessel info
  - Includes unit preference (`feet` or `meters`)

- `lib/widgets/mob_modal.dart` *(optional depending on how script modal is implemented)*

---

## 🔎 Current Bugs/Regressions

### 🐛 1. “foots” instead of “feet”
- `buildSpokenVesselDescription()` uses `"foot" + 's'`, resulting in incorrect plural `"foots"`.

### 🐛 2. Sail number or description not included
- If vessel description (e.g., “sail number 3456”) is missing or not merged properly, it's left out of the spoken script.

### 🐛 3. Intro phonetic line not showing on physical device
- Possibly due to conditional logic, missing render step, or string not passed correctly to `_presentRadioDialog`.

### 🐛 4. Style issues
- Bottom close button in modal wastes vertical space.
- Coordinates are not bullet-separated and can be hard to read when wrapped.

---

## 🔧 Step-by-Step Refactor Plan

### Step 1: Fix “foots” bug
Update `buildSpokenVesselDescription()` in `radio_helper.dart`:
- ✅ Replace naive plural logic with:

```dart
String getPluralizedUnit(String unit, String length) {
  final isSingular = length == '1';
  if (unit == 'meters') return isSingular ? 'meter' : 'meters';
  return isSingular ? 'foot' : 'feet';
}
```

And use:
```dart
final unitLabel = getPluralizedUnit(unit, length);
```

---

### Step 2: Confirm radio intro + description logic

In `radio_helper.dart`:

- ✅ Keep this version:

```dart
Future<String> buildPhoneticVesselIntro() async {
  final boatName = await SettingsManager.getBoatName();
  final type = await SettingsManager.getVesselType();
  final fullName = boatName.trim();
  final phonetic = formatPhonetic(fullName);
  return 'This is the $type $fullName: $phonetic';
}
```

- ✅ And this for description:

```dart
Future<String> buildSpokenVesselDescription() async {
  final length = (await SettingsManager.getVesselLength()).trim();
  final type = (await SettingsManager.getVesselType()).trim();
  final description = (await SettingsManager.getVesselDescription()).trim();
  final unit = (await SettingsManager.getUnitPreference()).trim().toLowerCase();

  final spokenLength = formatSpokenDigits(length);
  final unitLabel = getPluralizedUnit(unit, length);
  final base = 'We are a $spokenLength $unitLabel $type';
  return description.isNotEmpty ? '$base, ${description.trim()}.' : '$base.';
}
```

---

### Step 3: Fix layout/spacing in radio script modal

In `mob_emergency_screen.dart`, look for `_presentRadioDialog(...)`:

- ✅ Ensure bottom padding is removed from the dialog’s action area
- ✅ Reduce or eliminate extra vertical space around the Close button
- ✅ Change script block to show GPS like:

```dart
• three-seven degrees decimal four-seven decimal one-five-zero minutes North  
• one-two-two degrees decimal two-four decimal three-eight-five minutes West
```

---

### Step 4: Investigate simulator vs. physical device issue

- Confirm that on physical device, `buildPhoneticVesselIntro()` and `buildSpokenVesselDescription()` are awaited and passed to the dialog
- ✅ Use `SelectableText(...)` to render intro and description
- Check if modal is triggered too early (before settings loaded) — if so, delay with `await Future.delayed(...)` or `WidgetsBinding.instance.addPostFrameCallback(...)`

---

### Step 5: Manual QA Flow to Verify Fixes

1. Open app on both simulator and phone
2. Tap MOB life ring icon
3. Tap “Radio Script”
4. Confirm:
   - ✅ Phonetic name appears
   - ✅ Spoken vessel description appears with proper plural (“feet”)
   - ✅ Sail number (if in description) is included
   - ✅ MMSI printed once only (or not spoken)
   - ✅ GPS lines have bullet formatting and wrap cleanly
   - ✅ Red Close button at bottom has no extra vertical padding
   - ✅ All logic behaves identically on simulator and device

---

## ✅ Summary

You have a mostly working MOB emergency system. What regressed was:

- **Incorrect plural ("foots")**
- **Missing or malformed intro and description**
- **Styling/layout issues in the modal**
- **Render timing bugs possibly affecting real devices**

I’ll now help you restore each issue precisely and verify it's correct. Let me know when you want to begin the repair pass.
















set 1
To announce a Mayday to the Coast Guard for a man overboard, start by stating "Mayday, Mayday, Mayday" three times, then state your vessel's name three times. Follow this with your vessel's location (latitude and longitude or a relative position from a known landmark), the nature of the distress (man overboard), and the number of people on board. Finally, conclude with "Over". 
Detailed Steps:
Initial Call:
Press the transmit button and say slowly and clearly: "Mayday, Mayday, Mayday". 
Follow with: "This is..." (state your vessel's name three times and call sign or MMSI number). 
Position:
State your position: provide precise coordinates (latitude and longitude) or a reference to a known landmark (e.g., distance and bearing from a light). 
Nature of Distress:
Clearly state the nature of the emergency: "Man Overboard". 
Additional Information:
Provide the number of people on board. 
Any other relevant information, like if a flare was fired or if people are abandoning ship. 
Conclusion:
End your message with "Over". 
Important Considerations:
Speak Clearly and Slowly:
Ensure the Coast Guard can understand your message. 
Use Channel 16:
This is the universal emergency channel, monitored by the Coast Guard and other vessels. 
Repeat Information:
Repeat key information, especially your position and vessel name, to ensure it's received correctly. 
Listen for Acknowledgement:
Wait for a response from the Coast Guard or another vessel. If no response, repeat your message. 
DSC (Digital Selective Calling):
If your VHF radio has DSC capabilities, use the distress button to send a pre-formatted message to the Coast Guard. This automatically sends your position and other information, says SpinSheet Magazine. 
Alternative Channels:
If channel 16 is busy or unmonitored, you may be directed to another working channel by the Coast Guard or a nearby vessel. 
Keep it Concise:
Provide the most important information first, especially your position. 

set 2
MAYDAY Call: To issue a MAYDAY call on Channel 16 of your VHF radio:
Transmit "MAYDAY, MAYDAY, MAYDAY."
Say "This is (name of boat three times, call letters once)."
Repeat once more "MAYDAY" and your boat's name.
Report your location.
Report the nature of your emergency.
Report the kind of assistance needed.
Report the number of people on board and condition of any injured.
Describe the boat and its seaworthiness.
Wait for a response. If there is none, repeat the message.





















Please audit this file, then offer the refactors needed for these changes:

1. This:
Read this over VHF Channel 16
should be:
Say this over VHF Channel 16: Speak clearly and slowly, press the microphone button while speaking slowly and clearly


2. this:
This is the Sailing Vessel Fernweh: Foxtrot Echo Romeo November Whiskey Echo Hotel
should be:
This is the Sailing Vessel Fernweh, Fernweh, Fernweh: Foxtrot Echo Romeo November Whiskey Echo Hotel

3. Move the "We are a 37-foot Sailing Vessel, with Center Cockpit, sail number 3456." to after the "We have a man overboard at position:
• three-seven degrees decimal four-seven decimal one-five-zero minutes North
• one-two-two degrees decimal two-four decimal three-eight-five minutes West

We are located near [INSERT LANDMARK], 📍e.g., "In the north bay, 2 miles east of Pelican Rock."

There is more, I need the work up that we so carefully did to be sure. Please repost our final radio script here and I will provide more.

add "Over" when done and LET GO of the microphone button



Great — I've logged all those changes to ensure the MOB radio script follows the final structure we've crafted. Here's the **most recent approved version of the script** we agreed on, with steps, wording, and formatting intact so you can verify before we begin coding refactors:

---

## ✅ Finalized MOB Radio Script

Report MAYDAY to the Coast Guard: Ensure radio is on channel 16, press and hold the microphone transmit button while speaking slowly and clearly the following:

**1.** “Mayday, Mayday, Mayday.”  
**2.** “This is the Sailing Vessel Fernweh, Fernweh, Fernweh: Foxtrot-Echo-Romeo-November-Whiskey-Echo-Hotel — space — Romeo-India-Sierra-India-November-Golf.”  
**3.** “We have a man overboard at position:”  
  • three-seven degrees four-seven decimal one-five-zero minutes North  
  • one-two-two degrees two-four decimal three-eight-five minutes West  
**4.** “We are located near [SAY HELPFUL NEARBY LANDMARK IF YOU CAN], 📍e.g., ‘In the north bay, two miles east of Pelican Rock.’”  
**5.** “We are a 37-foot Sailing Vessel, with Center Cockpit, sail number three-four-five-six.”  
  *(or “12-meter” if meters selected, but never both)*  
**6.** “We have four adults and one child onboard, all wearing life jackets.”  
**7.** “We need immediate assistance recovering the person in the water.”  
**8.** “Over.” *(LET GO of the microphone button)*

---

### 🆘 Optional Follow-Up Details
These appear **after a visual divider or subtitle** in the modal:
Additional statements as necessary, the Coast Guard may ask about:
**9.** “We have fired a flare.” *(if applicable)*  
**10.** “We have injuries onboard.” *(if applicable)*  
**11.** “📡 MMSI: 123456789” *(only if MMSI is available)*
12. They will likely want your cell phone number if in cell service range. Speak it slowly and clearly.





update 4/16/25 1125
Perfect — I've captured your intent clearly:

✅ **Your goal** is a user-friendly **modal-like MOB flow**:
- **Entry**: User taps the MOB icon → opens `MOBEmergencyScreen` (modal or modal-style full-screen).
- **Action**: On that screen, they can tap **Other Emergencies** → see `ToolItemScreen(toolbag: 'emergencies')`.
- **Back behavior**: Pressing back from the tool list should return them to the MOB modal.
- **Final exit**: From the MOB modal, pressing close exits and returns to the prior context (e.g., LandingScreen or wherever they were).

We're **not** using `GoRouter.go()` or `.pushNamed()` for these transitions because:
- That would **lose the modal context** (back goes to LandingScreen instead of MOB).
- We’d have to pass awkward `.extra` values and manually wire transition keys to preserve routing state.

Instead, we’re using **`Navigator.push()`** and **`MaterialPageRoute`**, which:
- Preserves the navigation stack naturally,
- Gives you full control for **modality and styling**,
- Avoids GoRouter overhead for emergency paths.

---

Next step: I’ll refactor the `MOBEmergencyScreen` to:
1. **Fix the missing MainScaffold**, so it doesn't look black or broken.
2. **Push `ToolItemScreen`** wrapped in a `MainScaffold`, with valid `renderItems`, and correct keys.
3. Ensure **back navigation from tool screen goes to MOB** and not Landing or elsewhere.

Ready to proceed?