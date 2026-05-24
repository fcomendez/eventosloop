import 'package:eventosloop/core/config/supabase_runtime.dart';
import 'package:eventosloop/features/feed/services/feed_service.dart';
import 'package:eventosloop/features/posts/models/post_comment_model.dart';
import 'package:eventosloop/features/posts/services/post_detail_mock_service.dart';
import 'package:eventosloop/features/posts/services/post_supabase_service.dart';

class PostDetailService {
  PostDetailService({
    PostSupabaseService? supabaseService,
    PostDetailMockService? mockService,
  })  : _supabase = supabaseService ?? PostSupabaseService(),
        _mock = mockService ?? PostDetailMockService();

  final PostSupabaseService _supabase;
  final PostDetailMockService _mock;
  final FeedService _feedService = FeedService();

  Future<PostDetailModel?> fetchById(int id) async {
    if (supabaseLive) {
      try {
        return await _supabase.fetchDetail(id);
      } catch (_) {
        return null;
      }
    }
    if (allowMockFallback) {
      return _mock.fetchById(id);
    }
    return null;
  }

  Future<void> addComment({
    required int postId,
    required String text,
  }) async {
    if (supabaseLive) {
      await _supabase.addComment(postId: postId, text: text);
      return;
    }
  }

  Future<void> updatePost({
    required int postId,
    required String title,
    required String body,
    String? communityId,
    String? urlMedia,
  }) async {
    if (supabaseLive) {
      await _supabase.updatePost(
        postId: postId,
        title: title,
        body: body,
        comunidadId: communityId == null ? null : int.tryParse(communityId),
        urlMedia: urlMedia,
      );
      return;
    }
    if (allowMockFallback) {
      await _mock.updatePost(
        postId: postId,
        title: title,
        body: body,
        communityId: communityId,
      );
    }
  }

  Future<void> deletePost(int postId) async {
    if (supabaseLive) {
      await _supabase.deletePost(postId);
      return;
    }
    if (allowMockFallback) {
      await _mock.deletePost(postId);
    }
  }

  Future<bool> toggleLike({
    required int postId,
    required bool currentlyLiked,
  }) async {
    if (supabaseLive) {
      try {
        await _feedService.toggleLike(
          postId: postId,
          currentlyLiked: currentlyLiked,
        );
        return !currentlyLiked;
      } catch (_) {}
    }
    if (allowMockFallback) {
      return !currentlyLiked;
    }
    return currentlyLiked;
  }
}
