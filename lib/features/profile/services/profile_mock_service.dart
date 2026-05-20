import 'package:eventosloop/features/profile/models/profile_model.dart';

class ProfileMockService {
  Future<ProfileModel> fetchProfile() async {
    await Future<void>.delayed(const Duration(milliseconds: 350));

    return const ProfileModel(
      fullName: 'Alex Chen',
      username: '@alex_loop_24',
      avatarInitials: 'AC',
      postsCount: 128,
      followersCount: 1200,
      followingCount: 482,
      eventsAttendedCount: 42,
      communitiesJoinedCount: 15,
      interests: <String>['Ajedrez', 'Futbol', 'Coding', 'Lectura'],
      imagePosts: <ProfileImagePostModel>[
        ProfileImagePostModel(id: 1, label: 'UX', colorHex: '#B8DFF6'),
        ProfileImagePostModel(id: 2, label: 'Cine', colorHex: '#D6CDF0'),
        ProfileImagePostModel(id: 3, label: 'Run', colorHex: '#BFE8D4'),
        ProfileImagePostModel(id: 4, label: 'Cafe', colorHex: '#F3D9BD'),
        ProfileImagePostModel(id: 5, label: 'Museo', colorHex: '#C9E6F2'),
        ProfileImagePostModel(id: 6, label: 'Arte', colorHex: '#F0C7C7'),
        ProfileImagePostModel(id: 7, label: 'Tech', colorHex: '#D9EAF5'),
        ProfileImagePostModel(id: 8, label: 'Yoga', colorHex: '#CFE7C1'),
        ProfileImagePostModel(id: 9, label: 'Viaje', colorHex: '#E6D7C3'),
      ],
      writtenPosts: <ProfileWrittenPostModel>[
        ProfileWrittenPostModel(
          id: 1,
          authorName: 'Alex Chen',
          publishedLabel: '2 dias',
          body:
              'Just finished a great coding session with the local community. Loving the new LOOP features!',
          likesCount: 24,
          commentsCount: 8,
        ),
        ProfileWrittenPostModel(
          id: 2,
          authorName: 'Alex Chen',
          publishedLabel: '5 dias',
          body:
              'El workshop de UX me ayudo a entender mejor como se conectan comunidades y eventos.',
          likesCount: 51,
          commentsCount: 13,
        ),
      ],
      pastEvents: <ProfilePastEventModel>[
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
      ],
    );
  }

  Future<List<ProfileConnectionModel>> fetchFollowers() async {
    await Future<void>.delayed(const Duration(milliseconds: 250));
    return const <ProfileConnectionModel>[
      ProfileConnectionModel(
        id: 1,
        name: 'Marcus Chen',
        username: '@marcus_arc',
        avatarInitials: 'MC',
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
