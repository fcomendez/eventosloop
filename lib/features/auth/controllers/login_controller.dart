import 'package:eventosloop/features/auth/models/auth_login_result.dart';
import 'package:eventosloop/features/auth/services/auth_api_service.dart';
import 'package:flutter/foundation.dart';

class LoginController extends ChangeNotifier {
  LoginController({AuthApiService? authApiService})
      : _authApiService = authApiService ?? AuthApiService();

  final AuthApiService _authApiService;

  static final RegExp _emailRegex = RegExp(
    r'^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$',
  );

  String? validarEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Correo obligatorio';
    }
    if (!_emailRegex.hasMatch(value.trim())) {
      return 'Correo invalido';
    }
    return null;
  }

  String? validarPassword(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Contrasena obligatoria';
    }
    return null;
  }

  Future<AuthLoginResult> iniciarSesionConCorreo({
    required String email,
    required String password,
  }) {
    return _authApiService.loginConCorreo(
      email: email,
      password: password,
    );
  }
}
