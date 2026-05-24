import 'package:eventosloop/core/config/app_env.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Verifica si el usuario autenticado puede acceder al panel admin.
class AdminAccessService {
  AdminAccessService({SupabaseClient? client}) : _client = client;

  final SupabaseClient? _client;

  SupabaseClient get _supabase => _client ?? Supabase.instance.client;

  Future<bool> puedeAccederAdmin() async {
    if (!AppEnv.useSupabase) {
      return false;
    }
    if (_supabase.auth.currentSession == null) {
      return false;
    }
    try {
      final Map<String, dynamic>? row = await _supabase
          .from('usuario')
          .select('id_usuario, rol_user')
          .eq('auth_user_id', _supabase.auth.currentUser!.id)
          .maybeSingle();
      final String rol = row?['rol_user'] as String? ?? 'USER';
      if (rol == 'ADMIN' || rol == 'MODERADOR') {
        return true;
      }
      final int? usuarioId = (row?['id_usuario'] as num?)?.toInt();
      if (usuarioId == null) {
        return false;
      }
      final List<Map<String, dynamic>> roles =
          List<Map<String, dynamic>>.from(
        await _supabase
            .from('roles_sistema')
            .select('nombre_rol')
            .eq('usuario_id_usuario', usuarioId)
            .inFilter('nombre_rol', <String>['ADMIN', 'MODERADOR']),
      );
      return roles.isNotEmpty;
    } catch (_) {
      return false;
    }
  }

  Future<bool> esAdminPrincipal() async {
    if (!AppEnv.useSupabase || _supabase.auth.currentSession == null) {
      return false;
    }
    try {
      final Map<String, dynamic>? row = await _supabase
          .from('usuario')
          .select('id_usuario, rol_user')
          .eq('auth_user_id', _supabase.auth.currentUser!.id)
          .maybeSingle();
      if (row?['rol_user'] == 'ADMIN') {
        return true;
      }
      final int? usuarioId = (row?['id_usuario'] as num?)?.toInt();
      if (usuarioId == null) {
        return false;
      }
      final List<Map<String, dynamic>> roles =
          List<Map<String, dynamic>>.from(
        await _supabase
            .from('roles_sistema')
            .select('nombre_rol')
            .eq('usuario_id_usuario', usuarioId)
            .eq('nombre_rol', 'ADMIN'),
      );
      return roles.isNotEmpty;
    } catch (_) {
      return false;
    }
  }
}
