import 'package:eventosloop/core/theme/app_colors.dart';
import 'package:eventosloop/features/auth/controllers/forgot_password_controller.dart';
import 'package:eventosloop/features/auth/services/auth_api_service.dart';
import 'package:eventosloop/features/auth/views/otp_verification_view.dart';
import 'package:flutter/material.dart';

class ForgotPasswordView extends StatefulWidget {
  const ForgotPasswordView({super.key});

  @override
  State<ForgotPasswordView> createState() => _ForgotPasswordViewState();
}

class _ForgotPasswordViewState extends State<ForgotPasswordView> {
  final ForgotPasswordController _controller = ForgotPasswordController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  bool _loading = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) {
      return;
    }
    setState(() {
      _loading = true;
    });
    final ServiceResult result =
        await _controller.enviarCodigo(_emailController.text);
    if (!mounted) {
      return;
    }
    setState(() {
      _loading = false;
    });
    if (!result.ok) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            result.errorMessage ?? 'No se pudo enviar el codigo',
          ),
        ),
      );
      return;
    }
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) =>
            OtpVerificationView(email: _emailController.text.trim()),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Recuperar cuenta')),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: <Color>[Color(0xFFD8EAF7), Color(0xFFEAF4FC)],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Container(
                constraints: const BoxConstraints(maxWidth: 360),
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: AppColors.cardBackground,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      const Text(
                        'Olvidaste tu contrasena',
                        style: TextStyle(
                          fontSize: 21,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 6),
                      const Text(
                        'Ingresa tu correo para recibir un codigo de verificacion.',
                        style: TextStyle(color: AppColors.textSecondary),
                      ),
                      const SizedBox(height: 18),
                      const Text(
                        'CORREO ELECTRONICO',
                        style: TextStyle(
                          fontSize: 10,
                          color: AppColors.textSecondary,
                          letterSpacing: 1.1,
                        ),
                      ),
                      const SizedBox(height: 6),
                      TextFormField(
                        controller: _emailController,
                        validator: _controller.validarEmail,
                        keyboardType: TextInputType.emailAddress,
                        decoration: const InputDecoration(
                          hintText: 'nombre@ejemplo.com',
                        ),
                      ),
                      const SizedBox(height: 18),
                      SizedBox(
                        height: 44,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            foregroundColor: AppColors.white,
                          ),
                          onPressed: _loading ? null : _submit,
                          child: _loading
                              ? const SizedBox(
                                  width: 16,
                                  height: 16,
                                  child:
                                      CircularProgressIndicator(strokeWidth: 2),
                                )
                              : const Text('Enviar codigo'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
