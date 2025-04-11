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

