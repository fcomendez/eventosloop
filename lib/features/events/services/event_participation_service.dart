import 'package:eventosloop/core/config/app_env.dart';
import 'package:eventosloop/features/events/models/event_model.dart';
import 'package:eventosloop/features/events/models/event_participation_status.dart';
import 'package:eventosloop/features/events/services/event_participation_supabase_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class EventParticipationService {
  EventParticipationService({EventParticipationSupabaseService? supabaseService})
      : _supabase = supabaseService ?? EventParticipationSupabaseService();

  final EventParticipationSupabaseService _supabase;

  bool get _canUseSupabase =>
      AppEnv.useSupabase &&
      Supabase.instance.client.auth.currentSession != null;

  Future<EventParticipationStatus> join({
    required int eventId,
    required bool esPrivado,
    required int capacity,
  }) async {
    if (!_canUseSupabase) {
      throw Exception('Debes iniciar sesion con Supabase');
    }
    return _supabase.join(
      eventId: eventId,
      esPrivado: esPrivado,
      capacity: capacity,
    );
  }

  Future<List<EventModel>> listarMisEventos() async {
    if (!_canUseSupabase) {
      return const <EventModel>[];
    }
    try {
      return await _supabase.listarMisEventos();
    } catch (_) {
      return const <EventModel>[];
    }
  }
}
