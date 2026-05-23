import 'package:eventosloop/core/theme/app_colors.dart';
import 'package:eventosloop/core/widgets/auth_feedback.dart';
import 'package:eventosloop/features/auth/controllers/login_controller.dart';
import 'package:eventosloop/features/auth/models/auth_field_key.dart';
import 'package:eventosloop/features/auth/models/auth_login_result.dart';
import 'package:eventosloop/features/auth/navigation/auth_navigation.dart';
import 'package:eventosloop/features/auth/views/forgot_password_view.dart';
import 'package:eventosloop/features/auth/views/register_view.dart';
import 'package:flutter/material.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final LoginController _controller = LoginController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _obscure = true;
  bool _iniciandoCorreo = false;
  String? _errorEmailServidor;
  String? _errorPasswordServidor;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _limpiarErroresServidor() {
    if (_errorEmailServidor != null || _errorPasswordServidor != null) {
      setState(() {
        _errorEmailServidor = null;
        _errorPasswordServidor = null;
      });
    }
  }

  String? _validarEmail(String? value) {
    if (_errorEmailServidor != null) {
      return _errorEmailServidor;
    }
    return _controller.validarEmail(value);
  }

  String? _validarPassword(String? value) {
    if (_errorPasswordServidor != null) {
      return _errorPasswordServidor;
    }
    return _controller.validarPassword(value);
  }

  Future<void> _navegarPostLogin(String email) async {
    await AuthNavigation.navigateAfterAuth(context, email: email);
  }

  void _aplicarErrorLogin(AuthLoginResult result) {
    if (result.isCancellation) {
      return;
    }
    final String message =
        result.message ?? 'No se pudo iniciar sesion. Intenta nuevamente.';
    if (result.field == AuthFieldKey.email) {
      setState(() => _errorEmailServidor = message);
      _formKey.currentState?.validate();
      return;
    }
    if (result.field == AuthFieldKey.password) {
      setState(() => _errorPasswordServidor = message);
      _formKey.currentState?.validate();
      return;
    }
    if (result.useDialog) {
      AuthFeedback.showErrorDialog(
        context,
        title: 'Inicio de sesion',
        message: message,
      );
      return;
    }
    AuthFeedback.showSnackBar(context, message: message);
  }

  Future<void> _submit() async {
    _limpiarErroresServidor();
    if (!(_formKey.currentState?.validate() ?? false)) {
      return;
    }
    setState(() => _iniciandoCorreo = true);
    final AuthLoginResult result = await _controller.iniciarSesionConCorreo(
      email: _emailController.text,
      password: _passwordController.text,
    );
    if (!mounted) {
      return;
    }
    setState(() => _iniciandoCorreo = false);
    if (result.ok && result.session != null) {
      await _navegarPostLogin(result.session!.email);
      return;
    }
    _aplicarErrorLogin(result);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  const Text(
                    'LOOP',
                    style: TextStyle(
                      fontSize: 42,
                      fontWeight: FontWeight.w800,
                      color: AppColors.primaryDark,
                    ),
                  ),
                  const SizedBox(height: 14),
                  Container(
                    constraints: const BoxConstraints(maxWidth: 330),
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: AppColors.cardBackground,
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          const Text(
                            'Bienvenido',
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textPrimary,
                            ),
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
                            keyboardType: TextInputType.emailAddress,
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            validator: _validarEmail,
                            onChanged: (_) => _limpiarErroresServidor(),
                            decoration: const InputDecoration(
                              hintText: 'nombre@ejemplo.com',
                            ),
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: <Widget>[
                              const Text(
                                'CONTRASENA',
                                style: TextStyle(
                                  fontSize: 10,
                                  color: AppColors.textSecondary,
                                  letterSpacing: 1.1,
                                ),
                              ),
                              const Spacer(),
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute<void>(
                                      builder: (_) =>
                                          const ForgotPasswordView(),
                                    ),
                                  );
                                },
                                child: const Text(
                                  'Olvide mi contrasena',
                                  style: TextStyle(fontSize: 10),
                                ),
                              ),
                            ],
                          ),
                          TextFormField(
                            controller: _passwordController,
                            obscureText: _obscure,
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            validator: _validarPassword,
                            onChanged: (_) => _limpiarErroresServidor(),
                            decoration: InputDecoration(
                              hintText: '••••••••',
                              suffixIcon: IconButton(
                                onPressed: () => setState(() {
                                  _obscure = !_obscure;
                                }),
                                icon: Icon(
                                  _obscure
                                      ? Icons.visibility_outlined
                                      : Icons.visibility_off_outlined,
                                ),
                              ),
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
                              onPressed: _iniciandoCorreo ? null : _submit,
                              child: _iniciandoCorreo
                                  ? const SizedBox(
                                      height: 16,
                                      width: 16,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        color: AppColors.white,
                                      ),
                                    )
                                  : const Text('Iniciar sesion'),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      const Text(
                        'No tienes una cuenta?',
                        style: TextStyle(color: AppColors.textSecondary),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute<void>(
                              builder: (_) => const RegisterView(),
                            ),
                          );
                        },
                        child: const Text('Registrate'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
