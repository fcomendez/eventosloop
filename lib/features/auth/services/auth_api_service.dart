import 'dart:convert';

import 'package:eventosloop/core/config/app_env.dart';
import 'package:eventosloop/features/auth/models/auth_session_model.dart';
import 'package:eventosloop/features/auth/models/register_form_model.dart';
import 'package:http/http.dart' as http;
import 'package:supabase_flutter/supabase_flutter.dart';

class ServiceResult {
  ServiceResult({
    required this.ok,
    this.errorMessage,
  });

  final bool ok;
  final String? errorMessage;
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

  Future<AuthSessionModel?> loginConCorreo({
    required String email,
    required String password,
  }) async {
    if (AppEnv.useSupabase) {
      try {
        final AuthResponse response = await _supabase.auth.signInWithPassword(
          email: email.trim().toLowerCase(),
          password: password,
        );
        return _fromSupabaseSession(response.session);
      } on AuthException {
        return null;
      } catch (_) {
        return null;
      }
    }

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
      return null;
    }
    final Map<String, dynamic> data =
        jsonDecode(response.body) as Map<String, dynamic>;
    return AuthSessionModel.fromJson(data);
  }

  Future<AuthSessionModel?> loginConGoogle({
    required String email,
    required String idToken,
    required String? accessToken,
  }) async {
    if (AppEnv.useSupabase) {
      try {
        final AuthResponse response = await _supabase.auth.signInWithIdToken(
          provider: OAuthProvider.google,
          idToken: idToken,
          accessToken: accessToken,
        );
        return _fromSupabaseSession(response.session);
      } on AuthException {
        return null;
      } catch (_) {
        return null;
      }
    }

    final Uri uri = Uri.parse(AppEnv.loginGoogleEndpoint);
    final http.Response response = await http.post(
      uri,
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: jsonEncode(<String, dynamic>{
        'email': email.trim().toLowerCase(),
        'id_token': idToken,
        'access_token': accessToken,
      }),
    );
    if (response.statusCode < 200 || response.statusCode > 299) {
      return null;
    }
    final Map<String, dynamic> data =
        jsonDecode(response.body) as Map<String, dynamic>;
    return AuthSessionModel.fromJson(data);
  }

  Future<bool> solicitarCodigoRecuperacion({
    required String email,
  }) async {
    if (AppEnv.useSupabase) {
      try {
        await _supabase.auth.resetPasswordForEmail(email.trim().toLowerCase());
        return true;
      } on AuthException {
        return false;
      } catch (_) {
        return false;
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
    return response.statusCode >= 200 && response.statusCode <= 299;
  }

  Future<String?> validarOtp({
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
        return response.session?.accessToken;
      } on AuthException {
        return null;
      } catch (_) {
        return null;
      }
    }

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
      return null;
    }
    final Map<String, dynamic> data =
        jsonDecode(response.body) as Map<String, dynamic>;
    return data['reset_token'] as String?;
  }

  Future<bool> cambiarPassword({
    required String resetToken,
    required String nuevaPassword,
  }) async {
    if (AppEnv.useSupabase) {
      try {
        final Session? currentSession = _supabase.auth.currentSession;
        if (currentSession == null) {
          return false;
        }
        final UserResponse response = await _supabase.auth.updateUser(
          UserAttributes(password: nuevaPassword),
        );
        return response.user != null;
      } on AuthException {
        return false;
      } catch (_) {
        return false;
      }
    }

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
    return response.statusCode >= 200 && response.statusCode <= 299;
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

      try {
        final int? comunaId = int.tryParse(model.comuna.trim());
        await _supabase.from('usuario').upsert(<String, dynamic>{
          'auth_user_id': user.id,
          'email': model.email.trim().toLowerCase(),
          'username': model.username.trim(),
          'nombres': model.nombres.trim(),
          'apellidos': model.apellidos.trim(),
          'fecha_nacimiento': model.fechaNacimiento.toIso8601String(),
          'genero': model.genero.trim(),
          if (comunaId != null) 'comuna_id_comuna': comunaId,
        });
      } catch (_) {
        // El registro auth ya existe. Si la tabla MER aún no está lista,
        // permitimos continuar y se sincroniza en un paso posterior.
      }

      return ServiceResult(ok: true);
    } on AuthException catch (e) {
      return ServiceResult(
        ok: false,
        errorMessage: e.message,
      );
    } catch (_) {
      return ServiceResult(
        ok: false,
        errorMessage: 'Error inesperado al registrar usuario.',
      );
    }
  }
}
