import 'package:eventosloop/core/config/app_env.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ExploreSearchPerson {
  const ExploreSearchPerson({
    required this.userId,
    required this.name,
    required this.username,
  });

  final int userId;
  final String name;
  final String username;
}

class ExploreSearchCommunity {
  const ExploreSearchCommunity({
    required this.communityId,
    required this.name,
    required this.membersLabel,
  });

  final int communityId;
  final String name;
  final String membersLabel;
}

class ExploreSearchEvent {
  const ExploreSearchEvent({
    required this.eventId,
    required this.name,
    required this.meta,
  });

  final int eventId;
  final String name;
  final String meta;
}

class ExploreSearchService {
  ExploreSearchService({SupabaseClient? client}) : _client = client;

  final SupabaseClient? _client;

  SupabaseClient get _supabase => _client ?? Supabase.instance.client;

  bool get _ready =>
      AppEnv.useSupabase && _supabase.auth.currentSession != null;

  String _likePattern(String query) => '%${query.trim()}%';

  Future<List<ExploreSearchPerson>> searchPersons(
    String query, {
    int limit = 20,
  }) async {
    if (!_ready || query.trim().isEmpty) {
      return const <ExploreSearchPerson>[];
    }
    final String pattern = _likePattern(query);
    final List<Map<String, dynamic>> rows =
        List<Map<String, dynamic>>.from(
      await _supabase
          .from('usuario')
          .select('id_usuario, nombres, apellidos, username')
          .eq('estado_cuenta', 'ACTIVO')
          .or(
            'nombres.ilike.$pattern,apellidos.ilike.$pattern,username.ilike.$pattern,email.ilike.$pattern',
          )
          .order('nombres')
          .limit(limit),
    );
    return rows.map((Map<String, dynamic> row) {
      final String? nombres = row['nombres'] as String?;
      final String? apellidos = row['apellidos'] as String?;
      final String name = <String>[
        if (nombres != null && nombres.trim().isNotEmpty) nombres.trim(),
        if (apellidos != null && apellidos.trim().isNotEmpty) apellidos.trim(),
      ].join(' ').trim();
      final String? usernameRaw = row['username'] as String?;
      final String username = usernameRaw == null || usernameRaw.isEmpty
          ? '@usuario'
          : (usernameRaw.startsWith('@') ? usernameRaw : '@$usernameRaw');
      return ExploreSearchPerson(
        userId: (row['id_usuario'] as num).toInt(),
        name: name.isEmpty ? username.replaceAll('@', '') : name,
        username: username,
      );
    }).toList();
  }

  Future<List<ExploreSearchCommunity>> searchCommunities(
    String query, {
    int limit = 20,
  }) async {
    if (!_ready || query.trim().isEmpty) {
      return const <ExploreSearchCommunity>[];
    }
    final String pattern = _likePattern(query);
    final List<Map<String, dynamic>> rows =
        List<Map<String, dynamic>>.from(
      await _supabase
          .from('comunidades')
          .select('id_comunidad, nombre, miembro_comunidad(count)')
          .eq('estado', 'ACTIVA')
          .or('nombre.ilike.$pattern,descripcion.ilike.$pattern')
          .order('nombre')
          .limit(limit),
    );
    return rows.map((Map<String, dynamic> row) {
      int memberCount = 0;
      final dynamic memberAgg = row['miembro_comunidad'];
      if (memberAgg is List && memberAgg.isNotEmpty) {
        final dynamic countValue = memberAgg.first['count'];
        if (countValue is num) {
          memberCount = countValue.toInt();
        }
      }
      return ExploreSearchCommunity(
        communityId: (row['id_comunidad'] as num).toInt(),
        name: row['nombre'] as String? ?? 'Comunidad',
        membersLabel: '$memberCount miembros',
      );
    }).toList();
  }

  Future<List<ExploreSearchEvent>> searchEvents(
    String query, {
    int limit = 20,
  }) async {
    if (!_ready || query.trim().isEmpty) {
      return const <ExploreSearchEvent>[];
    }
    final String pattern = _likePattern(query);
    final List<Map<String, dynamic>> rows =
        List<Map<String, dynamic>>.from(
      await _supabase
          .from('evento')
          .select('''
            id_evento,
            titulo,
            nombre,
            direccion,
            fecha_realizacion,
            comuna:comuna_id_comuna (nombre)
          ''')
          .eq('estado', 'ACTIVO')
          .or('titulo.ilike.$pattern,nombre.ilike.$pattern,descripcion.ilike.$pattern')
          .order('fecha_realizacion')
          .limit(limit),
    );
    const List<String> meses = <String>[
      'Ene', 'Feb', 'Mar', 'Abr', 'May', 'Jun',
      'Jul', 'Ago', 'Sep', 'Oct', 'Nov', 'Dic',
    ];
    return rows.map((Map<String, dynamic> row) {
      final DateTime fecha =
          DateTime.parse(row['fecha_realizacion'] as String).toLocal();
      final Map<String, dynamic>? comuna =
          row['comuna'] as Map<String, dynamic>?;
      final String comunaName = comuna?['nombre'] as String? ?? 'Chile';
      final String dateLabel =
          '${fecha.day} ${meses[fecha.month - 1]}, ${fecha.hour.toString().padLeft(2, '0')}:${fecha.minute.toString().padLeft(2, '0')}';
      return ExploreSearchEvent(
        eventId: (row['id_evento'] as num).toInt(),
        name: row['titulo'] as String? ?? row['nombre'] as String? ?? 'Evento',
        meta: '$dateLabel · $comunaName',
      );
    }).toList();
  }
}
