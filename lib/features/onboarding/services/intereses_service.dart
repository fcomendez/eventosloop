import 'package:eventosloop/core/config/app_env.dart';
import 'package:eventosloop/features/onboarding/models/interes_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class InteresesService {
  SupabaseClient get _supabase => Supabase.instance.client;

  Future<List<InteresModel>> obtenerIntereses() async {
    if (!AppEnv.useSupabase) {
      return const <InteresModel>[];
    }
    try {
      final List<Map<String, dynamic>> data = await _supabase
          .from('intereses')
          .select()
          .eq('activo', true)
          .order('categoria')
          .order('nombre');
      return data.map(InteresModel.fromJson).toList();
    } catch (_) {
      return const <InteresModel>[];
    }
  }

  Future<List<int>> obtenerInteresesUsuario() async {
    if (!AppEnv.useSupabase) {
      return const <int>[];
    }
    final String? uid = _supabase.auth.currentUser?.id;
    if (uid == null) {
      return const <int>[];
    }
    try {
      final List<Map<String, dynamic>> data = await _supabase
          .from('usuario_intereses')
          .select('id_interes')
          .eq('auth_user_id', uid);
      return data
          .map((Map<String, dynamic> row) => (row['id_interes'] as num).toInt())
          .toList();
    } catch (_) {
      return const <int>[];
    }
  }

  Future<bool> guardarIntereses(Set<int> ids) async {
    if (!AppEnv.useSupabase) {
      return false;
    }
    if (_supabase.auth.currentUser == null) {
      return false;
    }
    try {
      await _supabase.rpc(
        'guardar_intereses_usuario',
        params: <String, dynamic>{
          'ids': ids.toList(),
        },
      );
      return true;
    } catch (_) {
      return false;
    }
  }

  Future<bool> usuarioTieneIntereses() async {
    final List<int> ids = await obtenerInteresesUsuario();
    return ids.length >= 5;
  }
}
