import 'package:eventosloop/core/config/app_env.dart';
import 'package:eventosloop/features/events/models/participant_request_model.dart';
import 'package:eventosloop/features/events/services/participant_request_mock_service.dart';
import 'package:eventosloop/features/events/services/participant_request_supabase_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ParticipantRequestService {
  ParticipantRequestService({
    ParticipantRequestSupabaseService? supabaseService,
    ParticipantRequestMockService? mockService,
  })  : _supabase = supabaseService ?? ParticipantRequestSupabaseService(),
        _mock = mockService ?? ParticipantRequestMockService();

  final ParticipantRequestSupabaseService _supabase;
  final ParticipantRequestMockService _mock;

  bool get _canUseSupabase =>
      AppEnv.useSupabase &&
      Supabase.instance.client.auth.currentSession != null;

  Future<ParticipantRequestSummary> fetchPendingSummary() async {
    if (_canUseSupabase) {
      try {
        final ParticipantRequestSummary summary =
            await _supabase.fetchPendingSummary();
        if (summary.totalPending > 0) {
          return summary;
        }
      } catch (_) {}
    }
    if (_mock.pendingCount > 0) {
      return ParticipantRequestSummary(
        totalPending: _mock.pendingCount,
        firstEventId: ParticipantRequestMockService.defaultPrivateEventId,
        firstEventTitle: ParticipantRequestMockService.defaultPrivateEventTitle,
      );
    }
    return const ParticipantRequestSummary(
      totalPending: 0,
      firstEventId: null,
      firstEventTitle: null,
    );
  }

  Future<List<ParticipantRequestModel>> fetchByEventId(int eventId) async {
    if (_canUseSupabase) {
      try {
        final List<ParticipantRequestModel> items =
            await _supabase.fetchByEventId(eventId);
        return items;
      } catch (_) {}
    }
    return _mock.fetchByEventId(eventId);
  }

  Future<void> respond({
    required int participacionId,
    required bool accept,
  }) async {
    if (_canUseSupabase) {
      try {
        await _supabase.respond(
          participacionId: participacionId,
          accept: accept,
        );
        return;
      } catch (_) {}
    }
  }
}
