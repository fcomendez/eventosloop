import 'package:eventosloop/features/auth/services/auth_api_service.dart';

class ForgotPasswordController {
  ForgotPasswordController({AuthApiService? service})
      : _service = service ?? AuthApiService();

  final AuthApiService _service;

  static final RegExp _emailRegex = RegExp(
    r'^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$',
  );

  String? validarEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Correo obligatorio';
    }
    if (!_emailRegex.hasMatch(value.trim())) {
      return 'Formato de correo invalido';
    }
    return null;
  }

  Future<ServiceResult> enviarCodigo(String email) {
    return _service.solicitarCodigoRecuperacion(email: email);
  }
}
