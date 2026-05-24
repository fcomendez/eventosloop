import 'package:eventosloop/core/config/app_env.dart';
import 'package:eventosloop/core/utils/relative_time_label.dart';
import 'package:eventosloop/features/admin/models/admin_directory_models.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AdminUserSupabaseService {
  AdminUserSupabaseService({SupabaseClient? client}) : _client = client;

  final SupabaseClient? _client;

  SupabaseClient get _supabase => _client ?? Supabase.instance.client;

  Future<List<AdminUserRow>> listarUsuarios() async {
    if (!AppEnv.useSupabase) {
      return const <AdminUserRow>[];
    }

    final List<Map<String, dynamic>> rows =
        List<Map<String, dynamic>>.from(
      await _supabase
          .from('usuario')
          .select(
            'id_usuario, auth_user_id, nombres, apellidos, email, username, '
            'rol_user, estado_cuenta, fecha_registro',
          )
          .order('fecha_registro', ascending: false),
    );

    final Map<String, List<String>> interestsByAuthId =
        await _loadInterestsByAuthId();

    return rows.map((Map<String, dynamic> row) {
      final String? nombres = row['nombres'] as String?;
      final String? apellidos = row['apellidos'] as String?;
      final String name = <String>[
        if (nombres != null && nombres.trim().isNotEmpty) nombres.trim(),
        if (apellidos != null && apellidos.trim().isNotEmpty) apellidos.trim(),
      ].join(' ').trim();

      final String authUserId = row['auth_user_id'] as String? ?? '';
      final int id = (row['id_usuario'] as num).toInt();
      final DateTime joinedAt =
          DateTime.parse(row['fecha_registro'] as String);

      return AdminUserRow(
        name: name.isEmpty
            ? (row['username'] as String? ?? 'Usuario')
            : name,
        email: row['email'] as String? ?? '',
        role: row['rol_user'] as String? ?? 'USER',
        interests: interestsByAuthId[authUserId] ?? const <String>[],
        joinedLabel: relativeTimeLabel(joinedAt),
        status: _mapStatus(row['estado_cuenta'] as String?),
        avatarColor: 0xFF0682BC + (id % 5) * 0x00181818,
      );
    }).toList();
  }

  Future<Map<String, List<String>>> _loadInterestsByAuthId() async {
    final List<Map<String, dynamic>> rows =
        List<Map<String, dynamic>>.from(
      await _supabase.from('usuario_intereses').select('''
            auth_user_id,
            intereses (nombre)
          '''),
    );

    final Map<String, List<String>> result = <String, List<String>>{};
    for (final Map<String, dynamic> row in rows) {
      final String authId = row['auth_user_id'] as String;
      final Map<String, dynamic>? interes =
          row['intereses'] as Map<String, dynamic>?;
      final String? nombre = interes?['nombre'] as String?;
      if (nombre == null) {
        continue;
      }
      result.putIfAbsent(authId, () => <String>[]).add(nombre);
    }
    return result;
  }

  AdminUserStatus _mapStatus(String? estado) {
    return switch (estado) {
      'PENDIENTE' => AdminUserStatus.pending,
      'SUSPENDIDO' => AdminUserStatus.suspended,
      _ => AdminUserStatus.active,
    };
  }
}
