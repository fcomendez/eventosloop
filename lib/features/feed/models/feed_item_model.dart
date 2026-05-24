enum FeedItemType {
  personal,
  evento,
  comunidad,
}

class FeedAuthorModel {
  const FeedAuthorModel({
    required this.name,
    required this.username,
    required this.avatarInitials,
    this.avatarUrl,
  });

  final String name;
  final String username;
  final String avatarInitials;
  final String? avatarUrl;
}

class FeedItemModel {
  const FeedItemModel({
    required this.id,
    required this.type,
    required this.author,
    required this.publishedLabel,
    required this.body,
    required this.likesCount,
    required this.commentsCount,
    required this.sharesCount,
    required this.likedByMe,
    this.title,
    this.contextLabel,
    this.mediaLabel,
    this.mediaColorHex,
    this.mediaUrl,
  });

  final int id;
  final FeedItemType type;
  final FeedAuthorModel author;
  final String publishedLabel;
  final String? title;
  final String body;
  final String? contextLabel;
  final String? mediaLabel;
  final String? mediaColorHex;
  final String? mediaUrl;
  final int likesCount;
  final int commentsCount;
  final int sharesCount;
  final bool likedByMe;

  String get typeLabel {
    switch (type) {
      case FeedItemType.personal:
        return 'Publicacion';
      case FeedItemType.evento:
        return 'Evento vivido';
      case FeedItemType.comunidad:
        return 'Comunidad';
    }
  }
}
