import 'package:bcc5/data/models/part_model.dart';
import 'part_deck_repository.dart';
import 'part_hull_repository.dart';
import 'part_rigging_repository.dart';
import 'part_sails_repository.dart';
import 'part_interior_repository.dart';

final Map<String, List<PartItem>> allPartRepositories = {
  'Deck': deckParts,
  'Hull': hullParts,
  'Rigging': riggingParts,
  'Sails': sailsParts,
  'Interior': interiorParts,
};

final List<PartItem> allParts = [
  ...deckParts,
  ...hullParts,
  ...riggingParts,
  ...sailsParts,
  ...interiorParts,
];
