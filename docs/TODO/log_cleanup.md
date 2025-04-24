✅ Side Cleanup: Log Noise Candidates
These logs are very frequent but not helpful after debugging is complete. Consider muting or demoting them:


Tag	File	Line / Info
<!-- 🐛 [Scaffold] tab index: X	main_scaffold.dart	Repeated constantly across all tabs -->
<!-- 🐛 [AppBar] title: ...	custom_app_bar_widget.dart:59	Repeats for every build, not dynamic -->
<!-- 🐛 [Render] ... item IDs	render_item_helpers.dart:10	Potentially useful in dev, noisy in production -->
<!-- 🐛 [Router] Navigated to ...	app_router.dart	Can be demoted to debug -->
🐛 [ToolDetail] Content blocks	tool_detail_screen.dart	Low signal unless content count is dynamic





Label | Description | Suggestion
💡 🧪 [TransitionManager] buildCustomTransition EXTRAS DUMP | Dumps every key from .extra, spans 10+ lines, repeated every transition. | Demote to logger.v(...), or gate behind kDebugMode && verboseLogging.
💡 [TransitionManager] buildCustomTransition → detailRoute: ... | Summary line repeated every route | Keep if useful, or demote to .d or conditional.
💡 🛠️ Navigating to ToolItemScreen for toolbag: ... | In app_router.dart, happens for every navigation | Demote to .d.
🐛 [ToolDetail] AppBar keys assigned. | Logs on every rebuild | Either remove or guard with kDebugMode.
🐛 [ToolDetail] Content blocks: N | Logs item count but adds little in runtime | Demote or remove unless debugging item construction.
💡 ToolItemScreen loaded for toolbag: ... | Logs repeatedly when switching tools | Could be useful in dev, demote to .d otherwise.
💡 🟦 Displaying ToolsScreen | Appears every time ToolBagScreen is rebuilt | Remove or demote.
⚠️ No pages left to pop. Redirecting manually. | Valid warning, but occurs often | Keep, but consider .w instead of .i if noisy.
⚠️ Back tap ignored — nothing to pop! | Same as above, common in edge back cases | Same suggestion as above.
💡 🚀 App Launch / 🌕 APP LAUNCH | Huge emoji spam repeated at startup | Replace with a one-liner banner or concise emoji if you want flair without noise.