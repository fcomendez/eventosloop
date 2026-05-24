import 'package:eventosloop/core/config/app_env.dart';
import 'package:eventosloop/core/config/supabase_runtime.dart';
import 'package:eventosloop/features/feed/models/feed_page_result.dart';
import 'package:eventosloop/features/feed/services/feed_mock_service.dart';
import 'package:eventosloop/features/feed/services/feed_supabase_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Facade del feed: intenta Supabase primero y conserva mock como respaldo.
class FeedService {
  FeedService({
    FeedSupabaseService? supabaseService,
    FeedMockService? mockService,
  })  : _supabase = supabaseService ?? FeedSupabaseService(),
        _mock = mockService ?? FeedMockService();

  final FeedSupabaseService _supabase;
  final FeedMockService _mock;

  Future<FeedPageResult> fetchPage({int? cursor}) async {
    if (supabaseLive) {
      return await _supabase.fetchPage(cursor: cursor);
    }
    return _mock.fetchPage(cursor: cursor);
  }

  Future<void> toggleLike({
    required int postId,
    required bool currentlyLiked,
  }) async {
    final bool canUseSupabase = AppEnv.useSupabase &&
        Supabase.instance.client.auth.currentSession != null;
    if (!canUseSupabase) {
      return;
    }
    await _supabase.toggleLike(
      postId: postId,
      currentlyLiked: currentlyLiked,
    );
  }
}
