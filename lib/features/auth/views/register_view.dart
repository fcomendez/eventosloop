import 'package:eventosloop/core/theme/app_colors.dart';
import 'package:eventosloop/features/auth/controllers/register_controller.dart';
import 'package:eventosloop/features/auth/models/register_form_model.dart';
import 'package:flutter/material.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  final RegisterController _controller = RegisterController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _nombres = TextEditingController();
  final TextEditingController _apellidos = TextEditingController();
  final TextEditingController _username = TextEditingController();
  final TextEditingController _fechaNacimiento = TextEditingController();
  final TextEditingController _direccion = TextEditingController();
  final TextEditingController _comuna = TextEditingController();
  final TextEditingController _region = TextEditingController();
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

  @override
  void initState() {
    super.initState();
    _emailFocus.addListener(() {
      if (!_emailFocus.hasFocus && _email.text.trim().isNotEmpty) {
        _controller.validarCorreoUnico(_email.text);
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
    _comuna.dispose();
    _region.dispose();
    _postal.dispose();
    _email.dispose();
    _password.dispose();
    _confirmPassword.dispose();
    _emailFocus.dispose();
    _controller.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) {
      return;
    }
    if (!_acceptedTerms) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Debes aceptar terminos y privacidad')),
      );
      return;
    }

    final RegisterFormModel model = RegisterFormModel(
      nombres: _nombres.text,
      apellidos: _apellidos.text,
      username: _username.text,
      fechaNacimiento: _fechaNacimientoSeleccionada!,
      genero: _generoSeleccionado!,
      direccion: _direccion.text,
      comuna: _comuna.text,
      region: _region.text,
      codigoPostal: _postal.text,
      email: _email.text,
      password: _password.text,
    );

    final bool ok = await _controller.enviarRegistro(model);
    if (!mounted) {
      return;
    }
    if (ok) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Cuenta creada correctamente')),
      );
      Navigator.of(context).pop();
      return;
    }

    setState(() {});
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('No se pudo crear. Correo ya registrado')),
    );
  }

  Future<void> _pickFechaNacimiento() async {
    final DateTime now = DateTime.now();
    final DateTime? selected = await showDatePicker(
      context: context,
      initialDate: DateTime(now.year - 18),
      firstDate: DateTime(1900),
      lastDate: DateTime(now.year - 10),
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
          decoration: InputDecoration(hintText: hint, suffixIcon: suffixIcon),
        ),
      ],
    );
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
                        hint: 'username',
                        validator: (String? v) =>
                            _controller.validarRequerido(v, 'Alias'),
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
                      _field(
                        controller: _comuna,
                        label: 'Comuna',
                        validator: (String? v) =>
                            _controller.validarRequerido(v, 'Comuna'),
                      ),
                      const SizedBox(height: 10),
                      _field(
                        controller: _region,
                        label: 'Region',
                        validator: (String? v) =>
                            _controller.validarRequerido(v, 'Region'),
                      ),
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
                        validator: _controller.validarEmail,
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
                        validator: _controller.validarPassword,
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
                          onPressed: _submit,
                          child: const Text('Crear cuenta'),
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
