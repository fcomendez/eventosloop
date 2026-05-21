import 'dart:async';

import 'package:eventosloop/core/theme/app_colors.dart';
import 'package:eventosloop/features/auth/controllers/otp_verification_controller.dart';
import 'package:eventosloop/features/auth/services/auth_api_service.dart';
import 'package:eventosloop/features/auth/views/reset_password_view.dart';
import 'package:flutter/material.dart';

class OtpVerificationView extends StatefulWidget {
  const OtpVerificationView({super.key, required this.email});

  final String email;

  @override
  State<OtpVerificationView> createState() => _OtpVerificationViewState();
}

class _OtpVerificationViewState extends State<OtpVerificationView> {
  final OtpVerificationController _controller = OtpVerificationController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _otpController = TextEditingController();
  bool _loading = false;
  bool _reenviando = false;
  int _segundosRestantes = 0;
  Timer? _cooldownTimer;

  @override
  void dispose() {
    _cooldownTimer?.cancel();
    _otpController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) {
      return;
    }
    setState(() {
      _loading = true;
    });
    final String? resetToken = await _controller.verificarCodigo(
      email: widget.email,
      otp: _otpController.text,
    );
    if (!mounted) {
      return;
    }
    setState(() {
      _loading = false;
    });

    if (resetToken == null || resetToken.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Codigo invalido o expirado')),
      );
      return;
    }
    Navigator.of(context).pushReplacement(
      MaterialPageRoute<void>(
        builder: (_) => ResetPasswordView(
          email: widget.email,
          resetToken: resetToken,
        ),
      ),
    );
  }

  Future<void> _reenviarCodigo() async {
    if (_reenviando || _segundosRestantes > 0) {
      return;
    }
    setState(() {
      _reenviando = true;
    });
    final ServiceResult result = await _controller.reenviarCodigo(widget.email);
    if (!mounted) {
      return;
    }
    setState(() {
      _reenviando = false;
    });
    if (!result.ok) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            result.errorMessage ?? 'No se pudo reenviar el codigo',
          ),
        ),
      );
      return;
    }
    _iniciarCooldown();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Te enviamos un nuevo codigo')),
    );
  }

  void _iniciarCooldown() {
    _cooldownTimer?.cancel();
    setState(() {
      _segundosRestantes = 30;
    });
    _cooldownTimer = Timer.periodic(const Duration(seconds: 1), (Timer timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }
      if (_segundosRestantes <= 1) {
        timer.cancel();
        setState(() {
          _segundosRestantes = 0;
        });
        return;
      }
      setState(() {
        _segundosRestantes--;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Verificar identidad')),
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
                        'Verifica tu identidad',
                        style: TextStyle(
                          fontSize: 21,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Codigo enviado a ${widget.email}.',
                        style: const TextStyle(color: AppColors.textSecondary),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'CODIGO DE VERIFICACION',
                        style: TextStyle(
                          fontSize: 10,
                          color: AppColors.textSecondary,
                          letterSpacing: 1.1,
                        ),
                      ),
                      const SizedBox(height: 6),
                      TextFormField(
                        controller: _otpController,
                        validator: _controller.validarOtp,
                        keyboardType: TextInputType.text,
                        maxLength: 16,
                        decoration: const InputDecoration(
                          hintText: 'Ingresa tu codigo',
                          counterText: '',
                        ),
                      ),
                      const SizedBox(height: 16),
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
                              : const Text('Verificar'),
                        ),
                      ),
                      const SizedBox(height: 10),
                      TextButton(
                        onPressed:
                            (_reenviando || _segundosRestantes > 0)
                                ? null
                                : _reenviarCodigo,
                        child: _reenviando
                            ? const Text('Reenviando...')
                            : Text(
                                _segundosRestantes > 0
                                    ? 'Reenviar codigo en ${_segundosRestantes}s'
                                    : 'Reenviar codigo',
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
