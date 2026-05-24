import 'package:eventosloop/core/config/app_env.dart';

import 'package:eventosloop/core/utils/relative_time_label.dart';

import 'package:eventosloop/features/communities/models/community_list_item.dart';
import 'package:eventosloop/features/posts/services/post_supabase_service.dart';

import 'package:eventosloop/features/profile/models/profile_model.dart';

import 'package:supabase_flutter/supabase_flutter.dart';



class ProfilePostsData {

  const ProfilePostsData({

    required this.imagePosts,

    required this.writtenPosts,

  });



  final List<ProfileImagePostModel> imagePosts;

  final List<ProfileWrittenPostModel> writtenPosts;

}



class ProfileFollowStats {

  const ProfileFollowStats({

    required this.followersCount,

    required this.followingCount,

    required this.isFollowing,

  });



  final int followersCount;

  final int followingCount;

  final bool isFollowing;

}



class ProfileSupabaseService {

  ProfileSupabaseService({
    SupabaseClient? client,
    PostSupabaseService? postService,
  })  : _client = client,
        _postService = postService ?? PostSupabaseService(client: client);

  final SupabaseClient? _client;
  final PostSupabaseService _postService;



  SupabaseClient get _supabase => _client ?? Supabase.instance.client;



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



  Future<ProfileHeaderData?> fetchCurrentUserHeader() async {

    if (!AppEnv.useSupabase) {

      return null;

    }

    final int? userId = await _currentUsuarioId();

    if (userId == null) {

      return null;

    }

    return fetchHeaderByUserId(userId);

  }



  Future<ProfileHeaderData?> fetchHeaderByUserId(int userId) async {

    if (!AppEnv.useSupabase) {

      return null;

    }



    final Map<String, dynamic>? row = await _supabase

        .from('usuario')

        .select('id_usuario, nombres, apellidos, username, email, avatar_url')

        .eq('id_usuario', userId)

        .maybeSingle();



    if (row == null) {

      return null;

    }



    final String? nombres = row['nombres'] as String?;

    final String? apellidos = row['apellidos'] as String?;

    final String fullName = <String>[

      if (nombres != null && nombres.trim().isNotEmpty) nombres.trim(),

      if (apellidos != null && apellidos.trim().isNotEmpty) apellidos.trim(),

    ].join(' ').trim();



    final String? usernameRaw = row['username'] as String?;

    final String username = usernameRaw == null || usernameRaw.isEmpty

        ? '@usuario'

        : (usernameRaw.startsWith('@') ? usernameRaw : '@$usernameRaw');



    final List<Map<String, dynamic>> posts =

        await _postService.fetchPostsByUser(userId);



    return ProfileHeaderData(

      userId: userId,

      fullName: fullName.isEmpty ? username.replaceAll('@', '') : fullName,

      username: username,

      email: row['email'] as String? ??

          _supabase.auth.currentUser?.email ??

          '',

      avatarInitials: authorInitials(

        nombres: nombres,

        apellidos: apellidos,

        username: usernameRaw,

      ),

      avatarUrl: row['avatar_url'] as String?,

      postsCount: posts.length,

    );

  }



  Future<ProfilePostsData> fetchUserPosts(int userId) async {

    if (!AppEnv.useSupabase) {

      return const ProfilePostsData(

        imagePosts: <ProfileImagePostModel>[],

        writtenPosts: <ProfileWrittenPostModel>[],

      );

    }



    final List<Map<String, dynamic>> rows =

        await _postService.fetchPostsByUser(userId);

    final List<int> postIds = rows

        .map((Map<String, dynamic> row) => (row['id_post'] as num).toInt())

        .toList();



    final Map<int, int> likesByPost = postIds.isEmpty

        ? <int, int>{}

        : await _countReactions(postIds);

    final Map<int, int> commentsByPost = postIds.isEmpty

        ? <int, int>{}

        : await _countComments(postIds);



    final List<ProfileImagePostModel> imagePosts = <ProfileImagePostModel>[];

    final List<ProfileWrittenPostModel> writtenPosts =

        <ProfileWrittenPostModel>[];



    for (final Map<String, dynamic> row in rows) {

      final int id = (row['id_post'] as num).toInt();

      final String? titulo = row['titulo'] as String?;

      final String contenido = row['contenido'] as String? ?? '';

      final bool hasMedia = row['url_media'] != null;

      final DateTime publishedAt =

          DateTime.parse(row['fecha_publicacion'] as String);

      final Map<String, dynamic>? usuario =

          row['usuario'] as Map<String, dynamic>?;

      final String? nombres = usuario?['nombres'] as String?;

      final String? apellidos = usuario?['apellidos'] as String?;

      final String authorName = <String>[

        if (nombres != null && nombres.trim().isNotEmpty) nombres.trim(),

        if (apellidos != null && apellidos.trim().isNotEmpty) apellidos.trim(),

      ].join(' ').trim();



      if (hasMedia) {

        imagePosts.add(

          ProfileImagePostModel(

            id: id,

            label: titulo ?? contenido,

            colorHex: '#D9EAF5',

            mediaUrl: row['url_media'] as String?,

          ),

        );

      } else {

        writtenPosts.add(

          ProfileWrittenPostModel(

            id: id,

            authorName: authorName.isEmpty ? 'Usuario' : authorName,

            publishedLabel: relativeTimeLabel(publishedAt),

            body: contenido,

            likesCount: likesByPost[id] ?? 0,

            commentsCount: commentsByPost[id] ?? 0,

          ),

        );

      }

    }



    return ProfilePostsData(

      imagePosts: imagePosts,

      writtenPosts: writtenPosts,

    );

  }



  Future<List<ProfileCommunityModel>> fetchUserCommunities(int userId) async {

    if (!AppEnv.useSupabase) {

      return const <ProfileCommunityModel>[];

    }



    final List<Map<String, dynamic>> membresias =

        List<Map<String, dynamic>>.from(

      await _supabase

          .from('miembro_comunidad')

          .select('id_comunidad')

          .eq('usuario_id_usuario', userId),

    );

    if (membresias.isEmpty) {

      return const <ProfileCommunityModel>[];

    }



    final List<int> ids = membresias

        .map((Map<String, dynamic> row) => (row['id_comunidad'] as num).toInt())

        .toList();



    final List<Map<String, dynamic>> data = List<Map<String, dynamic>>.from(

      await _supabase

          .from('comunidades')

          .select('''

            id_comunidad,

            nombre,

            descripcion,

            comunidad_intereses (

              intereses (nombre, color_hex)

            ),

            miembro_comunidad (count)

          ''')

          .inFilter('id_comunidad', ids)

          .eq('estado', 'ACTIVA'),

    );



    return data.map((Map<String, dynamic> row) {

      final CommunityListItem item = CommunityListItem.fromJson(row);

      final CommunityInterestTag? tag =

          item.interestTags.isNotEmpty ? item.interestTags.first : null;

      return ProfileCommunityModel(

        id: item.id,

        name: item.name,

        category: tag?.name ?? 'Comunidad',

        membersLabel: item.membersLabel,

        coverColorHex: tag?.colorHex ?? '#0682BC',

      );

    }).toList();

  }



  Future<ProfileFollowStats> fetchFollowStats({

    required int targetUserId,

  }) async {

    if (!AppEnv.useSupabase) {

      return const ProfileFollowStats(

        followersCount: 0,

        followingCount: 0,

        isFollowing: false,

      );

    }



    final int? currentUserId = await _currentUsuarioId();



    final List<Map<String, dynamic>> followers =

        List<Map<String, dynamic>>.from(

      await _supabase

          .from('seguidores')

          .select('id_usuario_seguidor')

          .eq('id_usuario_seguido', targetUserId),

    );

    final List<Map<String, dynamic>> following =

        List<Map<String, dynamic>>.from(

      await _supabase

          .from('seguidores')

          .select('id_usuario_seguido')

          .eq('id_usuario_seguidor', targetUserId),

    );



    bool isFollowing = false;

    if (currentUserId != null && currentUserId != targetUserId) {

      final List<Map<String, dynamic>> rel = await _supabase

          .from('seguidores')

          .select('id_usuario_seguido')

          .eq('id_usuario_seguidor', currentUserId)

          .eq('id_usuario_seguido', targetUserId);

      isFollowing = rel.isNotEmpty;

    }



    return ProfileFollowStats(

      followersCount: followers.length,

      followingCount: following.length,

      isFollowing: isFollowing,

    );

  }



  Future<List<ProfileConnectionModel>> fetchFollowers(int userId) async {

    return _fetchConnections(userId, asFollowers: true);

  }



  Future<List<ProfileConnectionModel>> fetchFollowing(int userId) async {

    return _fetchConnections(userId, asFollowers: false);

  }



  Future<void> toggleFollow(int targetUserId) async {

    final int? currentUserId = await _currentUsuarioId();

    if (currentUserId == null) {

      throw Exception('Debes iniciar sesion');

    }

    if (currentUserId == targetUserId) {

      return;

    }



    final List<Map<String, dynamic>> existing = await _supabase

        .from('seguidores')

        .select('id_usuario_seguido')

        .eq('id_usuario_seguidor', currentUserId)

        .eq('id_usuario_seguido', targetUserId);



    if (existing.isNotEmpty) {

      await _supabase

          .from('seguidores')

          .delete()

          .eq('id_usuario_seguidor', currentUserId)

          .eq('id_usuario_seguido', targetUserId);

    } else {

      await _supabase.from('seguidores').insert(<String, dynamic>{

        'id_usuario_seguidor': currentUserId,

        'id_usuario_seguido': targetUserId,

      });

    }

  }



  Future<List<ProfileConnectionModel>> _fetchConnections(

    int userId, {

    required bool asFollowers,

  }) async {

    if (!AppEnv.useSupabase) {

      return const <ProfileConnectionModel>[];

    }



    final int? currentUserId = await _currentUsuarioId();

    final String column = asFollowers ? 'id_usuario_seguido' : 'id_usuario_seguidor';

    final String joinColumn =

        asFollowers ? 'id_usuario_seguidor' : 'id_usuario_seguido';



    final List<Map<String, dynamic>> rows =

        List<Map<String, dynamic>>.from(

      await _supabase

          .from('seguidores')

          .select('''

            $joinColumn,

            usuario:$joinColumn (

              id_usuario,

              nombres,

              apellidos,

              username,

              avatar_url

            )

          ''')

          .eq(column, userId),

    );



    final Set<int> myFollowing = <int>{};

    if (currentUserId != null) {

      final List<Map<String, dynamic>> mine = await _supabase

          .from('seguidores')

          .select('id_usuario_seguido')

          .eq('id_usuario_seguidor', currentUserId);

      myFollowing.addAll(

        mine.map((Map<String, dynamic> row) =>

            (row['id_usuario_seguido'] as num).toInt()),

      );

    }



    return rows.map((Map<String, dynamic> row) {

      final Map<String, dynamic>? usuario =

          row['usuario'] as Map<String, dynamic>?;

      final int id = (usuario?['id_usuario'] as num).toInt();

      final String? nombres = usuario?['nombres'] as String?;

      final String? apellidos = usuario?['apellidos'] as String?;

      final String? usernameRaw = usuario?['username'] as String?;

      final String name = <String>[

        if (nombres != null && nombres.trim().isNotEmpty) nombres.trim(),

        if (apellidos != null && apellidos.trim().isNotEmpty) apellidos.trim(),

      ].join(' ').trim();

      final String username = usernameRaw == null || usernameRaw.isEmpty

          ? '@usuario'

          : (usernameRaw.startsWith('@') ? usernameRaw : '@$usernameRaw');



      return ProfileConnectionModel(

        id: id,

        name: name.isEmpty ? username.replaceAll('@', '') : name,

        username: username,

        avatarInitials: authorInitials(

          nombres: nombres,

          apellidos: apellidos,

          username: usernameRaw,

        ),

        avatarUrl: usuario?['avatar_url'] as String?,

        isFollowing: myFollowing.contains(id),

      );

    }).toList();

  }



  Future<Map<int, int>> _countReactions(List<int> postIds) async {

    final List<Map<String, dynamic>> data = await _supabase

        .from('reacciones_post')

        .select('publicaciones_id_post')

        .inFilter('publicaciones_id_post', postIds);

    final Map<int, int> counts = <int, int>{};

    for (final Map<String, dynamic> row in data) {

      final int id = (row['publicaciones_id_post'] as num).toInt();

      counts[id] = (counts[id] ?? 0) + 1;

    }

    return counts;

  }



  Future<Map<int, int>> _countComments(List<int> postIds) async {

    final List<Map<String, dynamic>> data = await _supabase

        .from('comentario')

        .select('publicaciones_id_post')

        .inFilter('publicaciones_id_post', postIds);

    final Map<int, int> counts = <int, int>{};

    for (final Map<String, dynamic> row in data) {

      final int id = (row['publicaciones_id_post'] as num).toInt();

      counts[id] = (counts[id] ?? 0) + 1;

    }

    return counts;

  }

  Future<List<String>> fetchUserInterests(int userId) async {
    if (!AppEnv.useSupabase) {
      return const <String>[];
    }
    final Map<String, dynamic>? usuario = await _supabase
        .from('usuario')
        .select('auth_user_id')
        .eq('id_usuario', userId)
        .maybeSingle();
    final String? authUserId = usuario?['auth_user_id'] as String?;
    if (authUserId == null) {
      return const <String>[];
    }
    final List<Map<String, dynamic>> rows =
        List<Map<String, dynamic>>.from(
      await _supabase
          .from('usuario_intereses')
          .select('intereses (nombre)')
          .eq('auth_user_id', authUserId),
    );
    return rows
        .map((Map<String, dynamic> row) {
          final Map<String, dynamic>? interes =
              row['intereses'] as Map<String, dynamic>?;
          return interes?['nombre'] as String?;
        })
        .whereType<String>()
        .toList();
  }

  Future<List<ProfilePastEventModel>> fetchPastEvents(int userId) async {
    if (!AppEnv.useSupabase) {
      return const <ProfilePastEventModel>[];
    }
    final String nowIso = DateTime.now().toUtc().toIso8601String();
    final List<Map<String, dynamic>> rows =
        List<Map<String, dynamic>>.from(
      await _supabase
          .from('participantes_evento')
          .select('''
            evento:evento_id_evento (
              id_evento,
              titulo,
              direccion,
              ubicacion_direccion,
              fecha_realizacion,
              comunidad:comunidad_id_comunidad (nombre)
            )
          ''')
          .eq('usuario_id_usuario', userId)
          .inFilter('estado_solicitud', <String>['APROBADO', 'CONFIRMADO']),
    );

    final List<ProfilePastEventModel> events = <ProfilePastEventModel>[];
    for (final Map<String, dynamic> row in rows) {
      final Map<String, dynamic>? evento =
          row['evento'] as Map<String, dynamic>?;
      if (evento == null) {
        continue;
      }
      final String? fechaRaw = evento['fecha_realizacion'] as String?;
      if (fechaRaw == null) {
        continue;
      }
      final DateTime fecha = DateTime.parse(fechaRaw);
      if (!fecha.isBefore(DateTime.now())) {
        continue;
      }
      final Map<String, dynamic>? comunidad =
          evento['comunidad'] as Map<String, dynamic>?;
      events.add(_mapPastEvent(evento, comunidad));
    }

    final List<Map<String, dynamic>> hosted =
        List<Map<String, dynamic>>.from(
      await _supabase
          .from('evento')
          .select('''
            id_evento,
            titulo,
            direccion,
            ubicacion_direccion,
            fecha_realizacion,
            comunidad:comunidad_id_comunidad (nombre)
          ''')
          .eq('usuario_id_usuario', userId)
          .lt('fecha_realizacion', nowIso)
          .eq('estado', 'ACTIVO'),
    );
    for (final Map<String, dynamic> evento in hosted) {
      events.add(
        _mapPastEvent(
          evento,
          evento['comunidad'] as Map<String, dynamic>?,
        ),
      );
    }

    return events;
  }

  ProfilePastEventModel _mapPastEvent(
    Map<String, dynamic> evento,
    Map<String, dynamic>? comunidad,
  ) {
    final DateTime fecha =
        DateTime.parse(evento['fecha_realizacion'] as String).toLocal();
    const List<String> meses = <String>[
      'Ene', 'Feb', 'Mar', 'Abr', 'May', 'Jun',
      'Jul', 'Ago', 'Sep', 'Oct', 'Nov', 'Dic',
    ];
    return ProfilePastEventModel(
      id: (evento['id_evento'] as num).toInt(),
      day: '${fecha.day}',
      month: meses[fecha.month - 1],
      title: evento['titulo'] as String? ?? 'Evento',
      location: evento['direccion'] as String? ??
          evento['ubicacion_direccion'] as String? ??
          'Ubicacion',
      category: comunidad?['nombre'] as String? ?? 'Evento',
    );
  }

  Future<ProfileModel?> fetchFullProfile(int userId) async {
    final ProfileHeaderData? header = await fetchHeaderByUserId(userId);
    if (header == null) {
      return null;
    }
    final ProfilePostsData posts = await fetchUserPosts(userId);
    final List<ProfileCommunityModel> communities =
        await fetchUserCommunities(userId);
    final ProfileFollowStats stats =
        await fetchFollowStats(targetUserId: userId);
    final List<String> interests = await fetchUserInterests(userId);
    final List<ProfilePastEventModel> pastEvents =
        await fetchPastEvents(userId);

    return ProfileModel(
      userId: header.userId,
      fullName: header.fullName,
      username: header.username,
      avatarInitials: header.avatarInitials,
      avatarUrl: header.avatarUrl,
      email: header.email,
      postsCount:
          header.postsCount ?? posts.imagePosts.length + posts.writtenPosts.length,
      followersCount: stats.followersCount,
      followingCount: stats.followingCount,
      eventsAttendedCount: pastEvents.length,
      communitiesJoinedCount: communities.length,
      interests: interests,
      imagePosts: posts.imagePosts,
      writtenPosts: posts.writtenPosts,
      pastEvents: pastEvents.take(5).toList(),
      communities: communities,
      isFollowing: stats.isFollowing,
    );
  }

  Future<ProfilePersonalInfoData?> fetchPersonalInfo() async {
    if (!AppEnv.useSupabase) {
      return null;
    }
    final String? authId = _supabase.auth.currentUser?.id;
    if (authId == null) {
      return null;
    }
    final Map<String, dynamic>? row = await _supabase
        .from('usuario')
        .select(
          'id_usuario, nombres, apellidos, username, email, genero, avatar_url, telefono, nacionalidad',
        )
        .eq('auth_user_id', authId)
        .maybeSingle();
    if (row == null) {
      return null;
    }
    final String? nombres = row['nombres'] as String?;
    final String? apellidos = row['apellidos'] as String?;
    final String fullName = <String>[
      if (nombres != null && nombres.trim().isNotEmpty) nombres.trim(),
      if (apellidos != null && apellidos.trim().isNotEmpty) apellidos.trim(),
    ].join(' ').trim();
    final String? usernameRaw = row['username'] as String?;
    final String username = usernameRaw == null || usernameRaw.isEmpty
        ? '@usuario'
        : (usernameRaw.startsWith('@') ? usernameRaw : '@$usernameRaw');
    return ProfilePersonalInfoData(
      userId: (row['id_usuario'] as num).toInt(),
      fullName: fullName.isEmpty ? username.replaceAll('@', '') : fullName,
      username: username,
      email: row['email'] as String? ?? '',
      gender: row['genero'] as String? ?? 'No especificado',
      phone: row['telefono'] as String? ?? '',
      nationality: row['nacionalidad'] as String? ?? 'Chileno',
      avatarInitials: authorInitials(
        nombres: nombres,
        apellidos: apellidos,
        username: usernameRaw,
      ),
      avatarUrl: row['avatar_url'] as String?,
    );
  }

  Future<ProfileSettingsData?> fetchProfileSettings() async {
    if (!AppEnv.useSupabase) {
      return null;
    }
    final String? authId = _supabase.auth.currentUser?.id;
    if (authId == null) {
      return null;
    }
    final Map<String, dynamic>? row = await _supabase
        .from('usuario')
        .select(
          'edad_min_eventos, edad_max_eventos, notificar_eventos_recomendados, mostrar_stats_perfil',
        )
        .eq('auth_user_id', authId)
        .maybeSingle();
    if (row == null) {
      return null;
    }
    return ProfileSettingsData(
      ageMin: (row['edad_min_eventos'] as num?)?.toInt() ?? 18,
      ageMax: (row['edad_max_eventos'] as num?)?.toInt() ?? 35,
      notifyRecommendedEvents:
          row['notificar_eventos_recomendados'] as bool? ?? true,
      showProfileStats: row['mostrar_stats_perfil'] as bool? ?? true,
    );
  }

  Future<void> saveProfileSettings(ProfileSettingsData settings) async {
    if (!AppEnv.useSupabase) {
      throw Exception('Supabase no esta configurado');
    }
    final String? authId = _supabase.auth.currentUser?.id;
    if (authId == null) {
      throw Exception('Debes iniciar sesion');
    }
    await _supabase.from('usuario').update(<String, dynamic>{
      'edad_min_eventos': settings.ageMin,
      'edad_max_eventos': settings.ageMax,
      'notificar_eventos_recomendados': settings.notifyRecommendedEvents,
      'mostrar_stats_perfil': settings.showProfileStats,
    }).eq('auth_user_id', authId);
  }

  Future<void> updatePersonalInfo({
    required String telefono,
    required String nacionalidad,
    required String genero,
    String? avatarUrl,
  }) async {
    if (!AppEnv.useSupabase) {
      throw Exception('Supabase no esta configurado');
    }
    final String? authId = _supabase.auth.currentUser?.id;
    if (authId == null) {
      throw Exception('Debes iniciar sesion');
    }
    final Map<String, dynamic> payload = <String, dynamic>{
      'telefono': telefono.trim(),
      'nacionalidad': nacionalidad.trim(),
      'genero': genero.trim(),
    };
    if (avatarUrl != null && avatarUrl.trim().isNotEmpty) {
      payload['avatar_url'] = avatarUrl.trim();
    }
    await _supabase.from('usuario').update(payload).eq('auth_user_id', authId);
  }

  Future<void> eliminarCuenta({required String password}) async {
    if (!AppEnv.useSupabase) {
      throw Exception('Supabase no esta configurado');
    }
    final String? email = _supabase.auth.currentUser?.email;
    if (email == null || email.isEmpty) {
      throw Exception('No hay sesion activa');
    }

    final AuthResponse reauth = await _supabase.auth.signInWithPassword(
      email: email,
      password: password,
    );
    if (reauth.session == null) {
      throw Exception('Contrasena incorrecta');
    }

    await _supabase.rpc('eliminar_mi_cuenta');
    await _supabase.auth.signOut();
  }

}



class ProfileHeaderData {

  const ProfileHeaderData({

    required this.userId,

    required this.fullName,

    required this.username,

    required this.email,

    required this.avatarInitials,

    this.avatarUrl,

    this.postsCount,

  });



  final int userId;

  final String fullName;

  final String username;

  final String email;

  final String avatarInitials;

  final String? avatarUrl;

  final int? postsCount;

}



class ProfilePersonalInfoData {
  const ProfilePersonalInfoData({
    required this.userId,
    required this.fullName,
    required this.username,
    required this.email,
    required this.gender,
    required this.phone,
    required this.nationality,
    required this.avatarInitials,
    this.avatarUrl,
  });

  final int userId;
  final String fullName;
  final String username;
  final String email;
  final String gender;
  final String phone;
  final String nationality;
  final String avatarInitials;
  final String? avatarUrl;
}

class ProfileSettingsData {
  const ProfileSettingsData({
    required this.ageMin,
    required this.ageMax,
    required this.notifyRecommendedEvents,
    required this.showProfileStats,
  });

  final int ageMin;
  final int ageMax;
  final bool notifyRecommendedEvents;
  final bool showProfileStats;
}


