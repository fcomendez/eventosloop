import 'package:eventosloop/features/events/models/event_model.dart';
import 'package:eventosloop/features/events/models/event_status.dart';

class EventMockService {
  static final List<EventModel> _events = <EventModel>[
    const EventModel(
      id: 1,
      title: 'UX/UI Mastery: The Luminous Curator Deep Dive',
      description:
          'Sesion intensiva sobre diseno de producto, curaduria visual y experiencias digitales para comunidades creativas.',
      category: 'Diseno colectivo',
      subCategory: 'UX/UI',
      hostName: 'Creative Collective',
      dateLabel: 'Manana, 24 Oct',
      timeLabel: '6:30 PM - 8:00 PM',
      address: 'Av. Apoquindo 3000, Las Condes',
      locationName: 'Centro Creativo Las Condes',
      comuna: 'Las Condes',
      latitude: -33.4167,
      longitude: -70.5833,
      capacity: 10,
      joinedCount: 5,
      coverColorHex: '#0E3554',
      communityId: 1,
      isFlash: true,
      isHighlighted: true,
      isPrivate: true,
      whatsappLink: 'https://chat.whatsapp.com/loop-ux-mastery',
      isHostedByMe: true,
      hostAvatarUrl:
          'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?w=160&h=160&fit=crop',
    ),
    const EventModel(
      id: 2,
      title: 'Digital Storytelling in the Age of AI',
      description:
          'Exploramos narrativas digitales, herramientas de IA y formatos para contar historias en comunidad.',
      category: 'LOOP creators',
      hostName: 'Tech Founders Circle',
      dateLabel: 'Sab, 28 Oct',
      timeLabel: '11:00 AM - 12:30 PM',
      address: 'Av. Providencia 1208, Providencia',
      locationName: 'Hub Providencia',
      comuna: 'Providencia',
      latitude: -33.4372,
      longitude: -70.6506,
      capacity: 20,
      joinedCount: 12,
      coverColorHex: '#7A4D22',
      communityId: 2,
      whatsappLink: 'https://chat.whatsapp.com/loop-storytelling',
    ),
    const EventModel(
      id: 3,
      title: 'Founder Meetup: Scaling Beyond Zero',
      description:
          'Encuentro para fundadores: metricas, crecimiento y aprendizajes de equipos en etapa temprana.',
      category: 'Startup hub',
      hostName: 'Tech Founders Circle',
      dateLabel: 'Mar, 31 Oct',
      timeLabel: '5:00 PM - 7:00 PM',
      address: 'Av. Vitacura 2771, Vitacura',
      locationName: 'Espacio Founders',
      comuna: 'Vitacura',
      latitude: -33.3924,
      longitude: -70.5738,
      capacity: 30,
      joinedCount: 18,
      coverColorHex: '#4D6B73',
      communityId: 2,
    ),
    const EventModel(
      id: 4,
      title: 'Running nocturno por el parque',
      description:
          'Salida nocturna de running por el parque con calentamiento, ritmo grupal y hidratacion al final.',
      category: 'Deporte',
      hostName: 'Open Source Explorers',
      dateLabel: '18 MAY, 2026',
      timeLabel: '7:30 PM - 9:00 PM',
      address: 'Av. Bicentenario 3800, Vitacura',
      locationName: 'Parque Bicentenario',
      comuna: 'Vitacura',
      latitude: -33.4020,
      longitude: -70.5980,
      capacity: 15,
      joinedCount: 9,
      coverColorHex: '#0682BC',
      communityId: 3,
      isHostedByMe: true,
    ),
    const EventModel(
      id: 5,
      title: 'Meetup Tecnologia 2026: IA y Frontend',
      description:
          'Charlas rapidas sobre IA aplicada al frontend, demos en vivo y networking entre desarrolladores.',
      category: 'TECH',
      hostName: 'Developers Santiago',
      dateLabel: 'Jueves, 12 de Junio',
      timeLabel: '19:00 - 21:30',
      address: 'Av. Las Condes 12345, Las Condes',
      locationName: 'Espacio Tech Las Condes',
      comuna: 'Las Condes',
      latitude: -33.4080,
      longitude: -70.5670,
      capacity: 40,
      joinedCount: 22,
      coverColorHex: '#005F9A',
      communityId: 2,
      isFlash: true,
    ),
    const EventModel(
      id: 6,
      title: 'Yoga al amanecer',
      description: 'Sesion de yoga al aire libre para empezar el dia con energia.',
      category: 'Bienestar',
      hostName: 'Outdoor Chile',
      dateLabel: 'Hoy',
      timeLabel: '7:00 AM - 8:00 AM',
      address: 'Av. Providencia 2650, Providencia',
      locationName: 'Parque Bustamante',
      comuna: 'Providencia',
      latitude: -33.4410,
      longitude: -70.6320,
      capacity: 25,
      joinedCount: 14,
      coverColorHex: '#4D6B73',
      communityId: 1,
    ),
  ];

  Future<EventModel?> fetchById(int id) async {
    await Future<void>.delayed(const Duration(milliseconds: 120));
    try {
      return _events.firstWhere((EventModel event) => event.id == id);
    } catch (_) {
      return null;
    }
  }

  Future<List<EventModel>> fetchByCommunityId(int communityId) async {
    await Future<void>.delayed(const Duration(milliseconds: 120));
    return _events
        .where((EventModel event) => event.communityId == communityId)
        .toList();
  }

  Future<void> updateEvent({
    required int eventId,
    required String title,
    required String description,
    required String dateLabel,
    required String timeLabel,
    required String address,
    String? comuna,
    int? communityId,
    int? capacity,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 220));
    final int index = _events.indexWhere((EventModel e) => e.id == eventId);
    if (index == -1) {
      return;
    }
    final EventModel current = _events[index];
    _events[index] = EventModel(
      id: current.id,
      title: title,
      description: description,
      category: current.category,
      subCategory: current.subCategory,
      hostName: current.hostName,
      dateLabel: dateLabel,
      timeLabel: timeLabel,
      address: address,
      locationName: current.locationName,
      comuna: comuna ?? current.comuna,
      latitude: current.latitude,
      longitude: current.longitude,
      capacity: capacity ?? current.capacity,
      joinedCount: current.joinedCount,
      coverColorHex: current.coverColorHex,
      communityId: communityId ?? current.communityId,
      isFlash: current.isFlash,
      isHighlighted: current.isHighlighted,
      isPrivate: current.isPrivate,
      whatsappLink: current.whatsappLink,
      isHostedByMe: current.isHostedByMe,
      status: current.status,
      hostAvatarUrl: current.hostAvatarUrl,
    );
  }

  Future<void> updateEventStatus({
    required int eventId,
    required EventStatus status,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 180));
    final int index = _events.indexWhere((EventModel e) => e.id == eventId);
    if (index == -1) {
      return;
    }
    final EventModel current = _events[index];
    _events[index] = EventModel(
      id: current.id,
      title: current.title,
      description: current.description,
      category: current.category,
      subCategory: current.subCategory,
      hostName: current.hostName,
      dateLabel: current.dateLabel,
      timeLabel: current.timeLabel,
      address: current.address,
      locationName: current.locationName,
      comuna: current.comuna,
      latitude: current.latitude,
      longitude: current.longitude,
      capacity: current.capacity,
      joinedCount: current.joinedCount,
      coverColorHex: current.coverColorHex,
      communityId: current.communityId,
      isFlash: current.isFlash,
      isHighlighted: current.isHighlighted,
      isPrivate: current.isPrivate,
      whatsappLink: current.whatsappLink,
      isHostedByMe: current.isHostedByMe,
      status: status,
      hostAvatarUrl: current.hostAvatarUrl,
    );
  }

  Future<void> cancelEvent(int eventId) async {
    await Future<void>.delayed(const Duration(milliseconds: 220));
    _events.removeWhere((EventModel event) => event.id == eventId);
  }
}
