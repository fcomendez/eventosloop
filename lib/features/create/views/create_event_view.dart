import 'package:eventosloop/core/data/chile_comunas.dart';
import 'package:eventosloop/core/theme/app_colors.dart';
import 'package:eventosloop/features/create/data/user_communities_mock.dart';
import 'package:flutter/material.dart';

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

  String? _selectedCommunityId;
  String? _selectedComuna;
  String _selectedCapacity = '20';

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
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _dateController.dispose();
    _timeController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  String _capacityLabel(String value) {
    if (value == 'sin_limite') {
      return 'Sin limite';
    }
    return '$value personas';
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
                    _communityField(),
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
                    _comunaField(),
                    _capacityField(),
                    const SizedBox(height: 10),
                    SizedBox(
                      height: 48,
                      child: ElevatedButton(
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content:
                                  Text('Evento guardado localmente por ahora'),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: AppColors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        child: const Text('Crear evento'),
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
    return Container(
      height: 146,
      decoration: BoxDecoration(
        color: AppColors.inputBackground,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.primary.withValues(alpha: 0.35),
        ),
      ),
      child: const Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Icon(Icons.add_a_photo_outlined, color: AppColors.primary, size: 30),
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
              style: TextStyle(color: AppColors.textSecondary, fontSize: 12),
            ),
          ],
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
            items: UserCommunitiesMock.participando
                .map(
                  (UserCommunityOption community) => DropdownMenuItem<String>(
                    value: community.id,
                    child: Text(community.name),
                  ),
                )
                .toList(),
            onChanged: (String? value) {
              setState(() {
                _selectedCommunityId = value;
              });
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
              setState(() {
                _selectedComuna = value;
              });
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
              setState(() {
                _selectedCapacity = value;
              });
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
