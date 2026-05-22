import 'package:eventosloop/features/explore/models/explore_catalog_models.dart';

class ExploreMockService {
  static const UserLocationContext currentUserLocation = UserLocationContext(
    region: 'Metropolitana de Santiago',
    comuna: 'Providencia',
  );

  static final List<ExploreNearbyEventItem> _nearbyEvents =
      <ExploreNearbyEventItem>[
    const ExploreNearbyEventItem(
      eventId: 6,
      title: 'Yoga al amanecer',
      comuna: 'Providencia',
      region: 'Metropolitana de Santiago',
      distanceLabel: '1.8 km',
      dateLabel: 'Hoy 07:30',
      colorHex: '#7BC8B7',
    ),
    const ExploreNearbyEventItem(
      eventId: 2,
      title: 'Cafe y lectura',
      comuna: 'Nuñoa',
      region: 'Metropolitana de Santiago',
      distanceLabel: '2.4 km',
      dateLabel: 'Hoy 18:00',
      colorHex: '#D9A441',
    ),
    const ExploreNearbyEventItem(
      eventId: 4,
      title: 'Running nocturno',
      comuna: 'Las Condes',
      region: 'Metropolitana de Santiago',
      distanceLabel: '3.1 km',
      dateLabel: 'Manana 20:00',
      colorHex: '#0E3554',
    ),
    const ExploreNearbyEventItem(
      eventId: 1,
      title: 'UX/UI Mastery Deep Dive',
      comuna: 'Las Condes',
      region: 'Metropolitana de Santiago',
      distanceLabel: '4.0 km',
      dateLabel: 'Manana 18:30',
      colorHex: '#0E3554',
    ),
    const ExploreNearbyEventItem(
      eventId: 5,
      title: 'Meetup Tecnologia 2026',
      comuna: 'Las Condes',
      region: 'Metropolitana de Santiago',
      distanceLabel: '4.5 km',
      dateLabel: 'Jue 19:00',
      colorHex: '#005F9A',
    ),
  ];

  static final List<ExploreRecommendedCommunityItem> _recommendedCommunities =
      <ExploreRecommendedCommunityItem>[
    const ExploreRecommendedCommunityItem(
      communityId: 1,
      title: 'Creative Collective',
      membersLabel: '3.2k miembros',
      colorHex: '#C9D9D1',
      region: 'Metropolitana de Santiago',
      matchLabel: 'Por tus intereses en arte y diseno',
    ),
    const ExploreRecommendedCommunityItem(
      communityId: 2,
      title: 'Tech Founders Circle',
      membersLabel: '980 miembros',
      colorHex: '#192B3A',
      region: 'Metropolitana de Santiago',
      matchLabel: 'Recomendada por perfil emprendedor',
    ),
    const ExploreRecommendedCommunityItem(
      communityId: 3,
      title: 'Open Source Explorers',
      membersLabel: '1.2k miembros',
      colorHex: '#0E3554',
      region: 'Metropolitana de Santiago',
      matchLabel: 'Popular en Providencia',
    ),
    const ExploreRecommendedCommunityItem(
      communityId: 4,
      title: 'Digital Canvas Lab',
      membersLabel: '640 miembros',
      colorHex: '#D8B46A',
      region: 'Metropolitana de Santiago',
      matchLabel: 'Comunidades similares a las tuyas',
    ),
  ];

  static final List<ExploreUpcomingEventItem> _upcomingEvents =
      <ExploreUpcomingEventItem>[
    const ExploreUpcomingEventItem(
      eventId: 5,
      title: 'Festival urbano',
      locationLabel: 'Santiago Centro',
      region: 'Metropolitana de Santiago',
      comuna: 'Santiago',
      dateLabel: 'Sab 25',
      colorHex: '#C94F4F',
    ),
    const ExploreUpcomingEventItem(
      eventId: 1,
      title: 'Torneo de ajedrez',
      locationLabel: 'La Reina',
      region: 'Metropolitana de Santiago',
      comuna: 'La Reina',
      dateLabel: 'Dom 26',
      colorHex: '#2C3E50',
    ),
    const ExploreUpcomingEventItem(
      eventId: 3,
      title: 'Taller de ceramica',
      locationLabel: 'Barrio Italia',
      region: 'Metropolitana de Santiago',
      comuna: 'Providencia',
      dateLabel: 'Mar 28',
      colorHex: '#B97955',
    ),
    const ExploreUpcomingEventItem(
      eventId: 2,
      title: 'Digital Storytelling in the Age of AI',
      locationLabel: 'Hub Providencia',
      region: 'Metropolitana de Santiago',
      comuna: 'Providencia',
      dateLabel: 'Sab 28 Oct',
      colorHex: '#7A4D22',
    ),
  ];

  static final List<ExploreFeaturedPostItem> _featuredPosts =
      <ExploreFeaturedPostItem>[
    const ExploreFeaturedPostItem(
      postId: 118,
      user: '@martina.loop',
      linkedTo: 'Comunidad: Running Santiago',
      imageLabel: 'Atardecer en el parque',
      imageColorHex: '#B8DFF6',
      caption:
          'Gran salida grupal despues del trabajo. Buen ritmo, buena energia y nuevas personas para seguir entrenando.',
      likes: 42,
      comments: 11,
    ),
    ExploreFeaturedPostItem(
      postId: 120,
      user: '@diego.dev',
      linkedTo: 'Evento: Workshop UX Editorial',
      imageLabel: null,
      imageColorHex: '#D9EAF5',
      caption: '',
      likes: 31,
      comments: 18,
      isTextOnly: true,
      title: 'Que llevarian a una jornada creativa?',
      body:
          'Estoy armando mi lista para el proximo encuentro y quiero recomendaciones de materiales, libros o apps utiles.',
      replies: 18,
    ),
    const ExploreFeaturedPostItem(
      postId: 115,
      user: '@camila.foodie',
      linkedTo: 'Evento: Feria gastronomica',
      imageLabel: 'Sabores locales',
      imageColorHex: '#F3D9BD',
      caption:
          'Probamos cafeterias nuevas y varios stands de comida chilena. Recomendadisimo para ir en grupo.',
      likes: 76,
      comments: 24,
    ),
  ];

  Future<UserLocationContext> fetchUserLocation() async {
    await Future<void>.delayed(const Duration(milliseconds: 80));
    return currentUserLocation;
  }

  Future<List<ExploreNearbyEventItem>> fetchNearbyEvents() async {
    await Future<void>.delayed(const Duration(milliseconds: 120));
    final UserLocationContext location = currentUserLocation;
    return _nearbyEvents
        .where(
          (ExploreNearbyEventItem event) =>
              event.region == location.region,
        )
        .toList()
      ..sort((ExploreNearbyEventItem a, ExploreNearbyEventItem b) {
        if (a.comuna == location.comuna && b.comuna != location.comuna) {
          return -1;
        }
        if (b.comuna == location.comuna && a.comuna != location.comuna) {
          return 1;
        }
        return a.distanceLabel.compareTo(b.distanceLabel);
      });
  }

  Future<List<ExploreRecommendedCommunityItem>>
      fetchRecommendedCommunities() async {
    await Future<void>.delayed(const Duration(milliseconds: 120));
    return _recommendedCommunities
        .where(
          (ExploreRecommendedCommunityItem item) =>
              item.region == currentUserLocation.region,
        )
        .toList();
  }

  Future<List<ExploreUpcomingEventItem>> fetchUpcomingEvents() async {
    await Future<void>.delayed(const Duration(milliseconds: 120));
    return List<ExploreUpcomingEventItem>.from(_upcomingEvents);
  }

  Future<List<ExploreFeaturedPostItem>> fetchFeaturedPosts() async {
    await Future<void>.delayed(const Duration(milliseconds: 80));
    return List<ExploreFeaturedPostItem>.from(_featuredPosts);
  }

  List<ExploreNearbyEventItem> previewNearbyEvents({int limit = 3}) {
    return _nearbyEvents.take(limit).toList();
  }

  List<ExploreRecommendedCommunityItem> previewRecommendedCommunities(
      {int limit = 3}) {
    return _recommendedCommunities.take(limit).toList();
  }

  List<ExploreUpcomingEventItem> previewUpcomingEvents({int limit = 3}) {
    return _upcomingEvents.take(limit).toList();
  }
}
