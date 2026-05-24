import 'package:eventosloop/core/config/supabase_runtime.dart';
import 'package:eventosloop/features/report/models/report_content_model.dart';
import 'package:eventosloop/features/report/services/report_content_mock_service.dart';
import 'package:eventosloop/features/report/services/report_content_supabase_service.dart';

class ReportContentService {
  ReportContentService({
    ReportContentSupabaseService? supabaseService,
    ReportContentMockService? mockService,
  })  : _supabase = supabaseService ?? ReportContentSupabaseService(),
        _mock = mockService ?? ReportContentMockService();

  final ReportContentSupabaseService _supabase;
  final ReportContentMockService _mock;

  Future<void> submitReport(ReportContentRequest request) async {
    if (supabaseLive) {
      await _supabase.submitReport(request);
      return;
    }
    if (allowMockFallback) {
      await _mock.submitReport(request);
      return;
    }
    throw Exception('Debes iniciar sesion para reportar contenido');
  }
}
