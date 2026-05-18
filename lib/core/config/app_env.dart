class AppEnv {
  const AppEnv._();

  /// Fallback para backend propio cuando no se use Supabase.
  static const String apiBaseUrl = 'http://10.0.2.2:8080';
  static const String _defaultSupabaseUrl =
      'https://fhwwrkjaqhfloawzxipu.supabase.co';
  static const String _defaultSupabaseAnonKey =
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImZod3dya2phcWhmbG9hd3p4aXB1Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3Nzg3Nzk3MDQsImV4cCI6MjA5NDM1NTcwNH0.F5mtrN7rQlwlEVpfR3-YySSRdspEna6LfFtqjaXqbsI';

  static const String supabaseUrl = String.fromEnvironment(
    'SUPABASE_URL',
    defaultValue: _defaultSupabaseUrl,
  );
  static const String supabaseAnonKey = String.fromEnvironment(
    'SUPABASE_ANON_KEY',
    defaultValue: _defaultSupabaseAnonKey,
  );

  static bool get useSupabase =>
      supabaseUrl.trim().isNotEmpty && supabaseAnonKey.trim().isNotEmpty;

  static String get loginEndpoint => '$apiBaseUrl/auth/login';
  static String get loginGoogleEndpoint => '$apiBaseUrl/auth/login/google';
  static String get forgotPasswordEndpoint =>
      '$apiBaseUrl/auth/forgot-password';
  static String get verifyOtpEndpoint => '$apiBaseUrl/auth/verify-otp';
  static String get resetPasswordEndpoint => '$apiBaseUrl/auth/reset-password';
}
