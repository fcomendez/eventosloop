import 'package:eventosloop/core/config/app_env.dart';
import 'package:eventosloop/features/auth/models/auth_session_model.dart';
import 'package:eventosloop/features/auth/services/auth_api_service.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LoginController extends ChangeNotifier {
  LoginController({AuthApiService? authApiService})
      : _authApiService = authApiService ?? AuthApiService();

  final GoogleSignIn _googleSignIn = GoogleSignIn.instance;
  final AuthApiService _authApiService;
  bool _googleInitialized = false;
  bool googleSignInCancelado = false;

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

  Future<void> _ensureGoogleInitialized() async {
    if (_googleInitialized) {
      return;
    }
    await _googleSignIn.initialize(
      serverClientId: AppEnv.googleWebClientId.isNotEmpty
          ? AppEnv.googleWebClientId
          : null,
    );
    _googleInitialized = true;
  }

  Future<AuthSessionModel?> iniciarSesionConGoogle() async {
    googleSignInCancelado = false;
    try {
      await _ensureGoogleInitialized();
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
    } on GoogleSignInException catch (e) {
      if (e.code == GoogleSignInExceptionCode.canceled ||
          e.code == GoogleSignInExceptionCode.interrupted ||
          e.code == GoogleSignInExceptionCode.uiUnavailable) {
        googleSignInCancelado = true;
      }
      return null;
    } catch (_) {
      return null;
    }
  }
}
