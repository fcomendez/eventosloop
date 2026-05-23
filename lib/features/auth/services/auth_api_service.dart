import 'dart:convert';
import 'dart:io';

import 'package:eventosloop/core/config/app_env.dart';
import 'package:eventosloop/features/auth/models/auth_field_key.dart';
import 'package:eventosloop/features/auth/models/auth_login_result.dart';
import 'package:eventosloop/features/auth/models/auth_session_model.dart';
import 'package:eventosloop/features/auth/models/register_form_model.dart';
import 'package:eventosloop/features/auth/utils/auth_error_mapper.dart';
import 'package:http/http.dart' as http;
import 'package:supabase_flutter/supabase_flutter.dart';

class ServiceResult {
  ServiceResult({
    required this.ok,
    this.errorMessage,
    this.field,
    this.useDialog = false,
  });

  final bool ok;
  final String? errorMessage;
  final AuthFieldKey? field;
  final bool useDialog;
}

class OtpVerifyResult {
  const OtpVerifyResult({
    this.resetToken,
    this.errorMessage,
    this.field,
    this.useDialog = false,
  });

  final String? resetToken;
  final String? errorMessage;
  final AuthFieldKey? field;
  final bool useDialog;

  bool get ok => resetToken != null && resetToken!.isNotEmpty;
}

class AuthApiService {
  SupabaseClient get _supabase => Supabase.instance.client;

  AuthSessionModel? _fromSupabaseSession(Session? session) {
    if (session == null) {
      return null;
    }
    final User user = session.user;
    return AuthSessionModel(
      accessToken: session.accessToken,
      refreshToken: session.refreshToken ?? '',
      userId: 0,
      email: user.email ?? '',
    );
  }

  Future<AuthLoginResult> loginConCorreo({
    required String email,
    required String password,
  }) async {
    if (AppEnv.useSupabase) {
      try {
        final AuthResponse response = await _supabase.auth.signInWithPassword(
          email: email.trim().toLowerCase(),
          password: password,
        );
        final AuthSessionModel? session = _fromSupabaseSession(response.session);
        if (session == null) {
          return AuthLoginResult.failure(
            message: 'No se pudo iniciar sesion. Intenta nuevamente.',
            field: AuthFieldKey.password,
          );
        }
        return AuthLoginResult.success(session);
      } on AuthException catch (e) {
        final MappedAuthError mapped = AuthErrorMapper.fromAuthException(e);
        return AuthLoginResult.failure(
          message: mapped.message,
          field: mapped.field,
          useDialog: mapped.useDialog,
        );
      } on SocketException catch (e) {
        final MappedAuthError mapped = AuthErrorMapper.fromNetwork(e);
        return AuthLoginResult.failure(
          message: mapped.message,
          useDialog: mapped.useDialog,
        );
      } catch (e) {
        final MappedAuthError mapped = AuthErrorMapper.fromNetwork(e);
        return AuthLoginResult.failure(
          message: mapped.message,
          useDialog: mapped.useDialog,
        );
      }
    }

    try {
      final Uri uri = Uri.parse(AppEnv.loginEndpoint);
      final http.Response response = await http.post(
        uri,
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
        body: jsonEncode(<String, String>{
          'email': email.trim().toLowerCase(),
          'password': password,
        }),
      );
      if (response.statusCode < 200 || response.statusCode > 299) {
        final MappedAuthError mapped =
            AuthErrorMapper.fromHttpLoginStatus(response.statusCode);
        return AuthLoginResult.failure(
          message: mapped.message,
          field: mapped.field,
          useDialog: mapped.useDialog,
        );
      }
      final Map<String, dynamic> data =
          jsonDecode(response.body) as Map<String, dynamic>;
      return AuthLoginResult.success(AuthSessionModel.fromJson(data));
    } on SocketException catch (e) {
      final MappedAuthError mapped = AuthErrorMapper.fromNetwork(e);
      return AuthLoginResult.failure(
        message: mapped.message,
        useDialog: mapped.useDialog,
      );
    } catch (_) {
      return AuthLoginResult.failure(
        message: 'No se pudo conectar con el servidor de autenticacion.',
        useDialog: true,
      );
    }
  }

  Future<ServiceResult> solicitarCodigoRecuperacion({
    required String email,
  }) async {
    if (AppEnv.useSupabase) {
      try {
        await _supabase.auth.resetPasswordForEmail(email.trim().toLowerCase());
        return ServiceResult(ok: true);
      } on AuthException catch (e) {
        final MappedAuthError mapped = AuthErrorMapper.fromAuthException(e);
        return ServiceResult(
          ok: false,
          errorMessage: mapped.message,
          field: mapped.field ?? AuthFieldKey.email,
          useDialog: mapped.useDialog,
        );
      } on SocketException catch (e) {
        final MappedAuthError mapped = AuthErrorMapper.fromNetwork(e);
        return ServiceResult(
          ok: false,
          errorMessage: mapped.message,
          useDialog: mapped.useDialog,
        );
      } catch (e) {
        final MappedAuthError mapped = AuthErrorMapper.fromNetwork(e);
        return ServiceResult(
          ok: false,
          errorMessage: mapped.message,
          useDialog: mapped.useDialog,
        );
      }
    }

    final Uri uri = Uri.parse(AppEnv.forgotPasswordEndpoint);
    final http.Response response = await http.post(
      uri,
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: jsonEncode(<String, String>{
        'email': email.trim().toLowerCase(),
      }),
    );
    if (response.statusCode >= 200 && response.statusCode <= 299) {
      return ServiceResult(ok: true);
    }
    return ServiceResult(
      ok: false,
      errorMessage: 'No se pudo solicitar recuperacion (${response.statusCode}).',
    );
  }

  Future<OtpVerifyResult> validarOtp({
    required String email,
    required String otp,
  }) async {
    if (AppEnv.useSupabase) {
      try {
        final AuthResponse response = await _supabase.auth.verifyOTP(
          email: email.trim().toLowerCase(),
          token: otp.trim(),
          type: OtpType.recovery,
        );
        final String? token = response.session?.accessToken;
        if (token == null || token.isEmpty) {
          return const OtpVerifyResult(
            errorMessage: 'Codigo invalido o expirado',
            field: AuthFieldKey.otp,
          );
        }
        return OtpVerifyResult(resetToken: token);
      } on AuthException catch (e) {
        final MappedAuthError mapped = AuthErrorMapper.fromAuthException(e);
        return OtpVerifyResult(
          errorMessage: mapped.message,
          field: mapped.field ?? AuthFieldKey.otp,
          useDialog: mapped.useDialog,
        );
      } catch (e) {
        final MappedAuthError mapped = AuthErrorMapper.fromNetwork(e);
        return OtpVerifyResult(
          errorMessage: mapped.message,
          useDialog: mapped.useDialog,
        );
      }
    }

    try {
      final Uri uri = Uri.parse(AppEnv.verifyOtpEndpoint);
      final http.Response response = await http.post(
        uri,
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
        body: jsonEncode(<String, String>{
          'email': email.trim().toLowerCase(),
          'otp': otp.trim(),
        }),
      );
      if (response.statusCode < 200 || response.statusCode > 299) {
        return const OtpVerifyResult(
          errorMessage: 'Codigo invalido o expirado',
          field: AuthFieldKey.otp,
        );
      }
      final Map<String, dynamic> data =
          jsonDecode(response.body) as Map<String, dynamic>;
      final String? resetToken = data['reset_token'] as String?;
      if (resetToken == null || resetToken.isEmpty) {
        return const OtpVerifyResult(
          errorMessage: 'Codigo invalido o expirado',
          field: AuthFieldKey.otp,
        );
      }
      return OtpVerifyResult(resetToken: resetToken);
    } catch (e) {
      final MappedAuthError mapped = AuthErrorMapper.fromNetwork(e);
      return OtpVerifyResult(
        errorMessage: mapped.message,
        useDialog: mapped.useDialog,
      );
    }
  }

  Future<ServiceResult> cambiarPassword({
    required String resetToken,
    required String nuevaPassword,
  }) async {
    if (AppEnv.useSupabase) {
      try {
        final Session? currentSession = _supabase.auth.currentSession;
        if (currentSession == null) {
          return ServiceResult(
            ok: false,
            errorMessage:
                'La sesion de recuperacion expiro. Solicita un nuevo codigo.',
            useDialog: true,
          );
        }
        final UserResponse response = await _supabase.auth.updateUser(
          UserAttributes(password: nuevaPassword),
        );
        if (response.user == null) {
          return ServiceResult(
            ok: false,
            errorMessage: 'No se pudo actualizar la contrasena.',
            field: AuthFieldKey.password,
          );
        }
        return ServiceResult(ok: true);
      } on AuthException catch (e) {
        final MappedAuthError mapped = AuthErrorMapper.fromAuthException(e);
        return ServiceResult(
          ok: false,
          errorMessage: mapped.message,
          field: mapped.field ?? AuthFieldKey.password,
          useDialog: mapped.useDialog,
        );
      } catch (e) {
        final MappedAuthError mapped = AuthErrorMapper.fromNetwork(e);
        return ServiceResult(
          ok: false,
          errorMessage: mapped.message,
          useDialog: mapped.useDialog,
        );
      }
    }

    try {
      final Uri uri = Uri.parse(AppEnv.resetPasswordEndpoint);
      final http.Response response = await http.post(
        uri,
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
        body: jsonEncode(<String, String>{
          'reset_token': resetToken,
          'new_password': nuevaPassword,
        }),
      );
      if (response.statusCode >= 200 && response.statusCode <= 299) {
        return ServiceResult(ok: true);
      }
      return ServiceResult(
        ok: false,
        errorMessage: 'No se pudo actualizar la contrasena.',
        field: AuthFieldKey.password,
      );
    } catch (e) {
      final MappedAuthError mapped = AuthErrorMapper.fromNetwork(e);
      return ServiceResult(
        ok: false,
        errorMessage: mapped.message,
        useDialog: mapped.useDialog,
      );
    }
  }

  Future<ServiceResult> registrarUsuario(RegisterFormModel model) async {
    if (!AppEnv.useSupabase) {
      return ServiceResult(ok: true);
    }

    try {
      final AuthResponse signUpResponse = await _supabase.auth.signUp(
        email: model.email.trim().toLowerCase(),
        password: model.password,
      );

      final User? user = signUpResponse.user;
      if (user == null) {
        return ServiceResult(
          ok: false,
          errorMessage: 'No se pudo crear la cuenta en Supabase Auth.',
        );
      }

      final String fechaNacimiento =
          '${model.fechaNacimiento.year.toString().padLeft(4, '0')}-'
          '${model.fechaNacimiento.month.toString().padLeft(2, '0')}-'
          '${model.fechaNacimiento.day.toString().padLeft(2, '0')}';

      try {
        await _supabase.from('usuario').upsert(
          <String, dynamic>{
            'auth_user_id': user.id,
            'email': model.email.trim().toLowerCase(),
            'username': model.username.trim(),
            'nombres': model.nombres.trim(),
            'apellidos': model.apellidos.trim(),
            'fecha_nacimiento': fechaNacimiento,
            'genero': model.genero.trim(),
            'comuna_id_comuna': model.comunaId,
          },
          onConflict: 'auth_user_id',
        );
      } catch (e) {
        final MappedAuthError mapped = AuthErrorMapper.fromRegisterPostgrest(e);
        return ServiceResult(
          ok: false,
          errorMessage: mapped.message,
          field: mapped.field,
          useDialog: mapped.useDialog,
        );
      }

      return ServiceResult(ok: true);
    } on AuthException catch (e) {
      final MappedAuthError mapped = AuthErrorMapper.fromAuthException(e);
      return ServiceResult(
        ok: false,
        errorMessage: mapped.message,
        field: mapped.field ?? AuthFieldKey.email,
        useDialog: mapped.useDialog,
      );
    } on SocketException catch (e) {
      final MappedAuthError mapped = AuthErrorMapper.fromNetwork(e);
      return ServiceResult(
        ok: false,
        errorMessage: mapped.message,
        useDialog: mapped.useDialog,
      );
    } catch (e) {
      final MappedAuthError mapped = AuthErrorMapper.fromNetwork(e);
      return ServiceResult(
        ok: false,
        errorMessage: mapped.message,
        useDialog: mapped.useDialog,
      );
    }
  }
}
