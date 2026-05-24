import 'package:eventosloop/core/theme/app_colors.dart';
import 'package:eventosloop/features/onboarding/controllers/intereses_controller.dart';
import 'package:eventosloop/features/onboarding/models/interes_model.dart';
import 'package:eventosloop/features/onboarding/views/join_communities_view.dart';
import 'package:flutter/material.dart';

class InteresesSelectionView extends StatefulWidget {
  const InteresesSelectionView({super.key});

  @override
  State<InteresesSelectionView> createState() => _InteresesSelectionViewState();
}

class _InteresesSelectionViewState extends State<InteresesSelectionView> {
  final InteresesController _controller = InteresesController();

  @override
  void initState() {
    super.initState();
    _controller.cargarIntereses();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _guardarYContinuar() async {
    final bool ok = await _controller.guardarSeleccion();
    if (!mounted) {
      return;
    }
    if (!ok) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            _controller.error ?? 'No se pudieron guardar los intereses',
          ),
        ),
      );
      return;
    }
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute<void>(
        builder: (_) => const JoinCommunitiesView(),
      ),
      (_) => false,
    );
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
          child: AnimatedBuilder(
            animation: _controller,
            builder: (BuildContext context, Widget? child) {
              if (_controller.cargando) {
                return const Center(child: CircularProgressIndicator());
              }

              if (_controller.error != null && _controller.intereses.isEmpty) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Text(
                          _controller.error!,
                          textAlign: TextAlign.center,
                          style: const TextStyle(color: AppColors.error),
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: _controller.cargarIntereses,
                          child: const Text('Reintentar'),
                        ),
                      ],
                    ),
                  ),
                );
              }

              return Column(
                children: <Widget>[
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                    child: Column(
                      children: <Widget>[
                        const Text(
                          'Elige tus intereses',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w800,
                            color: AppColors.primaryDark,
                          ),
                        ),
                        const SizedBox(height: 6),
                        const Text(
                          'Selecciona al menos 5 para personalizar tu experiencia.',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: AppColors.textSecondary),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '${_controller.cantidadSeleccionados} seleccionados',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: _controller.puedeAvanzar
                                ? AppColors.primary
                                : AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: _controller.categorias.length,
                      itemBuilder: (BuildContext context, int index) {
                        final String cat = _controller.categorias[index];
                        final List<InteresModel> items =
                            _controller.interesesPorCategoria(cat);
                        return _CategoriaSection(
                          categoria: _formatCategoria(cat),
                          items: items,
                          controller: _controller,
                        );
                      },
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                    child: SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _controller.puedeAvanzar
                              ? AppColors.primary
                              : AppColors.divider,
                          foregroundColor: AppColors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        onPressed: _controller.puedeAvanzar
                            ? (_controller.guardando ? null : _guardarYContinuar)
                            : null,
                        child: _controller.guardando
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: AppColors.white,
                                ),
                              )
                            : Text(
                                _controller.puedeAvanzar
                                    ? 'Siguiente'
                                    : 'Faltan ${InteresesController.minimoIntereses - _controller.cantidadSeleccionados} mas',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  String _formatCategoria(String cat) {
    return cat
        .replaceAll('_', ' ')
        .toLowerCase()
        .split(' ')
        .map((String w) =>
            w.isEmpty ? w : '${w[0].toUpperCase()}${w.substring(1)}')
        .join(' ');
  }
}

class _CategoriaSection extends StatelessWidget {
  const _CategoriaSection({
    required this.categoria,
    required this.items,
    required this.controller,
  });

  final String categoria;
  final List<InteresModel> items;
  final InteresesController controller;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(top: 14, bottom: 8, left: 4),
          child: Text(
            categoria,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
              letterSpacing: 0.5,
            ),
          ),
        ),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: items.map((InteresModel interes) {
            final bool selected =
                controller.estaSeleccionado(interes.idInteres);
            return _InteresBubble(
              interes: interes,
              selected: selected,
              onTap: () => controller.toggleInteres(interes.idInteres),
            );
          }).toList(),
        ),
      ],
    );
  }
}

class _InteresBubble extends StatelessWidget {
  const _InteresBubble({
    required this.interes,
    required this.selected,
    required this.onTap,
  });

  final InteresModel interes;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeInOut,
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: selected
              ? AppColors.primary
              : AppColors.cardBackground,
          borderRadius: BorderRadius.circular(22),
          border: Border.all(
            color: selected ? AppColors.primary : AppColors.divider,
            width: selected ? 2 : 1,
          ),
          boxShadow: selected
              ? <BoxShadow>[
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Icon(
              interes.iconData,
              size: 20,
              color: selected ? AppColors.white : AppColors.primary,
            ),
            const SizedBox(width: 6),
            Text(
              interes.nombre,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: selected ? AppColors.white : AppColors.textPrimary,
              ),
            ),
            if (selected) ...<Widget>[
              const SizedBox(width: 4),
              const Icon(Icons.check_circle, size: 16, color: AppColors.white),
            ],
          ],
        ),
      ),
    );
  }
}
