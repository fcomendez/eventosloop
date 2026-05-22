import 'package:eventosloop/core/utils/relative_time_label.dart';
import 'package:eventosloop/features/feed/models/feed_item_model.dart';
import 'package:eventosloop/features/feed/models/feed_page_result.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class FeedSupabaseService {
  FeedSupabaseService({SupabaseClient? client}) : _client = client;

  final SupabaseClient? _client;

  static const int _pageSize = 6;

  SupabaseClient get _supabase => _client ?? Supabase.instance.client;

  Future<FeedPageResult> fetchPage({int? cursor}) async {
    dynamic query = _supabase
        .from('publicaciones')
        .select('''
          id_post,
          titulo,
          contenido,
          url_media,
          fecha_publicacion,
          usuario:usuario_id_usuario (
            nombres,
            apellidos,
            username
          ),
          comunidad:comunidades_id_comunidad (
            id_comunidad,
            nombre
          )
        ''')
        .order('id_post', ascending: false)
        .limit(_pageSize);

    if (cursor != null) {
      query = query.lt('id_post', cursor);
    }

    final List<Map<String, dynamic>> rows =
        List<Map<String, dynamic>>.from(await query);

    if (rows.isEmpty) {
      return FeedPageResult(
        items: const <FeedItemModel>[],
        nextCursor: cursor,
        hasMore: false,
      );
    }

    final List<int> postIds = rows
        .map((Map<String, dynamic> row) => (row['id_post'] as num).toInt())
        .toList();
    final int? currentUserId = await _currentUsuarioId();
    final Map<int, int> likesByPost = await _countByPost(
      table: 'reacciones_post',
      postIds: postIds,
    );
    final Map<int, int> commentsByPost = await _countByPost(
      table: 'comentario',
      postIds: postIds,
      column: 'publicaciones_id_post',
    );
    final Set<int> likedByMe = currentUserId == null
        ? <int>{}
        : await _likedPostIds(currentUserId, postIds);

    final List<FeedItemModel> items = rows
        .map(
          (Map<String, dynamic> row) => _mapRow(
            row,
            likesCount: likesByPost[(row['id_post'] as num).toInt()] ?? 0,
            commentsCount:
                commentsByPost[(row['id_post'] as num).toInt()] ?? 0,
            likedByMe: likedByMe.contains((row['id_post'] as num).toInt()),
          ),
        )
        .toList();

    return FeedPageResult(
      items: items,
      nextCursor: items.last.id,
      hasMore: rows.length >= _pageSize,
    );
  }

  FeedItemModel _mapRow(
    Map<String, dynamic> row, {
    required int likesCount,
    required int commentsCount,
    required bool likedByMe,
  }) {
    final int id = (row['id_post'] as num).toInt();
    final Map<String, dynamic>? usuario =
        row['usuario'] as Map<String, dynamic>?;
    final Map<String, dynamic>? comunidad =
        row['comunidad'] as Map<String, dynamic>?;

    final String? nombres = usuario?['nombres'] as String?;
    final String? apellidos = usuario?['apellidos'] as String?;
    final String? usernameRaw = usuario?['username'] as String?;
    final String displayName = <String>[
      if (nombres != null && nombres.trim().isNotEmpty) nombres.trim(),
      if (apellidos != null && apellidos.trim().isNotEmpty) apellidos.trim(),
    ].join(' ').trim();
    final String username = usernameRaw == null || usernameRaw.isEmpty
        ? '@usuario'
        : (usernameRaw.startsWith('@') ? usernameRaw : '@$usernameRaw');

    final DateTime publishedAt = DateTime.parse(
      row['fecha_publicacion'] as String,
    );
    final String? communityName = comunidad?['nombre'] as String?;
    final bool hasCommunity =
        communityName != null && communityName.trim().isNotEmpty;

    return FeedItemModel(
      id: id,
      type: hasCommunity ? FeedItemType.comunidad : FeedItemType.personal,
      author: FeedAuthorModel(
        name: displayName.isEmpty ? username.replaceAll('@', '') : displayName,
        username: username,
        avatarInitials: authorInitials(
          nombres: nombres,
          apellidos: apellidos,
          username: usernameRaw,
        ),
        avatarUrl: usuario?['avatar_url'] as String?,
      ),
      publishedLabel: relativeTimeLabel(publishedAt),
      title: row['titulo'] as String?,
      body: row['contenido'] as String? ?? '',
      contextLabel: hasCommunity ? 'Comunidad: $communityName' : null,
      mediaLabel: row['url_media'] != null ? 'Imagen' : null,
      mediaColorHex: '#D9EAF5',
      likesCount: likesCount,
      commentsCount: commentsCount,
      sharesCount: 0,
      likedByMe: likedByMe,
    );
  }

  Future<int?> _currentUsuarioId() async {
    final String? authId = _supabase.auth.currentUser?.id;
    if (authId == null) {
      return null;
    }
    final Map<String, dynamic>? row = await _supabase
        .from('usuario')
        .select('id_usuario')
        .eq('auth_user_id', authId)
        .maybeSingle();
    return (row?['id_usuario'] as num?)?.toInt();
  }

  Future<Map<int, int>> _countByPost({
    required String table,
    required List<int> postIds,
    String column = 'publicaciones_id_post',
  }) async {
    if (postIds.isEmpty) {
      return <int, int>{};
    }
    final List<Map<String, dynamic>> data = await _supabase
        .from(table)
        .select(column)
        .inFilter(column, postIds);
    final Map<int, int> counts = <int, int>{};
    for (final Map<String, dynamic> row in data) {
      final int postId = (row[column] as num).toInt();
      counts[postId] = (counts[postId] ?? 0) + 1;
    }
    return counts;
  }

  Future<Set<int>> _likedPostIds(int userId, List<int> postIds) async {
    if (postIds.isEmpty) {
      return <int>{};
    }
    final List<Map<String, dynamic>> data = await _supabase
        .from('reacciones_post')
        .select('publicaciones_id_post')
        .eq('usuario_id_usuario', userId)
        .inFilter('publicaciones_id_post', postIds);
    return data
        .map((Map<String, dynamic> row) =>
            (row['publicaciones_id_post'] as num).toInt())
        .toSet();
  }
}
