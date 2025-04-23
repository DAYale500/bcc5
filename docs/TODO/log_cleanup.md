✅ Side Cleanup: Log Noise Candidates
These logs are very frequent but not helpful after debugging is complete. Consider muting or demoting them:


Tag	File	Line / Info
<!-- 🐛 [Scaffold] tab index: X	main_scaffold.dart	Repeated constantly across all tabs -->
<!-- 🐛 [AppBar] title: ...	custom_app_bar_widget.dart:59	Repeats for every build, not dynamic -->
<!-- 🐛 [Render] ... item IDs	render_item_helpers.dart:10	Potentially useful in dev, noisy in production -->
<!-- 🐛 [Router] Navigated to ...	app_router.dart	Can be demoted to debug -->
🐛 [ToolDetail] Content blocks	tool_detail_screen.dart	Low signal unless content count is dynamic



I'd like to create a table of the transitions in each branch and what they're supposed to be. Then, I can manually verify if that's the way it's working.





take picker off detail screens


change next chapter to the lastGroupButton style, but have two buttons: back to chapter list and next chapter (name)

