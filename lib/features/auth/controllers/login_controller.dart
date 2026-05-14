import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'package:eventosloop/features/auth/models/auth_session_model.dart';
import 'package:eventosloop/features/auth/services/auth_api_service.dart';

class LoginController extends ChangeNotifier {
  LoginController({AuthApiService? authApiService})
      : _authApiService = authApiService ?? AuthApiService();

  final GoogleSignIn _googleSignIn = GoogleSignIn.instance;
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

  Future<AuthSessionModel?> iniciarSesionConCorreo({
    required String email,
    required String password,
  }) async {
    try {
      return await _authApiService.loginConCorreo(
        email: email,
        password: password,
      );
    } catch (_) {
      return null;
    }
  }

  Future<AuthSessionModel?> iniciarSesionConGoogle() async {
    try {
      await _googleSignIn.initialize();
      final GoogleSignInAccount cuenta = await _googleSignIn.authenticate();
      final GoogleSignInAuthentication auth = cuenta.authentication;
      final String? idToken = auth.idToken;
      if (idToken == null || idToken.isEmpty) {
        return null;
      }
      return await _authApiService.loginConGoogle(
        email: cuenta.email,
        idToken: idToken,
        accessToken: null,
      );
    } catch (_) {
      return null;
    }
  }
}
