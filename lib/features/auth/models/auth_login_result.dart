import 'package:eventosloop/features/auth/models/auth_field_key.dart';
import 'package:eventosloop/features/auth/models/auth_session_model.dart';

class AuthLoginResult {
  const AuthLoginResult._({
    required this.ok,
    this.session,
    this.message,
    this.field,
    this.useDialog = false,
    this.isCancellation = false,
  });

  factory AuthLoginResult.success(AuthSessionModel session) {
    return AuthLoginResult._(ok: true, session: session);
  }

  factory AuthLoginResult.failure({
    required String message,
    AuthFieldKey? field,
    bool useDialog = false,
  }) {
    return AuthLoginResult._(
      ok: false,
      message: message,
      field: field,
      useDialog: useDialog,
    );
  }

  factory AuthLoginResult.cancelled() {
    return const AuthLoginResult._(
      ok: false,
      isCancellation: true,
    );
  }

  final bool ok;
  final AuthSessionModel? session;
  final String? message;
  final AuthFieldKey? field;
  final bool useDialog;
  final bool isCancellation;
}
