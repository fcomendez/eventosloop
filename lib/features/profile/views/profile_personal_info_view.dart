import 'dart:io';

import 'package:eventosloop/core/config/app_env.dart';
import 'package:eventosloop/core/services/media_storage_service.dart';
import 'package:eventosloop/core/theme/app_colors.dart';
import 'package:eventosloop/core/widgets/loop_user_avatar.dart';
import 'package:eventosloop/features/auth/navigation/auth_navigation.dart';
import 'package:eventosloop/features/auth/services/auth_api_service.dart';
import 'package:eventosloop/features/profile/models/profile_model.dart';
import 'package:eventosloop/features/profile/services/profile_supabase_service.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ProfilePersonalInfoView extends StatefulWidget {
  const ProfilePersonalInfoView({super.key});

  @override
  State<ProfilePersonalInfoView> createState() => _ProfilePersonalInfoViewState();
}

class _ProfilePersonalInfoViewState extends State<ProfilePersonalInfoView> {
  final ProfileSupabaseService _profileService = ProfileSupabaseService();
  final MediaStorageService _mediaStorage = MediaStorageService();
  final ImagePicker _imagePicker = ImagePicker();
  ProfileModel? _profile;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  String _gender = 'Prefiero no decir';
  String _nationality = 'Chileno';
  bool _loading = true;
  bool _saving = false;
  String? _pendingAvatarUrl;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    if (AppEnv.useSupabase) {
      final ProfilePersonalInfoData? info =
          await _profileService.fetchPersonalInfo();
      if (info != null && mounted) {
        setState(() {
          _profile = ProfileModel(
            fullName: info.fullName,
            username: info.username,
            avatarInitials: info.avatarInitials,
            avatarUrl: info.avatarUrl,
            email: info.email,
            postsCount: 0,
            followersCount: 0,
            followingCount: 0,
            eventsAttendedCount: 0,
            communitiesJoinedCount: 0,
            interests: const <String>[],
            imagePosts: const <ProfileImagePostModel>[],
            writtenPosts: const <ProfileWrittenPostModel>[],
            pastEvents: const <ProfilePastEventModel>[],
            communities: const <ProfileCommunityModel>[],
            userId: info.userId,
          );
          _emailController.text = info.email;
          _phoneController.text = info.phone;
          _gender = _normalizeGender(info.gender);
          _nationality = info.nationality;
          _pendingAvatarUrl = info.avatarUrl;
          _loading = false;
        });
        return;
      }
    }
    if (mounted) {
      setState(() => _loading = false);
    }
  }

  String _normalizeGender(String value) {
    const List<String> allowed = <String>[
      'Hombre',
      'Mujer',
      'Otro',
      'Prefiero no decir',
    ];
    if (allowed.contains(value)) {
      return value;
    }
    return 'Prefiero no decir';
  }

  Future<void> _pickAvatar() async {
    final XFile? picked =
        await _imagePicker.pickImage(source: ImageSource.gallery);
    if (picked == null) {
      return;
    }
    final String? url = await _mediaStorage.uploadImage(
      file: File(picked.path),
      bucket: MediaBucket.avatars,
    );
    if (url == null || !mounted) {
      return;
    }
    setState(() {
      _pendingAvatarUrl = url;
      if (_profile != null) {
        _profile = _profile!.copyWith(avatarUrl: url);
      }
    });
  }

  Future<void> _savePersonalInfo() async {
    if (!AppEnv.useSupabase) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Supabase no esta configurado')),
      );
      return;
    }
    setState(() => _saving = true);
    try {
      await _profileService.updatePersonalInfo(
        telefono: _phoneController.text,
        nacionalidad: _nationality,
        genero: _gender,
        avatarUrl: _pendingAvatarUrl,
      );
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Informacion actualizada')),
      );
    } catch (e) {
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString().replaceFirst('Exception: ', '')),
        ),
      );
    } finally {
      if (mounted) {
        setState(() => _saving = false);
      }
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _showDeleteAccountWarning() async {
    final bool? confirmed = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          title: const Text('Estas seguro que deseas eliminar tu cuenta?'),
          content: const Text(
            'Recuerda que al eliminar tu cuenta se borraran tus datos de manera permanente y no podran restablecerse.',
            style: TextStyle(height: 1.35),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('No borrar'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.error,
                foregroundColor: AppColors.white,
              ),
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Si, confirmo'),
            ),
          ],
        );
      },
    );

    if (confirmed == true && mounted) {
      await _showPasswordDeleteConfirmation();
    }
  }

  Future<void> _showPasswordDeleteConfirmation() async {
    final TextEditingController passwordController = TextEditingController();
    final bool? accepted = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          title: const Text('Confirma tu contrasena'),
          content: TextField(
            controller: passwordController,
            obscureText: true,
            decoration: const InputDecoration(
              labelText: 'Contrasena actual',
              prefixIcon: Icon(Icons.lock_outline),
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.error,
                foregroundColor: AppColors.white,
              ),
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Eliminar cuenta'),
            ),
          ],
        );
      },
    );

    final String password = passwordController.text;
    passwordController.dispose();

    if (accepted != true || !mounted) {
      return;
    }

    setState(() => _saving = true);
    try {
      await _profileService.eliminarCuenta(password: password);
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Cuenta eliminada correctamente')),
      );
      await AuthNavigation.cerrarSesion(context);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              e.toString().replaceFirst('Exception: ', ''),
            ),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _saving = false);
      }
    }
  }

  void _openPasswordSheet() {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return const _PasswordChangeSheet();
      },
    );
  }

  Future<void> _confirmarCerrarSesion() async {
    final bool? confirmed = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          title: const Text('Cerrar sesion'),
          content: const Text(
            'Saldras de tu cuenta en este dispositivo. Podras volver a iniciar sesion cuando quieras.',
            style: TextStyle(height: 1.35),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Cerrar sesion'),
            ),
          ],
        );
      },
    );
    if (confirmed != true || !mounted) {
      return;
    }
    await AuthNavigation.cerrarSesion(context);
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: <Color>[Color(0xFFF5F0F8), Color(0xFFEAF4FC)],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: <Widget>[
              _topBar(),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(18, 12, 18, 24),
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Stack(
                          alignment: Alignment.bottomRight,
                          children: <Widget>[
                            GestureDetector(
                              onTap: _pickAvatar,
                              child: LoopUserAvatar(
                                avatarUrl: _pendingAvatarUrl ?? _profile?.avatarUrl,
                                initials: _profile?.avatarInitials ?? 'AC',
                                radius: 34,
                                fontSize: 22,
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                            Container(
                              width: 24,
                              height: 24,
                              decoration: const BoxDecoration(
                                color: AppColors.primary,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.camera_alt,
                                color: AppColors.white,
                                size: 14,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(width: 14),
                        const Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                'Informacion Personal',
                                style: TextStyle(
                                  color: AppColors.textPrimary,
                                  fontSize: 23,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                'Manten tus datos de contacto actualizados.',
                                style: TextStyle(
                                  color: AppColors.textSecondary,
                                  height: 1.25,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 22),
                    _label('Correo electronico'),
                    TextField(
                      controller: _emailController,
                      readOnly: true,
                      decoration: const InputDecoration(
                        prefixIcon: Icon(Icons.email_outlined),
                      ),
                    ),
                    const SizedBox(height: 14),
                    _label('Numero de telefono'),
                    TextField(
                      controller: _phoneController,
                      keyboardType: TextInputType.phone,
                      decoration: const InputDecoration(
                        prefixIcon: Icon(Icons.phone_outlined),
                      ),
                    ),
                    const SizedBox(height: 14),
                    _label('Nacionalidad'),
                    DropdownButtonFormField<String>(
                      initialValue: _nationality,
                      decoration: const InputDecoration(
                        prefixIcon: Icon(Icons.flag_outlined),
                      ),
                      items: const <DropdownMenuItem<String>>[
                        DropdownMenuItem<String>(
                          value: 'Chileno',
                          child: Text('Chileno'),
                        ),
                        DropdownMenuItem<String>(
                          value: 'Extranjero',
                          child: Text('Extranjero'),
                        ),
                      ],
                      onChanged: (String? value) {
                        if (value == null) {
                          return;
                        }
                        setState(() {
                          _nationality = value;
                        });
                      },
                    ),
                    const SizedBox(height: 14),
                    _label('Genero'),
                    DropdownButtonFormField<String>(
                      initialValue: _gender,
                      decoration: const InputDecoration(
                        prefixIcon: Icon(Icons.person_outline),
                      ),
                      items: const <DropdownMenuItem<String>>[
                        DropdownMenuItem<String>(
                          value: 'Hombre',
                          child: Text('Hombre'),
                        ),
                        DropdownMenuItem<String>(
                          value: 'Mujer',
                          child: Text('Mujer'),
                        ),
                        DropdownMenuItem<String>(
                          value: 'Otro',
                          child: Text('Otro'),
                        ),
                        DropdownMenuItem<String>(
                          value: 'Prefiero no decir',
                          child: Text('Prefiero no decir'),
                        ),
                      ],
                      onChanged: (String? value) {
                        if (value == null) {
                          return;
                        }
                        setState(() {
                          _gender = value;
                        });
                      },
                    ),
                    const SizedBox(height: 18),
                    _verificationCard(),
                    const SizedBox(height: 16),
                    SizedBox(
                      height: 48,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: AppColors.white,
                        ),
                        onPressed: _saving ? null : _savePersonalInfo,
                        child: _saving
                            ? const SizedBox(
                                width: 18,
                                height: 18,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: AppColors.white,
                                ),
                              )
                            : const Text('Actualizar informacion'),
                      ),
                    ),
                    const SizedBox(height: 10),
                    SizedBox(
                      height: 46,
                      child: OutlinedButton.icon(
                        onPressed: _openPasswordSheet,
                        icon: const Icon(Icons.lock_reset),
                        label: const Text('Cambiar contrasena'),
                      ),
                    ),
                    const SizedBox(height: 10),
                    SizedBox(
                      height: 46,
                      child: OutlinedButton.icon(
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppColors.primaryDark,
                          side: const BorderSide(color: AppColors.divider),
                        ),
                        onPressed: _confirmarCerrarSesion,
                        icon: const Icon(Icons.logout),
                        label: const Text('Cerrar sesion'),
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Divider(),
                    const SizedBox(height: 8),
                    TextButton.icon(
                      style: TextButton.styleFrom(
                        foregroundColor: AppColors.error,
                        alignment: Alignment.centerLeft,
                      ),
                      onPressed: _showDeleteAccountWarning,
                      icon: const Icon(Icons.delete_outline),
                      label: const Text('Eliminar cuenta permanentemente'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _topBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 10, 16, 4),
      child: Row(
        children: <Widget>[
          IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: const Icon(Icons.arrow_back),
            color: AppColors.primaryDark,
          ),
          const SizedBox(width: 4),
          const Text(
            'Configuracion de Perfil',
            style: TextStyle(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w900,
            ),
          ),
        ],
      ),
    );
  }

  Widget _label(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Text(
        text,
        style: const TextStyle(
          color: AppColors.textSecondary,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  Widget _verificationCard() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.divider),
      ),
      child: const Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Icon(Icons.verified_user_outlined, color: AppColors.primary),
          SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  'Estado de verificacion',
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Tu cuenta ha sido verificada correctamente mediante el correo electronico proporcionado.',
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    height: 1.3,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _PasswordChangeSheet extends StatefulWidget {
  const _PasswordChangeSheet();

  @override
  State<_PasswordChangeSheet> createState() => _PasswordChangeSheetState();
}

class _PasswordChangeSheetState extends State<_PasswordChangeSheet> {
  final AuthApiService _authService = AuthApiService();
  final TextEditingController _currentPassword = TextEditingController();
  final TextEditingController _newPassword = TextEditingController();
  final TextEditingController _confirmPassword = TextEditingController();
  bool _showNewPassword = true;
  bool _saving = false;

  bool get _hasLength =>
      _newPassword.text.length >= 8 && _newPassword.text.length <= 16;
  bool get _hasUppercase => RegExp(r'[A-Z]').hasMatch(_newPassword.text);
  bool get _isAlphanumeric =>
      RegExp(r'^[A-Za-z0-9]+$').hasMatch(_newPassword.text);
  bool get _matches => _newPassword.text == _confirmPassword.text;
  bool get _canSave =>
      _currentPassword.text.isNotEmpty &&
      _hasLength &&
      _hasUppercase &&
      _isAlphanumeric &&
      _matches;

  @override
  void dispose() {
    _currentPassword.dispose();
    _newPassword.dispose();
    _confirmPassword.dispose();
    super.dispose();
  }

  void _refresh() {
    setState(() {});
  }

  Future<void> _savePassword() async {
    if (!_canSave || _saving) {
      return;
    }
    setState(() => _saving = true);
    final ServiceResult result = await _authService.cambiarPasswordAutenticado(
      passwordActual: _currentPassword.text,
      nuevaPassword: _newPassword.text,
    );
    if (!mounted) {
      return;
    }
    setState(() => _saving = false);
    if (!result.ok) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            result.errorMessage ?? 'No se pudo cambiar la contrasena',
          ),
        ),
      );
      return;
    }
    Navigator.of(context).pop();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Contrasena actualizada')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Container(
        height: MediaQuery.of(context).size.height * 0.58,
        padding: const EdgeInsets.fromLTRB(20, 14, 20, 20),
        decoration: const BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Center(
                child: Container(
                  width: 44,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.divider,
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Cambiar contrasena',
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 22,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 14),
              TextField(
                controller: _currentPassword,
                obscureText: true,
                onChanged: (_) => _refresh(),
                decoration: const InputDecoration(
                  labelText: 'Contrasena actual',
                  prefixIcon: Icon(Icons.lock_outline),
                ),
              ),
              const SizedBox(height: 12),
              _rulesBox(),
              const SizedBox(height: 12),
              TextField(
                controller: _newPassword,
                obscureText: !_showNewPassword,
                onChanged: (_) => _refresh(),
                decoration: InputDecoration(
                  labelText: 'Nueva contrasena',
                  prefixIcon: const Icon(Icons.password),
                  suffixIcon: IconButton(
                    onPressed: () {
                      setState(() {
                        _showNewPassword = !_showNewPassword;
                      });
                    },
                    icon: Icon(
                      _showNewPassword
                          ? Icons.visibility_outlined
                          : Icons.visibility_off_outlined,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _confirmPassword,
                obscureText: true,
                onChanged: (_) => _refresh(),
                decoration: InputDecoration(
                  labelText: 'Confirmar nueva contrasena',
                  prefixIcon: const Icon(Icons.lock_person_outlined),
                  errorText: _confirmPassword.text.isNotEmpty && !_matches
                      ? 'Las contrasenas no coinciden'
                      : null,
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                height: 48,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        _canSave ? AppColors.primary : AppColors.divider,
                    foregroundColor: AppColors.white,
                  ),
                  onPressed: _canSave && !_saving ? _savePassword : null,
                  child: _saving
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: AppColors.white,
                          ),
                        )
                      : const Text('Guardar nueva contrasena'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _rulesBox() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.inputBackground,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _RuleRow(ok: _hasLength, text: 'Entre 8 y 16 caracteres'),
          _RuleRow(ok: _hasUppercase, text: 'Al menos 1 mayuscula'),
          _RuleRow(ok: _isAlphanumeric, text: 'Solo letras y numeros'),
          _RuleRow(ok: _matches, text: 'Confirmacion identica'),
        ],
      ),
    );
  }
}

class _RuleRow extends StatelessWidget {
  const _RuleRow({
    required this.ok,
    required this.text,
  });

  final bool ok;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: <Widget>[
          Icon(
            ok ? Icons.check_circle : Icons.radio_button_unchecked,
            color: ok ? AppColors.primary : AppColors.textSecondary,
            size: 17,
          ),
          const SizedBox(width: 8),
          Text(
            text,
            style: TextStyle(
              color: ok ? AppColors.textPrimary : AppColors.textSecondary,
              fontWeight: ok ? FontWeight.w700 : FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
