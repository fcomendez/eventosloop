import 'dart:io';

import 'package:eventosloop/core/config/app_env.dart';
import 'package:eventosloop/core/data/chile_comunas.dart';
import 'package:eventosloop/core/services/geocoding_service.dart';
import 'package:eventosloop/core/services/media_storage_service.dart';
import 'package:eventosloop/core/theme/app_colors.dart';
import 'package:eventosloop/core/widgets/scrollable_picker_sheet.dart';
import 'package:eventosloop/features/create/data/user_communities_mock.dart';
import 'package:eventosloop/features/create/services/user_communities_service.dart';
import 'package:eventosloop/features/events/services/event_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

class CreateEventView extends StatefulWidget {
  const CreateEventView({super.key});

  @override
  State<CreateEventView> createState() => _CreateEventViewState();
}

class _CreateEventViewState extends State<CreateEventView> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _capacityController =
      TextEditingController(text: '20');
  final UserCommunitiesService _communitiesService = UserCommunitiesService();
  final EventService _eventService = EventService();
  final GeocodingService _geocodingService = GeocodingService();
  final MediaStorageService _mediaService = MediaStorageService();
  final ImagePicker _imagePicker = ImagePicker();

  String? _selectedCommunityId;
  String? _selectedRegion;
  String? _selectedComuna;
  bool _isPrivate = false;
  bool _submitting = false;
  XFile? _selectedImage;
  List<UserCommunityOption> _communities = UserCommunitiesMock.participando;
  bool _loadingCommunities = true;

  static const List<String> _capacitySuggestions = <String>[
    '5',
    '10',
    '20',
    '50',
    '100',
    '200',
  ];

  List<String> get _comunasDisponibles {
    if (_selectedRegion == null) {
      return const <String>[];
    }
    return ChileComunas.comunasPorRegion(_selectedRegion!);
  }

  @override
  void initState() {
    super.initState();
    _loadCommunities();
  }

  Future<void> _loadCommunities() async {
    final List<UserCommunityOption> items =
        await _communitiesService.fetchParticipando();
    if (mounted) {
      setState(() {
        _communities = items;
        _loadingCommunities = false;
      });
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _dateController.dispose();
    _timeController.dispose();
    _addressController.dispose();
    _capacityController.dispose();
    super.dispose();
  }

  Future<void> _pickCommunity() async {
    if (_loadingCommunities) {
      return;
    }
    final String? selected = await showScrollablePickerSheet<String>(
      context: context,
      title: 'Comunidad del evento',
      children: _communities
          .map(
            (UserCommunityOption community) => ListTile(
              leading:
                  const Icon(Icons.groups_outlined, color: AppColors.primary),
              title: Text(community.name),
              onTap: () => Navigator.of(context).pop(community.id),
            ),
          )
          .toList(),
    );
    if (selected == null) {
      return;
    }
    setState(() => _selectedCommunityId = selected);
  }

  Future<void> _pickRegion() async {
    final String? selected = await showScrollablePickerSheet<String>(
      context: context,
      title: 'Region',
      children: ChileComunas.regiones
          .map(
            (String region) => ListTile(
              leading:
                  const Icon(Icons.public_outlined, color: AppColors.primary),
              title: Text(region),
              onTap: () => Navigator.of(context).pop(region),
            ),
          )
          .toList(),
    );
    if (selected == null) {
      return;
    }
    setState(() {
      _selectedRegion = selected;
      _selectedComuna = null;
    });
  }

  Future<void> _pickComuna() async {
    if (_selectedRegion == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Selecciona una region primero')),
      );
      return;
    }
    final List<String> comunas = _comunasDisponibles;
    if (comunas.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No hay comunas para esta region')),
      );
      return;
    }
    final String? selected = await showScrollablePickerSheet<String>(
      context: context,
      title: 'Comuna',
      children: comunas
          .map(
            (String comuna) => ListTile(
              leading: const Icon(Icons.map_outlined, color: AppColors.primary),
              title: Text(comuna),
              onTap: () => Navigator.of(context).pop(comuna),
            ),
          )
          .toList(),
    );
    if (selected == null) {
      return;
    }
    setState(() => _selectedComuna = selected);
  }

  String? _communityLabel() {
    return _communitiesService
        .findById(_communities, _selectedCommunityId)
        ?.name;
  }

  String? _validateCapacity(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Ingresa un cupo maximo';
    }
    if (value.trim().toLowerCase() == 'sin limite' ||
        value.trim().toLowerCase() == 'sin_limite') {
      return null;
    }
    final int? parsed = int.tryParse(value.trim());
    if (parsed == null || parsed < 1) {
      return 'Ingresa un numero valido (minimo 1)';
    }
    if (parsed > 10000) {
      return 'El cupo maximo es 10000';
    }
    return null;
  }

  Future<void> _pickImage() async {
    try {
      final XFile? image = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 85,
      );
      if (mounted && image != null) {
        setState(() => _selectedImage = image);
      }
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No se pudo abrir la galeria')),
        );
      }
    }
  }

  DateTime? _parseDateTime() {
    final String dateRaw = _dateController.text.trim();
    final String timeRaw = _timeController.text.trim();
    if (dateRaw.isEmpty) {
      return null;
    }
    final List<String> parts = dateRaw.split('/');
    if (parts.length != 3) {
      return null;
    }
    final int? day = int.tryParse(parts[0]);
    final int? month = int.tryParse(parts[1]);
    final int? year = int.tryParse(parts[2]);
    if (day == null || month == null || year == null) {
      return null;
    }
    int hour = 18;
    int minute = 0;
    if (timeRaw.contains(':')) {
      final List<String> timeParts = timeRaw.split(':');
      hour = int.tryParse(timeParts[0]) ?? hour;
      minute = int.tryParse(timeParts[1]) ?? minute;
    }
    return DateTime(year, month, day, hour, minute);
  }

  Future<void> _submitEvent() async {
    if (_titleController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Agrega un titulo para el evento')),
      );
      return;
    }
    if (_selectedCommunityId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Selecciona una comunidad')),
      );
      return;
    }
    final String? capacityError =
        _validateCapacity(_capacityController.text);
    if (capacityError != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(capacityError)),
      );
      return;
    }
    if (!AppEnv.useSupabase) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Supabase no esta configurado')),
      );
      return;
    }

    setState(() => _submitting = true);
    try {
      final int comunidadId = int.parse(_selectedCommunityId!);
      int? cupos;
      final String capRaw = _capacityController.text.trim().toLowerCase();
      if (capRaw != 'sin limite' && capRaw != 'sin_limite') {
        cupos = int.tryParse(capRaw);
      }
      int? comunaId;
      if (_selectedComuna != null) {
        comunaId = await _eventService.resolveComunaId(_selectedComuna!);
      }

      final GeocodingResult? coords =
          await _geocodingService.geocodeChileAddress(
        address: _addressController.text.trim(),
        comuna: _selectedComuna,
        region: _selectedRegion,
      );
      if (coords == null &&
          (_addressController.text.trim().isNotEmpty ||
              _selectedComuna != null)) {
        throw Exception(
          'No se pudo ubicar la direccion en el mapa. Revisa calle, comuna y region.',
        );
      }

      String? coverUrl;
      if (_selectedImage != null) {
        coverUrl = await _mediaService.uploadImage(
          file: File(_selectedImage!.path),
          bucket: MediaBucket.events,
        );
      }

      await _eventService.crearEvento(
        titulo: _titleController.text.trim(),
        descripcion: _descriptionController.text.trim(),
        comunidadId: comunidadId,
        esPrivado: _isPrivate,
        cuposMax: cupos,
        direccion: _addressController.text.trim(),
        ubicacionDireccion: _selectedComuna ?? _selectedRegion,
        comunaId: comunaId,
        fechaRealizacion: _parseDateTime(),
        latitud: coords?.latitude,
        longitud: coords?.longitude,
        coverUrl: coverUrl,
      );

      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Evento ${_isPrivate ? 'privado' : 'publico'} creado correctamente',
          ),
        ),
      );
      Navigator.of(context).pop(true);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('No se pudo crear el evento: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _submitting = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
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
              _topBar(context),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(20, 18, 20, 24),
                  children: <Widget>[
                    const Text(
                      'Crear nuevo evento',
                      style: TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 24,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      'Comparte una experiencia con la comunidad. Define los detalles y deja que otros se unan.',
                      style: TextStyle(
                        color: AppColors.textSecondary,
                        height: 1.35,
                      ),
                    ),
                    const SizedBox(height: 18),
                    _imageBox(),
                    const SizedBox(height: 16),
                    _pickerField(
                      label: 'Comunidad',
                      value: _communityLabel(),
                      hint: 'Selecciona una comunidad',
                      icon: Icons.groups_outlined,
                      onTap: _pickCommunity,
                    ),
                    _input(
                      label: 'Titulo del evento',
                      hint: 'Escribe un nombre vibrante',
                      controller: _titleController,
                    ),
                    _input(
                      label: 'Descripcion',
                      hint: 'Que hara que este evento sea especial?',
                      controller: _descriptionController,
                      maxLines: 4,
                    ),
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: _input(
                            label: 'Fecha',
                            hint: 'dd/mm/aaaa',
                            controller: _dateController,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: _input(
                            label: 'Hora',
                            hint: '--:--',
                            controller: _timeController,
                          ),
                        ),
                      ],
                    ),
                    _input(
                      label: 'Direccion',
                      hint: 'Calle, numero o enlace virtual',
                      icon: Icons.location_on_outlined,
                      controller: _addressController,
                    ),
                    _pickerField(
                      label: 'Region',
                      value: _selectedRegion,
                      hint: 'Selecciona una region',
                      icon: Icons.public_outlined,
                      onTap: _pickRegion,
                    ),
                    _pickerField(
                      label: 'Comuna',
                      value: _selectedComuna,
                      hint: _selectedRegion == null
                          ? 'Primero selecciona una region'
                          : 'Selecciona una comuna',
                      icon: Icons.map_outlined,
                      onTap: _pickComuna,
                    ),
                    _capacityField(),
                    _privacyField(),
                    const SizedBox(height: 10),
                    SizedBox(
                      height: 48,
                      child: ElevatedButton(
                        onPressed: _submitting ? null : _submitEvent,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: AppColors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        child: Text(
                          _submitting ? 'Creando...' : 'Crear evento',
                        ),
                      ),
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

  Widget _topBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 10, 16, 4),
      child: Row(
        children: <Widget>[
          IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: const Icon(Icons.arrow_back),
            color: AppColors.primaryDark,
          ),
          const Text(
            'Crear evento',
            style: TextStyle(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w900,
            ),
          ),
        ],
      ),
    );
  }

  Widget _imageBox() {
    return InkWell(
      onTap: _pickImage,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        height: 146,
        decoration: BoxDecoration(
          color: AppColors.inputBackground,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: AppColors.primary.withValues(alpha: 0.35),
          ),
          image: _selectedImage == null
              ? null
              : DecorationImage(
                  image: FileImage(File(_selectedImage!.path)),
                  fit: BoxFit.cover,
                ),
        ),
        child: _selectedImage == null
            ? const Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Icon(Icons.add_a_photo_outlined,
                        color: AppColors.primary, size: 30),
                    SizedBox(height: 8),
                    Text(
                      'Cargar imagen del evento',
                      style: TextStyle(
                        color: AppColors.primaryDark,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    SizedBox(height: 3),
                    Text(
                      'Recomendado: 16:9, max 3MB',
                      style:
                          TextStyle(color: AppColors.textSecondary, fontSize: 12),
                    ),
                  ],
                ),
              )
            : null,
      ),
    );
  }

  Widget _pickerField({
    required String label,
    required String? value,
    required String hint,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            label,
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 12,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 6),
          InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(10),
            child: InputDecorator(
              decoration: InputDecoration(
                hintText: hint,
                prefixIcon: Icon(icon, size: 19),
                suffixIcon: const Icon(Icons.keyboard_arrow_down, size: 20),
              ),
              child: Text(
                value ?? hint,
                style: TextStyle(
                  color: value == null
                      ? AppColors.textSecondary
                      : AppColors.textPrimary,
                  fontWeight: value == null ? FontWeight.w500 : FontWeight.w700,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _capacityField() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const Text(
            'Cupo maximo',
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: 12,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 6),
          TextField(
            controller: _capacityController,
            keyboardType: TextInputType.number,
            inputFormatters: <TextInputFormatter>[
              FilteringTextInputFormatter.digitsOnly,
            ],
            decoration: const InputDecoration(
              hintText: 'Escribe un numero o usa una sugerencia',
              prefixIcon: Icon(Icons.people_outline, size: 19),
            ),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: <Widget>[
              ..._capacitySuggestions.map(
                (String value) => ActionChip(
                  label: Text('$value personas'),
                  onPressed: () {
                    _capacityController.text = value;
                  },
                ),
              ),
              ActionChip(
                label: const Text('Sin limite'),
                onPressed: () {
                  _capacityController.text = 'sin limite';
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _privacyField() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const Text(
              'Visibilidad del evento',
              style: TextStyle(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              'Los eventos privados requieren aprobacion antes de confirmar la inscripcion.',
              style: TextStyle(
                color: AppColors.textSecondary,
                fontSize: 12,
                height: 1.35,
              ),
            ),
            const SizedBox(height: 10),
            Row(
              children: <Widget>[
                Expanded(
                  child: _PrivacyOption(
                    label: 'Publico',
                    subtitle: 'Inscripcion directa',
                    selected: !_isPrivate,
                    onTap: () => setState(() => _isPrivate = false),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _PrivacyOption(
                    label: 'Privado',
                    subtitle: 'Requiere aprobacion',
                    selected: _isPrivate,
                    onTap: () => setState(() => _isPrivate = true),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _input({
    required String label,
    required String hint,
    TextEditingController? controller,
    IconData? icon,
    int maxLines = 1,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            label,
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 12,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 6),
          TextField(
            controller: controller,
            maxLines: maxLines,
            decoration: InputDecoration(
              hintText: hint,
              prefixIcon: icon == null ? null : Icon(icon, size: 19),
            ),
          ),
        ],
      ),
    );
  }
}

class _PrivacyOption extends StatelessWidget {
  const _PrivacyOption({
    required this.label,
    required this.subtitle,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final String subtitle;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
        decoration: BoxDecoration(
          color: selected
              ? AppColors.primary.withValues(alpha: 0.12)
              : AppColors.inputBackground,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: selected ? AppColors.primary : AppColors.divider,
            width: selected ? 1.5 : 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              label,
              style: TextStyle(
                color: selected ? AppColors.primaryDark : AppColors.textPrimary,
                fontWeight: FontWeight.w900,
              ),
            ),
            Text(
              subtitle,
              style: const TextStyle(
                color: AppColors.textSecondary,
                fontSize: 11,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
