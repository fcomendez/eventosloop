import 'package:eventosloop/core/config/app_env.dart';

import 'package:eventosloop/core/utils/relative_time_label.dart';

import 'package:eventosloop/features/explore/models/explore_catalog_models.dart';

import 'package:eventosloop/features/posts/models/post_comment_model.dart';

import 'package:supabase_flutter/supabase_flutter.dart';



class PostSupabaseService {

  PostSupabaseService({SupabaseClient? client}) : _client = client;



  final SupabaseClient? _client;



  SupabaseClient get _supabase => _client ?? Supabase.instance.client;



  static const String _postSelect = '''

    id_post,

    titulo,

    contenido,

    url_media,

    fecha_publicacion,

    usuario_id_usuario,

    comunidades_id_comunidad,

    usuario:usuario_id_usuario (

      nombres,

      apellidos,

      username

    ),

    comunidad:comunidades_id_comunidad (

      id_comunidad,

      nombre

    )

  ''';



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



  Future<int> crearPublicacion({

    required String titulo,

    required String contenido,

    int? comunidadId,

    String? urlMedia,

  }) async {

    if (!AppEnv.useSupabase) {

      throw Exception('Supabase no esta configurado');

    }

    final int? usuarioId = await _currentUsuarioId();

    if (usuarioId == null) {

      throw Exception('Debes iniciar sesion');

    }

    if (contenido.trim().isEmpty) {

      throw Exception('El contenido no puede estar vacio');

    }



    final Map<String, dynamic> payload = <String, dynamic>{

      'titulo': titulo.trim().isEmpty ? null : titulo.trim(),

      'contenido': contenido.trim(),

      'usuario_id_usuario': usuarioId,

    };

    if (comunidadId != null) {

      payload['comunidades_id_comunidad'] = comunidadId;

    }

    if (urlMedia != null && urlMedia.isNotEmpty) {

      payload['url_media'] = urlMedia;

    }



    final Map<String, dynamic> row = await _supabase

        .from('publicaciones')

        .insert(payload)

        .select('id_post')

        .single();



    return (row['id_post'] as num).toInt();

  }



  Future<PostDetailModel?> fetchDetail(int postId) async {

    if (!AppEnv.useSupabase) {

      return null;

    }

    final Map<String, dynamic>? row = await _supabase

        .from('publicaciones')

        .select(_postSelect)

        .eq('id_post', postId)

        .maybeSingle();

    if (row == null) {

      return null;

    }



    final int? currentUserId = await _currentUsuarioId();

    final int ownerId = (row['usuario_id_usuario'] as num).toInt();

    final int likesCount = await _countLikes(postId);

    final List<PostCommentModel> comments = await fetchComments(postId);

    final bool likedByMe =

        currentUserId == null ? false : await _userLikedPost(currentUserId, postId);



    return _mapDetailRow(

      row,

      likesCount: likesCount,

      comments: comments,

      likedByMe: likedByMe,

      isOwnedByMe: currentUserId != null && currentUserId == ownerId,

    );

  }



  Future<List<PostCommentModel>> fetchComments(int postId) async {

    final List<Map<String, dynamic>> rows =

        List<Map<String, dynamic>>.from(

      await _supabase

          .from('comentario')

          .select('''

            id_comentario,

            texto_comentario,

            fecha_comentario,

            usuario:usuario_id_usuario (nombres, apellidos, username)

          ''')

          .eq('publicaciones_id_post', postId)

          .order('fecha_comentario'),

    );



    return rows.map((Map<String, dynamic> row) {

      final Map<String, dynamic>? usuario =

          row['usuario'] as Map<String, dynamic>?;

      final String? nombres = usuario?['nombres'] as String?;

      final String? apellidos = usuario?['apellidos'] as String?;

      final String? usernameRaw = usuario?['username'] as String?;

      final String displayName = <String>[

        if (nombres != null && nombres.trim().isNotEmpty) nombres.trim(),

        if (apellidos != null && apellidos.trim().isNotEmpty) apellidos.trim(),

      ].join(' ').trim();

      final String authorName = displayName.isEmpty

          ? (usernameRaw ?? 'Usuario')

          : displayName;

      final DateTime fecha =

          DateTime.parse(row['fecha_comentario'] as String);

      return PostCommentModel(

        id: (row['id_comentario'] as num).toInt(),

        authorName: authorName,

        authorInitials: authorInitials(

          nombres: nombres,

          apellidos: apellidos,

          username: usernameRaw,

        ),

        publishedLabel: relativeTimeLabel(fecha),

        body: row['texto_comentario'] as String,

        likesCount: 0,

      );

    }).toList();

  }



  Future<void> addComment({

    required int postId,

    required String text,

  }) async {

    final int? userId = await _currentUsuarioId();

    if (userId == null) {

      throw Exception('Debes iniciar sesion');

    }

    if (text.trim().isEmpty) {

      throw Exception('Escribe un comentario');

    }

    await _supabase.from('comentario').insert(<String, dynamic>{

      'texto_comentario': text.trim(),

      'usuario_id_usuario': userId,

      'publicaciones_id_post': postId,

    });

  }



  Future<void> updatePost({

    required int postId,

    required String title,

    required String body,

    int? comunidadId,

    String? urlMedia,

  }) async {

    final int? userId = await _currentUsuarioId();

    if (userId == null) {

      throw Exception('Debes iniciar sesion');

    }



    final Map<String, dynamic> payload = <String, dynamic>{

      'titulo': title.trim().isEmpty ? null : title.trim(),

      'contenido': body.trim(),

      'comunidades_id_comunidad': comunidadId,

    };

    if (urlMedia != null) {

      payload['url_media'] = urlMedia;

    }



    await _supabase

        .from('publicaciones')

        .update(payload)

        .eq('id_post', postId)

        .eq('usuario_id_usuario', userId);

  }



  Future<void> deletePost(int postId) async {

    final int? userId = await _currentUsuarioId();

    if (userId == null) {

      throw Exception('Debes iniciar sesion');

    }

    await _supabase

        .from('publicaciones')

        .delete()

        .eq('id_post', postId)

        .eq('usuario_id_usuario', userId);

  }



  Future<List<ExploreFeaturedPostItem>> fetchFeatured({int limit = 6}) async {

    if (!AppEnv.useSupabase) {

      return const <ExploreFeaturedPostItem>[];

    }



    final List<Map<String, dynamic>> rows =

        List<Map<String, dynamic>>.from(

      await _supabase

          .from('publicaciones')

          .select(_postSelect)

          .order('fecha_publicacion', ascending: false)

          .limit(limit * 2),

    );

    if (rows.isEmpty) {

      return const <ExploreFeaturedPostItem>[];

    }



    final List<int> postIds = rows

        .map((Map<String, dynamic> row) => (row['id_post'] as num).toInt())

        .toList();

    final Map<int, int> likesByPost = await _countLikesByPosts(postIds);

    final Map<int, int> commentsByPost = await _countCommentsByPosts(postIds);



    rows.sort((Map<String, dynamic> a, Map<String, dynamic> b) {

      final int scoreA = (likesByPost[(a['id_post'] as num).toInt()] ?? 0) +

          (commentsByPost[(a['id_post'] as num).toInt()] ?? 0);

      final int scoreB = (likesByPost[(b['id_post'] as num).toInt()] ?? 0) +

          (commentsByPost[(b['id_post'] as num).toInt()] ?? 0);

      return scoreB.compareTo(scoreA);

    });



    return rows.take(limit).map((Map<String, dynamic> row) {

      final int postId = (row['id_post'] as num).toInt();

      final Map<String, dynamic>? usuario =

          row['usuario'] as Map<String, dynamic>?;

      final Map<String, dynamic>? comunidad =

          row['comunidad'] as Map<String, dynamic>?;

      final String? usernameRaw = usuario?['username'] as String?;

      final String username = usernameRaw == null || usernameRaw.isEmpty

          ? '@usuario'

          : (usernameRaw.startsWith('@') ? usernameRaw : '@$usernameRaw');

      final String? titulo = row['titulo'] as String?;

      final String contenido = row['contenido'] as String? ?? '';

      final bool hasMedia = row['url_media'] != null;

      final String? communityName = comunidad?['nombre'] as String?;



      return ExploreFeaturedPostItem(

        postId: postId,

        user: username,

        linkedTo: communityName != null

            ? 'Comunidad: $communityName'

            : 'Publicacion personal',

        imageLabel: hasMedia ? 'Imagen' : null,

        imageColorHex: '#D9EAF5',

        caption: titulo == null || titulo.isEmpty ? contenido : titulo,

        likes: likesByPost[postId] ?? 0,

        comments: commentsByPost[postId] ?? 0,

        isTextOnly: !hasMedia,

        title: titulo,

        body: contenido,

        replies: commentsByPost[postId] ?? 0,

      );

    }).toList();

  }



  Future<List<Map<String, dynamic>>> fetchPostsByUser(int userId) async {

    return List<Map<String, dynamic>>.from(

      await _supabase

          .from('publicaciones')

          .select(_postSelect)

          .eq('usuario_id_usuario', userId)

          .order('fecha_publicacion', ascending: false),

    );

  }



  Future<int> _countLikes(int postId) async {

    final List<Map<String, dynamic>> data = await _supabase

        .from('reacciones_post')

        .select('publicaciones_id_post')

        .eq('publicaciones_id_post', postId);

    return data.length;

  }



  Future<bool> _userLikedPost(int userId, int postId) async {

    final List<Map<String, dynamic>> data = await _supabase

        .from('reacciones_post')

        .select('publicaciones_id_post')

        .eq('usuario_id_usuario', userId)

        .eq('publicaciones_id_post', postId);

    return data.isNotEmpty;

  }



  Future<Map<int, int>> _countLikesByPosts(List<int> postIds) async {

    if (postIds.isEmpty) {

      return <int, int>{};

    }

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



  Future<Map<int, int>> _countCommentsByPosts(List<int> postIds) async {

    if (postIds.isEmpty) {

      return <int, int>{};

    }

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



  PostDetailModel _mapDetailRow(

    Map<String, dynamic> row, {

    required int likesCount,

    required List<PostCommentModel> comments,

    required bool likedByMe,

    required bool isOwnedByMe,

  }) {

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

    final String authorName = displayName.isEmpty

        ? username.replaceAll('@', '')

        : displayName;



    final DateTime publishedAt =

        DateTime.parse(row['fecha_publicacion'] as String);

    final String? communityName = comunidad?['nombre'] as String?;

    final int? communityId = (comunidad?['id_comunidad'] as num?)?.toInt();



    return PostDetailModel(

      id: (row['id_post'] as num).toInt(),

      authorUserId: (row['usuario_id_usuario'] as num).toInt(),

      authorName: authorName,

      authorInitials: authorInitials(

        nombres: nombres,

        apellidos: apellidos,

        username: usernameRaw,

      ),

      username: username,

      publishedLabel: relativeTimeLabel(publishedAt),

      title: row['titulo'] as String?,

      body: row['contenido'] as String? ?? '',

      mediaLabel: row['url_media'] != null ? 'Imagen' : null,

      mediaColorHex: '#D9EAF5',

      mediaUrl: row['url_media'] as String?,

      likesCount: likesCount,

      commentsCount: comments.length,

      sharesCount: 0,

      likedByMe: likedByMe,

      isOwnedByMe: isOwnedByMe,

      communityId: communityId?.toString(),

      hashtags: communityName != null

          ? <String>['#Comunidad', '#LOOP']

          : <String>['#LOOP', '#Personal'],

      comments: comments,

    );

  }

}


