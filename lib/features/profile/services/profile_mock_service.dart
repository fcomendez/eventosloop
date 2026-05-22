import 'package:eventosloop/features/profile/models/profile_model.dart';

class ProfileMockService {
  static const List<ProfileCommunityModel> _defaultCommunities =
      <ProfileCommunityModel>[
    ProfileCommunityModel(
      id: 1,
      name: 'Creative Collective',
      category: 'Arte y diseno',
      membersLabel: '3.2k miembros',
      coverColorHex: '#C9D9D1',
    ),
    ProfileCommunityModel(
      id: 2,
      name: 'Tech Founders Circle',
      category: 'Emprendimiento',
      membersLabel: '980 miembros',
      coverColorHex: '#192B3A',
    ),
    ProfileCommunityModel(
      id: 3,
      name: 'Open Source Explorers',
      category: 'Tecnologia',
      membersLabel: '1.2k miembros',
      coverColorHex: '#0E3554',
    ),
    ProfileCommunityModel(
      id: 4,
      name: 'Digital Canvas Lab',
      category: 'Fotografia y arte',
      membersLabel: '640 miembros',
      coverColorHex: '#D8B46A',
    ),
  ];

  static const List<ProfilePastEventModel> _defaultPastEvents =
      <ProfilePastEventModel>[
    ProfilePastEventModel(
      id: 4,
      day: '18',
      month: 'MAY',
      title: 'Running nocturno por el parque',
      location: 'Parque Bicentenario',
      category: 'Deporte',
    ),
    ProfilePastEventModel(
      id: 3,
      day: '12',
      month: 'MAY',
      title: 'Workshop de UX Editorial',
      location: 'Centro Creativo LOOP',
      category: 'Tecnologia',
    ),
    ProfilePastEventModel(
      id: 2,
      day: '02',
      month: 'MAY',
      title: 'Noche de Museos',
      location: 'Museo de Arte Moderno',
      category: 'Cultura',
    ),
    ProfilePastEventModel(
      id: 1,
      day: '25',
      month: 'ABR',
      title: 'Chess Tournament #4',
      location: 'Grand Master Hall',
      category: 'Ajedrez',
    ),
    ProfilePastEventModel(
      id: 5,
      day: '10',
      month: 'ABR',
      title: 'Meetup Tecnologia 2026',
      location: 'Las Condes',
      category: 'Tecnologia',
    ),
    ProfilePastEventModel(
      id: 6,
      day: '28',
      month: 'MAR',
      title: 'Yoga al amanecer',
      location: 'Providencia',
      category: 'Bienestar',
    ),
  ];

  Future<ProfileModel> fetchProfile() async {
    await Future<void>.delayed(const Duration(milliseconds: 350));
    return _ownProfile();
  }

  Future<ProfileModel> fetchProfileByUserId(int userId) async {
    await Future<void>.delayed(const Duration(milliseconds: 350));
    return _profiles[userId] ?? _profiles[101]!;
  }

  Future<List<ProfilePastEventModel>> fetchPastEvents({int? userId}) async {
    await Future<void>.delayed(const Duration(milliseconds: 120));
    if (userId == null) {
      return _defaultPastEvents;
    }
    return _profiles[userId]?.pastEvents ?? _defaultPastEvents;
  }

  ProfileModel _ownProfile() {
    return ProfileModel(
      userId: null,
      fullName: 'Alex Chen',
      username: '@alex_loop_24',
      avatarInitials: 'AC',
      avatarUrl:
          'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?w=320&h=320&fit=crop',
      postsCount: 128,
      followersCount: 1200,
      followingCount: 482,
      eventsAttendedCount: 42,
      communitiesJoinedCount: 15,
      interests: const <String>['Ajedrez', 'Futbol', 'Coding', 'Lectura'],
      imagePosts: const <ProfileImagePostModel>[
        ProfileImagePostModel(id: 118, label: 'UX', colorHex: '#B8DFF6'),
        ProfileImagePostModel(id: 119, label: 'Cine', colorHex: '#D6CDF0'),
        ProfileImagePostModel(id: 117, label: 'Run', colorHex: '#BFE8D4'),
        ProfileImagePostModel(id: 115, label: 'Cafe', colorHex: '#F3D9BD'),
        ProfileImagePostModel(id: 114, label: 'Museo', colorHex: '#C9E6F2'),
        ProfileImagePostModel(id: 112, label: 'Arte', colorHex: '#F0C7C7'),
        ProfileImagePostModel(id: 110, label: 'Tech', colorHex: '#D9EAF5'),
        ProfileImagePostModel(id: 301, label: 'Yoga', colorHex: '#CFE7C1'),
        ProfileImagePostModel(id: 120, label: 'Viaje', colorHex: '#E6D7C3'),
      ],
      writtenPosts: const <ProfileWrittenPostModel>[
        ProfileWrittenPostModel(
          id: 118,
          authorName: 'Alex Chen',
          publishedLabel: '2 dias',
          body:
              'Just finished a great coding session with the local community. Loving the new LOOP features!',
          likesCount: 24,
          commentsCount: 8,
        ),
        ProfileWrittenPostModel(
          id: 120,
          authorName: 'Alex Chen',
          publishedLabel: '5 dias',
          body:
              'El workshop de UX me ayudo a entender mejor como se conectan comunidades y eventos.',
          likesCount: 51,
          commentsCount: 13,
        ),
      ],
      pastEvents: _defaultPastEvents.take(4).toList(),
      communities: _defaultCommunities,
    );
  }

  static final Map<int, ProfileModel> _profiles = <int, ProfileModel>{
    101: ProfileModel(
      userId: 101,
      fullName: 'Martina Flores',
      username: '@martina.loop',
      avatarInitials: 'MF',
      postsCount: 86,
      followersCount: 940,
      followingCount: 210,
      eventsAttendedCount: 28,
      communitiesJoinedCount: 9,
      isFollowing: false,
      interests: const <String>['Running', 'Fotografia', 'Cafe'],
      imagePosts: const <ProfileImagePostModel>[
        ProfileImagePostModel(id: 201, label: 'Parque', colorHex: '#BFE8D4'),
        ProfileImagePostModel(id: 202, label: 'Loop', colorHex: '#D9EAF5'),
      ],
      writtenPosts: const <ProfileWrittenPostModel>[
        ProfileWrittenPostModel(
          id: 201,
          authorName: 'Martina Flores',
          publishedLabel: '1 dia',
          body: 'Gran salida grupal despues del trabajo. Buen ritmo y buena energia.',
          likesCount: 42,
          commentsCount: 11,
        ),
      ],
      pastEvents: _defaultPastEvents.take(3).toList(),
      communities: _defaultCommunities.take(3).toList(),
    ),
    102: ProfileModel(
      userId: 102,
      fullName: 'Diego Rojas',
      username: '@diego.dev',
      avatarInitials: 'DR',
      postsCount: 64,
      followersCount: 520,
      followingCount: 180,
      eventsAttendedCount: 19,
      communitiesJoinedCount: 6,
      isFollowing: true,
      interests: const <String>['Flutter', 'UX', 'Startups'],
      imagePosts: const <ProfileImagePostModel>[
        ProfileImagePostModel(id: 203, label: 'Dev', colorHex: '#0E3554'),
      ],
      writtenPosts: const <ProfileWrittenPostModel>[
        ProfileWrittenPostModel(
          id: 120,
          authorName: 'Diego Rojas',
          publishedLabel: '3 dias',
          body: 'Que llevarian a una jornada creativa? Busco recomendaciones.',
          likesCount: 31,
          commentsCount: 18,
        ),
      ],
      pastEvents: _defaultPastEvents.take(2).toList(),
      communities: _defaultCommunities.take(2).toList(),
    ),
    103: ProfileModel(
      userId: 103,
      fullName: 'Camila Torres',
      username: '@camila.foodie',
      avatarInitials: 'CT',
      postsCount: 112,
      followersCount: 1800,
      followingCount: 340,
      eventsAttendedCount: 35,
      communitiesJoinedCount: 11,
      isFollowing: false,
      interests: const <String>['Gastronomia', 'Eventos', 'Viajes'],
      imagePosts: const <ProfileImagePostModel>[
        ProfileImagePostModel(id: 115, label: 'Sabores', colorHex: '#F3D9BD'),
      ],
      writtenPosts: const <ProfileWrittenPostModel>[
        ProfileWrittenPostModel(
          id: 115,
          authorName: 'Camila Torres',
          publishedLabel: '4 dias',
          body: 'Probamos cafeterias nuevas y varios stands de comida chilena.',
          likesCount: 76,
          commentsCount: 24,
        ),
      ],
      pastEvents: _defaultPastEvents.take(4).toList(),
      communities: _defaultCommunities,
    ),
  };

  Future<List<ProfileConnectionModel>> fetchFollowers() async {
    await Future<void>.delayed(const Duration(milliseconds: 250));
    return const <ProfileConnectionModel>[
      ProfileConnectionModel(
        id: 1,
        name: 'Marcus Chen',
        username: '@marcus_arc',
        avatarInitials: 'MC',
        avatarUrl:
            'https://images.unsplash.com/photo-1506794778202-cad84cf45f1d?w=200',
        isFollowing: true,
        isOnline: true,
      ),
      ProfileConnectionModel(
        id: 2,
        name: 'Elena Rodriguez',
        username: '@elena_creates',
        avatarInitials: 'ER',
        isFollowing: false,
      ),
      ProfileConnectionModel(
        id: 3,
        name: 'David Park',
        username: '@dpark_studio',
        avatarInitials: 'DP',
        isFollowing: true,
      ),
      ProfileConnectionModel(
        id: 4,
        name: 'Sarah Jenkins',
        username: '@s_jenkins',
        avatarInitials: 'SJ',
        isFollowing: true,
      ),
      ProfileConnectionModel(
        id: 5,
        name: 'Leo Thompson',
        username: '@thompson_vibe',
        avatarInitials: 'LT',
        isFollowing: false,
        isOnline: true,
      ),
    ];
  }

  Future<List<ProfileConnectionModel>> fetchFollowing() async {
    await Future<void>.delayed(const Duration(milliseconds: 250));
    return const <ProfileConnectionModel>[
      ProfileConnectionModel(
        id: 11,
        name: 'Creative Collective',
        username: '@creativeclub',
        avatarInitials: 'CC',
        isFollowing: true,
      ),
      ProfileConnectionModel(
        id: 12,
        name: 'Tech Founders',
        username: '@techfounders',
        avatarInitials: 'TF',
        isFollowing: true,
        isOnline: true,
      ),
      ProfileConnectionModel(
        id: 13,
        name: 'Urban Gardeners',
        username: '@urbangardeners',
        avatarInitials: 'UG',
        isFollowing: true,
      ),
      ProfileConnectionModel(
        id: 14,
        name: 'Salsa Santiago',
        username: '@salsasantiago',
        avatarInitials: 'SS',
        isFollowing: true,
      ),
    ];
  }
}
