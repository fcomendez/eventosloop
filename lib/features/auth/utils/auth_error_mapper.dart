import 'package:eventosloop/features/auth/models/auth_field_key.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class MappedAuthError {
  const MappedAuthError({
    required this.message,
    this.field,
    this.useDialog = false,
  });

  final String message;
  final AuthFieldKey? field;
  final bool useDialog;
}

class AuthErrorMapper {
  const AuthErrorMapper._();

  static MappedAuthError fromAuthException(AuthException exception) {
    final String raw = exception.message.toLowerCase();

    if (raw.contains('invalid login credentials') ||
        raw.contains('invalid credentials')) {
      return const MappedAuthError(
        message: 'Correo o contrasena incorrectos',
        field: AuthFieldKey.password,
      );
    }
    if (raw.contains('email not confirmed')) {
      return const MappedAuthError(
        message:
            'Debes confirmar tu correo antes de iniciar sesion. Revisa tu bandeja de entrada.',
        field: AuthFieldKey.email,
        useDialog: true,
      );
    }
    if (raw.contains('user already registered') ||
        raw.contains('already been registered')) {
      return const MappedAuthError(
        message: 'Este correo ya esta registrado',
        field: AuthFieldKey.email,
      );
    }
    if (raw.contains('user not found')) {
      return const MappedAuthError(
        message: 'No existe una cuenta con este correo',
        field: AuthFieldKey.email,
      );
    }
    if (raw.contains('password') &&
        (raw.contains('weak') || raw.contains('short'))) {
      return const MappedAuthError(
        message: 'La contrasena no cumple los requisitos minimos',
        field: AuthFieldKey.password,
      );
    }
    if (raw.contains('otp') ||
        raw.contains('token') && raw.contains('invalid')) {
      return const MappedAuthError(
        message: 'Codigo invalido o expirado',
        field: AuthFieldKey.otp,
      );
    }
    if (raw.contains('rate limit') || raw.contains('too many')) {
      return const MappedAuthError(
        message: 'Demasiados intentos. Espera unos minutos e intenta de nuevo.',
        useDialog: true,
      );
    }

    return MappedAuthError(
      message: _limpiarMensaje(exception.message),
      useDialog: true,
    );
  }

  static MappedAuthError fromRegisterPostgrest(Object error) {
    final String raw = error.toString().toLowerCase();
    if (raw.contains('usuario_username_key') ||
        raw.contains('duplicate key') && raw.contains('username')) {
      return const MappedAuthError(
        message: 'Este alias ya esta en uso',
        field: AuthFieldKey.username,
      );
    }
    if (raw.contains('usuario_email_key') ||
        raw.contains('duplicate key') && raw.contains('email')) {
      return const MappedAuthError(
        message: 'Este correo ya esta registrado',
        field: AuthFieldKey.email,
      );
    }
    if (raw.contains('comuna_id_comuna') || raw.contains('comuna')) {
      return const MappedAuthError(
        message: 'La comuna seleccionada no es valida. Elige otra.',
        field: AuthFieldKey.comuna,
        useDialog: true,
      );
    }
    return MappedAuthError(
      message: 'No se pudo guardar el perfil. Intenta nuevamente.',
      useDialog: true,
    );
  }

  static MappedAuthError fromNetwork(Object error) {
    final String raw = error.toString().toLowerCase();
    if (raw.contains('socket') ||
        raw.contains('connection') ||
        raw.contains('network') ||
        raw.contains('failed host lookup')) {
      return const MappedAuthError(
        message:
            'Sin conexion al servidor. Revisa tu internet o la configuracion de Supabase.',
        useDialog: true,
      );
    }
    return MappedAuthError(
      message: 'Ocurrio un error inesperado. Intenta nuevamente.',
      useDialog: true,
    );
  }

  static MappedAuthError fromHttpLoginStatus(int statusCode) {
    if (statusCode == 401 || statusCode == 403) {
      return const MappedAuthError(
        message: 'Correo o contrasena incorrectos',
        field: AuthFieldKey.password,
      );
    }
    if (statusCode >= 500) {
      return const MappedAuthError(
        message: 'El servidor no esta disponible. Intenta mas tarde.',
        useDialog: true,
      );
    }
    return const MappedAuthError(
      message: 'No se pudo iniciar sesion. Verifica tus datos.',
      field: AuthFieldKey.password,
    );
  }

  static String _limpiarMensaje(String message) {
    final String trimmed = message.trim();
    if (trimmed.isEmpty) {
      return 'Ocurrio un error. Intenta nuevamente.';
    }
    if (trimmed.length > 160) {
      return '${trimmed.substring(0, 157)}...';
    }
    return trimmed;
  }
}
