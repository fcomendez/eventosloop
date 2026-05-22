import 'package:eventosloop/core/config/app_env.dart';
import 'package:eventosloop/features/onboarding/models/interes_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class InteresesService {
  InteresesService({SupabaseClient? client}) : _client = client;

  final SupabaseClient? _client;

  SupabaseClient get _supabase => _client ?? Supabase.instance.client;

  static const int minimoRequerido = 5;

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
    } catch (e) {
      throw Exception('No se pudieron cargar los intereses: $e');
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
    } catch (e) {
      throw Exception('No se pudieron leer tus intereses: $e');
    }
  }

  Future<void> guardarIntereses(Set<int> ids) async {
    if (!AppEnv.useSupabase) {
      throw Exception('Supabase no esta configurado');
    }
    if (_supabase.auth.currentUser == null) {
      throw Exception('Debes iniciar sesion para guardar intereses');
    }
    if (ids.length < minimoRequerido) {
      throw Exception('Selecciona al menos $minimoRequerido intereses');
    }
    try {
      await _supabase.rpc(
        'guardar_intereses_usuario',
        params: <String, dynamic>{
          'ids': ids.toList(),
        },
      );
    } catch (e) {
      throw Exception('No se pudieron guardar los intereses: $e');
    }
  }

  Future<bool> usuarioTieneIntereses() async {
    if (!AppEnv.useSupabase) {
      return false;
    }
    if (_supabase.auth.currentUser == null) {
      return false;
    }
    try {
      final List<int> ids = await obtenerInteresesUsuario();
      return ids.length >= minimoRequerido;
    } catch (_) {
      return false;
    }
  }
}
