import 'package:eventosloop/core/config/app_env.dart';
import 'package:eventosloop/features/events/models/event_model.dart';
import 'package:eventosloop/features/events/models/event_participation_status.dart';
import 'package:eventosloop/features/events/models/event_status.dart';
import 'package:eventosloop/features/events/models/event_status.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class EventParticipationSupabaseService {
  EventParticipationSupabaseService({SupabaseClient? client}) : _client = client;

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

  Future<EventParticipationStatus> fetchStatus(int eventId) async {
    if (!AppEnv.useSupabase) {
      return EventParticipationStatus.none;
    }
    final int? userId = await _currentUsuarioId();
    if (userId == null) {
      return EventParticipationStatus.none;
    }
    final Map<String, dynamic>? row = await _supabase
        .from('participantes_evento')
        .select('estado_solicitud')
        .eq('evento_id_evento', eventId)
        .eq('usuario_id_usuario', userId)
        .maybeSingle();
    if (row == null) {
      return EventParticipationStatus.none;
    }
    return EventParticipationStatusLabels.fromDb(
      row['estado_solicitud'] as String?,
    );
  }

  Future<int> countApproved(int eventId) async {
    final List<Map<String, dynamic>> rows =
        List<Map<String, dynamic>>.from(
      await _supabase
          .from('participantes_evento')
          .select('id_participacion')
          .eq('evento_id_evento', eventId)
          .eq('estado_solicitud', 'APROBADO'),
    );
    return rows.length;
  }

  /// Inscribe o solicita participacion. Retorna el estado resultante.
  Future<EventParticipationStatus> join({
    required int eventId,
    required bool esPrivado,
    required int capacity,
  }) async {
    if (!AppEnv.useSupabase) {
      throw Exception('Supabase no esta configurado');
    }
    final int? userId = await _currentUsuarioId();
    if (userId == null) {
      throw Exception('Debes iniciar sesion');
    }

    final EventParticipationStatus existing = await fetchStatus(eventId);
    if (existing == EventParticipationStatus.pending) {
      return existing;
    }
    if (existing == EventParticipationStatus.approved) {
      return existing;
    }

    if (!esPrivado) {
      final int joined = await countApproved(eventId);
      if (capacity > 0 && joined >= capacity) {
        throw Exception('No quedan cupos disponibles');
      }
    }

    final String estado = esPrivado ? 'PENDIENTE' : 'APROBADO';
    await _supabase.from('participantes_evento').upsert(
      <String, dynamic>{
        'evento_id_evento': eventId,
        'usuario_id_usuario': userId,
        'estado_solicitud': estado,
        'fecha_solicitud': DateTime.now().toUtc().toIso8601String(),
      },
      onConflict: 'evento_id_evento,usuario_id_usuario',
    );

    return EventParticipationStatusLabels.fromDb(estado);
  }

  Future<List<EventModel>> listarMisEventos() async {
    if (!AppEnv.useSupabase) {
      return const <EventModel>[];
    }
    final int? userId = await _currentUsuarioId();
    if (userId == null) {
      return const <EventModel>[];
    }

    final List<Map<String, dynamic>> rows =
        List<Map<String, dynamic>>.from(
      await _supabase
          .from('participantes_evento')
          .select('''
            estado_solicitud,
            evento:evento_id_evento (
              id_evento,
              nombre,
              titulo,
              descripcion,
              ubicacion_direccion,
              direccion,
              cupos_max,
              latitud,
              longitud,
              fecha_realizacion,
              estado,
              es_privado,
              whatsapp_link,
              cover_url,
              usuario_id_usuario,
              comunidad_id_comunidad,
              comuna:comuna_id_comuna (nombre),
              creador:usuario_id_usuario (nombres, apellidos, username),
              comunidad:comunidad_id_comunidad (nombre)
            )
          ''')
          .eq('usuario_id_usuario', userId)
          .inFilter('estado_solicitud', <String>['APROBADO', 'PENDIENTE'])
          .order('fecha_solicitud', ascending: false),
    );

    final int? currentUserId = userId;
    final List<EventModel> events = <EventModel>[];
    for (final Map<String, dynamic> row in rows) {
      final Map<String, dynamic>? evento =
          row['evento'] as Map<String, dynamic>?;
      if (evento == null || evento['estado'] != 'ACTIVO') {
        continue;
      }
      final EventModel model = _mapEventRow(
        evento,
        currentUserId: currentUserId,
        participationStatus: EventParticipationStatusLabels.fromDb(
          row['estado_solicitud'] as String?,
        ),
      );
      events.add(model);
    }
    return events;
  }

  EventModel _mapEventRow(
    Map<String, dynamic> row, {
    required int? currentUserId,
    EventParticipationStatus participationStatus =
        EventParticipationStatus.none,
  }) {
    final Map<String, dynamic>? comuna =
        row['comuna'] as Map<String, dynamic>?;
    final Map<String, dynamic>? creador =
        row['creador'] as Map<String, dynamic>?;
    final Map<String, dynamic>? comunidad =
        row['comunidad'] as Map<String, dynamic>?;

    final String? nombres = creador?['nombres'] as String?;
    final String? apellidos = creador?['apellidos'] as String?;
    final String hostName = <String>[
      if (nombres != null && nombres.trim().isNotEmpty) nombres.trim(),
      if (apellidos != null && apellidos.trim().isNotEmpty) apellidos.trim(),
    ].join(' ').trim();

    final DateTime? fecha = row['fecha_realizacion'] == null
        ? null
        : DateTime.parse(row['fecha_realizacion'] as String);

    final int ownerId = (row['usuario_id_usuario'] as num).toInt();
    final int communityId =
        (row['comunidad_id_comunidad'] as num?)?.toInt() ?? 0;

    return EventModel(
      id: (row['id_evento'] as num).toInt(),
      title: row['titulo'] as String? ?? row['nombre'] as String? ?? 'Evento',
      description: row['descripcion'] as String? ?? '',
      category: comunidad?['nombre'] as String? ?? 'Evento',
      hostName: hostName.isEmpty
          ? (creador?['username'] as String? ?? 'Organizador')
          : hostName,
      dateLabel: _formatDate(fecha),
      timeLabel: _formatTime(fecha),
      address: row['direccion'] as String? ?? '',
      locationName: row['ubicacion_direccion'] as String? ?? 'Ubicacion',
      comuna: comuna?['nombre'] as String? ?? 'Santiago',
      latitude: (row['latitud'] as num?)?.toDouble() ?? -33.4489,
      longitude: (row['longitud'] as num?)?.toDouble() ?? -70.6693,
      capacity: (row['cupos_max'] as num?)?.toInt() ?? 0,
      joinedCount: 0,
      coverColorHex: '#0682BC',
      coverUrl: row['cover_url'] as String?,
      communityId: communityId,
      isPrivate: row['es_privado'] as bool? ?? false,
      whatsappLink: row['whatsapp_link'] as String?,
      isHostedByMe: currentUserId != null && currentUserId == ownerId,
      status: EventStatusLabels.fromDb(row['estado'] as String?),
      participationStatus: participationStatus,
    );
  }

  String _formatDate(DateTime? date) {
    if (date == null) {
      return 'Por confirmar';
    }
    const List<String> meses = <String>[
      'Ene', 'Feb', 'Mar', 'Abr', 'May', 'Jun',
      'Jul', 'Ago', 'Sep', 'Oct', 'Nov', 'Dic',
    ];
    final DateTime local = date.toLocal();
    return '${local.day} ${meses[local.month - 1]} ${local.year}';
  }

  String _formatTime(DateTime? date) {
    if (date == null) {
      return '';
    }
    final DateTime local = date.toLocal();
    final String h = local.hour.toString().padLeft(2, '0');
    final String m = local.minute.toString().padLeft(2, '0');
    return '$h:$m';
  }
}
