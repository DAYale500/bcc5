Short answer: you’re *almost* JSON-only already. Lessons, Parts, Tools, and Paths screens load from the JSON repositories; the only live dependency on the old Dart repositories is the **Flashcards** feature and a couple of utility paths that still import the legacy “repository\_index” files.

Here’s the evidence and a clean way to prove it for sure.

# What’s still using legacy repos (and must be converted before deletion)

* **Flashcards screens & routing**
  The Flashcards category and item screens import `flashcard_repository_index.dart` (which pulls from the old Lesson/Part/Tool indexes). See the import in the category screen, and calls to `getAllCategories()` / `getFlashcardsForCategory(...)`. &#x20;
  The router also uses those helpers when jumping into Flashcards.&#x20;
  Open the flashcard repo index itself and you’ll see it *imports the legacy indices*: `lesson_repository_index.dart`, `part_repository_index.dart`, `tool_repository_index.dart`, and enumerates categories/flashcards from them.  &#x20;

So: if you delete the legacy Lesson/Part/Tool “index” files today, Flashcards will break.

# What’s already JSON-only

* Your file tree shows parallel JSON repos exist for lessons/parts/tools/paths, alongside legacy Dart repos.  &#x20;
* The Flashcards screens themselves *render* items via `buildRenderItems(ids: ...)`. Your utils even have a commented JSON-only resolver stub (no legacy fallback), which hints your runtime content objects can come purely from JSON once Flashcards stop depending on the legacy category/index layer. &#x20;

Also, your JSON files already contain **flashcards embedded** inside Tools (and some Lesson/Part content), so the data you need for drills already exists in the JSON ecosystem. Examples: COLREGs and calculators include `flashcards` arrays.  &#x20;

# How to know for certain you can remove legacy files (a deterministic check)

1. **Flip Flashcards to JSON sources only**
   Replace the legacy-backed aggregator with a JSON-backed one:

   * Create `lib/data/repositories/flashcards/json_flashcard_repository.dart` that:

     * Derives categories from JSON modules/zones/toolbags (e.g., from your JSON indexes or by scanning loaded JSON).
     * Aggregates flashcards from `JsonLessonRepository`, `JsonPartRepository`, and `JsonToolRepository`.
   * Update imports in:

     * `lib/screens/flashcards/flashcard_category_screen.dart` (swap to the JSON flashcard repo).&#x20;
     * Any router/utility that calls `getAllCategories()` / `getFlashcardsForCategory()` (the jump code in your restart handler uses these).&#x20;

   (You already have working JSON loaders and a commented JSON-only `getContentObject`/`buildRenderItems` blueprint in `render_item_helpers.dart`—you can lift from that to keep resolution strictly JSON.) &#x20;

2. **Run a “legacy-ban” build locally**
   Do this on a throwaway branch:

   * **Temporarily break** the legacy imports by renaming the legacy index files (e.g., `lesson_repository_index.dart → lesson_repository_index.dart.bak`, similarly for `part_...`, `tool_...`, and `flashcard_repository_index.dart`). Your compiler/analyzer will surface *every remaining dependency* instantly.

   * Or faster: add a quick grep gate:

     ```bash
     grep -R "repository_index.dart" lib && echo "❌ Found legacy index usages"
     ```

     Keep fixing/replacing until this returns nothing.

   * Then run:

     ```bash
     flutter analyze
     flutter run -d iOS
     ```

     Navigate every branch: Lessons, Parts, Tools, Paths, and **Flashcards** (All/Random and at least one category). If the app boots and drills render without those files present, you’re clear.

3. **Safety net: exhaustive ID walk**
   As a final guard, add a one-off dev screen or debug routine that:

   * Loads all JSON modules (lessons/parts/tools/paths),
   * Collects every `id` (including embedded flashcards),
   * Calls your **JSON-only** `buildRenderItems(ids: ...)`,
   * Asserts that none return null.
     This catches any IDs that only existed in the legacy repos.

# Practical to-dos (minimal changes)

* Build `json_flashcard_repository.dart` with functions:

  * `List<String> getAllCategories()` → derive from your JSON module/zone/bag names (you already have JSON for tools like colregs/vhf/emergency; lessons/parts JSON also present). &#x20;
  * `List<Flashcard> getFlashcardsForCategory(String category)` → concatenate `flashcards` from JSON lessons/parts/tools for that category.
  * Optional: `getNextCategory(...)` the same way your current index does.&#x20;
* Swap imports in Flashcard screens/router to this new JSON version. &#x20;
* Run the **legacy-ban** build steps above.

# Verdict

* **Today:** you cannot delete *all* legacy files yet because the Flashcards pipeline still depends on them. (Category discovery and card aggregation are wired to the legacy indexes.)&#x20;
* **After swapping Flashcards to JSON:** you can remove the legacy repos safely. Your JSON already contains the drills, and your runtime render pipeline is ready for JSON-only resolution. &#x20;

If you want, I can draft the tiny `json_flashcard_repository.dart` shim that mirrors your current API (`getAllCategories`, `getFlashcardsForCategory`, `getNextCategory`) but walks the JSON loaders instead.














love it — here’s a tight, no-code plan you can run straight through: migration → proof → cleanup. I’ll call out exactly where the current code still leans on legacy repos so we know what to swap.

# Phase 1 — Finish the migration to JSON (no code yet, just steps)

1. Flashcards: replace legacy aggregator with JSON-backed one

* Why: the router and flashcard screens currently import the legacy index (`flashcard_repository_index.dart`). That’s the last blocker to going JSON-only.&#x20;
* What to do (conceptually): create a JSON flashcard aggregator that:

  * Scans JSON lessons, parts, and tools to derive categories and flashcard lists (the JSON tool bundles already have embedded flashcards, e.g., calculators, emergency, checklists).&#x20;
  * Exposes the same public surface as today (e.g., “get all categories”, “get flashcards by category”, “getAllFlashcards” for the custom route).
* Where to point it: update the flashcard category/item/detail screens and the router to use this new JSON aggregator instead of the legacy one. Note: the “custom” route currently builds `RenderItem`s by calling `getAllFlashcards()` from the legacy repo; that must flip too.&#x20;

2. Ensure top-level tabs are JSON everywhere

* Lessons / Parts / Tools screens: confirm their list/detail flows are already using the `json_*_repository` loaders. The tree shows both JSON and legacy side-by-side (our goal is to remove the latter).&#x20;
* Tools are already set up with a JSON repository that indexes `assets/json/tools/*.json` via the asset manifest (this is the model to mirror for flashcards).&#x20;
* The router is already nudging in the JSON direction: for Parts it prefers `module` and only falls back to the old `zone` key; for Tools it allows a `module` fallback too. Once JSON is authoritative, we’ll remove those fallbacks.&#x20;

3. Check learning paths use JSON

* You have a JSON path repository alongside the legacy one. Confirm the Paths screens (chapter, items) resolve content through the JSON path repo only. If any path still enumerates legacy IDs, plan to re-point it.&#x20;

4. Validate JSON content coverage

* Ensure all flashcards you rely on for drills exist in JSON (many are already embedded in tool JSON; add any missing sets to their JSON homes).&#x20;

---

# Phase 2 — Deterministic test plan (prove you’re JSON-only)

A) Compile-time “legacy-ban” check (fastest signal)

* Temporarily disable the legacy indices by renaming these files (or moving them to a temp folder):

  * `lib/data/repositories/lessons/lesson_repository_index.dart`
  * `lib/data/repositories/parts/part_repository_index.dart`
  * `lib/data/repositories/tools/tool_repository_index.dart`
  * `lib/data/repositories/flashcards/flashcard_repository_index.dart`
    (See file tree for exact locations.)&#x20;
* Rebuild. Any remaining imports/usages will error immediately. Fix until clean.

B) Grep gates (add to your CI or a local pre-commit)

* Search for lingering references:

  * `repository_index.dart`
  * `Tool*Repository.dart` (non-JSON), `Lesson_*_repository.dart`, `Part_*_repository.dart` (non-JSON).
    The tree shows which files are legacy vs JSON; this audit should drop to zero matches for legacy.&#x20;

C) Runtime smoke across all tabs

* Routes under test (via BNB): `/lessons`, `/parts`, `/tools`, `/flashcards`. The router wiring is explicit; use it to drive your manual QA.&#x20;
* For each tab: open module list → open an item list → open an item detail → navigate next/prev → back.
* Tools: confirm lists and details load from `assets/json/tools/*.json` (your JSON Tool repo logs index/loads; watch logs).&#x20;
* Flashcards:

  * Category list populates (JSON-derived categories).
  * Item list shows cards.
  * Detail screen flips through cards and returns properly.
  * The `/flashcards/custom` route builds from the JSON aggregator, not the legacy “getAllFlashcards.”&#x20;

D) Data integrity walk (optional but strong)

* Add a one-off debug action that iterates every JSON asset ID (lessons, parts, tools, flashcards) and calls your existing render pipeline to ensure every ID resolves to a `RenderItem` (no nulls). Tool JSON and the JSON Tool repo provide a good template for discovery + load. &#x20;

E) Paths cross-check

* Open a couple of learning paths and step into their items; verify those IDs resolve solely through JSON repos (no legacy lookups in the chain). Router paths for learning paths are ready for this pass.&#x20;

---

# Phase 3 — Clean up (delete with confidence)

When all tests above are green:

1. Remove legacy repositories and indices

* Lessons: delete `lesson_*_repository.dart` and `lesson_repository_index.dart`. Keep `json_lesson_*`.&#x20;
* Parts: delete `part_*_repository.dart` and `part_repository_index.dart`. Keep `json_part_*`.&#x20;
* Tools: delete `tool_*_repository.dart` and `tool_repository_index.dart` (including any `*.bak` holdovers). Keep `json_tool_*`.&#x20;
* Flashcards: delete `flashcards/flashcard_repository_index.dart` (and the old “competent\_crew\_flashards.dart”). Wire everything to the JSON flashcard aggregator you added in Phase 1.&#x20;

2. Router & screen tidy

* Remove “legacy fallback” params in routes (e.g., Parts `zone` → pure `module`; Tools `module` fallback only if you intend to keep it).&#x20;

3. Asset audit

* Keep `assets/json/**` (authoritative data). Remove any obsolete CSV scaffolding if you no longer use it at build time. The converter scripts under `assets/json/june_effort/` are optional dev-tools; keep or archive them in a “scripts” folder outside the app bundle so they don’t ship. &#x20;

4. Guardrails for the future

* Add a CI check that fails on any `*_repository_index.dart` import.
* Consider a lightweight unit test that loads a representative sample of JSON lessons/parts/tools and asserts non-empty parse + non-null `RenderItem` build.

---

## What I’ll do first (next step)

Start with Phase 1, Step 1: define the JSON flashcard aggregator surface (categories, by-category lists, and “all” resolver) and switch the flashcard screens + the router’s “custom” route over to it — then run the compile-time legacy-ban to see what, if anything, still references the old indexes. The router import is our canary here.&#x20;

If that plan looks right, say the word and I’ll begin with the Flashcards swap (still minimal, targeted, and reversible).


UPDATED PLAN:
Totally aligned. We’ll make the app **discover** whatever’s in `assets/json/**` at runtime—no hard-coded lists—so editing/adding/removing JSON files is all the dev team has to do.

Here’s the tightened plan that bakes in “no code edits for content changes,” plus how we’ll prove it.

# Phase 1 — Migration with dynamic discovery (no code shown yet)

1. Flashcards → JSON-only, auto-indexed

* **Goal:** remove the last legacy dependency and make drills auto-discoverable.
* **What to change:** replace the router’s reliance on `flashcard_repository_index.dart` and `getAllFlashcards()` with a JSON-backed aggregator that scans the bundle for flashcards across Lessons, Parts, and Tools (from their existing JSON) and builds categories on the fly. Today, `/flashcards/custom` still calls `getAllFlashcards()` from the legacy index; that’s the pinch point to swap out.&#x20;
* **Discovery rule:** enumerate JSON via the asset manifest; parse each file; collect any `flashcards` arrays; derive categories from each file’s `module` (or another field we standardize) so category lists are 100% data-driven.

2. Router stays generic; no module names hard-coded

* **Keep routes generic** (`/lessons`, `/parts`, `/tools`, `/flashcards`) and pass only neutral params like `module` or `toolbag` coming from discovery, not from coded enums. Your router is already parameterized; we’ll just remove the legacy fallbacks once JSON is authoritative.&#x20;

3. Lessons/Parts/Tools lists come from manifest scans

* **Tools are already there:** `JsonToolRepository` scans `AssetManifest.json`, builds an ID→file index, and exposes module names and tool lists. That’s the exact pattern we’ll mirror for Flashcards (and ensure Lessons/Parts do the same), so dropping a new JSON file auto-surfaces in the UI—no edits to Dart. Also note it supports cache invalidation (handy during authoring).&#x20;
* **Audit the rest:** confirm Lessons/Parts repositories enumerate their JSON like Tools do (and update if not), so adding/removing a JSON file changes the app instantly at runtime. File tree shows both JSON repos and legacy side-by-side; we’re making JSON the only source.&#x20;

4. Remove all legacy-based data shaping for Tools/Parts/Lessons

* Any remaining uses of `*_repository_index.dart` (Tools, Parts, Lessons, Flashcards) get excised so that **all** lists, category names, and item IDs come solely from what’s in `assets/json/**`. You can see where legacy indexes are still present today.&#x20;

# Phase 2 — Proof it’s truly data-driven (tests you can run every time)

A) Compile-time “legacy-ban” check

* Temporarily rename the legacy index files (e.g., `lesson_repository_index.dart` → `.bak`) and rebuild. Any remaining import explodes immediately—fix until clean. The file tree shows the exact legacy file names to target.&#x20;

B) Grep gate (local + CI)

* Block merges if code references `repository_index.dart` (or other legacy repos). Keep this gate permanently so no one reintroduces hard-coded lists.&#x20;

C) Dynamic discovery tests (no code edits between steps)

1. **Add** a brand-new JSON file under `assets/json/tools/` with one tool + one flashcard → it should appear in Tools list and also in Flashcards under the correct category.
2. **Rename** a JSON module filename (e.g., `vhf.json` → `comms.json`) → Tools tab should show the new module name; Flashcards category list updates accordingly.
3. **Delete** a JSON file → the module/tool/cards disappear from UI.
4. **Edit** a title/contents in JSON → affected screens reflect new text.

* Tip: you can force a refresh during authoring by calling the existing index invalidator for Tools (`JsonToolRepository.invalidateIndex()`); we’ll add the same for Lessons/Parts/Flashcards so hot restarts pick up file changes quickly.&#x20;

D) Router flows (manual QA)

* Navigate every tab via the BNB (`/`, `/lessons`, `/parts`, `/tools`, `/flashcards`) and drill into items and detail screens to confirm everything on screen is populated from JSON (no coded lists). Your router wiring for these routes is already centralized, which makes this check straightforward.&#x20;

E) Paths sanity

* Open a couple of learning paths (chapters/items) and ensure the IDs those paths reference resolve through the JSON repos (not legacy). If a path still points to legacy-only IDs, update the path JSON so it’s self-contained.&#x20;

# Phase 3 — Cleanup (when Phase 2 is all green)

1. Delete all legacy repos and indexes

* Lessons: remove `lesson_*_repository.dart` and `lesson_repository_index.dart`.
* Parts: remove `part_*_repository.dart` and `part_repository_index.dart`.
* Tools: remove `tool_*_repository.dart` and `tool_repository_index.dart` (and the `*.bak` placeholders).
* Flashcards: remove `flashcard_repository_index.dart` and any hard-coded flashcard sets (e.g., `competent_crew_flashards.dart`). The file tree shows exactly where they live.&#x20;

2. Router tidy

* Remove legacy fallbacks (e.g., Parts `zone` → pure `module`; Tools `toolbag` consistently derived from the file’s `module`), and replace the `/flashcards/custom` legacy call with the JSON aggregator.&#x20;

3. Authoring helpers live outside the shipped app

* Keep your converter scripts (Dart→JSON, JSON↔CSV) in a dev-tools area so they don’t ship with the bundle; they’re great for authoring but should not be runtime dependencies.&#x20;

---

## Why this guarantees “no code edits for content updates”

* **Source of truth = asset manifest + JSON parsing**, not hand-curated lists. Tools already follow this pattern; we extend it to Flashcards (and verify Lessons/Parts do too).&#x20;
* **Router is data-agnostic** and only consumes IDs/modules discovered at runtime (we remove legacy safety fallbacks once JSON is sole source).&#x20;
* **Automated guardrails** (grep gates) prevent anyone from reintroducing hard-coded repositories.&#x20;

If this all sounds right, I’ll start with the Flashcards swap (JSON aggregator + router update for `/flashcards/custom`) so we can run the legacy-ban check immediately afterward.

































Awesome—kicking off Phase 1 with the Flashcards swap. Here’s a surgical, do-this-now checklist (no code yet), plus the quick proof you’ll run right after.

# A. Flashcards → JSON-only (no code pasted; just exact edits to make)

1. Create a JSON-backed flashcard aggregator (new file)

* **Path:** `lib/data/repositories/flashcards/json_flashcard_repository.dart`
* **Surface (methods only, keep signatures simple):**

  * `Future<List<String>> getAllCategories()`
  * `Future<List<Flashcard>> getFlashcardsForCategory(String category)`
  * `Future<List<Flashcard>> getFlashcardsByIds(List<String> ids)` *(for `/flashcards/custom` path)*
  * `void invalidateIndex()` *(optional; mirrors Tools’ cache invalidation)*
* **Behavior:** scan `AssetManifest.json`, enumerate `assets/json/tools/*.json` (+ any lessons/parts JSON you’ve already using), parse each, harvest any `flashcards` arrays, and derive categories from `module` (or a consistent field inside each JSON). You already do this pattern for Tools—copy that discovery approach.&#x20;
* **Why we know data is present:** tool JSON files already embed flashcards (e.g., checklists/calculators/emergency).&#x20;

2. Rewire the router away from legacy

* **Open:** `lib/navigation/app_router.dart`
* **Remove import:** `flashcard_repository_index.dart`
* **Add import:** your new `json_flashcard_repository.dart`
* **Swap the only legacy-dependent route:** in `/flashcards/custom`, stop calling `getAllFlashcards()` from the legacy index; use your new `getFlashcardsByIds(ids)` to build `RenderItem`s. The current code path calls the legacy repo directly here—that’s our pinch point.&#x20;

3. Point Flashcard screens to the JSON aggregator

* **Files:**

  * `screens/flashcards/flashcard_category_screen.dart`
  * `screens/flashcards/flashcard_item_screen.dart`
  * `screens/flashcards/flashcard_detail_screen.dart`
* **What to change:** wherever they import or call the legacy `flashcard_repository_index.dart` helpers (e.g., “all categories”, “cards for category”), point to the new JSON aggregator methods you defined in Step A1. (Router wiring to these screens is already clean; it just needs the new data source.)&#x20;

4. Keep routes & BNB untouched (they’re data-agnostic)

* `/flashcards` & `/flashcards/items` routing stays as is; you’re only changing the data source underneath. See the router definition for the Flashcards branch.&#x20;

# B. Quick proof it’s JSON-only (run right after A)

5. “Legacy-ban” compile check

* Temporarily rename these files (or move to `legacy_hold/`):

  * `lib/data/repositories/flashcards/flashcard_repository_index.dart`
  * (Optionally also rename the old `competent_crew_flashards.dart` if referenced)
* Rebuild. The app should compile. If you still see import errors, finish the swaps above. (File tree shows where these live.)&#x20;

6. Grep gate (fast sanity)

* Run:

  ```
  grep -R "flashcard_repository_index.dart" lib || echo "✅ no legacy flashcard index"
  grep -R "getAllFlashcards(" lib || echo "✅ no legacy all-cards call"
  ```

  Both should show **no matches** once the swap is complete. The router used that call in `/flashcards/custom`; it must be gone now.&#x20;

7. Runtime smoke (2 minutes)

* Bottom tab → **Drills** (Flashcards) → **Category list** loads (from JSON).
* Enter a category → cards list shows.
* Open a card → next/prev work → back preserves context.
* Navigate a **learning path** that pushes `/flashcards/custom` (if you have one wired) → confirm it renders from the JSON aggregator now (no legacy). The `/flashcards/custom` route was the only place hardwired to the legacy “all cards” call.&#x20;

# C. Guardrails (so content edits never need code edits)

8. Match Tools’ discovery pattern for Flashcards

* Use the same manifest scan + per-file parse as `JsonToolRepository` (module/file enumeration + ID lookup + cache + `invalidateIndex()` for hot authoring). This locks in “edit JSON, app updates” with no Dart edits.&#x20;

9. Data reality check (optional but strong)

* Temporarily **add one** flashcard to `assets/json/tools/checklists.json` and **remove one** from `assets/json/tools/emergency.json`. Confirm both the category counts and card lists reflect those changes at runtime—no code changes. (Those JSONs already contain flashcards.)&#x20;

---

If you follow the steps above, Flashcards will be JSON-only and the last legacy dependency will be gone. Then we can run the full repo “legacy-ban” for Lessons/Parts/Tools in one shot.

Give me the word and I’ll provide the minimal code patch list for **A1 → A3** (the new aggregator interface and the two tiny router/screen swaps) so you can paste it straight in and run the checks.  &#x20;
