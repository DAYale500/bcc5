# 📍 GPS Converter – Developer Narrative

### Purpose

The GPS Converter block provides users with a simple way to:

1. **Input GPS coordinates** in multiple formats (manual entry or using device location).
2. **Convert between formats** automatically (DD, DMM, DMS).
3. **Copy results** for easy reuse.
4. **Use a custom keypad** optimized for marine navigation input, while still offering a toggle to the native keyboard.

---

### High-Level Design

* Built as a **ContentBlock type** (`gpsConverter`) so it fits into the existing content rendering system.
* The UI consists of:

  * An input `TextField` (prefilled from device location).
  * A **custom keypad** (`GpsKeypad`) for structured entry (N/S/E/W, °, ′, ″, minus, decimal, etc.).
  * Automatic live **conversion results** displayed below (DMM, DD, DMS).
  * Utility buttons: *use my location*, *toggle keyboard*, *clear*, *copy*.

---

### Components

#### 1. **GpsFormats**

* Located in `lib/utils/gps_formats.dart`.
* Core parsing + formatting utilities:

  * **Parsers**: `_parseDD`, `_parseDMM`, `_parseDMS`
  * **Formatters**: `toDD`, `toDMM`, `toDMS`
* Normalizes messy input (`′`, `’`, unicode minus, etc.).
* Ensures outputs are consistent, with fixed decimal places.

This module is the **engine** behind the converter.

---

#### 2. **GpsConverterBlock**

* A `StatefulWidget` providing the UI and logic.
* Responsibilities:

  * Owns the input controller (`_controller`) and focus management (`_focusNode`).
  * Handles location prefill via `geolocator`.
  * Tracks transient state:

    * `_result`: last successful parse (`ParseResult`)
    * `_locLoading`: whether a location lookup is in progress
    * `_locError`: optional error message to display

**Prefill flow**:

1. On init, requests location permission.
2. Retrieves device location.
3. Formats it as **DMM (marine style)** using `GpsFormats.toDMM`.
4. Inserts into the text field and triggers conversion.

**Input handling**:

* `_insertText` → adds custom keypad characters at the caret.
* `_backspace` → simulates delete behavior.
* `onChanged` → reparses input using `GpsFormats.tryParse`.

---

#### 3. **GpsKeypad**

* Custom keypad with **6 columns** and multiple rows:

  * `N S E W` keys (red background).
  * Number keys `0–9` (outlined).
  * Symbols: °, ′, ″, ., , (green background).
  * Special: **spacebar** and **double-wide backspace**.
* All keys funnel input into `_insertText` or `_backspace`.

Styling is handled through `AppTheme.gpsKeyButtonStyle`.

---

#### 4. **TextField Behavior**

* By default, uses the **custom keypad** (`readOnly = true`).
* User can toggle to the native system keyboard.
* To prevent triple-tap crashes:

  * `enableInteractiveSelection: !_useCustomKeyboard`
  * `contextMenuBuilder: _useCustomKeyboard ? _emptyContextMenu : null`
* Caret is always shown (`showCursor: true`, `cursorOpacityAnimates: true`).

---

### Key UX Choices

* **Marine DMM as default format**: aligns with common chartplotters, handheld GPS units, and SAR conventions.
* **Custom keypad**: ensures users can input valid characters without hunting on their native keyboard.
* **Copy buttons**: allow users to take whichever format they need (DMM, DD, DMS).
* **Toggle keyboard option**: power users can still use their iOS/Android keyboards.

---

### Known Gotchas

* Location permission flow must be handled gracefully:

  * Denied once → request again.
  * Denied forever → show error and suggest opening Settings.
* If coordinates can’t be parsed, `_result` will be `null`, and the tiles will show placeholders.
* On small screens, keypad width may overflow — spacing/padding tweaks are in place but should be tested on multiple devices.

---

### Future Work

* **JSON conversion** (next step): export/import coordinate sets in structured form.
* **Validation UI**: inline error highlighting if the coordinate is malformed.
* **History / favorites**: allow quick re-entry of recent or saved positions.
* **Theming**: adapt keypad colors more dynamically for light/dark.

---

✅ With this doc, a new dev should be able to:

* Understand how data flows from user input → parser → formatters → UI.
* Extend functionality without breaking the existing pipeline.
* Debug common issues (parsing edge cases, location services, layout overflow).

---
