import 'package:eventosloop/features/auth/services/auth_api_service.dart';

class OtpVerificationController {
  OtpVerificationController({AuthApiService? service})
      : _service = service ?? AuthApiService();

  final AuthApiService _service;

  static final RegExp _otpRegex = RegExp(r'^\d{6}$');

  String? validarOtp(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Codigo obligatorio';
    }
    if (!_otpRegex.hasMatch(value.trim())) {
      return 'Ingresa 6 digitos';
    }
    return null;
  }

  Future<String?> verificarCodigo({
    required String email,
    required String otp,
  }) {
    return _service.validarOtp(email: email, otp: otp);
  }
}
