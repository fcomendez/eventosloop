import 'package:eventosloop/core/theme/app_colors.dart';
import 'package:eventosloop/features/auth/controllers/login_controller.dart';
import 'package:eventosloop/features/auth/views/forgot_password_view.dart';
import 'package:eventosloop/features/auth/views/register_view.dart';
import 'package:eventosloop/features/feed/views/feed_home_view.dart';
import 'package:eventosloop/features/onboarding/services/intereses_service.dart';
import 'package:eventosloop/features/onboarding/views/welcome_view.dart';
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
  bool _iniciandoGoogle = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _navegarPostLogin(String email) async {
    final bool tieneIntereses =
        await InteresesService().usuarioTieneIntereses();
    if (!mounted) {
      return;
    }
    if (tieneIntereses) {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute<void>(
          builder: (_) => FeedHomeView(email: email),
        ),
        (_) => false,
      );
    } else {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute<void>(
          builder: (_) => const WelcomeView(),
        ),
        (_) => false,
      );
    }
  }

  Future<void> _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) {
      return;
    }
    final session = await _controller.iniciarSesionConCorreo(
      email: _emailController.text,
      password: _passwordController.text,
    );
    if (!mounted) {
      return;
    }
    if (session != null) {
      await _navegarPostLogin(session.email);
      return;
    }
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('No se pudo iniciar sesion con backend')),
    );
  }

  Future<void> _loginGoogle() async {
    setState(() {
      _iniciandoGoogle = true;
    });
    final session = await _controller.iniciarSesionConGoogle();
    if (!mounted) {
      return;
    }
    setState(() {
      _iniciandoGoogle = false;
    });
    if (session != null) {
      await _navegarPostLogin(session.email);
      return;
    }
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'No se pudo iniciar con Google. Revisa configuracion OAuth/API.',
        ),
      ),
    );
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
                            validator: _controller.validarEmail,
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
                            validator: _controller.validarPassword,
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
                              onPressed: _submit,
                              child: const Text('Iniciar sesion'),
                            ),
                          ),
                          const SizedBox(height: 18),
                          const Center(
                            child: Text(
                              'O CONTINUA CON',
                              style: TextStyle(
                                fontSize: 10,
                                color: AppColors.textSecondary,
                                letterSpacing: 1.1,
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: <Widget>[
                              Expanded(
                                child: OutlinedButton(
                                  onPressed:
                                      _iniciandoGoogle ? null : _loginGoogle,
                                  child: _iniciandoGoogle
                                      ? const SizedBox(
                                          height: 16,
                                          width: 16,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                          ),
                                        )
                                      : const Text('Continuar con Google'),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: OutlinedButton(
                                  onPressed: () {},
                                  child: const Text('Continuar con Apple'),
                                ),
                              ),
                            ],
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
