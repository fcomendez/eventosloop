import 'package:eventosloop/core/config/supabase_runtime.dart';
import 'package:eventosloop/features/notifications/models/notification_model.dart';
import 'package:eventosloop/features/notifications/services/notification_mock_service.dart';
import 'package:eventosloop/features/notifications/services/notification_supabase_service.dart';

class NotificationService {
  NotificationService({
    NotificationSupabaseService? supabaseService,
    NotificationMockService? mockService,
  })  : _supabase = supabaseService ?? NotificationSupabaseService(),
        _mock = mockService ?? NotificationMockService();

  final NotificationSupabaseService _supabase;
  final NotificationMockService _mock;

  Future<List<NotificationModel>> fetchAll() async {
    if (supabaseLive) {
      try {
        return await _supabase.fetchAll();
      } catch (_) {
        return const <NotificationModel>[];
      }
    }
    if (allowMockFallback) {
      return _mock.fetchAll();
    }
    return const <NotificationModel>[];
  }

  Future<int> unreadCount() async {
    if (supabaseLive) {
      try {
        return await _supabase.fetchUnreadCount();
      } catch (_) {
        return 0;
      }
    }
    if (allowMockFallback) {
      return _mock.unreadCount;
    }
    return 0;
  }

  Future<void> markAsRead(int notificationId) async {
    if (supabaseLive) {
      await _supabase.markAsRead(notificationId);
    }
  }

  Future<void> markAllAsRead() async {
    if (supabaseLive) {
      await _supabase.markAllAsRead();
    }
  }
}
