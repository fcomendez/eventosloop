import 'package:eventosloop/core/config/supabase_runtime.dart';
import 'package:eventosloop/core/utils/relative_time_label.dart';
import 'package:eventosloop/features/communities/models/community_list_item.dart';
import 'package:eventosloop/features/communities/models/community_model.dart';
import 'package:eventosloop/features/communities/services/community_detail_mock_service.dart';
import 'package:eventosloop/features/communities/services/community_supabase_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class CommunityDetailData {
  const CommunityDetailData({
    required this.community,
    required this.posts,
    required this.members,
  });

  final CommunityModel community;
  final List<CommunityPostModel> posts;
  final List<CommunityMemberItem> members;
}

class CommunityDetailService {
  CommunityDetailService({
    CommunitySupabaseService? supabaseService,
    CommunityDetailMockService? mockService,
  })  : _supabase = supabaseService ?? CommunitySupabaseService(),
        _mock = mockService ?? CommunityDetailMockService();

  final CommunitySupabaseService _supabase;
  final CommunityDetailMockService _mock;

  SupabaseClient get _client => Supabase.instance.client;

  Future<CommunityDetailData?> fetchDetail(int communityId) async {
    if (supabaseLive) {
      try {
        final CommunityListItem? item =
            await _supabase.obtenerPorId(communityId);
        if (item == null) {
          return null;
        }
        List<CommunityMemberItem> members = const <CommunityMemberItem>[];
        List<CommunityPostModel> posts = const <CommunityPostModel>[];
        try {
          members = await _supabase.listarMiembros(communityId);
        } catch (_) {}
        try {
          posts = await _fetchPosts(communityId);
        } catch (_) {}
        return CommunityDetailData(
          community: _mapCommunity(item, members),
          posts: posts,
          members: members,
        );
      } catch (_) {
        return null;
      }
    }

    if (allowMockFallback) {
      final CommunityModel? community = await _mock.fetchById(communityId);
      if (community == null) {
        return null;
      }
      final List<CommunityPostModel> posts =
          await _mock.fetchPosts(communityId);
      return CommunityDetailData(
        community: community,
        posts: posts,
        members: const <CommunityMemberItem>[],
      );
    }
    return null;
  }

  CommunityModel _mapCommunity(
    CommunityListItem item,
    List<CommunityMemberItem> members,
  ) {
    final String memberPreview = members.isEmpty
        ? '${item.memberCount} miembros'
        : members
            .take(4)
            .map((CommunityMemberItem m) => m.displayName)
            .join(', ');

    return CommunityModel(
      id: item.id,
      name: item.name,
      category: item.primaryCategory,
      description: item.description.isNotEmpty
          ? item.description
          : 'Comunidad en LOOP.',
      tags: item.interestTags.map((CommunityInterestTag t) => t.name).toList(),
      activityLabel: item.memberCount > 0
          ? '${item.memberCount} miembros · $memberPreview'
          : memberPreview,
      coverColorHex:
          item.interestTags.isNotEmpty ? item.interestTags.first.colorHex : '#0682BC',
      bannerUrl: item.bannerUrl,
      isActive: item.isActive,
    );
  }

  Future<List<CommunityPostModel>> _fetchPosts(int communityId) async {
    final List<Map<String, dynamic>> rows =
        List<Map<String, dynamic>>.from(
      await _client
          .from('publicaciones')
          .select('''
            id_post,
            titulo,
            contenido,
            fecha_publicacion,
            url_media,
            usuario:usuario_id_usuario (nombres, apellidos, username)
          ''')
          .eq('comunidades_id_comunidad', communityId)
          .order('fecha_publicacion', ascending: false),
    );

    return rows.map((Map<String, dynamic> row) {
      final Map<String, dynamic>? usuario =
          row['usuario'] as Map<String, dynamic>?;
      final String? nombres = usuario?['nombres'] as String?;
      final String? apellidos = usuario?['apellidos'] as String?;
      final String? username = usuario?['username'] as String?;
      final String authorName = <String>[
        if (nombres != null && nombres.trim().isNotEmpty) nombres.trim(),
        if (apellidos != null && apellidos.trim().isNotEmpty) apellidos.trim(),
      ].join(' ').trim();

      return CommunityPostModel(
        id: (row['id_post'] as num).toInt(),
        authorName: authorName.isEmpty
            ? (username ?? 'Usuario')
            : authorName,
        authorInitials: authorInitials(
          nombres: nombres,
          apellidos: apellidos,
          username: username,
        ),
        publishedLabel: relativeTimeLabel(
          DateTime.parse(row['fecha_publicacion'] as String),
        ),
        title: row['titulo'] as String? ?? '',
        body: row['contenido'] as String? ?? '',
        linkedTo: 'Comunidad',
        likesCount: 0,
        commentsCount: 0,
        mediaLabel: row['url_media'] != null ? 'Imagen' : null,
        mediaColorHex: '#D9EAF5',
      );
    }).toList();
  }
}
