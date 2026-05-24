import 'package:eventosloop/core/config/app_env.dart';
import 'package:eventosloop/features/communities/models/community_list_item.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class CommunitySupabaseService {
  CommunitySupabaseService({SupabaseClient? client}) : _client = client;

  final SupabaseClient? _client;

  SupabaseClient get _supabase => _client ?? Supabase.instance.client;

  static const String _listSelect = '''
    id_comunidad,
    nombre,
    descripcion,
    banner_url,
    privacidad,
    estado,
    creador:usuario_id_usuario (nombres, apellidos, username),
    comunidad_intereses (
      id_interes,
      intereses (nombre, color_hex)
    ),
    miembro_comunidad (count)
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

  Future<bool> esAdmin() async {
    if (!AppEnv.useSupabase) {
      return false;
    }
    final String? authId = _supabase.auth.currentUser?.id;
    if (authId == null) {
      return false;
    }
    final Map<String, dynamic>? row = await _supabase
        .from('usuario')
        .select('rol_user')
        .eq('auth_user_id', authId)
        .maybeSingle();
    return row?['rol_user'] == 'ADMIN';
  }

  Future<int> solicitarComunidad({
    required String nombre,
    required String descripcion,
    required String privacidad,
    required List<int> interesIds,
    String? bannerUrl,
  }) async {
    if (!AppEnv.useSupabase) {
      throw Exception('Supabase no esta configurado');
    }
    final dynamic result = await _supabase.rpc(
      'solicitar_comunidad',
      params: <String, dynamic>{
        'p_nombre': nombre,
        'p_descripcion': descripcion,
        'p_privacidad': privacidad,
        'p_interes_ids': interesIds,
        'p_banner_url': bannerUrl,
      },
    );
    return (result as num).toInt();
  }

  Future<void> aprobarComunidad(int communityId) async {
    await _supabase.rpc(
      'aprobar_comunidad',
      params: <String, dynamic>{'p_id_comunidad': communityId},
    );
  }

  Future<void> asignarRolMiembro({
    required int communityId,
    required int usuarioId,
    required String rol,
  }) async {
    await _supabase.rpc(
      'asignar_rol_miembro_comunidad',
      params: <String, dynamic>{
        'p_id_comunidad': communityId,
        'p_usuario_id': usuarioId,
        'p_rol': rol,
      },
    );
  }

  /// Comunidades publicas activas visibles en exploracion / onboarding.
  Future<List<CommunityListItem>> listarExplorables() async {
    if (!AppEnv.useSupabase) {
      return const <CommunityListItem>[];
    }
    final List<Map<String, dynamic>> data = List<Map<String, dynamic>>.from(
      await _supabase
          .from('comunidades')
          .select(_listSelect)
          .eq('estado', 'ACTIVA')
          .eq('privacidad', 'PUBLICA')
          .order('nombre'),
    );
    return data.map(CommunityListItem.fromJson).toList();
  }

  Future<List<CommunityListItem>> listarParaAdmin() async {
    if (!AppEnv.useSupabase) {
      return const <CommunityListItem>[];
    }
    final List<Map<String, dynamic>> data = List<Map<String, dynamic>>.from(
      await _supabase
          .from('comunidades')
          .select(_listSelect)
          .order('fecha_creacion', ascending: false),
    );
    return data.map(CommunityListItem.fromJson).toList();
  }

  Future<List<CommunityMemberItem>> listarMiembros(int communityId) async {
    if (!AppEnv.useSupabase) {
      return const <CommunityMemberItem>[];
    }
    final List<Map<String, dynamic>> data = List<Map<String, dynamic>>.from(
      await _supabase
          .from('miembro_comunidad')
          .select('''
            rol,
            usuario:usuario_id_usuario (
              id_usuario,
              nombres,
              apellidos,
              username
            )
          ''')
          .eq('id_comunidad', communityId)
          .order('rol'),
    );

    return data.map((Map<String, dynamic> row) {
      final Map<String, dynamic>? usuario =
          row['usuario'] as Map<String, dynamic>?;
      final String? nombres = usuario?['nombres'] as String?;
      final String? apellidos = usuario?['apellidos'] as String?;
      final String displayName = <String>[
        if (nombres != null && nombres.trim().isNotEmpty) nombres.trim(),
        if (apellidos != null && apellidos.trim().isNotEmpty) apellidos.trim(),
      ].join(' ').trim();
      return CommunityMemberItem(
        usuarioId: (usuario?['id_usuario'] as num).toInt(),
        displayName: displayName.isEmpty
            ? (usuario?['username'] as String? ?? 'Usuario')
            : displayName,
        rol: row['rol'] as String? ?? 'MIEMBRO',
      );
    }).toList();
  }

  Future<void> unirse(int communityId) async {
    if (!AppEnv.useSupabase) {
      throw Exception('Supabase no esta configurado');
    }
    final int? usuarioId = await _currentUsuarioId();
    if (usuarioId == null) {
      throw Exception('Debes iniciar sesion');
    }
    await _supabase.from('miembro_comunidad').insert(<String, dynamic>{
      'id_comunidad': communityId,
      'usuario_id_usuario': usuarioId,
      'rol': 'MIEMBRO',
    });
  }

  Future<void> unirseVarias(List<int> communityIds) async {
    for (final int id in communityIds) {
      try {
        await unirse(id);
      } catch (_) {
        // Ignorar duplicados si ya es miembro.
      }
    }
  }

  Future<CommunityListItem?> obtenerPorId(int communityId) async {
    if (!AppEnv.useSupabase) {
      return null;
    }
    final Map<String, dynamic>? row = await _supabase
        .from('comunidades')
        .select(_listSelect)
        .eq('id_comunidad', communityId)
        .maybeSingle();
    if (row == null) {
      return null;
    }
    return CommunityListItem.fromJson(row);
  }

  Future<List<CommunityListItem>> listarMisComunidades() async {
    if (!AppEnv.useSupabase) {
      return const <CommunityListItem>[];
    }
    final int? usuarioId = await _currentUsuarioId();
    if (usuarioId == null) {
      return const <CommunityListItem>[];
    }
    final List<Map<String, dynamic>> membresias =
        List<Map<String, dynamic>>.from(
      await _supabase
          .from('miembro_comunidad')
          .select('id_comunidad')
          .eq('usuario_id_usuario', usuarioId),
    );
    if (membresias.isEmpty) {
      return const <CommunityListItem>[];
    }
    final List<int> ids = membresias
        .map((Map<String, dynamic> row) => (row['id_comunidad'] as num).toInt())
        .toList();
    final List<Map<String, dynamic>> data = List<Map<String, dynamic>>.from(
      await _supabase
          .from('comunidades')
          .select(_listSelect)
          .inFilter('id_comunidad', ids)
          .eq('estado', 'ACTIVA')
          .order('nombre'),
    );
    return data.map(CommunityListItem.fromJson).toList();
  }
}
