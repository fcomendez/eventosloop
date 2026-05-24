import 'package:eventosloop/core/config/supabase_runtime.dart';
import 'package:eventosloop/features/events/models/participant_request_model.dart';
import 'package:eventosloop/features/events/services/participant_request_mock_service.dart';
import 'package:eventosloop/features/events/services/participant_request_supabase_service.dart';

class ParticipantRequestService {
  ParticipantRequestService({
    ParticipantRequestSupabaseService? supabaseService,
    ParticipantRequestMockService? mockService,
  })  : _supabase = supabaseService ?? ParticipantRequestSupabaseService(),
        _mock = mockService ?? ParticipantRequestMockService();

  final ParticipantRequestSupabaseService _supabase;
  final ParticipantRequestMockService _mock;

  Future<ParticipantRequestSummary> fetchPendingSummary() async {
    if (supabaseLive) {
      try {
        return await _supabase.fetchPendingSummary();
      } catch (_) {
        return const ParticipantRequestSummary(
          totalPending: 0,
          firstEventId: null,
          firstEventTitle: null,
        );
      }
    }
    if (allowMockFallback && _mock.pendingCount > 0) {
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
    if (supabaseLive) {
      try {
        return await _supabase.fetchByEventId(eventId);
      } catch (_) {
        return const <ParticipantRequestModel>[];
      }
    }
    if (allowMockFallback) {
      return _mock.fetchByEventId(eventId);
    }
    return const <ParticipantRequestModel>[];
  }

  Future<void> respond({
    required int participacionId,
    required bool accept,
  }) async {
    if (supabaseLive) {
      await _supabase.respond(
        participacionId: participacionId,
        accept: accept,
      );
    }
  }
}
