import 'package:eventosloop/core/config/app_env.dart';
import 'package:eventosloop/core/config/supabase_runtime.dart';
import 'package:eventosloop/features/events/models/event_model.dart';
import 'package:eventosloop/features/events/models/event_status.dart';
import 'package:eventosloop/features/events/services/event_mock_service.dart';
import 'package:eventosloop/features/events/services/event_participation_service.dart';
import 'package:eventosloop/features/events/services/event_participation_supabase_service.dart';
import 'package:eventosloop/features/events/services/event_supabase_service.dart';

class EventService {
  EventService({
    EventSupabaseService? supabaseService,
    EventMockService? mockService,
  })  : _supabase = supabaseService ?? EventSupabaseService(),
        _mock = mockService ?? EventMockService();

  final EventSupabaseService _supabase;
  final EventMockService _mock;

  Future<EventModel?> fetchById(int eventId) async {
    if (supabaseLive) {
      try {
        return await _supabase.fetchById(eventId);
      } catch (_) {
        return null;
      }
    }
    return _mock.fetchById(eventId);
  }

  Future<List<EventModel>> fetchByCommunityId(int communityId) async {
    if (supabaseLive) {
      try {
        return await _supabase.fetchByCommunityId(communityId);
      } catch (_) {
        return const <EventModel>[];
      }
    }
    return _mock.fetchByCommunityId(communityId);
  }

  Future<List<EventModel>> listarActivos({int limit = 50}) async {
    if (supabaseLive) {
      try {
        return await _supabase.listarActivos(limit: limit);
      } catch (_) {
        return const <EventModel>[];
      }
    }
    return _mock.fetchAll();
  }

  Future<List<EventModel>> listarProximos({int limit = 20}) async {
    if (supabaseLive) {
      try {
        return await _supabase.listarProximos(limit: limit);
      } catch (_) {
        return const <EventModel>[];
      }
    }
    return _mock.fetchAll();
  }

  Future<void> updateEventStatus({
    required int eventId,
    required EventStatus status,
  }) async {
    if (supabaseLive) {
      await _supabase.actualizarEstado(eventId: eventId, status: status);
      return;
    }
    await _mock.updateEventStatus(eventId: eventId, status: status);
  }

  Future<List<EventModel>> listarMisEventosInscritos() async {
    if (supabaseLive) {
      try {
        return await EventParticipationService(
          supabaseService: EventParticipationSupabaseService(),
        ).listarMisEventos();
      } catch (_) {
        return const <EventModel>[];
      }
    }
    return const <EventModel>[];
  }

  Future<int> crearEvento({
    required String titulo,
    required String descripcion,
    required int comunidadId,
    required bool esPrivado,
    int? cuposMax,
    String? direccion,
    String? ubicacionDireccion,
    int? comunaId,
    DateTime? fechaRealizacion,
    double? latitud,
    double? longitud,
    String? coverUrl,
  }) async {
    if (AppEnv.useSupabase) {
      return _supabase.crearEvento(
        titulo: titulo,
        descripcion: descripcion,
        comunidadId: comunidadId,
        esPrivado: esPrivado,
        cuposMax: cuposMax,
        direccion: direccion,
        ubicacionDireccion: ubicacionDireccion,
        comunaId: comunaId,
        fechaRealizacion: fechaRealizacion,
        latitud: latitud,
        longitud: longitud,
        coverUrl: coverUrl,
      );
    }
    throw Exception('Supabase no esta configurado');
  }

  Future<void> actualizarEvento({
    required int eventId,
    required String titulo,
    required String descripcion,
    int? comunidadId,
    bool? esPrivado,
    int? cuposMax,
    String? direccion,
    String? ubicacionDireccion,
    int? comunaId,
    DateTime? fechaRealizacion,
    double? latitud,
    double? longitud,
    String? coverUrl,
  }) async {
    if (AppEnv.useSupabase) {
      await _supabase.actualizarEvento(
        eventId: eventId,
        titulo: titulo,
        descripcion: descripcion,
        comunidadId: comunidadId,
        esPrivado: esPrivado,
        cuposMax: cuposMax,
        direccion: direccion,
        ubicacionDireccion: ubicacionDireccion,
        comunaId: comunaId,
        fechaRealizacion: fechaRealizacion,
        latitud: latitud,
        longitud: longitud,
        coverUrl: coverUrl,
      );
      return;
    }
    throw Exception('Supabase no esta configurado');
  }

  Future<int?> resolveComunaId(String nombreComuna) async {
    if (AppEnv.useSupabase) {
      return _supabase.resolveComunaId(nombreComuna);
    }
    return null;
  }

  Future<void> cancelarEvento(int eventId) async {
    if (AppEnv.useSupabase) {
      await _supabase.cancelarEvento(eventId);
      return;
    }
    await _mock.cancelEvent(eventId);
  }
}
