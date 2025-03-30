// From BCC4: lib/data/repositories/paths/path_repositories.dart

// 🟡 COMMENTARY:
// - Central index file for all learning paths in BCC4.
// - Simply imports and exposes all path lists.
// - BCC5 will likely refactor this into a structured repository with ID → Path map.
// - Still useful as a reference or seed for migration.

import 'learning_path_competent_crew.md';

final Map<String, List<Map<String, String>>> pathRepositories = {
  'competent_crew': competentCrewPath,
  // Add other paths here in the future
};
