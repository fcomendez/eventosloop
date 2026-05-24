import 'package:eventosloop/features/auth/services/auth_api_service.dart';

class ResetPasswordController {
  ResetPasswordController({AuthApiService? service})
      : _service = service ?? AuthApiService();

  final AuthApiService _service;

  static final RegExp _passwordRegex = RegExp(
    r'^(?=.*[A-Z])(?=.*\d)(?=.*[!@#$%^&*(),.?":{}|<>_\-\[\]\\\/+=~`])[A-Za-z\d!@#$%^&*(),.?":{}|<>_\-\[\]\\\/+=~`]{8,16}$',
  );

  String? validarPassword(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Contrasena obligatoria';
    }
    if (!_passwordRegex.hasMatch(value.trim())) {
      return 'Debe tener 8-16, mayuscula, numero y simbolo';
    }
    return null;
  }

  String? validarConfirmacion({
    required String? confirmacion,
    required String password,
  }) {
    if (confirmacion == null || confirmacion.trim().isEmpty) {
      return 'Confirmacion obligatoria';
    }
    if (confirmacion.trim() != password.trim()) {
      return 'Las contrasenas no coinciden';
    }
    return null;
  }

  Future<ServiceResult> cambiarContrasena({
    required String resetToken,
    required String nuevaPassword,
  }) {
    return _service.cambiarPassword(
      resetToken: resetToken,
      nuevaPassword: nuevaPassword,
    );
  }
}
