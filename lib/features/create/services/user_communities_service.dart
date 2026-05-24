import 'package:eventosloop/core/config/supabase_runtime.dart';
import 'package:eventosloop/features/communities/models/community_list_item.dart';
import 'package:eventosloop/features/communities/services/community_supabase_service.dart';
import 'package:eventosloop/features/create/data/user_communities_mock.dart';

class UserCommunitiesService {
  UserCommunitiesService({CommunitySupabaseService? communityService})
      : _communityService = communityService ?? CommunitySupabaseService();

  final CommunitySupabaseService _communityService;

  Future<List<UserCommunityOption>> fetchParticipando() async {
    if (supabaseLive) {
      final List<CommunityListItem> items =
          await _communityService.listarMisComunidades();
      return items
          .map(
            (CommunityListItem item) => UserCommunityOption(
              id: '${item.id}',
              name: item.name,
            ),
          )
          .toList();
    }
    if (allowMockFallback) {
      return UserCommunitiesMock.participando;
    }
    return const <UserCommunityOption>[];
  }

  UserCommunityOption? findById(
    List<UserCommunityOption> communities,
    String? id,
  ) {
    if (id == null) {
      return null;
    }
    for (final UserCommunityOption community in communities) {
      if (community.id == id) {
        return community;
      }
    }
    return null;
  }
}
