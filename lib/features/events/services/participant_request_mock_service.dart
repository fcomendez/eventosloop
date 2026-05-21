import 'package:eventosloop/features/events/models/participant_request_model.dart';

class ParticipantRequestMockService {
  static const int defaultPrivateEventId = 1;
  static const String defaultPrivateEventTitle =
      'UX/UI Mastery: The Luminous Curator Deep Dive';

  int get pendingCount => _items.length;

  Future<List<ParticipantRequestModel>> fetchByEventId(int eventId) async {
    await Future<void>.delayed(const Duration(milliseconds: 180));
    return _items.where((ParticipantRequestModel r) => r.eventId == eventId).toList();
  }

  static final List<ParticipantRequestModel> _items = <ParticipantRequestModel>[
    const ParticipantRequestModel(
      id: 1,
      userName: 'Clara Montes',
      userInitials: 'CM',
      communityName: 'CREATIVE ARTS',
      category: 'Diseno',
      skills: <String>['UX DESIGN', 'PHOTOGRAPHY'],
      eventId: 1,
    ),
    const ParticipantRequestModel(
      id: 2,
      userName: 'Julian Herrera',
      userInitials: 'JH',
      communityName: 'TECH INNOVATORS',
      category: 'Tecnologia',
      skills: <String>['SOFTWARE ARCHITECT', 'BLOCKCHAIN'],
      eventId: 1,
    ),
    const ParticipantRequestModel(
      id: 3,
      userName: 'Elena Vargas',
      userInitials: 'EV',
      communityName: 'DIGITAL MARKETING',
      category: 'Arte',
      skills: <String>['MARKETING', 'CONTENT STRATEGY'],
      eventId: 1,
    ),
    const ParticipantRequestModel(
      id: 4,
      userName: 'Roberto Soler',
      userInitials: 'RS',
      communityName: '3D DESIGNERS',
      category: 'Diseno',
      skills: <String>['MOTION GRAPHICS', '3D ART'],
      eventId: 1,
    ),
  ];
}
