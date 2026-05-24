class ProfileModel {
  const ProfileModel({
    required this.fullName,
    required this.username,
    required this.avatarInitials,
    required this.postsCount,
    required this.followersCount,
    required this.followingCount,
    required this.eventsAttendedCount,
    required this.communitiesJoinedCount,
    required this.interests,
    required this.imagePosts,
    required this.writtenPosts,
    required this.pastEvents,
    required this.communities,
    this.userId,
    this.isFollowing = false,
    this.avatarUrl,
    this.email,
  });

  final int? userId;
  final bool isFollowing;
  final String fullName;
  final String username;
  final String avatarInitials;
  final String? avatarUrl;
  final String? email;
  final int postsCount;
  final int followersCount;
  final int followingCount;
  final int eventsAttendedCount;
  final int communitiesJoinedCount;
  final List<String> interests;
  final List<ProfileImagePostModel> imagePosts;
  final List<ProfileWrittenPostModel> writtenPosts;
  final List<ProfilePastEventModel> pastEvents;
  final List<ProfileCommunityModel> communities;

  ProfileModel copyWith({
    int? userId,
    String? fullName,
    String? username,
    String? avatarInitials,
    String? avatarUrl,
    String? email,
    int? postsCount,
    int? followersCount,
    int? followingCount,
    int? communitiesJoinedCount,
    bool? isFollowing,
    List<ProfileImagePostModel>? imagePosts,
    List<ProfileWrittenPostModel>? writtenPosts,
    List<ProfileCommunityModel>? communities,
  }) {
    return ProfileModel(
      userId: userId ?? this.userId,
      isFollowing: isFollowing ?? this.isFollowing,
      fullName: fullName ?? this.fullName,
      username: username ?? this.username,
      avatarInitials: avatarInitials ?? this.avatarInitials,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      email: email ?? this.email,
      postsCount: postsCount ?? this.postsCount,
      followersCount: followersCount ?? this.followersCount,
      followingCount: followingCount ?? this.followingCount,
      eventsAttendedCount: eventsAttendedCount,
      communitiesJoinedCount:
          communitiesJoinedCount ?? this.communitiesJoinedCount,
      interests: interests,
      imagePosts: imagePosts ?? this.imagePosts,
      writtenPosts: writtenPosts ?? this.writtenPosts,
      pastEvents: pastEvents,
      communities: communities ?? this.communities,
    );
  }
}

class ProfileCommunityModel {
  const ProfileCommunityModel({
    required this.id,
    required this.name,
    required this.category,
    required this.membersLabel,
    required this.coverColorHex,
  });

  final int id;
  final String name;
  final String category;
  final String membersLabel;
  final String coverColorHex;
}

class ProfileImagePostModel {
  const ProfileImagePostModel({
    required this.id,
    required this.label,
    required this.colorHex,
    this.mediaUrl,
  });

  final int id;
  final String label;
  final String colorHex;
  final String? mediaUrl;
}

class ProfileWrittenPostModel {
  const ProfileWrittenPostModel({
    required this.id,
    required this.authorName,
    required this.publishedLabel,
    required this.body,
    required this.likesCount,
    required this.commentsCount,
  });

  final int id;
  final String authorName;
  final String publishedLabel;
  final String body;
  final int likesCount;
  final int commentsCount;
}

class ProfilePastEventModel {
  const ProfilePastEventModel({
    required this.id,
    required this.day,
    required this.month,
    required this.title,
    required this.location,
    required this.category,
  });

  final int id;
  final String day;
  final String month;
  final String title;
  final String location;
  final String category;
}

class ProfileConnectionModel {
  const ProfileConnectionModel({
    required this.id,
    required this.name,
    required this.username,
    required this.avatarInitials,
    this.avatarUrl,
    required this.isFollowing,
    this.isOnline = false,
  });

  final int id;
  final String name;
  final String username;
  final String avatarInitials;
  final String? avatarUrl;
  final bool isFollowing;
  final bool isOnline;
}
