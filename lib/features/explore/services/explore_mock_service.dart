import 'dart:math' as math;

import 'package:eventosloop/core/config/app_env.dart';
import 'package:eventosloop/core/services/geocoding_service.dart';
import 'package:eventosloop/core/services/location_service.dart';
import 'package:eventosloop/features/communities/models/community_list_item.dart';
import 'package:eventosloop/features/communities/services/community_supabase_service.dart';
import 'package:eventosloop/features/events/models/event_model.dart';
import 'package:eventosloop/features/events/services/event_service.dart';
import 'package:eventosloop/features/explore/models/explore_catalog_models.dart';
import 'package:eventosloop/features/posts/services/post_supabase_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ExploreMockService {
  ExploreMockService({
    LocationService? locationService,
    GeocodingService? geocodingService,
  })  : _locationService = locationService ?? LocationService(),
        _geocodingService = geocodingService ?? GeocodingService();

  final LocationService _locationService;
  final GeocodingService _geocodingService;

  static const UserLocationContext _fallbackLocation = UserLocationContext(
    region: 'Metropolitana de Santiago',
    comuna: 'Providencia',
    latitude: -33.4372,
    longitude: -70.6506,
  );

  UserLocationContext? _cachedLocation;

  static const double _fallbackLat = -33.4372;
  static const double _fallbackLon = -70.6506;

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
    if (_cachedLocation != null) {
      return _cachedLocation!;
    }

    try {
      final position = await _locationService.getCurrentPosition();
      final ReverseGeocodingResult? reverse =
          await _geocodingService.reverseGeocode(
        latitude: position.latitude,
        longitude: position.longitude,
      );
      _cachedLocation = UserLocationContext(
        region: reverse?.region ?? _fallbackLocation.region,
        comuna: reverse?.comuna ?? _fallbackLocation.comuna,
        latitude: position.latitude,
        longitude: position.longitude,
      );
    } catch (_) {
      _cachedLocation = _fallbackLocation;
    }

    return _cachedLocation!;
  }

  UserLocationContext get currentUserLocation =>
      _cachedLocation ?? _fallbackLocation;

  Future<List<ExploreNearbyEventItem>> fetchNearbyEvents() async {
    final UserLocationContext location = await fetchUserLocation();
    final double userLat = location.latitude ?? _fallbackLat;
    final double userLon = location.longitude ?? _fallbackLon;

    if (AppEnv.useSupabase &&
        Supabase.instance.client.auth.currentSession != null) {
      try {
        final EventService eventService = EventService();
        final List<EventModel> events =
            await eventService.listarProximos(limit: 20);
        if (events.isNotEmpty) {
          final List<_ScoredEvent> scored = events
              .map(
                (EventModel event) => _ScoredEvent(
                  event: event,
                  distanceKm: _distanceKm(
                    userLat,
                    userLon,
                    event.latitude,
                    event.longitude,
                  ),
                ),
              )
              .toList()
            ..sort((_ScoredEvent a, _ScoredEvent b) {
              if (a.event.comuna == location.comuna &&
                  b.event.comuna != location.comuna) {
                return -1;
              }
              if (b.event.comuna == location.comuna &&
                  a.event.comuna != location.comuna) {
                return 1;
              }
              return a.distanceKm.compareTo(b.distanceKm);
            });
          return scored
              .map(
                (_ScoredEvent item) => ExploreNearbyEventItem(
                  eventId: item.event.id,
                  title: item.event.title,
                  comuna: item.event.comuna,
                  region: location.region,
                  distanceLabel: '${item.distanceKm.toStringAsFixed(1)} km',
                  dateLabel:
                      '${item.event.dateLabel} ${item.event.timeLabel}'.trim(),
                  colorHex: item.event.coverColorHex,
                ),
              )
              .toList();
        }
      } catch (_) {}
    }
    await Future<void>.delayed(const Duration(milliseconds: 120));
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
    final UserLocationContext location = await fetchUserLocation();
    if (AppEnv.useSupabase) {
      try {
        final CommunitySupabaseService service = CommunitySupabaseService();
        final List<CommunityListItem> items = await service.listarExplorables();
        if (items.isNotEmpty) {
          return items
              .map((CommunityListItem item) => _mapCommunityListItem(item, location))
              .toList();
        }
      } catch (_) {
        // Fallback al mock si Supabase falla.
      }
    }
    await Future<void>.delayed(const Duration(milliseconds: 120));
    return _recommendedCommunities
        .where(
          (ExploreRecommendedCommunityItem item) =>
              item.region == location.region,
        )
        .toList();
  }

  ExploreRecommendedCommunityItem _mapCommunityListItem(
    CommunityListItem item,
    UserLocationContext location,
  ) {
    final CommunityInterestTag? firstTag =
        item.interestTags.isNotEmpty ? item.interestTags.first : null;
    return ExploreRecommendedCommunityItem(
      communityId: item.id,
      title: item.name,
      membersLabel: item.membersLabel,
      colorHex: firstTag?.colorHex ?? '#0682BC',
      region: location.region,
      matchLabel: firstTag != null
          ? 'Interes: ${firstTag.name}'
          : 'Comunidad recomendada',
    );
  }

  Future<List<ExploreUpcomingEventItem>> fetchUpcomingEvents() async {
    final UserLocationContext location = await fetchUserLocation();
    if (AppEnv.useSupabase) {
      try {
        final EventService eventService = EventService();
        final List<EventModel> events =
            await eventService.listarProximos(limit: 12);
        if (events.isNotEmpty) {
          return events
              .map((EventModel event) => _mapUpcomingEvent(event, location))
              .toList();
        }
      } catch (_) {
        // Fallback al mock.
      }
    }
    await Future<void>.delayed(const Duration(milliseconds: 120));
    return List<ExploreUpcomingEventItem>.from(_upcomingEvents);
  }

  ExploreUpcomingEventItem _mapUpcomingEvent(
    EventModel event,
    UserLocationContext location,
  ) {
    return ExploreUpcomingEventItem(
      eventId: event.id,
      title: event.title,
      locationLabel: event.locationName,
      region: location.region,
      comuna: event.comuna,
      dateLabel: event.dateLabel,
      colorHex: event.coverColorHex,
    );
  }

  Future<List<ExploreFeaturedPostItem>> fetchFeaturedPosts() async {
    if (AppEnv.useSupabase &&
        Supabase.instance.client.auth.currentSession != null) {
      try {
        final PostSupabaseService service = PostSupabaseService();
        final List<ExploreFeaturedPostItem> items =
            await service.fetchFeatured(limit: 6);
        if (items.isNotEmpty) {
          return items;
        }
      } catch (_) {}
    }
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

  double _distanceKm(
    double lat1,
    double lon1,
    double lat2,
    double lon2,
  ) {
    const double earthRadius = 6371;
    final double dLat = _toRadians(lat2 - lat1);
    final double dLon = _toRadians(lon2 - lon1);
    final double a = math.sin(dLat / 2) * math.sin(dLat / 2) +
        math.cos(_toRadians(lat1)) *
            math.cos(_toRadians(lat2)) *
            math.sin(dLon / 2) *
            math.sin(dLon / 2);
    final double c = 2 * math.asin(math.sqrt(a));
    return earthRadius * c;
  }

  double _toRadians(double deg) => deg * 3.141592653589793 / 180;
}

class _ScoredEvent {
  const _ScoredEvent({required this.event, required this.distanceKm});

  final EventModel event;
  final double distanceKm;
}
