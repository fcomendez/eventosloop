import 'package:eventosloop/features/auth/services/auth_api_service.dart';

class OtpVerificationController {
  OtpVerificationController({AuthApiService? service})
      : _service = service ?? AuthApiService();

  final AuthApiService _service;

  String? validarOtp(String? value) {
    final String normalized = value?.trim() ?? '';
    if (normalized.isEmpty) {
      return 'Codigo obligatorio';
    }
    if (normalized.length < 6 || normalized.length > 16) {
      return 'Ingresa un codigo entre 6 y 16 caracteres';
    }
    return null;
  }

  Future<OtpVerifyResult> verificarCodigo({
    required String email,
    required String otp,
  }) {
    return _service.validarOtp(email: email, otp: otp);
  }

  Future<ServiceResult> reenviarCodigo(String email) {
    return _service.solicitarCodigoRecuperacion(email: email);
  }
}
