class PostCommentModel {
  const PostCommentModel({
    required this.id,
    required this.authorName,
    required this.authorInitials,
    required this.publishedLabel,
    required this.body,
    required this.likesCount,
  });

  final int id;
  final String authorName;
  final String authorInitials;
  final String publishedLabel;
  final String body;
  final int likesCount;
}

class PostDetailModel {
  const PostDetailModel({
    required this.id,
    required this.authorName,
    required this.authorInitials,
    required this.username,
    required this.publishedLabel,
    required this.body,
    required this.likesCount,
    required this.commentsCount,
    required this.sharesCount,
    required this.likedByMe,
    required this.hashtags,
    required this.comments,
    this.title,
    this.mediaLabel,
    this.mediaColorHex,
    this.mediaUrl,
    this.isActive = true,
    this.isOwnedByMe = false,
    this.communityId,
  });

  final int id;
  final String authorName;
  final String authorInitials;
  final String username;
  final String publishedLabel;
  final String? title;
  final String body;
  final String? mediaLabel;
  final String? mediaColorHex;
  final String? mediaUrl;
  final int likesCount;
  final int commentsCount;
  final int sharesCount;
  final bool likedByMe;
  final bool isActive;
  final bool isOwnedByMe;
  final String? communityId;
  final List<String> hashtags;
  final List<PostCommentModel> comments;
}
