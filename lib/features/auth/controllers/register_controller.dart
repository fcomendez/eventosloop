import 'dart:async';

import 'package:eventosloop/features/auth/models/register_form_model.dart';
import 'package:flutter/foundation.dart';

class RegisterController extends ChangeNotifier {
  final Set<String> _emailsExistentes = <String>{
    'admin@loop.com',
    'test@loop.com',
    'usuario@loop.com',
  };

  bool _checkingEmail = false;
  bool _emailDisponible = true;
  String? _emailMensaje;

  bool get checkingEmail => _checkingEmail;
  bool get emailDisponible => _emailDisponible;
  String? get emailMensaje => _emailMensaje;

  static final RegExp _emailRegex = RegExp(
    r'^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$',
  );

  static final RegExp _passwordRegex = RegExp(
    r'^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{8,16}$',
  );

  Future<bool> validarCorreoUnico(String email) async {
    final String normalized = email.trim().toLowerCase();
    if (!_emailRegex.hasMatch(normalized)) {
      _emailDisponible = false;
      _emailMensaje = 'Correo invalido';
      notifyListeners();
      return false;
    }

    _checkingEmail = true;
    _emailMensaje = null;
    notifyListeners();

    await Future<void>.delayed(const Duration(milliseconds: 550));

    _emailDisponible = !_emailsExistentes.contains(normalized);
    _emailMensaje = _emailDisponible ? null : 'Este correo ya esta registrado';
    _checkingEmail = false;
    notifyListeners();
    return _emailDisponible;
  }

  String? validarRequerido(String? value, String fieldName) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName es obligatorio';
    }
    return null;
  }

  String? validarEmail(String? value) {
    final String? requiredError = validarRequerido(value, 'Correo');
    if (requiredError != null) {
      return requiredError;
    }
    if (!_emailRegex.hasMatch(value!.trim())) {
      return 'Formato de correo invalido';
    }
    if (!_emailDisponible) {
      return 'Este correo ya esta registrado';
    }
    return null;
  }

  String? validarPassword(String? value) {
    final String? requiredError = validarRequerido(value, 'Contrasena');
    if (requiredError != null) {
      return requiredError;
    }
    if (!_passwordRegex.hasMatch(value!.trim())) {
      return 'Debe tener 8 a 16 caracteres y ser alfanumerica';
    }
    return null;
  }

  String? validarConfirmacion(String? value, String originalPassword) {
    final String? requiredError =
        validarRequerido(value, 'Confirmar contrasena');
    if (requiredError != null) {
      return requiredError;
    }
    if (value!.trim() != originalPassword.trim()) {
      return 'Las contrasenas no coinciden';
    }
    return null;
  }

  String? validarGenero(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Genero es obligatorio';
    }
    return null;
  }

  String? validarFechaNacimiento(DateTime? fecha) {
    if (fecha == null) {
      return 'Fecha de nacimiento es obligatoria';
    }
    final DateTime hoy = DateTime.now();
    final int edad = hoy.year -
        fecha.year -
        ((hoy.month < fecha.month ||
                (hoy.month == fecha.month && hoy.day < fecha.day))
            ? 1
            : 0);
    if (edad < 13) {
      return 'Debes tener al menos 13 anos';
    }
    return null;
  }

  Future<bool> enviarRegistro(RegisterFormModel model) async {
    final String normalized = model.email.trim().toLowerCase();
    final bool disponible = await validarCorreoUnico(normalized);
    if (!disponible) {
      return false;
    }
    _emailsExistentes.add(normalized);
    return true;
  }
}
