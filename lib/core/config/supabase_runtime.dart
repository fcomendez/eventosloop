import 'package:eventosloop/core/config/app_env.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Backend Supabase configurado y sesion activa.
bool get supabaseLive =>
    AppEnv.useSupabase &&
    Supabase.instance.client.auth.currentSession != null;

/// Datos mock solo cuando no hay Supabase (desarrollo sin Docker).
bool get allowMockFallback => !AppEnv.useSupabase;
