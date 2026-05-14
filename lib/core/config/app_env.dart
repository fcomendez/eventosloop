class AppEnv {
  const AppEnv._();

  /// Cambiar por la URL real de tu backend.
  /// Ej: https://api.loop.cl
  static const String apiBaseUrl = 'http://10.0.2.2:8080';

  static String get loginEndpoint => '$apiBaseUrl/auth/login';
  static String get loginGoogleEndpoint => '$apiBaseUrl/auth/login/google';
}
