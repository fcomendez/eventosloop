class AppEnv {
  const AppEnv._();

  /// Fallback para backend propio cuando no se use Supabase.
  static const String apiBaseUrl = 'http://10.0.2.2:8080';
  static const String _rawSupabaseUrl = String.fromEnvironment(
    'SUPABASE_URL',
    defaultValue: 'https://fhwwrkjaqhfloawzxipu.supabase.co',
  );
  static const String _rawSupabaseAnonKey = String.fromEnvironment(
    'SUPABASE_ANON_KEY',
    defaultValue: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImZod3dya2phcWhmbG9hd3p4aXB1Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3Nzg3Nzk3MDQsImV4cCI6MjA5NDM1NTcwNH0.F5mtrN7rQlwlEVpfR3-YySSRdspEna6LfFtqjaXqbsI',
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

  static const String googleWebClientId = String.fromEnvironment(
    'GOOGLE_WEB_CLIENT_ID',
    defaultValue: '',
  );

  static String get loginEndpoint => '$apiBaseUrl/auth/login';
  static String get loginGoogleEndpoint => '$apiBaseUrl/auth/login/google';
  static String get forgotPasswordEndpoint =>
      '$apiBaseUrl/auth/forgot-password';
  static String get verifyOtpEndpoint => '$apiBaseUrl/auth/verify-otp';
  static String get resetPasswordEndpoint => '$apiBaseUrl/auth/reset-password';
}
