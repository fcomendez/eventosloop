import 'package:eventosloop/core/config/app_env.dart';
import 'package:eventosloop/features/notifications/models/notification_model.dart';
import 'package:eventosloop/features/notifications/services/notification_mock_service.dart';
import 'package:eventosloop/features/notifications/services/notification_supabase_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class NotificationService {
  NotificationService({
    NotificationSupabaseService? supabaseService,
    NotificationMockService? mockService,
  })  : _supabase = supabaseService ?? NotificationSupabaseService(),
        _mock = mockService ?? NotificationMockService();

  final NotificationSupabaseService _supabase;
  final NotificationMockService _mock;

  bool get _canUseSupabase =>
      AppEnv.useSupabase &&
      Supabase.instance.client.auth.currentSession != null;

  Future<List<NotificationModel>> fetchAll() async {
    if (_canUseSupabase) {
      try {
        return await _supabase.fetchAll();
      } catch (_) {}
    }
    return _mock.fetchAll();
  }

  Future<int> unreadCount() async {
    if (_canUseSupabase) {
      try {
        return await _supabase.fetchUnreadCount();
      } catch (_) {}
    }
    return _mock.unreadCount;
  }

  Future<void> markAsRead(int notificationId) async {
    if (_canUseSupabase) {
      await _supabase.markAsRead(notificationId);
    }
  }

  Future<void> markAllAsRead() async {
    if (_canUseSupabase) {
      await _supabase.markAllAsRead();
    }
  }
}
