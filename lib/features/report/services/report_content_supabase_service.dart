import 'package:eventosloop/core/config/app_env.dart';
import 'package:eventosloop/features/report/models/report_content_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ReportContentSupabaseService {
  ReportContentSupabaseService({SupabaseClient? client}) : _client = client;

  final SupabaseClient? _client;

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

  Future<void> submitReport(ReportContentRequest request) async {
    if (!AppEnv.useSupabase) {
      throw Exception('Supabase no esta configurado');
    }
    final int? userId = await _currentUsuarioId();
    if (userId == null) {
      throw Exception('Debes iniciar sesion');
    }

    final String motivo = request.reason.title;
    final String? descripcion = request.description;

    if (request.contentType == ReportContentType.post) {
      await _supabase.from('reporte_publicacion').insert(<String, dynamic>{
        'motivo': motivo,
        'descripcion': descripcion,
        'usuario_id_usuario': userId,
        'publicaciones_id_post': request.contentId,
      });
      return;
    }

    await _supabase.from('reporte_evento').insert(<String, dynamic>{
      'motivo': motivo,
      'descripcion': descripcion,
      'usuario_id_usuario': userId,
      'evento_id_evento': request.contentId,
    });
  }
}
