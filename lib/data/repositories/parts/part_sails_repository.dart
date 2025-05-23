import 'package:bcc5/data/models/part_model.dart';
import 'package:bcc5/data/models/content_block.dart';

class SailsPartRepository {
  static final List<PartItem> partItems = [
    PartItem(
      id: 'part_sails_1.00',
      title: 'Mainsail',
      keywords: ['main', 'power'],
      isPaid: false,
      content: [
        ContentBlock.text(
          'The mainsail is the primary sail on most sailboats.',
        ),
        ContentBlock.image('assets/images/fallback_image.jpeg'),
        ContentBlock.text(
          'It provides power when sailing upwind or across the wind.',
        ),
      ],
      flashcards: [],
    ),
    PartItem(
      id: 'part_sails_2.00',
      title: 'Jib',
      keywords: ['headsail', 'front'],
      isPaid: false,
      content: [
        ContentBlock.text(
          'The jib is a headsail located in front of the mast.',
        ),
        ContentBlock.image('assets/images/fallback_image.jpeg'),
        ContentBlock.text(
          'It works together with the mainsail for efficiency.',
        ),
      ],
      flashcards: [],
    ),
    PartItem(
      id: 'part_sails_3.00',
      title: 'Spinnaker',
      keywords: ['downwind', 'balloon'],
      isPaid: false,
      content: [
        ContentBlock.text(
          'The spinnaker is a large sail used for downwind sailing.',
        ),
        ContentBlock.image('assets/images/fallback_image.jpeg'),
        ContentBlock.text('It is lightweight and shaped like a parachute.'),
      ],
      flashcards: [],
    ),
    PartItem(
      id: 'part_sails_4.00',
      title: 'Boom Vang',
      keywords: ['control', 'boom'],
      isPaid: false,
      content: [
        ContentBlock.text('The boom vang controls downward force on the boom.'),
        ContentBlock.image('assets/images/fallback_image.jpeg'),
        ContentBlock.text('It helps shape the mainsail when sailing downwind.'),
      ],
      flashcards: [],
    ),
    PartItem(
      id: 'part_sails_5.00',
      title: 'Reefing Lines',
      keywords: ['reduce sail', 'safety'],
      isPaid: false,
      content: [
        ContentBlock.text(
          'Reefing lines are used to reduce sail area in strong wind.',
        ),
        ContentBlock.image('assets/images/fallback_image.jpeg'),
        ContentBlock.text('They allow safe sailing by minimizing overpower.'),
      ],
      flashcards: [],
    ),
  ];
}
