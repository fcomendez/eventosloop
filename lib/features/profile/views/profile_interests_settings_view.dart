import 'package:eventosloop/core/theme/app_colors.dart';
import 'package:eventosloop/features/onboarding/controllers/intereses_controller.dart';
import 'package:eventosloop/features/onboarding/models/interes_model.dart';
import 'package:flutter/material.dart';

class ProfileInterestsSettingsView extends StatefulWidget {
  const ProfileInterestsSettingsView({super.key});

  @override
  State<ProfileInterestsSettingsView> createState() =>
      _ProfileInterestsSettingsViewState();
}

class _ProfileInterestsSettingsViewState
    extends State<ProfileInterestsSettingsView> {
  final InteresesController _controller = InteresesController();

  static const int _minIntereses = 3;
  static const int _maxIntereses = 10;

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

  Future<void> _guardar() async {
    final bool ok =
        await _controller.guardarSeleccionConMinimo(_minIntereses);
    if (!mounted) {
      return;
    }
    if (!ok) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Debes mantener al menos 3 intereses seleccionados'),
        ),
      );
      return;
    }
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Intereses actualizados')),
    );
    Navigator.of(context).pop();
  }

  void _toggle(InteresModel interes) {
    final bool changed =
        _controller.toggleInteres(interes.idInteres, maximo: _maxIntereses);
    if (!changed) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Puedes seleccionar un maximo de 10 intereses'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
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
                child: AnimatedBuilder(
                  animation: _controller,
                  builder: (BuildContext context, Widget? child) {
                    if (_controller.cargando) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (_controller.error != null &&
                        _controller.intereses.isEmpty) {
                      return _ErrorState(
                        message: _controller.error!,
                        onRetry: _controller.cargarIntereses,
                      );
                    }
                    return ListView(
                      padding: const EdgeInsets.fromLTRB(18, 12, 18, 18),
                      children: <Widget>[
                        const Text(
                          'Mis Intereses',
                          style: TextStyle(
                            color: AppColors.textPrimary,
                            fontSize: 30,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Personaliza tu experiencia seleccionando temas relevantes para tus eventos, comunidades y recomendaciones.',
                          style: TextStyle(
                            color: AppColors.textSecondary,
                            height: 1.35,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          '${_controller.cantidadSeleccionados}/$_maxIntereses seleccionados · minimo $_minIntereses',
                          style: TextStyle(
                            color: _controller.puedeGuardarConMinimo(_minIntereses)
                                ? AppColors.primary
                                : AppColors.error,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(height: 16),
                        GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            mainAxisSpacing: 10,
                            crossAxisSpacing: 10,
                            childAspectRatio: 1.25,
                          ),
                          itemCount: _controller.intereses.length,
                          itemBuilder: (BuildContext context, int index) {
                            final InteresModel interes =
                                _controller.intereses[index];
                            final bool selected = _controller
                                .estaSeleccionado(interes.idInteres);
                            return _InterestCard(
                              interes: interes,
                              selected: selected,
                              onTap: () => _toggle(interes),
                            );
                          },
                        ),
                        const SizedBox(height: 14),
                        _InfoBox(
                          min: _minIntereses,
                          max: _maxIntereses,
                        ),
                      ],
                    );
                  },
                ),
              ),
              AnimatedBuilder(
                animation: _controller,
                builder: (BuildContext context, Widget? child) {
                  final bool canSave =
                      _controller.puedeGuardarConMinimo(_minIntereses) &&
                          !_controller.guardando;
                  return Padding(
                    padding: const EdgeInsets.fromLTRB(18, 8, 18, 16),
                    child: SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              canSave ? AppColors.primary : AppColors.divider,
                          foregroundColor: AppColors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        onPressed: canSave ? _guardar : null,
                        child: _controller.guardando
                            ? const SizedBox(
                                width: 18,
                                height: 18,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: AppColors.white,
                                ),
                              )
                            : const Text('Guardar intereses'),
                      ),
                    ),
                  );
                },
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
            'Configuracion de Intereses',
            style: TextStyle(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}

class _InterestCard extends StatelessWidget {
  const _InterestCard({
    required this.interes,
    required this.selected,
    required this.onTap,
  });

  final InteresModel interes;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: selected ? AppColors.primary : AppColors.divider,
            width: selected ? 2 : 1,
          ),
        ),
        child: Stack(
          children: <Widget>[
            if (selected)
              const Positioned(
                top: 0,
                right: 0,
                child: Icon(
                  Icons.check_circle,
                  color: AppColors.primary,
                  size: 18,
                ),
              ),
            Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Container(
                    width: 42,
                    height: 42,
                    decoration: BoxDecoration(
                      color: selected
                          ? AppColors.primary.withValues(alpha: 0.12)
                          : AppColors.inputBackground,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      interes.iconData,
                      color: selected ? AppColors.primary : AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    interes.nombre,
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color:
                          selected ? AppColors.primaryDark : AppColors.textPrimary,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoBox extends StatelessWidget {
  const _InfoBox({
    required this.min,
    required this.max,
  });

  final int min;
  final int max;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const Icon(Icons.info_outline, color: AppColors.primary),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              'Debes mantener al menos $min intereses para que LOOP personalice tu experiencia. Por ahora puedes elegir hasta $max.',
              style: const TextStyle(
                color: AppColors.textPrimary,
                height: 1.35,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ErrorState extends StatelessWidget {
  const _ErrorState({
    required this.message,
    required this.onRetry,
  });

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(color: AppColors.error),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: onRetry,
              child: const Text('Reintentar'),
            ),
          ],
        ),
      ),
    );
  }
}
