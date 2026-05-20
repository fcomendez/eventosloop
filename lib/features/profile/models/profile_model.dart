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
  });

  final String fullName;
  final String username;
  final String avatarInitials;
  final int postsCount;
  final int followersCount;
  final int followingCount;
  final int eventsAttendedCount;
  final int communitiesJoinedCount;
  final List<String> interests;
  final List<ProfileImagePostModel> imagePosts;
  final List<ProfileWrittenPostModel> writtenPosts;
  final List<ProfilePastEventModel> pastEvents;
}

class ProfileImagePostModel {
  const ProfileImagePostModel({
    required this.id,
    required this.label,
    required this.colorHex,
  });

  final int id;
  final String label;
  final String colorHex;
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
    required this.isFollowing,
    this.isOnline = false,
  });

  final int id;
  final String name;
  final String username;
  final String avatarInitials;
  final bool isFollowing;
  final bool isOnline;
}
