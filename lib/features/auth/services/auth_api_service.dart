import 'dart:convert';

import 'package:eventosloop/core/config/app_env.dart';
import 'package:eventosloop/features/auth/models/auth_session_model.dart';
import 'package:http/http.dart' as http;

class AuthApiService {
  Future<AuthSessionModel?> loginConCorreo({
    required String email,
    required String password,
  }) async {
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
}
