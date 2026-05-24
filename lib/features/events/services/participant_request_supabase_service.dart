import 'package:eventosloop/core/config/app_env.dart';
import 'package:eventosloop/core/utils/relative_time_label.dart';
import 'package:eventosloop/features/events/models/participant_request_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ParticipantRequestSummary {
  const ParticipantRequestSummary({
    required this.totalPending,
    required this.firstEventId,
    required this.firstEventTitle,
  });

  final int totalPending;
  final int? firstEventId;
  final String? firstEventTitle;
}

class ParticipantRequestSupabaseService {
  ParticipantRequestSupabaseService({SupabaseClient? client}) : _client = client;

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

  Future<ParticipantRequestSummary> fetchPendingSummary() async {
    if (!AppEnv.useSupabase) {
      return const ParticipantRequestSummary(
        totalPending: 0,
        firstEventId: null,
        firstEventTitle: null,
      );
    }
    final int? userId = await _currentUsuarioId();
    if (userId == null) {
      return const ParticipantRequestSummary(
        totalPending: 0,
        firstEventId: null,
        firstEventTitle: null,
      );
    }

    final List<Map<String, dynamic>> rows =
        List<Map<String, dynamic>>.from(
      await _supabase
          .from('participantes_evento')
          .select('''
            id_participacion,
            evento:evento_id_evento (
              id_evento,
              titulo,
              usuario_id_usuario
            )
          ''')
          .eq('estado_solicitud', 'PENDIENTE'),
    );

    final List<Map<String, dynamic>> mine = rows.where((Map<String, dynamic> row) {
      final Map<String, dynamic>? evento =
          row['evento'] as Map<String, dynamic>?;
      return (evento?['usuario_id_usuario'] as num?)?.toInt() == userId;
    }).toList();

    if (mine.isEmpty) {
      return const ParticipantRequestSummary(
        totalPending: 0,
        firstEventId: null,
        firstEventTitle: null,
      );
    }

    final Map<String, dynamic>? first = mine.first;
    final Map<String, dynamic>? evento =
        first?['evento'] as Map<String, dynamic>?;
    return ParticipantRequestSummary(
      totalPending: mine.length,
      firstEventId: (evento?['id_evento'] as num?)?.toInt(),
      firstEventTitle: evento?['titulo'] as String?,
    );
  }

  Future<List<ParticipantRequestModel>> fetchByEventId(int eventId) async {
    if (!AppEnv.useSupabase) {
      return const <ParticipantRequestModel>[];
    }

    final List<Map<String, dynamic>> rows =
        List<Map<String, dynamic>>.from(
      await _supabase
          .from('participantes_evento')
          .select('''
            id_participacion,
            evento_id_evento,
            usuario:usuario_id_usuario (
              nombres,
              apellidos,
              username
            ),
            evento:evento_id_evento (
              comunidad:comunidad_id_comunidad (nombre)
            )
          ''')
          .eq('evento_id_evento', eventId)
          .eq('estado_solicitud', 'PENDIENTE')
          .order('fecha_solicitud'),
    );

    return rows.map((Map<String, dynamic> row) {
      final Map<String, dynamic>? usuario =
          row['usuario'] as Map<String, dynamic>?;
      final Map<String, dynamic>? evento =
          row['evento'] as Map<String, dynamic>?;
      final Map<String, dynamic>? comunidad =
          evento?['comunidad'] as Map<String, dynamic>?;
      final String? nombres = usuario?['nombres'] as String?;
      final String? apellidos = usuario?['apellidos'] as String?;
      final String? usernameRaw = usuario?['username'] as String?;
      final String displayName = <String>[
        if (nombres != null && nombres.trim().isNotEmpty) nombres.trim(),
        if (apellidos != null && apellidos.trim().isNotEmpty) apellidos.trim(),
      ].join(' ').trim();

      return ParticipantRequestModel(
        id: (row['id_participacion'] as num).toInt(),
        userName: displayName.isEmpty
            ? (usernameRaw ?? 'Usuario')
            : displayName,
        userInitials: authorInitials(
          nombres: nombres,
          apellidos: apellidos,
          username: usernameRaw,
        ),
        communityName:
            (comunidad?['nombre'] as String? ?? 'Comunidad').toUpperCase(),
        category: 'Participante',
        skills: const <String>['SOLICITUD'],
        eventId: eventId,
      );
    }).toList();
  }

  Future<void> respond({
    required int participacionId,
    required bool accept,
  }) async {
    await _supabase.from('participantes_evento').update(<String, dynamic>{
      'estado_solicitud': accept ? 'APROBADO' : 'RECHAZADO',
    }).eq('id_participacion', participacionId);
  }
}
