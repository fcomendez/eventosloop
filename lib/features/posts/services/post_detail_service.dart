import 'package:eventosloop/core/config/app_env.dart';
import 'package:eventosloop/features/feed/services/feed_service.dart';
import 'package:eventosloop/features/posts/models/post_comment_model.dart';
import 'package:eventosloop/features/posts/services/post_detail_mock_service.dart';
import 'package:eventosloop/features/posts/services/post_supabase_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class PostDetailService {
  PostDetailService({
    PostSupabaseService? supabaseService,
    PostDetailMockService? mockService,
  })  : _supabase = supabaseService ?? PostSupabaseService(),
        _mock = mockService ?? PostDetailMockService();

  final PostSupabaseService _supabase;
  final PostDetailMockService _mock;
  final FeedService _feedService = FeedService();

  bool get _canUseSupabase =>
      AppEnv.useSupabase &&
      Supabase.instance.client.auth.currentSession != null;

  Future<PostDetailModel?> fetchById(int id) async {
    if (_canUseSupabase) {
      try {
        final PostDetailModel? post = await _supabase.fetchDetail(id);
        if (post != null) {
          return post;
        }
      } catch (_) {}
    }
    return _mock.fetchById(id);
  }

  Future<void> addComment({
    required int postId,
    required String text,
  }) async {
    if (_canUseSupabase) {
      try {
        await _supabase.addComment(postId: postId, text: text);
        return;
      } catch (_) {}
    }
  }

  Future<void> updatePost({
    required int postId,
    required String title,
    required String body,
    String? communityId,
    String? urlMedia,
  }) async {
    if (_canUseSupabase) {
      try {
        await _supabase.updatePost(
          postId: postId,
          title: title,
          body: body,
          comunidadId: communityId == null ? null : int.tryParse(communityId),
          urlMedia: urlMedia,
        );
        return;
      } catch (_) {}
    }
    await _mock.updatePost(
      postId: postId,
      title: title,
      body: body,
      communityId: communityId,
    );
  }

  Future<void> deletePost(int postId) async {
    if (_canUseSupabase) {
      try {
        await _supabase.deletePost(postId);
        return;
      } catch (_) {}
    }
    await _mock.deletePost(postId);
  }

  Future<bool> toggleLike({
    required int postId,
    required bool currentlyLiked,
  }) async {
    if (_canUseSupabase) {
      try {
        await _feedService.toggleLike(
          postId: postId,
          currentlyLiked: currentlyLiked,
        );
        return !currentlyLiked;
      } catch (_) {}
    }
    return !currentlyLiked;
  }
}
