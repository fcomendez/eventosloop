import 'package:eventosloop/core/widgets/auth_feedback.dart';
import 'package:eventosloop/features/auth/models/auth_field_key.dart';
import 'package:eventosloop/features/auth/services/auth_api_service.dart';
import 'package:flutter/material.dart';

/// Aplica errores de servidor en campos o muestra snackbar/dialogo.
class AuthFormFeedback {
  const AuthFormFeedback._();

  static void handleServiceResult(
    BuildContext context, {
    required ServiceResult result,
    required GlobalKey<FormState> formKey,
    required void Function(AuthFieldKey? field, String? message) setServerError,
    String dialogTitle = 'No se pudo completar',
  }) {
    if (result.ok) {
      return;
    }
    final String message =
        result.errorMessage ?? 'Ocurrio un error. Intenta nuevamente.';
    if (result.field != null) {
      setServerError(result.field, message);
      formKey.currentState?.validate();
      return;
    }
    if (result.useDialog) {
      AuthFeedback.showErrorDialog(
        context,
        title: dialogTitle,
        message: message,
      );
      return;
    }
    AuthFeedback.showSnackBar(context, message: message);
  }

  static void handleOtpResult(
    BuildContext context, {
    required OtpVerifyResult result,
    required GlobalKey<FormState> formKey,
    required void Function(AuthFieldKey? field, String? message) setServerError,
  }) {
    if (result.ok) {
      return;
    }
    final String message =
        result.errorMessage ?? 'Codigo invalido o expirado';
    if (result.field != null) {
      setServerError(result.field, message);
      formKey.currentState?.validate();
      return;
    }
    if (result.useDialog) {
      AuthFeedback.showErrorDialog(
        context,
        title: 'Codigo no valido',
        message: message,
      );
      return;
    }
    AuthFeedback.showSnackBar(context, message: message);
  }
}
