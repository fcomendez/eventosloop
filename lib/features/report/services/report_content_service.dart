import 'package:eventosloop/core/config/app_env.dart';
import 'package:eventosloop/features/report/models/report_content_model.dart';
import 'package:eventosloop/features/report/services/report_content_mock_service.dart';
import 'package:eventosloop/features/report/services/report_content_supabase_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ReportContentService {
  ReportContentService({
    ReportContentSupabaseService? supabaseService,
    ReportContentMockService? mockService,
  })  : _supabase = supabaseService ?? ReportContentSupabaseService(),
        _mock = mockService ?? ReportContentMockService();

  final ReportContentSupabaseService _supabase;
  final ReportContentMockService _mock;

  bool get _canUseSupabase =>
      AppEnv.useSupabase &&
      Supabase.instance.client.auth.currentSession != null;

  Future<void> submitReport(ReportContentRequest request) async {
    if (_canUseSupabase) {
      try {
        await _supabase.submitReport(request);
        return;
      } catch (_) {}
    }
    await _mock.submitReport(request);
  }
}
