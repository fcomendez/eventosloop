import 'package:eventosloop/features/report/models/report_content_model.dart';

class ReportContentMockService {
  Future<void> submitReport(ReportContentRequest request) async {
    await Future<void>.delayed(const Duration(milliseconds: 450));
  }
}
