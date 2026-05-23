class AppEnv {
  const AppEnv._();

  /// Fallback para backend propio cuando no se use Supabase.
  static const String apiBaseUrl = 'http://10.0.2.2:8080';

  /// Supabase local (Docker): http://127.0.0.1:54321
  /// Emulador Android: http://10.0.2.2:54321
  static const String _rawSupabaseUrl = String.fromEnvironment(
    'SUPABASE_URL',
    defaultValue: 'http://127.0.0.1:54321',
  );

  /// Anon key demo del stack Supabase local (ver .env.example).
  static const String _rawSupabaseAnonKey = String.fromEnvironment(
    'SUPABASE_ANON_KEY',
    defaultValue:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZS1kZW1vIiwicm9sZSI6ImFub24iLCJleHAiOjE5ODM4MTI5OTZ9.CRXP1A7WOeoJeXxjNni43kdQwgnWNReilDMblYTn_I0',
  );

  static String get supabaseUrl => _normalizeSupabaseUrl(_rawSupabaseUrl);
  static String get supabaseAnonKey => _rawSupabaseAnonKey.trim();

  static bool get useSupabase =>
      supabaseUrl.trim().isNotEmpty && supabaseAnonKey.trim().isNotEmpty;

  static String _normalizeSupabaseUrl(String url) {
    String normalized = url.trim();
    if (normalized.endsWith('/')) {
      normalized = normalized.substring(0, normalized.length - 1);
    }
    const String restSuffix = '/rest/v1';
    if (normalized.endsWith(restSuffix)) {
      normalized = normalized.substring(0, normalized.length - restSuffix.length);
    }
    return normalized;
  }

  static const String androidApplicationId = 'com.loop.eventos.eventosloop';

  static String get loginEndpoint => '$apiBaseUrl/auth/login';
  static String get forgotPasswordEndpoint =>
      '$apiBaseUrl/auth/forgot-password';
  static String get verifyOtpEndpoint => '$apiBaseUrl/auth/verify-otp';
  static String get resetPasswordEndpoint => '$apiBaseUrl/auth/reset-password';
}
