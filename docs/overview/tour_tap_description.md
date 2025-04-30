Can we start with one thing, say #1 and get that working before moving on to #2 to minimize the challenge in the refactor? Also, I wasn't clear that the "Exit" button is also not needed and can be eliminated as a button. This way, the user will need to cycle through the complete tour and then on the final tourStep tap, the tour should self-exit instead of needing to tap "Exit" as it is now. 

And just to make sure what is possible... In my mind, the tour should work like this:

1. when the user first time ever opens the app and sees LandingScreen for the first time ever, the tour auto-starts. The descriptions and the connection is shown, the user taps the descriptions as they are shown the various widgets on the screen (MOB, settings, search, CompetentCrew, AdvancedGuides, bnb icons) and then the tour exits at that point, leaving the user on the landingScreen.
2. the user will then tap something (any of the widgets the tour pointed out) and they will navigate to that screen for the very first time thus the tour for that screen will start up again showing the user how to use that screen. again, they'll tap through the tour until the end and on the final tap, the tour will exit, leaving the user on that screen.
3. then the user will tap another widget, moving on to a new screen. if that's the first time on that new screen, then the tour. If they return instead to a screen they've seen before, then no tour.
4. potentially all screens will have a tour (though maybe not) and the tour will be ready for their first time ever visiting.
5. the tour can be reset in settings, though not sure if it's "start tour" or "reset tour" or "launch tour" or what makes the most sense.
