import 'dart:io';

import 'package:eventosloop/core/config/app_env.dart';
import 'package:eventosloop/core/services/media_storage_service.dart';
import 'package:eventosloop/core/theme/app_colors.dart';
import 'package:eventosloop/features/communities/services/community_supabase_service.dart';
import 'package:eventosloop/features/onboarding/models/interes_model.dart';
import 'package:eventosloop/features/onboarding/services/intereses_service.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class CreateCommunityView extends StatefulWidget {
  const CreateCommunityView({super.key});

  @override
  State<CreateCommunityView> createState() => _CreateCommunityViewState();
}

class _CreateCommunityViewState extends State<CreateCommunityView> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _nombreController = TextEditingController();
  final TextEditingController _descripcionController = TextEditingController();
  final InteresesService _interesesService = InteresesService();
  final CommunitySupabaseService _communityService = CommunitySupabaseService();
  final MediaStorageService _mediaService = MediaStorageService();
  final ImagePicker _imagePicker = ImagePicker();

  List<InteresModel> _intereses = <InteresModel>[];
  final Set<int> _selectedInteresIds = <int>{};
  String _privacidad = 'PUBLICA';
  bool _loadingIntereses = true;
  bool _submitting = false;
  XFile? _selectedBanner;

  @override
  void initState() {
    super.initState();
    _loadIntereses();
  }

  @override
  void dispose() {
    _nombreController.dispose();
    _descripcionController.dispose();
    super.dispose();
  }

  Future<void> _loadIntereses() async {
    try {
      final List<InteresModel> items = await _interesesService.obtenerIntereses();
      if (!mounted) {
        return;
      }
      setState(() {
        _intereses = items;
        _loadingIntereses = false;
      });
    } catch (e) {
      if (!mounted) {
        return;
      }
      setState(() => _loadingIntereses = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('$e')),
      );
    }
  }

  Future<void> _pickBanner() async {
    try {
      final XFile? image = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 85,
      );
      if (mounted && image != null) {
        setState(() => _selectedBanner = image);
      }
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No se pudo abrir la galeria')),
        );
      }
    }
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    if (_selectedInteresIds.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Selecciona al menos un interes para tu comunidad.'),
        ),
      );
      return;
    }
    if (!AppEnv.useSupabase) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Supabase no esta configurado.')),
      );
      return;
    }

    setState(() => _submitting = true);
    try {
      String? bannerUrl;
      if (_selectedBanner != null) {
        bannerUrl = await _mediaService.uploadImage(
          file: File(_selectedBanner!.path),
          bucket: MediaBucket.communities,
        );
      }

      await _communityService.solicitarComunidad(
        nombre: _nombreController.text.trim(),
        descripcion: _descripcionController.text.trim(),
        privacidad: _privacidad,
        interesIds: _selectedInteresIds.toList(),
        bannerUrl: bannerUrl,
      );
      if (!mounted) {
        return;
      }
      await showDialog<void>(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: const Text('Solicitud enviada'),
          content: const Text(
            'Tu comunidad quedo en estado PENDIENTE. Un administrador debe '
            'aprobarla antes de que sea visible para otros usuarios.',
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Entendido'),
            ),
          ],
        ),
      );
      if (mounted) {
        Navigator.pop(context);
      }
    } catch (e) {
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('No se pudo enviar la solicitud: $e')),
      );
    } finally {
      if (mounted) {
        setState(() => _submitting = false);
      }
    }
  }

  Widget _bannerPicker() {
    return InkWell(
      onTap: _pickBanner,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        height: 130,
        decoration: BoxDecoration(
          color: AppColors.inputBackground,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: AppColors.primary.withValues(alpha: 0.35),
          ),
          image: _selectedBanner == null
              ? null
              : DecorationImage(
                  image: FileImage(File(_selectedBanner!.path)),
                  fit: BoxFit.cover,
                ),
        ),
        child: _selectedBanner == null
            ? const Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Icon(Icons.add_photo_alternate_outlined,
                        color: AppColors.primary, size: 30),
                    SizedBox(height: 8),
                    Text(
                      'Banner de la comunidad (opcional)',
                      style: TextStyle(
                        color: AppColors.primaryDark,
                        fontWeight: FontWeight.w700,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              )
            : null,
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
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.fromLTRB(8, 8, 16, 0),
                child: Row(
                  children: <Widget>[
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.arrow_back),
                    ),
                    const Expanded(
                      child: Text(
                        'Solicitar comunidad',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w900,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Form(
                  key: _formKey,
                  child: ListView(
                    padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
                    children: <Widget>[
                      const Text(
                        'Crea una solicitud para abrir tu comunidad. '
                        'Un admin la revisara antes de activarla.',
                        style: TextStyle(color: AppColors.textSecondary, height: 1.35),
                      ),
                      const SizedBox(height: 20),
                      _bannerPicker(),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _nombreController,
                        decoration: const InputDecoration(
                          labelText: 'Nombre de la comunidad',
                          hintText: 'Ej: Running Santiago Centro',
                        ),
                        validator: (String? value) {
                          if (value == null || value.trim().length < 3) {
                            return 'Minimo 3 caracteres';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 14),
                      TextFormField(
                        controller: _descripcionController,
                        maxLines: 3,
                        decoration: const InputDecoration(
                          labelText: 'Descripcion',
                          hintText: 'Cuenta de que trata tu comunidad',
                        ),
                      ),
                      const SizedBox(height: 18),
                      const Text(
                        'Privacidad',
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 8),
                      SegmentedButton<String>(
                        segments: const <ButtonSegment<String>>[
                          ButtonSegment<String>(
                            value: 'PUBLICA',
                            label: Text('Publica'),
                            icon: Icon(Icons.public, size: 16),
                          ),
                          ButtonSegment<String>(
                            value: 'PRIVADA',
                            label: Text('Privada'),
                            icon: Icon(Icons.lock_outline, size: 16),
                          ),
                        ],
                        selected: <String>{_privacidad},
                        onSelectionChanged: (Set<String> value) {
                          setState(() => _privacidad = value.first);
                        },
                      ),
                      const SizedBox(height: 6),
                      Text(
                        _privacidad == 'PUBLICA'
                            ? 'Visible en exploracion una vez aprobada.'
                            : 'Solo visible para miembros invitados.',
                        style: const TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        'Intereses (tags)',
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 8),
                      if (_loadingIntereses)
                        const Center(child: CircularProgressIndicator())
                      else
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: _intereses.map((InteresModel interes) {
                            final bool selected =
                                _selectedInteresIds.contains(interes.idInteres);
                            return FilterChip(
                              label: Text(interes.nombre),
                              selected: selected,
                              onSelected: (_) {
                                setState(() {
                                  if (selected) {
                                    _selectedInteresIds.remove(interes.idInteres);
                                  } else {
                                    _selectedInteresIds.add(interes.idInteres);
                                  }
                                });
                              },
                              selectedColor: AppColors.primaryDark,
                              checkmarkColor: AppColors.white,
                              labelStyle: TextStyle(
                                color: selected
                                    ? AppColors.white
                                    : AppColors.primaryDark,
                                fontWeight: FontWeight.w600,
                                fontSize: 12,
                              ),
                            );
                          }).toList(),
                        ),
                      const SizedBox(height: 24),
                      SizedBox(
                        height: 48,
                        child: ElevatedButton(
                          onPressed: _submitting ? null : _submit,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            foregroundColor: AppColors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),
                          child: _submitting
                              ? const SizedBox(
                                  width: 22,
                                  height: 22,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: AppColors.white,
                                  ),
                                )
                              : const Text('Enviar solicitud'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
