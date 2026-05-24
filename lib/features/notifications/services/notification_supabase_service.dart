import 'package:eventosloop/core/config/app_env.dart';
import 'package:eventosloop/core/utils/relative_time_label.dart';
import 'package:eventosloop/features/notifications/models/notification_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class NotificationSupabaseService {
  NotificationSupabaseService({SupabaseClient? client}) : _client = client;

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

  Future<List<NotificationModel>> fetchAll() async {
    if (!AppEnv.useSupabase) {
      return const <NotificationModel>[];
    }
    final int? userId = await _currentUsuarioId();
    if (userId == null) {
      return const <NotificationModel>[];
    }

    final List<Map<String, dynamic>> rows =
        List<Map<String, dynamic>>.from(
      await _supabase
          .from('notificacion')
          .select('''
            id_notificacion,
            tipo,
            titulo,
            cuerpo,
            leida,
            id_post,
            id_evento,
            id_comunidad,
            fecha_creacion,
            origen:usuario_origen_id (nombres, apellidos, username)
          ''')
          .eq('usuario_destino_id', userId)
          .order('fecha_creacion', ascending: false)
          .limit(50),
    );

    return rows.map(_mapRow).toList();
  }

  Future<int> fetchUnreadCount() async {
    if (!AppEnv.useSupabase) {
      return 0;
    }
    final int? userId = await _currentUsuarioId();
    if (userId == null) {
      return 0;
    }
    final List<Map<String, dynamic>> rows =
        List<Map<String, dynamic>>.from(
      await _supabase
          .from('notificacion')
          .select('id_notificacion')
          .eq('usuario_destino_id', userId)
          .eq('leida', false),
    );
    return rows.length;
  }

  Future<void> markAsRead(int notificationId) async {
    if (!AppEnv.useSupabase) {
      return;
    }
    await _supabase.rpc(
      'marcar_notificacion_leida',
      params: <String, dynamic>{'p_id_notificacion': notificationId},
    );
  }

  Future<void> markAllAsRead() async {
    if (!AppEnv.useSupabase) {
      return;
    }
    await _supabase.rpc('marcar_todas_notificaciones_leidas');
  }

  NotificationModel _mapRow(Map<String, dynamic> row) {
    final Map<String, dynamic>? origen =
        row['origen'] as Map<String, dynamic>?;
    final DateTime fecha =
        DateTime.parse(row['fecha_creacion'] as String).toLocal();

    return NotificationModel(
      id: (row['id_notificacion'] as num).toInt(),
      type: _mapType(row['tipo'] as String?),
      title: row['titulo'] as String? ?? 'Notificacion',
      body: row['cuerpo'] as String? ?? '',
      timeLabel: relativeTimeLabel(fecha),
      groupLabel: _groupLabel(fecha),
      isUnread: !(row['leida'] as bool? ?? false),
      authorInitials: authorInitials(
        nombres: origen?['nombres'] as String?,
        apellidos: origen?['apellidos'] as String?,
        username: origen?['username'] as String?,
      ),
      quote: row['tipo'] == 'COMENTARIO' ? row['cuerpo'] as String? : null,
      postId: (row['id_post'] as num?)?.toInt(),
      eventId: (row['id_evento'] as num?)?.toInt(),
      communityId: (row['id_comunidad'] as num?)?.toInt(),
    );
  }

  NotificationType _mapType(String? tipo) {
    return switch (tipo?.toUpperCase()) {
      'COMENTARIO' => NotificationType.comentario,
      'LIKE' => NotificationType.mencion,
      'SOLICITUD_EVENTO' => NotificationType.solicitud,
      'INSCRIPCION_APROBADA' => NotificationType.evento,
      'INSCRIPCION_RECHAZADA' => NotificationType.evento,
      'RECORDATORIO' => NotificationType.recordatorio,
      'COMUNIDAD' => NotificationType.comunidad,
      _ => NotificationType.mencion,
    };
  }

  String _groupLabel(DateTime date) {
    final DateTime now = DateTime.now();
    if (date.year == now.year &&
        date.month == now.month &&
        date.day == now.day) {
      return 'Hoy';
    }
    if (now.difference(date).inDays == 1) {
      return 'Ayer';
    }
    if (now.difference(date).inDays < 7) {
      return 'Esta semana';
    }
    return 'Anteriores';
  }
}
