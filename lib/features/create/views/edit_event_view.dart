import 'dart:io';

import 'package:eventosloop/core/data/chile_comunas.dart';
import 'package:eventosloop/core/services/geocoding_service.dart';
import 'package:eventosloop/core/services/media_storage_service.dart';
import 'package:eventosloop/core/theme/app_colors.dart';
import 'package:eventosloop/core/widgets/loop_media_image.dart';
import 'package:eventosloop/features/create/data/user_communities_mock.dart';
import 'package:eventosloop/features/create/services/user_communities_service.dart';
import 'package:eventosloop/features/events/models/event_model.dart';
import 'package:eventosloop/features/events/services/event_service.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class EditEventView extends StatefulWidget {
  const EditEventView({super.key, required this.eventId});

  final int eventId;

  @override
  State<EditEventView> createState() => _EditEventViewState();
}

class _EditEventViewState extends State<EditEventView> {
  final EventService _service = EventService();
  final GeocodingService _geocodingService = GeocodingService();
  final MediaStorageService _mediaService = MediaStorageService();
  final ImagePicker _imagePicker = ImagePicker();
  final UserCommunitiesService _communitiesService = UserCommunitiesService();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();

  String? _selectedCommunityId;
  String? _selectedComuna;
  String _selectedCapacity = '20';
  bool _loading = true;
  bool _saving = false;
  String? _coverColorHex;
  String? _existingCoverUrl;
  XFile? _selectedImage;
  List<UserCommunityOption> _communities = UserCommunitiesMock.participando;

  static const List<String> _capacityOptions = <String>[
    '5',
    '10',
    '20',
    '50',
    '100',
    '200',
    'sin_limite',
  ];

  @override
  void initState() {
    super.initState();
    _loadCommunities();
    _load();
  }

  Future<void> _loadCommunities() async {
    final List<UserCommunityOption> items =
        await _communitiesService.fetchParticipando();
    if (mounted) {
      setState(() => _communities = items);
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _dateController.dispose();
    _timeController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    final EventModel? event = await _service.fetchById(widget.eventId);
    if (!mounted) {
      return;
    }
    if (event == null) {
      setState(() => _loading = false);
      return;
    }
    _titleController.text = event.title;
    _descriptionController.text = event.description;
    _dateController.text = event.dateLabel;
    _timeController.text = event.timeLabel;
    _addressController.text = event.address;
    _selectedComuna = event.comuna;
    _coverColorHex = event.coverColorHex;
    _existingCoverUrl = event.coverUrl;
    _selectedCommunityId = '${event.communityId}';
    _selectedCapacity = event.capacity >= 200
        ? '200'
        : _capacityOptions.contains('${event.capacity}')
            ? '${event.capacity}'
            : 'sin_limite';
    setState(() => _loading = false);
  }

  String _capacityLabel(String value) {
    if (value == 'sin_limite') {
      return 'Sin limite';
    }
    return '$value personas';
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

  Future<void> _save() async {
    if (_titleController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Agrega un titulo para el evento')),
      );
      return;
    }
    if (_descriptionController.text.trim().length < 15) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('La descripcion debe tener al menos 15 caracteres'),
        ),
      );
      return;
    }
    setState(() => _saving = true);
    try {
      int? comunaId;
      if (_selectedComuna != null) {
        comunaId = await _service.resolveComunaId(_selectedComuna!);
      }
      int? cupos;
      if (_selectedCapacity != 'sin_limite') {
        cupos = int.tryParse(_selectedCapacity);
      }

      final String? region = _selectedComuna == null
          ? null
          : ChileComunas.regionDeComuna(_selectedComuna!);
      final GeocodingResult? coords =
          await _geocodingService.geocodeChileAddress(
        address: _addressController.text.trim(),
        comuna: _selectedComuna,
        region: region,
      );
      if (coords == null &&
          (_addressController.text.trim().isNotEmpty ||
              _selectedComuna != null)) {
        throw Exception(
          'No se pudo ubicar la direccion en el mapa. Revisa calle y comuna.',
        );
      }

      String? coverUrl = _existingCoverUrl;
      if (_selectedImage != null) {
        coverUrl = await _mediaService.uploadImage(
          file: File(_selectedImage!.path),
          bucket: MediaBucket.events,
        );
      }

      await _service.actualizarEvento(
        eventId: widget.eventId,
        titulo: _titleController.text.trim(),
        descripcion: _descriptionController.text.trim(),
        comunidadId: int.tryParse(_selectedCommunityId ?? ''),
        cuposMax: cupos,
        direccion: _addressController.text.trim(),
        ubicacionDireccion: _selectedComuna,
        comunaId: comunaId,
        latitud: coords?.latitude,
        longitud: coords?.longitude,
        coverUrl: coverUrl,
      );
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Evento actualizado correctamente')),
      );
      Navigator.of(context).pop(true);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('No se pudo actualizar: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _saving = false);
      }
    }
  }

  Future<void> _confirmCancelEvent() async {
    final bool? confirmed = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
          title: const Text('Cancelar evento'),
          content: const Text(
            'Los participantes recibiran una notificacion. El evento dejara de aparecer como activo.',
            style: TextStyle(height: 1.35),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Volver'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.error,
                foregroundColor: AppColors.white,
              ),
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Cancelar evento'),
            ),
          ],
        );
      },
    );
    if (confirmed != true || !mounted) {
      return;
    }
    await _service.cancelarEvento(widget.eventId);
    if (!mounted) {
      return;
    }
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Evento cancelado')),
    );
    Navigator.of(context).pop(true);
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
                  padding: const EdgeInsets.fromLTRB(20, 10, 20, 24),
                  children: <Widget>[
                    const Text(
                      'Editar evento',
                      style: TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 24,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      'Modifica la informacion clave del evento. Mantén los datos claros para que los participantes sepan que esperar.',
                      style: TextStyle(color: AppColors.textSecondary, height: 1.35),
                    ),
                    const SizedBox(height: 16),
                    _coverPreview(),
                    const SizedBox(height: 14),
                    _communityField(),
                    _input(
                      label: 'Titulo del evento',
                      hint: 'Nombre visible para la comunidad',
                      controller: _titleController,
                    ),
                    _input(
                      label: 'Descripcion',
                      hint: 'Que incluye el evento y por que unirse',
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
                    _comunaField(),
                    _capacityField(),
                    const SizedBox(height: 10),
                    SizedBox(
                      height: 48,
                      child: ElevatedButton(
                        onPressed: _saving ? null : _save,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: AppColors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        child: Text(_saving ? 'Guardando...' : 'Guardar cambios'),
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextButton.icon(
                      onPressed: _confirmCancelEvent,
                      icon: const Icon(Icons.event_busy_outlined, color: AppColors.error),
                      label: const Text(
                        'Cancelar evento',
                        style: TextStyle(color: AppColors.error, fontWeight: FontWeight.w800),
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
            'Editar evento',
            style: TextStyle(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w900,
            ),
          ),
        ],
      ),
    );
  }

  Widget _coverPreview() {
    Color color = AppColors.primary;
    if (_coverColorHex != null) {
      final String clean = _coverColorHex!.replaceFirst('#', '');
      color = Color(int.parse('FF$clean', radix: 16));
    }

    return InkWell(
      onTap: _pickImage,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        height: 146,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: AppColors.primary.withValues(alpha: 0.35),
          ),
        ),
        clipBehavior: Clip.antiAlias,
        child: _selectedImage != null
            ? Image.file(
                File(_selectedImage!.path),
                width: double.infinity,
                height: 146,
                fit: BoxFit.cover,
              )
            : _existingCoverUrl != null && _existingCoverUrl!.isNotEmpty
                ? LoopMediaImage(
                    url: _existingCoverUrl!,
                    height: 146,
                    width: double.infinity,
                    fallbackColorHex: _coverColorHex ?? '#0682BC',
                  )
                : const Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Icon(Icons.add_a_photo_outlined,
                            color: AppColors.white, size: 28),
                        SizedBox(height: 6),
                        Text(
                          'Toca para agregar portada',
                          style: TextStyle(
                            color: AppColors.white,
                            fontWeight: FontWeight.w700,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
      ),
    );
  }

  Widget _communityField() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const Text(
            'Comunidad',
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: 12,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 6),
          DropdownButtonFormField<String>(
            initialValue: _selectedCommunityId,
            decoration: const InputDecoration(
              hintText: 'Selecciona una comunidad',
              prefixIcon: Icon(Icons.groups_outlined, size: 19),
            ),
            items: _communities
                .map(
                  (UserCommunityOption community) => DropdownMenuItem<String>(
                    value: community.id,
                    child: Text(community.name),
                  ),
                )
                .toList(),
            onChanged: (String? value) {
              setState(() => _selectedCommunityId = value);
            },
          ),
        ],
      ),
    );
  }

  Widget _comunaField() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const Text(
            'Comuna',
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: 12,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 6),
          DropdownButtonFormField<String>(
            initialValue: _selectedComuna,
            decoration: const InputDecoration(
              hintText: 'Selecciona una comuna',
              prefixIcon: Icon(Icons.map_outlined, size: 19),
            ),
            items: ChileComunas.todas
                .map(
                  (String comuna) => DropdownMenuItem<String>(
                    value: comuna,
                    child: Text(comuna),
                  ),
                )
                .toList(),
            onChanged: (String? value) {
              setState(() => _selectedComuna = value);
            },
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
          DropdownButtonFormField<String>(
            initialValue: _selectedCapacity,
            decoration: const InputDecoration(
              prefixIcon: Icon(Icons.people_outline, size: 19),
            ),
            items: _capacityOptions
                .map(
                  (String value) => DropdownMenuItem<String>(
                    value: value,
                    child: Text(_capacityLabel(value)),
                  ),
                )
                .toList(),
            onChanged: (String? value) {
              if (value == null) {
                return;
              }
              setState(() => _selectedCapacity = value);
            },
          ),
        ],
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
