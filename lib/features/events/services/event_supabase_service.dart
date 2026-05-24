import 'package:eventosloop/core/config/app_env.dart';
import 'package:eventosloop/features/events/models/event_model.dart';
import 'package:eventosloop/features/events/models/event_participation_status.dart';
import 'package:eventosloop/features/events/models/event_status.dart';
import 'package:eventosloop/features/events/services/event_participation_supabase_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class EventSupabaseService {
  EventSupabaseService({SupabaseClient? client}) : _client = client;

  final SupabaseClient? _client;

  SupabaseClient get _supabase => _client ?? Supabase.instance.client;

  static const String _select = '''
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

  Future<EventModel?> fetchById(int eventId) async {
    if (!AppEnv.useSupabase) {
      return null;
    }
    final Map<String, dynamic>? row = await _supabase
        .from('evento')
        .select(_select)
        .eq('id_evento', eventId)
        .eq('estado', 'ACTIVO')
        .maybeSingle();
    if (row == null) {
      return null;
    }
    final int? currentUserId = await _currentUsuarioId();
    final EventParticipationSupabaseService participation =
        EventParticipationSupabaseService(client: _client);
    final EventParticipationStatus participationStatus =
        await participation.fetchStatus(eventId);
    final int joinedCount = await participation.countApproved(eventId);
    return mapRow(
      row,
      currentUserId: currentUserId,
      participationStatus: participationStatus,
      joinedCount: joinedCount,
    );
  }

  Future<List<EventModel>> fetchByCommunityId(int communityId) async {
    if (!AppEnv.useSupabase) {
      return const <EventModel>[];
    }
    final List<Map<String, dynamic>> rows =
        List<Map<String, dynamic>>.from(
      await _supabase
          .from('evento')
          .select(_select)
          .eq('comunidad_id_comunidad', communityId)
          .eq('estado', 'ACTIVO')
          .order('fecha_realizacion'),
    );
    final int? currentUserId = await _currentUsuarioId();
    return rows
        .map(
          (Map<String, dynamic> row) =>
              _mapRow(row, currentUserId: currentUserId),
        )
        .toList();
  }

  Future<List<EventModel>> listarActivos({int limit = 50}) async {
    if (!AppEnv.useSupabase) {
      return const <EventModel>[];
    }
    final List<Map<String, dynamic>> rows =
        List<Map<String, dynamic>>.from(
      await _supabase
          .from('evento')
          .select(_select)
          .eq('estado', 'ACTIVO')
          .order('fecha_realizacion')
          .limit(limit),
    );
    final int? currentUserId = await _currentUsuarioId();
    return rows
        .map(
          (Map<String, dynamic> row) =>
              _mapRow(row, currentUserId: currentUserId),
        )
        .toList();
  }

  Future<List<EventModel>> listarProximos({int limit = 20}) async {
    if (!AppEnv.useSupabase) {
      return const <EventModel>[];
    }
    final String nowIso = DateTime.now().toUtc().toIso8601String();
    final List<Map<String, dynamic>> rows =
        List<Map<String, dynamic>>.from(
      await _supabase
          .from('evento')
          .select(_select)
          .eq('estado', 'ACTIVO')
          .gte('fecha_realizacion', nowIso)
          .order('fecha_realizacion')
          .limit(limit),
    );
    final int? currentUserId = await _currentUsuarioId();
    return rows
        .map(
          (Map<String, dynamic> row) =>
              _mapRow(row, currentUserId: currentUserId),
        )
        .toList();
  }

  Future<int> crearEvento({
    required String titulo,
    required String descripcion,
    required int comunidadId,
    required bool esPrivado,
    int? cuposMax,
    String? direccion,
    String? ubicacionDireccion,
    int? comunaId,
    DateTime? fechaRealizacion,
    double? latitud,
    double? longitud,
    String? coverUrl,
  }) async {
    if (!AppEnv.useSupabase) {
      throw Exception('Supabase no esta configurado');
    }
    final int? usuarioId = await _currentUsuarioId();
    if (usuarioId == null) {
      throw Exception('Debes iniciar sesion');
    }
    if (titulo.trim().isEmpty) {
      throw Exception('El titulo es obligatorio');
    }

    final Map<String, dynamic> payload = <String, dynamic>{
      'nombre': titulo.trim(),
      'titulo': titulo.trim(),
      'descripcion': descripcion.trim(),
      'usuario_id_usuario': usuarioId,
      'comunidad_id_comunidad': comunidadId,
      'es_privado': esPrivado,
      'estado': 'ACTIVO',
      'fecha_realizacion':
          (fechaRealizacion ?? DateTime.now().add(const Duration(days: 7)))
              .toUtc()
              .toIso8601String(),
      'latitud': latitud ?? -33.4489,
      'longitud': longitud ?? -70.6693,
    };
    if (cuposMax != null) {
      payload['cupos_max'] = cuposMax;
    }
    if (direccion != null && direccion.trim().isNotEmpty) {
      payload['direccion'] = direccion.trim();
    }
    if (ubicacionDireccion != null && ubicacionDireccion.trim().isNotEmpty) {
      payload['ubicacion_direccion'] = ubicacionDireccion.trim();
    }
    if (comunaId != null) {
      payload['comuna_id_comuna'] = comunaId;
    }
    if (coverUrl != null && coverUrl.trim().isNotEmpty) {
      payload['cover_url'] = coverUrl.trim();
    }

    final Map<String, dynamic> row = await _supabase
        .from('evento')
        .insert(payload)
        .select('id_evento')
        .single();
    return (row['id_evento'] as num).toInt();
  }

  Future<void> actualizarEvento({
    required int eventId,
    required String titulo,
    required String descripcion,
    int? comunidadId,
    bool? esPrivado,
    int? cuposMax,
    String? direccion,
    String? ubicacionDireccion,
    int? comunaId,
    DateTime? fechaRealizacion,
    double? latitud,
    double? longitud,
    String? coverUrl,
  }) async {
    final int? usuarioId = await _currentUsuarioId();
    if (usuarioId == null) {
      throw Exception('Debes iniciar sesion');
    }

    final Map<String, dynamic> payload = <String, dynamic>{
      'nombre': titulo.trim(),
      'titulo': titulo.trim(),
      'descripcion': descripcion.trim(),
    };
    if (comunidadId != null) {
      payload['comunidad_id_comunidad'] = comunidadId;
    }
    if (esPrivado != null) {
      payload['es_privado'] = esPrivado;
    }
    if (cuposMax != null) {
      payload['cupos_max'] = cuposMax;
    }
    if (direccion != null) {
      payload['direccion'] = direccion.trim();
    }
    if (ubicacionDireccion != null) {
      payload['ubicacion_direccion'] = ubicacionDireccion.trim();
    }
    if (comunaId != null) {
      payload['comuna_id_comuna'] = comunaId;
    }
    if (fechaRealizacion != null) {
      payload['fecha_realizacion'] = fechaRealizacion.toUtc().toIso8601String();
    }
    if (latitud != null) {
      payload['latitud'] = latitud;
    }
    if (longitud != null) {
      payload['longitud'] = longitud;
    }
    if (coverUrl != null) {
      payload['cover_url'] = coverUrl.trim().isEmpty ? null : coverUrl.trim();
    }

    await _supabase
        .from('evento')
        .update(payload)
        .eq('id_evento', eventId)
        .eq('usuario_id_usuario', usuarioId);
  }

  Future<int?> resolveComunaId(String nombreComuna) async {
    final Map<String, dynamic>? row = await _supabase
        .from('comuna')
        .select('id_comuna')
        .ilike('nombre', nombreComuna.trim())
        .maybeSingle();
    return (row?['id_comuna'] as num?)?.toInt();
  }

  Future<void> cancelarEvento(int eventId) async {
    final int? usuarioId = await _currentUsuarioId();
    if (usuarioId == null) {
      throw Exception('Debes iniciar sesion');
    }
    await _supabase
        .from('evento')
        .update(<String, dynamic>{'estado': 'CANCELADO'})
        .eq('id_evento', eventId)
        .eq('usuario_id_usuario', usuarioId);
  }

  Future<void> actualizarEstado({
    required int eventId,
    required EventStatus status,
  }) async {
    if (!AppEnv.useSupabase) {
      throw Exception('Supabase no esta configurado');
    }
    final int? usuarioId = await _currentUsuarioId();
    if (usuarioId == null) {
      throw Exception('Debes iniciar sesion');
    }
    await _supabase
        .from('evento')
        .update(<String, dynamic>{'estado': status.dbValue})
        .eq('id_evento', eventId)
        .eq('usuario_id_usuario', usuarioId);
  }

  EventModel mapRow(
    Map<String, dynamic> row, {
    required int? currentUserId,
    EventParticipationStatus participationStatus =
        EventParticipationStatus.none,
    int joinedCount = 0,
  }) {
    return _mapRow(
      row,
      currentUserId: currentUserId,
      participationStatus: participationStatus,
      joinedCount: joinedCount,
    );
  }

  EventModel _mapRow(
    Map<String, dynamic> row, {
    required int? currentUserId,
    EventParticipationStatus participationStatus =
        EventParticipationStatus.none,
    int joinedCount = 0,
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
      joinedCount: joinedCount,
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
