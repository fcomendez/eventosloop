class CommunityModel {
  const CommunityModel({
    required this.id,
    required this.name,
    required this.category,
    required this.description,
    required this.tags,
    required this.activityLabel,
    required this.coverColorHex,
    this.bannerUrl,
    this.isActive = true,
  });

  final int id;
  final String name;
  final String category;
  final String description;
  final List<String> tags;
  final String activityLabel;
  final String coverColorHex;
  final String? bannerUrl;
  final bool isActive;
}

class CommunityPostModel {
  const CommunityPostModel({
    required this.id,
    required this.authorName,
    required this.authorInitials,
    required this.publishedLabel,
    required this.title,
    required this.body,
    required this.linkedTo,
    required this.likesCount,
    required this.commentsCount,
    this.mediaLabel,
    this.mediaColorHex,
    this.isLinked = false,
  });

  final int id;
  final String authorName;
  final String authorInitials;
  final String publishedLabel;
  final String title;
  final String body;
  final String linkedTo;
  final int likesCount;
  final int commentsCount;
  final String? mediaLabel;
  final String? mediaColorHex;
  final bool isLinked;
}
