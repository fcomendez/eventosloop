import 'package:eventosloop/core/config/app_env.dart';
import 'package:eventosloop/core/utils/relative_time_label.dart';
import 'package:eventosloop/features/admin/models/admin_community_models.dart';
import 'package:eventosloop/features/admin/models/admin_directory_models.dart';
import 'package:eventosloop/features/admin/models/admin_models.dart';
import 'package:eventosloop/features/admin/models/admin_ops_models.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:supabase_flutter/supabase_flutter.dart';

class AdminSupabaseService {
  AdminSupabaseService({SupabaseClient? client}) : _client = client;

  final SupabaseClient? _client;

  SupabaseClient get _supabase => _client ?? Supabase.instance.client;

  bool get _ready =>
      AppEnv.useSupabase && _supabase.auth.currentSession != null;

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

  Future<int> _count(String table, {Map<String, Object?> filters = const {}}) async {
    var query = _supabase.from(table).select();
    filters.forEach((String key, Object? value) {
      if (value != null) {
        query = query.eq(key, value);
      }
    });
    final PostgrestList rows = await query;
    return rows.length;
  }

  Future<List<Map<String, dynamic>>> _fetchAll(String table) async {
    return List<Map<String, dynamic>>.from(await _supabase.from(table).select());
  }

  String _displayName(Map<String, dynamic>? user) {
    if (user == null) {
      return 'Usuario';
    }
    final String? nombres = user['nombres'] as String?;
    final String? apellidos = user['apellidos'] as String?;
    final String name = <String>[
      if (nombres != null && nombres.trim().isNotEmpty) nombres.trim(),
      if (apellidos != null && apellidos.trim().isNotEmpty) apellidos.trim(),
    ].join(' ').trim();
    if (name.isNotEmpty) {
      return name;
    }
    return user['username'] as String? ?? 'Usuario';
  }

  String _handle(Map<String, dynamic>? user) {
    if (user == null) {
      return '@usuario';
    }
    final String? username = user['username'] as String?;
    if (username != null && username.isNotEmpty) {
      return username.startsWith('@') ? username : '@$username';
    }
    return '@usuario';
  }

  String _formatCount(int value) {
    if (value >= 1000000) {
      return '${(value / 1000000).toStringAsFixed(1)}M';
    }
    if (value >= 1000) {
      return '${(value / 1000).toStringAsFixed(1)}k';
    }
    return '$value';
  }

  String _formatDate(DateTime date) {
    const List<String> meses = <String>[
      'ene',
      'feb',
      'mar',
      'abr',
      'may',
      'jun',
      'jul',
      'ago',
      'sep',
      'oct',
      'nov',
      'dic',
    ];
    return '${date.day} ${meses[date.month - 1]}, '
        '${date.hour.toString().padLeft(2, '0')}:'
        '${date.minute.toString().padLeft(2, '0')}';
  }

  int _reasonColor(String motivo) {
    final String m = motivo.toLowerCase();
    if (m.contains('acoso') || m.contains('odio')) {
      return 0xFFD64545;
    }
    if (m.contains('spam')) {
      return 0xFF0682BC;
    }
    if (m.contains('inapropiado')) {
      return 0xFFE08A3A;
    }
    if (m.contains('suplant') || m.contains('falso')) {
      return 0xFF5B79AA;
    }
    return 0xFF7B61B5;
  }

  int _parseHexColor(String? hex) {
    if (hex == null || hex.isEmpty) {
      return 0xFF0682BC;
    }
    final String normalized = hex.replaceAll('#', '');
    if (normalized.length == 6) {
      return int.parse('FF$normalized', radix: 16);
    }
    if (normalized.length == 8) {
      return int.parse(normalized, radix: 16);
    }
    return 0xFF0682BC;
  }

  IconData _iconForInterest(String name) {
    final String n = name.toLowerCase();
    if (n.contains('tech') || n.contains('tecnolog')) {
      return Icons.memory_outlined;
    }
    if (n.contains('futbol') || n.contains('deporte')) {
      return Icons.sports_soccer_outlined;
    }
    if (n.contains('musica') || n.contains('arte')) {
      return Icons.palette_outlined;
    }
    if (n.contains('food') || n.contains('gastron')) {
      return Icons.restaurant_outlined;
    }
    return Icons.interests_outlined;
  }

  // --- Dashboard ---

  Future<List<AdminKpiMetric>> fetchDashboardKpis() async {
    if (!_ready) {
      return const <AdminKpiMetric>[];
    }
    final DateTime now = DateTime.now();
    final DateTime weekAgo = now.subtract(const Duration(days: 7));
    final DateTime todayStart = DateTime(now.year, now.month, now.day);

    final List<Map<String, dynamic>> users = await _fetchAll('usuario');
    final int totalUsers = users.length;
    final int newUsersWeek = users.where((Map<String, dynamic> u) {
      final String? fecha = u['fecha_registro'] as String?;
      if (fecha == null) {
        return false;
      }
      return DateTime.parse(fecha).isAfter(weekAgo);
    }).length;

    final List<Map<String, dynamic>> posts = await _fetchAll('publicaciones');
    final int postsToday = posts.where((Map<String, dynamic> p) {
      return DateTime.parse(p['fecha_publicacion'] as String).isAfter(todayStart);
    }).length;

    final int activeCommunities =
        await _count('comunidades', filters: <String, Object?>{'estado': 'ACTIVA'});

    final int pendingReports =
        await _count('reporte_publicacion', filters: <String, Object?>{'estado': 'PENDIENTE'}) +
        await _count('reporte_evento', filters: <String, Object?>{'estado': 'PENDIENTE'});

    final double weekGrowthPct =
        totalUsers > 0 ? (newUsersWeek / totalUsers * 100) : 0;

    return <AdminKpiMetric>[
      AdminKpiMetric(
        label: 'Usuarios registrados',
        value: _formatCount(totalUsers),
        badgeLabel: newUsersWeek > 0
            ? '+$newUsersWeek (${weekGrowthPct.toStringAsFixed(1)}%)'
            : 'Sin cambios',
        badgeColor: newUsersWeek > 0 ? 0xFF2E9E6A : 0xFF0682BC,
      ),
      AdminKpiMetric(
        label: 'Publicaciones hoy',
        value: _formatCount(postsToday),
        badgeLabel: '${posts.length} total',
        badgeColor: 0xFF0682BC,
      ),
      AdminKpiMetric(
        label: 'Comunidades activas',
        value: _formatCount(activeCommunities),
        badgeLabel: 'En plataforma',
        badgeColor: 0xFF0682BC,
      ),
      AdminKpiMetric(
        label: 'Reportes pendientes',
        value: _formatCount(pendingReports),
        badgeLabel: pendingReports > 0 ? 'Revisar cola' : 'Al dia',
        badgeColor: pendingReports > 0 ? 0xFFD64545 : 0xFF2E9E6A,
      ),
    ];
  }

  Future<List<AdminGrowthPoint>> fetchGrowthSeries({required bool monthly}) async {
    if (!_ready) {
      return const <AdminGrowthPoint>[];
    }
    final List<Map<String, dynamic>> users = await _fetchAll('usuario');
    final DateTime now = DateTime.now();
    final int days = monthly ? 30 : 7;
    final DateTime start = now.subtract(Duration(days: days - 1));

    final Map<String, int> buckets = <String, int>{};
    for (int i = 0; i < days; i++) {
      final DateTime day = DateTime(
        start.year,
        start.month,
        start.day,
      ).add(Duration(days: i));
      buckets[_dayKey(day)] = 0;
    }

    for (final Map<String, dynamic> user in users) {
      final DateTime reg = DateTime.parse(user['fecha_registro'] as String).toLocal();
      if (reg.isBefore(start)) {
        continue;
      }
      final String key = _dayKey(DateTime(reg.year, reg.month, reg.day));
      if (buckets.containsKey(key)) {
        buckets[key] = (buckets[key] ?? 0) + 1;
      }
    }

    int cumulative = users.where((Map<String, dynamic> u) {
      return DateTime.parse(u['fecha_registro'] as String)
          .isBefore(start);
    }).length;

    final List<AdminGrowthPoint> points = <AdminGrowthPoint>[];
    final int maxTotal = users.length;
    for (int i = 0; i < days; i++) {
      final DateTime day = DateTime(start.year, start.month, start.day)
          .add(Duration(days: i));
      cumulative += buckets[_dayKey(day)] ?? 0;
      points.add(
        AdminGrowthPoint(
          label: monthly
              ? '${day.day.toString().padLeft(2, '0')} '
                  '${_monthShort(day.month)}'
              : _weekdayShort(day.weekday),
          value: maxTotal > 0 ? cumulative / maxTotal : 0,
        ),
      );
    }
    return points;
  }

  String _dayKey(DateTime day) =>
      '${day.year}-${day.month}-${day.day}';

  String _monthShort(int month) {
    const List<String> meses = <String>[
      'ENE',
      'FEB',
      'MAR',
      'ABR',
      'MAY',
      'JUN',
      'JUL',
      'AGO',
      'SEP',
      'OCT',
      'NOV',
      'DIC',
    ];
    return meses[month - 1];
  }

  String _weekdayShort(int weekday) {
    const List<String> days = <String>['LUN', 'MAR', 'MIE', 'JUE', 'VIE', 'SAB', 'DOM'];
    return days[weekday - 1];
  }

  // --- Analytics ---

  Future<({String topInterest, String topGrowth, int activeUsers, double avgInterests})>
      fetchAnalyticsHighlights() async {
    if (!_ready) {
      return (
        topInterest: '—',
        topGrowth: '—',
        activeUsers: 0,
        avgInterests: 0.0,
      );
    }
    final List<Map<String, dynamic>> rows =
        List<Map<String, dynamic>>.from(
      await _supabase.from('usuario_intereses').select('''
            id_interes,
            intereses (nombre)
          '''),
    );
    final Map<String, int> counts = <String, int>{};
    for (final Map<String, dynamic> row in rows) {
      final Map<String, dynamic>? interes =
          row['intereses'] as Map<String, dynamic>?;
      final String? nombre = interes?['nombre'] as String?;
      if (nombre == null) {
        continue;
      }
      counts[nombre] = (counts[nombre] ?? 0) + 1;
    }
    String topInterest = '—';
    int topCount = 0;
    counts.forEach((String name, int count) {
      if (count > topCount) {
        topCount = count;
        topInterest = name;
      }
    });

    final int usersWithInterests =
        rows.map((Map<String, dynamic> r) => r['auth_user_id']).toSet().length;
    final int totalUsers = await _count('usuario');
    final double avg = usersWithInterests > 0
        ? rows.length / usersWithInterests
        : 0;

    return (
      topInterest: topInterest,
      topGrowth: topCount > 0 ? '$topCount usuarios' : 'Sin datos',
      activeUsers: totalUsers,
      avgInterests: avg,
    );
  }

  Future<List<AdminInterestRanking>> fetchInterestRankings() async {
    if (!_ready) {
      return const <AdminInterestRanking>[];
    }
    final List<Map<String, dynamic>> rows =
        List<Map<String, dynamic>>.from(
      await _supabase.from('usuario_intereses').select('''
            id_interes,
            intereses (nombre, color_hex)
          '''),
    );
    final Map<String, ({int count, String colorHex})> counts =
        <String, ({int count, String colorHex})>{};
    for (final Map<String, dynamic> row in rows) {
      final Map<String, dynamic>? interes =
          row['intereses'] as Map<String, dynamic>?;
      final String? nombre = interes?['nombre'] as String?;
      if (nombre == null) {
        continue;
      }
      final String colorHex = interes?['color_hex'] as String? ?? '#0682BC';
      final int prev = counts[nombre]?.count ?? 0;
      counts[nombre] = (count: prev + 1, colorHex: colorHex);
    }

    final List<MapEntry<String, ({int count, String colorHex})>> sorted =
        counts.entries.toList()
          ..sort(
            (MapEntry<String, ({int count, String colorHex})> a,
                    MapEntry<String, ({int count, String colorHex})> b) =>
                b.value.count.compareTo(a.value.count),
          );

    final int total = rows.isEmpty ? 1 : rows.length;
    final List<AdminInterestRanking> result = <AdminInterestRanking>[];
    for (int i = 0; i < sorted.length && i < 10; i++) {
      final MapEntry<String, ({int count, String colorHex})> entry = sorted[i];
      result.add(
        AdminInterestRanking(
          rank: i + 1,
          name: entry.key,
          usersLabel: _formatCount(entry.value.count),
          marketShare: entry.value.count / total,
          icon: _iconForInterest(entry.key),
          barColor: _parseHexColor(entry.value.colorHex),
        ),
      );
    }
    return result;
  }

  // --- Moderation ---

  Future<List<AdminModerationStat>> fetchModerationStats() async {
    if (!_ready) {
      return const <AdminModerationStat>[];
    }
    final int pendingPosts =
        await _count('reporte_publicacion', filters: <String, Object?>{'estado': 'PENDIENTE'});
    final int pendingEvents =
        await _count('reporte_evento', filters: <String, Object?>{'estado': 'PENDIENTE'});
    final int totalPending = pendingPosts + pendingEvents;

    final List<Map<String, dynamic>> allReports = <Map<String, dynamic>>[
      ...await _fetchAll('reporte_publicacion'),
      ...await _fetchAll('reporte_evento'),
    ];
    final DateTime todayStart = DateTime.now();
    final DateTime dayStart =
        DateTime(todayStart.year, todayStart.month, todayStart.day);
    final int resolvedToday = allReports.where((Map<String, dynamic> r) {
      if (r['estado'] != 'RESUELTO') {
        return false;
      }
      final String? fecha = r['fecha_resolucion'] as String?;
      if (fecha == null) {
        return false;
      }
      return DateTime.parse(fecha).isAfter(dayStart);
    }).length;

    return <AdminModerationStat>[
      AdminModerationStat(
        label: 'Reportes pendientes',
        value: '$totalPending',
        subtitle: '$pendingPosts posts · $pendingEvents eventos',
        subtitleColor: totalPending > 0 ? 0xFFD64545 : 0xFF2E9E6A,
        icon: Icons.flag_outlined,
      ),
      AdminModerationStat(
        label: 'Reportes totales',
        value: '${allReports.length}',
        subtitle: 'En base de datos',
        subtitleColor: 0xFF0682BC,
        icon: Icons.inventory_2_outlined,
      ),
      AdminModerationStat(
        label: 'Resueltos hoy',
        value: '$resolvedToday',
        subtitle: resolvedToday > 0 ? 'Moderacion activa' : 'Sin resoluciones hoy',
        subtitleColor: 0xFF2E9E6A,
        icon: Icons.check_circle_outline,
      ),
    ];
  }

  Future<List<AdminReportQueueRow>> fetchReportQueue() async {
    if (!_ready) {
      return const <AdminReportQueueRow>[];
    }
    final List<AdminReportQueueRow> rows = <AdminReportQueueRow>[];

    final List<Map<String, dynamic>> postReports =
        List<Map<String, dynamic>>.from(
      await _supabase.from('reporte_publicacion').select('''
            id_reporte,
            motivo,
            estado,
            fecha_reporte,
            reporter:usuario_id_usuario (nombres, apellidos, username),
            post:publicaciones_id_post (
              id_post,
              titulo,
              contenido,
              autor:usuario_id_usuario (nombres, apellidos, username)
            )
          ''').order('fecha_reporte', ascending: false),
    );

    for (final Map<String, dynamic> row in postReports) {
      rows.add(_mapReportRow(row, AdminReportContentType.post));
    }

    final List<Map<String, dynamic>> eventReports =
        List<Map<String, dynamic>>.from(
      await _supabase.from('reporte_evento').select('''
            id_reporte,
            motivo,
            estado,
            fecha_reporte,
            reporter:usuario_id_usuario (nombres, apellidos, username),
            evento:evento_id_evento (
              id_evento,
              titulo,
              nombre,
              organizador:usuario_id_usuario (nombres, apellidos, username)
            )
          ''').order('fecha_reporte', ascending: false),
    );

    for (final Map<String, dynamic> row in eventReports) {
      rows.add(_mapReportRow(row, AdminReportContentType.event));
    }

    rows.sort(
      (AdminReportQueueRow a, AdminReportQueueRow b) =>
          b.sortDate.compareTo(a.sortDate),
    );
    return rows;
  }

  AdminReportQueueRow _mapReportRow(
    Map<String, dynamic> row,
    AdminReportContentType type,
  ) {
    final int id = (row['id_reporte'] as num).toInt();
    final String motivo = row['motivo'] as String? ?? 'Reporte';
    final String estado = row['estado'] as String? ?? 'PENDIENTE';
    final DateTime fecha = DateTime.parse(row['fecha_reporte'] as String);
    final Map<String, dynamic>? reporter =
        row['reporter'] as Map<String, dynamic>?;

    String objectLabel;
    String objectAuthor;
    if (type == AdminReportContentType.post) {
      final Map<String, dynamic>? post =
          row['post'] as Map<String, dynamic>?;
      final int postId = (post?['id_post'] as num?)?.toInt() ?? 0;
      objectLabel = post?['titulo'] as String? ??
          'Publicacion #$postId';
      objectAuthor = _handle(post?['autor'] as Map<String, dynamic>?);
    } else {
      final Map<String, dynamic>? evento =
          row['evento'] as Map<String, dynamic>?;
      final int eventId = (evento?['id_evento'] as num?)?.toInt() ?? 0;
      objectLabel = evento?['titulo'] as String? ??
          evento?['nombre'] as String? ??
          'Evento #$eventId';
      objectAuthor =
          _handle(evento?['organizador'] as Map<String, dynamic>?);
    }

    final String prefix = type == AdminReportContentType.post ? 'post' : 'event';
    return AdminReportQueueRow(
      id: '$prefix-$id',
      dateLabel: _formatDate(fecha.toLocal()),
      sortDate: fecha,
      reporterHandle: _handle(reporter),
      objectLabel: objectLabel,
      objectAuthor: objectAuthor,
      reason: motivo,
      reasonColor: _reasonColor(motivo),
      status: estado == 'PENDIENTE'
          ? AdminReportStatus.pending
          : AdminReportStatus.reviewed,
      actionLabel: estado == 'PENDIENTE' ? 'Pendiente de revision' : 'Resuelto',
      incidentReportId: '$prefix-$id',
      contentType: type,
    );
  }

  Future<AdminModerationIncident?> fetchModerationIncident(String reportId) async {
    if (!_ready) {
      return null;
    }
    final List<String> parts = reportId.split('-');
    if (parts.length < 2) {
      return null;
    }
    final AdminReportContentType type =
        parts.first == 'event' ? AdminReportContentType.event : AdminReportContentType.post;
    final int id = int.tryParse(parts.sublist(1).join('-')) ?? 0;
    if (id == 0) {
      return null;
    }

    if (type == AdminReportContentType.post) {
      return _fetchPostIncident(id);
    }
    return _fetchEventIncident(id);
  }

  Future<AdminModerationIncident?> _fetchPostIncident(int reportId) async {
    final Map<String, dynamic>? row = await _supabase
        .from('reporte_publicacion')
        .select('''
          id_reporte,
          motivo,
          descripcion,
          estado,
          fecha_reporte,
          reporter:usuario_id_usuario (nombres, apellidos, username),
          post:publicaciones_id_post (
            id_post,
            titulo,
            contenido,
            url_media,
            fecha_publicacion,
            autor:usuario_id_usuario (
              id_usuario,
              nombres,
              apellidos,
              username,
              fecha_registro,
              estado_cuenta
            )
          )
        ''')
        .eq('id_reporte', reportId)
        .maybeSingle();
    if (row == null) {
      return null;
    }
    final Map<String, dynamic>? post = row['post'] as Map<String, dynamic>?;
    final Map<String, dynamic>? author =
        post?['autor'] as Map<String, dynamic>?;
    final int authorId = (author?['id_usuario'] as num?)?.toInt() ?? 0;
    final int postId = (post?['id_post'] as num?)?.toInt() ?? 0;

    final int likes = await _count(
      'reacciones_post',
      filters: <String, Object?>{'publicaciones_id_post': postId},
    );
    final int comments = await _count(
      'comentario',
      filters: <String, Object?>{'publicaciones_id_post': postId},
    );
    final int followers = await _count(
      'seguidores',
      filters: <String, Object?>{'id_usuario_seguido': authorId},
    );
    final int authorReports = await _countReportsForUser(authorId);

    final List<String> previousActions = await _fetchAdmLogForUser(authorId);

    return AdminModerationIncident(
      reportId: 'post-$reportId',
      contentType: AdminReportContentType.post,
      contentId: postId,
      authorUserId: authorId,
      authorName: _displayName(author),
      authorHandle: _handle(author),
      postedLabel: post?['fecha_publicacion'] != null
          ? relativeTimeLabel(DateTime.parse(post!['fecha_publicacion'] as String))
          : '—',
      riskLabel: row['estado'] == 'PENDIENTE' ? 'PENDIENTE' : 'REVISADO',
      content: post?['contenido'] as String? ?? '(sin contenido)',
      mediaUrl: post?['url_media'] as String?,
      likesLabel: '$likes',
      commentsLabel: '$comments',
      joinedLabel: author?['fecha_registro'] != null
          ? relativeTimeLabel(DateTime.parse(author!['fecha_registro'] as String))
          : '—',
      statusLabel: author?['estado_cuenta'] as String? ?? 'ACTIVO',
      followersLabel: '$followers',
      pendingReportsLabel: '$authorReports',
      reasonTags: <String>[row['motivo'] as String? ?? 'Reporte'],
      reportVolumeLabel: 'Reporte #${row['id_reporte']}',
      reporterComments: <String>[
        if ((row['descripcion'] as String?)?.trim().isNotEmpty ?? false)
          row['descripcion'] as String,
      ],
      previousActions: previousActions,
    );
  }

  Future<AdminModerationIncident?> _fetchEventIncident(int reportId) async {
    final Map<String, dynamic>? row = await _supabase
        .from('reporte_evento')
        .select('''
          id_reporte,
          motivo,
          descripcion,
          estado,
          fecha_reporte,
          reporter:usuario_id_usuario (nombres, apellidos, username),
          evento:evento_id_evento (
            id_evento,
            titulo,
            descripcion,
            fecha_realizacion,
            cover_url,
            estado,
            organizador:usuario_id_usuario (
              id_usuario,
              nombres,
              apellidos,
              username,
              fecha_registro,
              estado_cuenta
            )
          )
        ''')
        .eq('id_reporte', reportId)
        .maybeSingle();
    if (row == null) {
      return null;
    }
    final Map<String, dynamic>? evento = row['evento'] as Map<String, dynamic>?;
    final Map<String, dynamic>? author =
        evento?['organizador'] as Map<String, dynamic>?;
    final int authorId = (author?['id_usuario'] as num?)?.toInt() ?? 0;
    final int eventId = (evento?['id_evento'] as num?)?.toInt() ?? 0;

    final int participants = await _count(
      'participantes_evento',
      filters: <String, Object?>{'evento_id_evento': eventId},
    );
    final int followers = await _count(
      'seguidores',
      filters: <String, Object?>{'id_usuario_seguido': authorId},
    );
    final int authorReports = await _countReportsForUser(authorId);
    final List<String> previousActions = await _fetchAdmLogForUser(authorId);

    return AdminModerationIncident(
      reportId: 'event-$reportId',
      contentType: AdminReportContentType.event,
      contentId: eventId,
      authorUserId: authorId,
      authorName: _displayName(author),
      authorHandle: _handle(author),
      postedLabel: evento?['fecha_realizacion'] != null
          ? relativeTimeLabel(
              DateTime.parse(evento!['fecha_realizacion'] as String),
            )
          : '—',
      riskLabel: row['estado'] == 'PENDIENTE' ? 'PENDIENTE' : 'REVISADO',
      content: evento?['descripcion'] as String? ??
          evento?['titulo'] as String? ??
          '(sin descripcion)',
      mediaUrl: evento?['cover_url'] as String?,
      likesLabel: '$participants',
      commentsLabel: evento?['estado'] as String? ?? 'ACTIVO',
      joinedLabel: author?['fecha_registro'] != null
          ? relativeTimeLabel(DateTime.parse(author!['fecha_registro'] as String))
          : '—',
      statusLabel: author?['estado_cuenta'] as String? ?? 'ACTIVO',
      followersLabel: '$followers',
      pendingReportsLabel: '$authorReports',
      reasonTags: <String>[row['motivo'] as String? ?? 'Reporte'],
      reportVolumeLabel: 'Reporte #${row['id_reporte']}',
      reporterComments: <String>[
        if ((row['descripcion'] as String?)?.trim().isNotEmpty ?? false)
          row['descripcion'] as String,
      ],
      previousActions: previousActions,
    );
  }

  Future<int> _countReportsForUser(int usuarioId) async {
    final int posts = await _count(
      'reporte_publicacion',
      filters: <String, Object?>{'estado': 'PENDIENTE'},
    );
    // Approximate: count all pending for simplicity in badge
    return posts;
  }

  Future<List<String>> _fetchAdmLogForUser(int usuarioId) async {
    final List<Map<String, dynamic>> rows =
        List<Map<String, dynamic>>.from(
      await _supabase
          .from('adm_log')
          .select('accion_realizada, detalle, fecha_accion')
          .eq('entidad_id', usuarioId)
          .order('fecha_accion', ascending: false)
          .limit(5),
    );
    return rows
        .map(
          (Map<String, dynamic> r) =>
              '${_formatDate(DateTime.parse(r['fecha_accion'] as String).toLocal())}: '
              '${r['accion_realizada']}${r['detalle'] != null ? ' — ${r['detalle']}' : ''}',
        )
        .toList();
  }

  Future<void> resolveReport({
    required String reportId,
    required AdminModerationAction action,
    required String note,
  }) async {
    if (!_ready) {
      throw Exception('Supabase no disponible');
    }
    final int? moderadorId = await _currentUsuarioId();
    final List<String> parts = reportId.split('-');
    final AdminReportContentType type =
        parts.first == 'event' ? AdminReportContentType.event : AdminReportContentType.post;
    final int id = int.parse(parts.sublist(1).join('-'));
    final AdminModerationIncident? incident = await fetchModerationIncident(reportId);
    if (incident == null) {
      throw Exception('Reporte no encontrado');
    }

    final String table =
        type == AdminReportContentType.post ? 'reporte_publicacion' : 'reporte_evento';
    await _supabase.from(table).update(<String, dynamic>{
      'estado': 'RESUELTO',
      'fecha_resolucion': DateTime.now().toUtc().toIso8601String(),
      'moderador_id_usuario': moderadorId,
    }).eq('id_reporte', id);

    final String actionLabel = switch (action) {
      AdminModerationAction.warnUser => 'ADVERTENCIA_USUARIO',
      AdminModerationAction.deleteContent => 'ELIMINAR_CONTENIDO',
      AdminModerationAction.permanentBan => 'SUSPENDER_USUARIO',
    };

    if (action == AdminModerationAction.deleteContent) {
      if (type == AdminReportContentType.post) {
        await _supabase
            .from('publicaciones')
            .delete()
            .eq('id_post', incident.contentId);
      } else {
        await _supabase.from('evento').update(<String, dynamic>{
          'estado': 'CANCELADO',
        }).eq('id_evento', incident.contentId);
      }
    }

    if (action == AdminModerationAction.permanentBan && incident.authorUserId > 0) {
      await _supabase.from('usuario').update(<String, dynamic>{
        'estado_cuenta': 'SUSPENDIDO',
      }).eq('id_usuario', incident.authorUserId);
    }

    if (action == AdminModerationAction.warnUser && incident.authorUserId > 0) {
      await _supabase.from('notificacion').insert(<String, dynamic>{
        'usuario_destino_id': incident.authorUserId,
        'usuario_origen_id': moderadorId,
        'tipo': 'MODERACION',
        'titulo': 'Advertencia de moderacion',
        'cuerpo': note.isNotEmpty
            ? note
            : 'Tu contenido fue reportado y recibio una advertencia del equipo LOOP.',
        'id_post': type == AdminReportContentType.post ? incident.contentId : null,
        'id_evento': type == AdminReportContentType.event ? incident.contentId : null,
      });
    }

    await _supabase.from('adm_log').insert(<String, dynamic>{
      'accion_realizada': actionLabel,
      'detalle': note.isNotEmpty ? note : null,
      'entidad_tipo': type == AdminReportContentType.post ? 'publicacion' : 'evento',
      'entidad_id': incident.contentId,
      'usuario_id_usuario': moderadorId,
    });
  }

  // --- Events ---

  Future<List<AdminEventStat>> fetchEventStats() async {
    if (!_ready) {
      return const <AdminEventStat>[];
    }
    final List<Map<String, dynamic>> events = await _fetchAll('evento');
    final DateTime now = DateTime.now();
    final int active = events.where((Map<String, dynamic> e) => e['estado'] == 'ACTIVO').length;
    final int upcoming = events.where((Map<String, dynamic> e) {
      if (e['estado'] != 'ACTIVO') {
        return false;
      }
      final String? fecha = e['fecha_realizacion'] as String?;
      if (fecha == null) {
        return false;
      }
      return DateTime.parse(fecha).isAfter(now);
    }).length;
    final int privateCount =
        events.where((Map<String, dynamic> e) => e['es_privado'] == true).length;
    final int participants = await _count('participantes_evento');

    return <AdminEventStat>[
      AdminEventStat(label: 'Eventos activos', value: '$active'),
      AdminEventStat(label: 'Proximos', value: '$upcoming'),
      AdminEventStat(label: 'Privados', value: '$privateCount'),
      AdminEventStat(label: 'Participaciones', value: '$participants'),
    ];
  }

  Future<List<AdminEventRow>> fetchEvents() async {
    if (!_ready) {
      return const <AdminEventRow>[];
    }
    final List<Map<String, dynamic>> rows =
        List<Map<String, dynamic>>.from(
      await _supabase.from('evento').select('''
            id_evento,
            titulo,
            nombre,
            fecha_realizacion,
            es_privado,
            estado,
            cupos_max,
            comunidad:comunidad_id_comunidad (nombre)
          ''').order('fecha_realizacion', ascending: false),
    );

    final List<Map<String, dynamic>> participantes =
        List<Map<String, dynamic>>.from(
      await _supabase.from('participantes_evento').select('evento_id_evento'),
    );
    final Map<int, int> participantCounts = <int, int>{};
    for (final Map<String, dynamic> p in participantes) {
      final int eventId = (p['evento_id_evento'] as num).toInt();
      participantCounts[eventId] = (participantCounts[eventId] ?? 0) + 1;
    }

    final List<Map<String, dynamic>> pendingEventReports =
        List<Map<String, dynamic>>.from(
      await _supabase
          .from('reporte_evento')
          .select('evento_id_evento')
          .eq('estado', 'PENDIENTE'),
    );
    final Set<int> reportedEventIds = pendingEventReports
        .map((Map<String, dynamic> r) => (r['evento_id_evento'] as num).toInt())
        .toSet();

    return rows.map((Map<String, dynamic> row) {
      final int id = (row['id_evento'] as num).toInt();
      final String title =
          row['titulo'] as String? ?? row['nombre'] as String? ?? 'Evento';
      final Map<String, dynamic>? comunidad =
          row['comunidad'] as Map<String, dynamic>?;
      final bool isPrivate = row['es_privado'] as bool? ?? false;
      final String? fechaStr = row['fecha_realizacion'] as String?;
      final DateTime? fecha =
          fechaStr != null ? DateTime.parse(fechaStr).toLocal() : null;
      final int participants = participantCounts[id] ?? 0;
      final int? cupos = (row['cupos_max'] as num?)?.toInt();
      final bool needsModeration = reportedEventIds.contains(id);
      final String estado = row['estado'] as String? ?? 'ACTIVO';

      return AdminEventRow(
        idEvento: id,
        name: title,
        dateLabel: fecha != null ? _formatDate(fecha) : 'Sin fecha',
        community: comunidad?['nombre'] as String? ?? 'Sin comunidad',
        type: isPrivate ? AdminEventType.privateEvent : AdminEventType.publicEvent,
        participantsLabel: cupos != null ? '$participants / $cupos' : '$participants',
        chatStatus: needsModeration
            ? AdminEventChatStatus.moderationRequired
            : participants > 5
                ? AdminEventChatStatus.active
                : AdminEventChatStatus.quiet,
        chatDetail: estado,
        iconColor: 0xFF0682BC + (id % 5) * 0x00181818,
        needsModeration: needsModeration,
      );
    }).toList();
  }

  Future<void> cancelEvent(int eventId) async {
    await _supabase.from('evento').update(<String, dynamic>{
      'estado': 'CANCELADO',
    }).eq('id_evento', eventId);
    final int? moderadorId = await _currentUsuarioId();
    await _supabase.from('adm_log').insert(<String, dynamic>{
      'accion_realizada': 'CANCELAR_EVENTO',
      'entidad_tipo': 'evento',
      'entidad_id': eventId,
      'usuario_id_usuario': moderadorId,
    });
  }

  // --- Ads (metricas derivadas del contenido real) ---

  Future<List<AdminAdStat>> fetchAdStats() async {
    if (!_ready) {
      return const <AdminAdStat>[];
    }
    final int communities =
        await _count('comunidades', filters: <String, Object?>{'estado': 'ACTIVA'});
    final int events =
        await _count('evento', filters: <String, Object?>{'estado': 'ACTIVO'});
    final List<Map<String, dynamic>> posts = await _fetchAll('publicaciones');
    final int withMedia =
        posts.where((Map<String, dynamic> p) => (p['url_media'] as String?)?.isNotEmpty ?? false).length;
    final int users = await _count('usuario');

    return <AdminAdStat>[
      AdminAdStat(label: 'Comunidades activas', value: '$communities'),
      AdminAdStat(label: 'Eventos activos', value: '$events'),
      AdminAdStat(label: 'Posts con media', value: '$withMedia'),
      AdminAdStat(label: 'Usuarios alcanzables', value: '$users'),
    ];
  }

  Future<List<AdminAdCampaignRow>> fetchAdCampaigns() async {
    // No existe tabla de campanas; devuelve contenido destacado real como referencia.
    if (!_ready) {
      return const <AdminAdCampaignRow>[];
    }
    final List<Map<String, dynamic>> communities =
        List<Map<String, dynamic>>.from(
      await _supabase
          .from('comunidades')
          .select('nombre, estado, banner_url')
          .eq('estado', 'ACTIVA')
          .limit(5),
    );
    return communities.asMap().entries.map((MapEntry<int, Map<String, dynamic>> e) {
      return AdminAdCampaignRow(
        name: e.value['nombre'] as String? ?? 'Comunidad',
        placement: 'Explorar / Comunidades',
        budgetLabel: 'Organico',
        impressionsLabel: '—',
        ctrLabel: '—',
        status: AdminAdCampaignStatus.running,
        accentColor: 0xFF0682BC + (e.key % 4) * 0x00202020,
      );
    }).toList();
  }

  // --- System status ---

  Future<List<AdminServiceStatusRow>> fetchServiceStatuses() async {
    if (!_ready) {
      return const <AdminServiceStatusRow>[];
    }
    final List<AdminServiceStatusRow> rows = <AdminServiceStatusRow>[];
    rows.add(await _probeService(
      name: 'API REST (Kong)',
      description: 'PostgREST + Auth gateway',
      url: '${AppEnv.supabaseUrl}/rest/v1/',
    ));
    rows.add(await _probeService(
      name: 'Auth (GoTrue)',
      description: 'Login, registro, JWT',
      url: '${AppEnv.supabaseUrl}/auth/v1/health',
    ));
    rows.add(await _probeService(
      name: 'Storage',
      description: 'Imagenes y archivos',
      url: '${AppEnv.supabaseUrl}/storage/v1/bucket',
    ));
    return rows;
  }

  Future<AdminServiceStatusRow> _probeService({
    required String name,
    required String description,
    required String url,
  }) async {
    final Stopwatch sw = Stopwatch()..start();
    try {
      final http.Response response = await http.get(
        Uri.parse(url),
        headers: <String, String>{
          'apikey': AppEnv.supabaseAnonKey,
        },
      ).timeout(const Duration(seconds: 5));
      sw.stop();
      final AdminServiceHealth health = response.statusCode < 500
          ? AdminServiceHealth.operational
          : AdminServiceHealth.degraded;
      return AdminServiceStatusRow(
        name: name,
        description: description,
        health: health,
        latencyLabel: '${sw.elapsedMilliseconds} ms',
        uptimeLabel: response.statusCode < 400 ? 'OK' : 'HTTP ${response.statusCode}',
      );
    } catch (_) {
      sw.stop();
      return AdminServiceStatusRow(
        name: name,
        description: description,
        health: AdminServiceHealth.down,
        latencyLabel: '${sw.elapsedMilliseconds} ms',
        uptimeLabel: 'Sin respuesta',
      );
    }
  }

  Future<List<AdminSystemIncidentRow>> fetchSystemIncidents() async {
    if (!_ready) {
      return const <AdminSystemIncidentRow>[];
    }
    final List<Map<String, dynamic>> rows =
        List<Map<String, dynamic>>.from(
      await _supabase
          .from('adm_log')
          .select('accion_realizada, detalle, entidad_tipo, fecha_accion')
          .order('fecha_accion', ascending: false)
          .limit(10),
    );
    return rows.map((Map<String, dynamic> row) {
      final DateTime fecha =
          DateTime.parse(row['fecha_accion'] as String).toLocal();
      final String accion = row['accion_realizada'] as String? ?? 'ACCION';
      final String? detalle = row['detalle'] as String?;
      final String? entidad = row['entidad_tipo'] as String?;
      return AdminSystemIncidentRow(
        timeLabel: relativeTimeLabel(fecha),
        service: entidad ?? 'admin',
        message: detalle != null ? '$accion — $detalle' : accion,
        severityColor: accion.contains('SUSPENDER') || accion.contains('ELIMINAR')
            ? 0xFFD64545
            : 0xFF0682BC,
      );
    }).toList();
  }
}
