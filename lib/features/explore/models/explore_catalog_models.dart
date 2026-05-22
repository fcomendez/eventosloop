class UserLocationContext {
  const UserLocationContext({
    required this.region,
    required this.comuna,
  });

  final String region;
  final String comuna;
}

class ExploreNearbyEventItem {
  const ExploreNearbyEventItem({
    required this.eventId,
    required this.title,
    required this.comuna,
    required this.region,
    required this.distanceLabel,
    required this.dateLabel,
    required this.colorHex,
  });

  final int eventId;
  final String title;
  final String comuna;
  final String region;
  final String distanceLabel;
  final String dateLabel;
  final String colorHex;
}

class ExploreRecommendedCommunityItem {
  const ExploreRecommendedCommunityItem({
    required this.communityId,
    required this.title,
    required this.membersLabel,
    required this.colorHex,
    required this.region,
    required this.matchLabel,
  });

  final int communityId;
  final String title;
  final String membersLabel;
  final String colorHex;
  final String region;
  final String matchLabel;
}

class ExploreUpcomingEventItem {
  const ExploreUpcomingEventItem({
    required this.eventId,
    required this.title,
    required this.locationLabel,
    required this.region,
    required this.comuna,
    required this.dateLabel,
    required this.colorHex,
  });

  final int eventId;
  final String title;
  final String locationLabel;
  final String region;
  final String comuna;
  final String dateLabel;
  final String colorHex;
}

class ExploreFeaturedPostItem {
  const ExploreFeaturedPostItem({
    required this.postId,
    required this.user,
    required this.linkedTo,
    required this.imageLabel,
    required this.imageColorHex,
    required this.caption,
    required this.likes,
    required this.comments,
    this.isTextOnly = false,
    this.title,
    this.body,
    this.replies,
  });

  final int postId;
  final String user;
  final String linkedTo;
  final String? imageLabel;
  final String imageColorHex;
  final String caption;
  final int likes;
  final int comments;
  final bool isTextOnly;
  final String? title;
  final String? body;
  final int? replies;
}
