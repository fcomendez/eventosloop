import 'package:eventosloop/core/config/app_env.dart';
import 'package:eventosloop/core/theme/app_colors.dart';
import 'package:eventosloop/core/widgets/auth_feedback.dart';
import 'package:eventosloop/features/auth/controllers/register_controller.dart';
import 'package:eventosloop/features/auth/models/auth_field_key.dart';
import 'package:eventosloop/features/auth/models/register_form_model.dart';
import 'package:eventosloop/features/auth/models/ubicacion_models.dart';
import 'package:eventosloop/features/auth/navigation/auth_navigation.dart';
import 'package:eventosloop/features/auth/services/auth_api_service.dart';
import 'package:eventosloop/features/auth/services/ubicacion_service.dart';
import 'package:eventosloop/features/auth/utils/auth_form_feedback.dart';
import 'package:eventosloop/features/onboarding/views/welcome_view.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  final RegisterController _controller = RegisterController();
  final UbicacionService _ubicacionService = UbicacionService();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _nombres = TextEditingController();
  final TextEditingController _apellidos = TextEditingController();
  final TextEditingController _username = TextEditingController();
  final TextEditingController _fechaNacimiento = TextEditingController();
  final TextEditingController _direccion = TextEditingController();
  final TextEditingController _postal = TextEditingController();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();
  final TextEditingController _confirmPassword = TextEditingController();
  final FocusNode _emailFocus = FocusNode();
  bool _obscurePassword = true;
  bool _obscureConfirm = true;
  bool _acceptedTerms = false;
  DateTime? _fechaNacimientoSeleccionada;
  String? _generoSeleccionado;
  int? _regionId;
  int? _comunaId;
  List<RegionOption> _regiones = const <RegionOption>[];
  List<ComunaOption> _comunas = const <ComunaOption>[];
  bool _cargandoUbicacion = true;
  bool _enviandoRegistro = false;
  String? _errorUbicacion;
  String? _errorEmailServidor;
  String? _errorUsernameServidor;
  String? _errorPasswordServidor;
  String? _errorComunaServidor;

  @override
  void initState() {
    super.initState();
    _emailFocus.addListener(() {
      if (!_emailFocus.hasFocus && _email.text.trim().isNotEmpty) {
        _controller.validarCorreoUnico(_email.text);
      }
    });
    _cargarUbicacion();
  }

  Future<void> _cargarUbicacion() async {
    setState(() {
      _cargandoUbicacion = true;
      _errorUbicacion = null;
    });
    final List<RegionOption> regiones =
        await _ubicacionService.fetchRegiones();
    final List<ComunaOption> comunas = await _ubicacionService.fetchComunas();
    if (!mounted) {
      return;
    }
    setState(() {
      _regiones = regiones;
      _comunas = comunas;
      _cargandoUbicacion = false;
      if (AppEnv.useSupabase && (regiones.isEmpty || comunas.isEmpty)) {
        _errorUbicacion =
            'No se pudieron cargar regiones/comunas. Levanta Docker (docker compose up -d).';
      }
    });
  }
  @override
  void dispose() {
    _nombres.dispose();
    _apellidos.dispose();
    _username.dispose();
    _fechaNacimiento.dispose();
    _direccion.dispose();
    _postal.dispose();
    _email.dispose();
    _password.dispose();
    _confirmPassword.dispose();
    _emailFocus.dispose();
    _controller.dispose();
    super.dispose();
  }

  void _limpiarErroresServidor() {
    if (_errorEmailServidor != null ||
        _errorUsernameServidor != null ||
        _errorPasswordServidor != null ||
        _errorComunaServidor != null) {
      setState(() {
        _errorEmailServidor = null;
        _errorUsernameServidor = null;
        _errorPasswordServidor = null;
        _errorComunaServidor = null;
      });
    }
  }

  void _setErrorServidor(AuthFieldKey? field, String? message) {
    setState(() {
      _errorEmailServidor = null;
      _errorUsernameServidor = null;
      _errorPasswordServidor = null;
      _errorComunaServidor = null;
      switch (field) {
        case AuthFieldKey.email:
          _errorEmailServidor = message;
        case AuthFieldKey.username:
          _errorUsernameServidor = message;
        case AuthFieldKey.password:
          _errorPasswordServidor = message;
        case AuthFieldKey.comuna:
          _errorComunaServidor = message;
        case AuthFieldKey.confirmPassword:
        case AuthFieldKey.otp:
        case AuthFieldKey.region:
        case AuthFieldKey.generic:
        case null:
          break;
      }
    });
  }

  Future<void> _submit() async {
    _limpiarErroresServidor();
    if (!(_formKey.currentState?.validate() ?? false)) {
      AuthFeedback.showSnackBar(
        context,
        message: 'Revisa los campos marcados antes de continuar.',
      );
      return;
    }
    if (!_acceptedTerms) {
      await AuthFeedback.showInfoDialog(
        context,
        title: 'Terminos y privacidad',
        message: 'Debes aceptar los Terminos de Servicio y la Politica de Privacidad para crear tu cuenta.',
      );
      return;
    }
    if (_fechaNacimientoSeleccionada == null) {
      _formKey.currentState?.validate();
      return;
    }
    if (_generoSeleccionado == null) {
      _formKey.currentState?.validate();
      return;
    }
    if (_comunaId == null || _regionActual == null) {
      AuthFeedback.showSnackBar(
        context,
        message: 'Selecciona region y comuna validas.',
      );
      return;
    }

    final RegisterFormModel model = RegisterFormModel(
      nombres: _nombres.text.trim(),
      apellidos: _apellidos.text.trim(),
      username: _username.text.trim(),
      fechaNacimiento: _fechaNacimientoSeleccionada!,
      genero: _generoSeleccionado!,
      direccion: _direccion.text.trim(),
      comunaId: _comunaId!,
      region: _regionActual!.nombre,
      codigoPostal: _postal.text.trim(),
      email: _email.text.trim(),
      password: _password.text,
    );

    setState(() => _enviandoRegistro = true);
    final ServiceResult result = await _controller.enviarRegistro(model);
    if (!mounted) {
      return;
    }
    setState(() => _enviandoRegistro = false);

    if (result.ok) {
      final Session? session = Supabase.instance.client.auth.currentSession;
      if (session != null) {
        AuthFeedback.showSnackBar(
          context,
          message: 'Cuenta creada correctamente',
          isError: false,
        );
        await AuthNavigation.navigateAfterAuth(
          context,
          email: session.user.email ?? model.email,
        );
        return;
      }
      await AuthFeedback.showInfoDialog(
        context,
        title: 'Cuenta creada',
        message:
            'Revisa tu correo para confirmar la cuenta e inicia sesion cuando recibas el enlace.',
      );
      if (!mounted) {
        return;
      }
      Navigator.of(context).pushReplacement(
        MaterialPageRoute<void>(builder: (_) => const WelcomeView()),
      );
      return;
    }

    AuthFormFeedback.handleServiceResult(
      context,
      result: result,
      formKey: _formKey,
      setServerError: _setErrorServidor,
      dialogTitle: 'No se pudo crear la cuenta',
    );
  }

  Future<void> _pickFechaNacimiento() async {
    final DateTime now = DateTime.now();
    final DateTime? selected = await showDatePicker(
      context: context,
      initialDate: DateTime(now.year - 18),
      firstDate: DateTime(1900),
      lastDate: DateTime(now.year - 10),
      locale: const Locale('es', 'CL'),
    );
    if (selected == null) {
      return;
    }
    setState(() {
      _fechaNacimientoSeleccionada = selected;
      _fechaNacimiento.text =
          '${selected.day.toString().padLeft(2, '0')}/${selected.month.toString().padLeft(2, '0')}/${selected.year}';
    });
  }

  Widget _sectionTitle(IconData icon, String title) {
    return Row(
      children: <Widget>[
        CircleAvatar(
          radius: 14,
          backgroundColor: AppColors.primary.withValues(alpha: 0.15),
          child: Icon(icon, size: 15, color: AppColors.primary),
        ),
        const SizedBox(width: 8),
        Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),
      ],
    );
  }

  Widget _field({
    required TextEditingController controller,
    required String label,
    String? hint,
    String? Function(String?)? validator,
    TextInputType? keyboardType,
    bool obscure = false,
    bool readOnly = false,
    Widget? suffixIcon,
    FocusNode? focusNode,
    VoidCallback? onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: 6),
        TextFormField(
          controller: controller,
          focusNode: focusNode,
          validator: validator,
          keyboardType: keyboardType,
          obscureText: obscure,
          readOnly: readOnly,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          onChanged: onChanged == null ? null : (_) => onChanged(),
          decoration: InputDecoration(hintText: hint, suffixIcon: suffixIcon),
        ),
      ],
    );
  }

  List<ComunaOption> get _comunasFiltradas {
    if (_regionId == null) {
      return const <ComunaOption>[];
    }
    return _comunas
        .where((ComunaOption comuna) => comuna.regionId == _regionId)
        .toList();
  }

  RegionOption? get _regionActual {
    for (final RegionOption region in _regiones) {
      if (region.id == _regionId) {
        return region;
      }
    }
    return null;
  }

  String? _validarRegion(int? value) {
    if (value == null) {
      return 'Region es obligatoria';
    }
    return null;
  }

  String? _validarComuna(int? value) {
    if (value == null) {
      return 'Comuna es obligatoria';
    }
    return null;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Crear cuenta'),
        centerTitle: true,
        actions: const <Widget>[
          Padding(
            padding: EdgeInsets.only(right: 16, top: 18),
            child: Text(
              'LOOP',
              style: TextStyle(fontWeight: FontWeight.w800),
            ),
          ),
        ],
      ),
      body: AnimatedBuilder(
        animation: _controller,
        builder: (BuildContext context, Widget? child) {
          return Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: <Color>[Color(0xFFDEEDF8), Color(0xFFF5FAFF)],
              ),
            ),
            child: SafeArea(
              child: Form(
                key: _formKey,
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(16, 10, 16, 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      const Center(
                        child: Text(
                          'Unete a la comunidad',
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 18,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ),
                      const SizedBox(height: 4),
                      const Center(
                        child: Text(
                          'Vive una nueva era de conexion digital.',
                          style: TextStyle(color: AppColors.textSecondary),
                        ),
                      ),
                      const SizedBox(height: 16),
                      _sectionTitle(Icons.person, 'Datos personales'),
                      const SizedBox(height: 8),
                      _field(
                        controller: _nombres,
                        label: 'Nombres',
                        hint: 'ej: Juan',
                        validator: (String? v) =>
                            _controller.validarRequerido(v, 'Nombres'),
                      ),
                      const SizedBox(height: 10),
                      _field(
                        controller: _apellidos,
                        label: 'Apellidos',
                        hint: 'ej: Perez',
                        validator: (String? v) =>
                            _controller.validarRequerido(v, 'Apellidos'),
                      ),
                      const SizedBox(height: 10),
                      _field(
                        controller: _username,
                        label: 'Nombre de Usuario/Alias',
                        hint: 'ej: marcos.loop',
                        validator: (String? v) {
                          if (_errorUsernameServidor != null) {
                            return _errorUsernameServidor;
                          }
                          return _controller.validarUsername(v);
                        },
                        onChanged: _limpiarErroresServidor,
                      ),
                      const SizedBox(height: 10),
                      _field(
                        controller: _fechaNacimiento,
                        label: 'Fecha de Nacimiento',
                        hint: 'DD/MM/AAAA',
                        readOnly: true,
                        validator: (_) => _controller.validarFechaNacimiento(
                          _fechaNacimientoSeleccionada,
                        ),
                        suffixIcon: IconButton(
                          onPressed: _pickFechaNacimiento,
                          icon: const Icon(Icons.calendar_today_outlined),
                        ),
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        'Genero',
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 6),
                      DropdownButtonFormField<String>(
                        initialValue: _generoSeleccionado,
                        decoration: const InputDecoration(
                            hintText: 'Selecciona genero'),
                        items: const <DropdownMenuItem<String>>[
                          DropdownMenuItem<String>(
                            value: 'MASCULINO',
                            child: Text('Masculino'),
                          ),
                          DropdownMenuItem<String>(
                            value: 'FEMENINO',
                            child: Text('Femenino'),
                          ),
                          DropdownMenuItem<String>(
                            value: 'OTRO',
                            child: Text('Otro'),
                          ),
                          DropdownMenuItem<String>(
                            value: 'PREFIERO_NO_DECIR',
                            child: Text('Prefiero no decir'),
                          ),
                        ],
                        onChanged: (String? value) {
                          setState(() {
                            _generoSeleccionado = value;
                          });
                        },
                        validator: _controller.validarGenero,
                      ),
                      const SizedBox(height: 18),
                      _sectionTitle(Icons.location_on_outlined, 'Ubicacion'),
                      const SizedBox(height: 8),
                      _field(
                        controller: _direccion,
                        label: 'Direccion',
                        hint: 'Calle, numero, depto',
                        validator: (String? v) =>
                            _controller.validarRequerido(v, 'Direccion'),
                      ),
                      const SizedBox(height: 10),
                      if (_cargandoUbicacion)
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 12),
                          child: Center(child: CircularProgressIndicator()),
                        )
                      else if (_errorUbicacion != null)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: <Widget>[
                              Text(
                                _errorUbicacion!,
                                style: const TextStyle(
                                  color: AppColors.error,
                                  fontSize: 12,
                                  height: 1.35,
                                ),
                              ),
                              TextButton(
                                onPressed: _cargarUbicacion,
                                child: const Text('Reintentar ubicaciones'),
                              ),
                            ],
                          ),
                        )
                      else ...<Widget>[
                        const Text(
                          'Region',
                          style: TextStyle(
                            fontSize: 12,
                            color: AppColors.textSecondary,
                          ),
                        ),
                        const SizedBox(height: 6),
                        DropdownButtonFormField<int>(
                          initialValue: _regionId,
                          decoration: const InputDecoration(
                            hintText: 'Selecciona una region',
                          ),
                          items: _regiones
                              .map(
                                (RegionOption region) => DropdownMenuItem<int>(
                                  value: region.id,
                                  child: Text(region.nombre),
                                ),
                              )
                              .toList(),
                          onChanged: (int? value) {
                            setState(() {
                              _regionId = value;
                              _comunaId = null;
                            });
                          },
                          validator: _validarRegion,
                        ),
                        const SizedBox(height: 10),
                        const Text(
                          'Comuna',
                          style: TextStyle(
                            fontSize: 12,
                            color: AppColors.textSecondary,
                          ),
                        ),
                        const SizedBox(height: 6),
                        DropdownButtonFormField<int>(
                          initialValue: _comunaId,
                          decoration: InputDecoration(
                            hintText: _regionId == null
                                ? 'Primero selecciona una region'
                                : 'Selecciona una comuna',
                            errorText: _errorComunaServidor,
                          ),
                          items: _comunasFiltradas
                              .map(
                                (ComunaOption comuna) => DropdownMenuItem<int>(
                                  value: comuna.id,
                                  child: Text(comuna.nombre),
                                ),
                              )
                              .toList(),
                          onChanged: _regionId == null
                              ? null
                              : (int? value) {
                                  setState(() {
                                    _comunaId = value;
                                    _errorComunaServidor = null;
                                  });
                                },
                          validator: _validarComuna,
                        ),
                      ],
                      const SizedBox(height: 10),
                      _field(
                        controller: _postal,
                        label: 'Codigo Postal',
                        keyboardType: TextInputType.number,
                        validator: (String? v) =>
                            _controller.validarRequerido(v, 'Codigo Postal'),
                      ),
                      const SizedBox(height: 18),
                      _sectionTitle(
                          Icons.lock_outline, 'Seguridad de la cuenta'),
                      const SizedBox(height: 8),
                      _field(
                        controller: _email,
                        focusNode: _emailFocus,
                        keyboardType: TextInputType.emailAddress,
                        label: 'Correo Electronico',
                        hint: 'email@dominio.com',
                        validator: (String? v) {
                          if (_errorEmailServidor != null) {
                            return _errorEmailServidor;
                          }
                          return _controller.validarEmail(v);
                        },
                        onChanged: _limpiarErroresServidor,
                      ),
                      if (_controller.checkingEmail)
                        const Padding(
                          padding: EdgeInsets.only(top: 6),
                          child: Text(
                            'Verificando correo...',
                            style: TextStyle(
                              fontSize: 12,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ),
                      if (_controller.emailMensaje != null)
                        Padding(
                          padding: const EdgeInsets.only(top: 6),
                          child: Text(
                            _controller.emailMensaje!,
                            style: const TextStyle(
                              fontSize: 12,
                              color: AppColors.error,
                            ),
                          ),
                        ),
                      const SizedBox(height: 10),
                      _field(
                        controller: _password,
                        label: 'Contrasena Alfanumerica',
                        obscure: _obscurePassword,
                        validator: (String? v) {
                          if (_errorPasswordServidor != null) {
                            return _errorPasswordServidor;
                          }
                          return _controller.validarPassword(v);
                        },
                        onChanged: _limpiarErroresServidor,
                        suffixIcon: IconButton(
                          onPressed: () => setState(() {
                            _obscurePassword = !_obscurePassword;
                          }),
                          icon: Icon(
                            _obscurePassword
                                ? Icons.visibility_outlined
                                : Icons.visibility_off_outlined,
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      _field(
                        controller: _confirmPassword,
                        label: 'Confirmar Contrasena',
                        obscure: _obscureConfirm,
                        validator: (String? v) =>
                            _controller.validarConfirmacion(v, _password.text),
                        suffixIcon: IconButton(
                          onPressed: () => setState(() {
                            _obscureConfirm = !_obscureConfirm;
                          }),
                          icon: Icon(
                            _obscureConfirm
                                ? Icons.visibility_outlined
                                : Icons.visibility_off_outlined,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Minimo 8 y maximo 16 caracteres, alfanumerica.',
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 10),
                      CheckboxListTile(
                        contentPadding: EdgeInsets.zero,
                        value: _acceptedTerms,
                        controlAffinity: ListTileControlAffinity.leading,
                        onChanged: (bool? value) {
                          setState(() {
                            _acceptedTerms = value ?? false;
                          });
                        },
                        title: const Text(
                          'Acepto los Terminos de Servicio y Politica de Privacidad.',
                          style: TextStyle(fontSize: 12),
                        ),
                      ),
                      const SizedBox(height: 8),
                      SizedBox(
                        height: 46,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            foregroundColor: AppColors.white,
                          ),
                          onPressed: _enviandoRegistro ? null : _submit,
                          child: _enviandoRegistro
                              ? const SizedBox(
                                  width: 18,
                                  height: 18,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: AppColors.white,
                                  ),
                                )
                              : const Text('Crear cuenta'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
