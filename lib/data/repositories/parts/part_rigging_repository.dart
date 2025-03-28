import 'package:bcc5/data/models/part_model.dart';
import 'package:bcc5/data/models/content_block.dart';

final List<PartItem> riggingParts = [
  PartItem(
    id: 'part_rigging_1.00',
    title: 'Standing Rigging',
    keywords: ['mast', 'support', 'wires'],
    content: [
      ContentBlock.text('Standing rigging supports the mast.'),
      ContentBlock.image('assets/images/fallback_image.jpeg'),
      ContentBlock.text('It includes stays and shrouds that remain in place.'),
    ],
  ),
  PartItem(
    id: 'part_rigging_2.00',
    title: 'Running Rigging',
    keywords: ['lines', 'sails'],
    content: [
      ContentBlock.text('Running rigging is used to raise and trim sails.'),
      ContentBlock.image('assets/images/fallback_image.jpeg'),
      ContentBlock.text('These lines are adjustable and operated frequently.'),
    ],
  ),
  PartItem(
    id: 'part_rigging_3.00',
    title: 'Turnbuckles',
    keywords: ['tension', 'adjustment'],
    content: [
      ContentBlock.text('Turnbuckles adjust tension in standing rigging.'),
      ContentBlock.image('assets/images/fallback_image.jpeg'),
      ContentBlock.text('They are threaded devices used for fine tuning.'),
    ],
  ),
  PartItem(
    id: 'part_rigging_4.00',
    title: 'Chainplates',
    keywords: ['attachment', 'structure'],
    content: [
      ContentBlock.text('Chainplates anchor the rigging to the hull.'),
      ContentBlock.image('assets/images/fallback_image.jpeg'),
      ContentBlock.text('They transfer rigging loads to the boat’s structure.'),
    ],
  ),
  PartItem(
    id: 'part_rigging_5.00',
    title: 'Mast Boot',
    keywords: ['seal', 'leak prevention'],
    content: [
      ContentBlock.text(
        'The mast boot seals the base of the mast at the deck.',
      ),
      ContentBlock.image('assets/images/fallback_image.jpeg'),
      ContentBlock.text('It helps prevent water from leaking below.'),
    ],
  ),
];
