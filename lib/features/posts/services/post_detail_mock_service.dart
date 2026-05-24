import 'package:eventosloop/features/communities/models/community_model.dart';
import 'package:eventosloop/features/communities/services/community_detail_mock_service.dart';
import 'package:eventosloop/features/feed/models/feed_item_model.dart';
import 'package:eventosloop/features/feed/services/feed_mock_service.dart';
import 'package:eventosloop/features/posts/models/post_comment_model.dart';

class PostDetailMockService {
  final CommunityDetailMockService _communityService =
      CommunityDetailMockService();

  static final List<PostCommentModel> _defaultComments = <PostCommentModel>[
    const PostCommentModel(
      id: 1,
      authorName: 'Sarah Jenkins',
      authorInitials: 'SJ',
      publishedLabel: 'hace 1 h',
      body:
          'Excelente reflexion. Me encanta como la comunidad esta impulsando cambios reales.',
      likesCount: 12,
    ),
    const PostCommentModel(
      id: 2,
      authorName: 'Marcus King',
      authorInitials: 'MK',
      publishedLabel: 'hace 45 min',
      body: 'Gracias por compartir el proceso. Muy inspirador para el equipo.',
      likesCount: 8,
    ),
    const PostCommentModel(
      id: 3,
      authorName: 'Elena Rodriguez',
      authorInitials: 'ER',
      publishedLabel: 'hace 30 min',
      body: 'Sumaria este enfoque a nuestro proximo meetup. Gran aporte.',
      likesCount: 5,
    ),
  ];

  Future<PostDetailModel?> fetchById(int id) async {
    await Future<void>.delayed(const Duration(milliseconds: 120));
    final FeedItemModel? feedItem = _findFeedItem(id);
    if (feedItem != null) {
      return _fromFeedItem(feedItem);
    }
    final PostDetailModel? mockPost = _mockPosts[id];
    if (mockPost != null) {
      return mockPost;
    }
    return _fromCommunityPost(id);
  }

  Future<PostDetailModel?> _fromCommunityPost(int id) async {
    for (final int communityId in <int>[1, 2, 3, 4]) {
      final List<CommunityPostModel> posts =
          await _communityService.fetchPosts(communityId);
      for (final CommunityPostModel post in posts) {
        if (post.id == id) {
          return PostDetailModel(
            id: post.id,
            authorName: post.authorName,
            authorInitials: post.authorInitials,
            username: '@${post.authorName.toLowerCase().replaceAll(' ', '.')}',
            publishedLabel: post.publishedLabel,
            title: post.title,
            body: post.body,
            mediaLabel: post.mediaLabel,
            mediaColorHex: post.mediaColorHex,
            likesCount: post.likesCount,
            commentsCount: post.commentsCount,
            sharesCount: 0,
            likedByMe: false,
            isOwnedByMe: post.id == 301,
            communityId: 'creative',
            hashtags: post.isLinked
                ? const <String>['#Vinculado', '#Comunidad', '#LOOP']
                : const <String>['#Comunidad', '#LOOP'],
            comments: _defaultComments,
          );
        }
      }
    }
    return null;
  }

  FeedItemModel? _findFeedItem(int id) {
    final FeedMockService service = FeedMockService();
    for (final FeedItemModel item in service.allItems) {
      if (item.id == id) {
        return item;
      }
    }
    return null;
  }

  PostDetailModel _fromFeedItem(FeedItemModel item) {
    return PostDetailModel(
      id: item.id,
      authorName: item.author.name,
      authorInitials: item.author.avatarInitials,
      username: item.author.username,
      publishedLabel: item.publishedLabel,
      title: item.title,
      body: item.body,
      mediaLabel: item.mediaLabel,
      mediaColorHex: item.mediaColorHex,
      likesCount: item.likesCount,
      commentsCount: item.commentsCount,
      sharesCount: item.sharesCount,
      likedByMe: item.likedByMe,
      isOwnedByMe: item.id == 301,
      communityId: 'tech',
      hashtags: _hashtagsFor(item),
      comments: _defaultComments,
    );
  }

  List<String> _hashtagsFor(FeedItemModel item) {
    return switch (item.type) {
      FeedItemType.personal => <String>['#LOOP', '#Comunidad', '#Descubrimientos'],
      FeedItemType.evento => <String>['#Eventos', '#Networking', '#LOOP'],
      FeedItemType.comunidad => <String>['#Comunidad', '#Creatividad', '#LOOP'],
    };
  }

  static final Map<int, PostDetailModel> _mockPosts = <int, PostDetailModel>{
    301: PostDetailModel(
      id: 301,
      authorName: 'Alex Rivero',
      authorInitials: 'AR',
      username: '@alex.rivero',
      publishedLabel: 'hace 2 h',
      title: 'Transicion hacia economia circular',
      body:
          'Hoy compartimos como nuestra comunidad avanzo hacia un modelo de economia circular, reduciendo residuos en un 40% este trimestre. El cambio empieza con pequenas acciones colectivas.',
      mediaLabel: 'Reciclaje',
      mediaColorHex: '#6B9080',
      likesCount: 1200,
      commentsCount: 84,
      sharesCount: 32,
      likedByMe: false,
      isActive: true,
      isOwnedByMe: true,
      communityId: 'opensource',
      hashtags: const <String>[
        '#Sustainability',
        '#CircularEconomy',
        '#LoopCommunity',
      ],
      comments: _defaultComments,
    ),
  };

  Future<void> updatePost({
    required int postId,
    required String title,
    required String body,
    String? communityId,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 200));
    final PostDetailModel? existing = _mockPosts[postId];
    if (existing != null) {
      _mockPosts[postId] = PostDetailModel(
        id: existing.id,
        authorName: existing.authorName,
        authorInitials: existing.authorInitials,
        username: existing.username,
        publishedLabel: existing.publishedLabel,
        title: title,
        body: body,
        mediaLabel: existing.mediaLabel,
        mediaColorHex: existing.mediaColorHex,
        likesCount: existing.likesCount,
        commentsCount: existing.commentsCount,
        sharesCount: existing.sharesCount,
        likedByMe: existing.likedByMe,
        isActive: existing.isActive,
        isOwnedByMe: existing.isOwnedByMe,
        communityId: communityId ?? existing.communityId,
        hashtags: existing.hashtags,
        comments: existing.comments,
      );
    }
  }

  Future<void> deletePost(int postId) async {
    await Future<void>.delayed(const Duration(milliseconds: 200));
    _mockPosts.remove(postId);
  }
}
