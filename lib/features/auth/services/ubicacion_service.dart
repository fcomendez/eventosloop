import 'package:eventosloop/core/config/app_env.dart';
import 'package:eventosloop/features/auth/models/ubicacion_models.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class UbicacionService {
  SupabaseClient get _supabase => Supabase.instance.client;

  Future<List<RegionOption>> fetchRegiones() async {
    if (!AppEnv.useSupabase) {
      return const <RegionOption>[];
    }
    try {
      final List<Map<String, dynamic>> data = await _supabase
          .from('region')
          .select('id_region, nombre')
          .order('nombre');
      return data.map(RegionOption.fromJson).toList();
    } catch (_) {
      return const <RegionOption>[];
    }
  }

  Future<List<ComunaOption>> fetchComunas() async {
    if (!AppEnv.useSupabase) {
      return const <ComunaOption>[];
    }
    try {
      final List<Map<String, dynamic>> data = await _supabase
          .from('comuna')
          .select('id_comuna, nombre, region_id_region')
          .order('nombre');
      return data.map(ComunaOption.fromJson).toList();
    } catch (_) {
      return const <ComunaOption>[];
    }
  }
}
