import 'package:eventosloop/core/theme/app_colors.dart';
import 'package:eventosloop/core/widgets/barra_interactiva.dart';
import 'package:eventosloop/features/create/views/create_event_view.dart';
import 'package:eventosloop/features/create/views/create_post_view.dart';
import 'package:eventosloop/features/main_navigation/views/nav_placeholder_view.dart';
import 'package:flutter/material.dart';

class CreateHubView extends StatelessWidget {
  const CreateHubView({super.key});

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
              const _CreateTopBar(),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(20, 22, 20, 24),
                  children: <Widget>[
                    const Text(
                      'Que quieres crear?',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 26,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Elige una opcion para compartir una publicacion o crear un evento para tu comunidad.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: AppColors.textSecondary,
                        height: 1.35,
                      ),
                    ),
                    const SizedBox(height: 26),
                    _CreateOptionCard(
                      icon: Icons.article_outlined,
                      title: 'Crear publicacion',
                      subtitle:
                          'Comparte una foto, experiencia o pensamiento con tu comunidad.',
                      buttonText: 'Crear publicacion',
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute<void>(
                            builder: (_) => const CreatePostView(),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 16),
                    _CreateOptionCard(
                      icon: Icons.event_available_outlined,
                      title: 'Crear evento',
                      subtitle:
                          'Define fecha, ubicacion, cupos y detalles para invitar personas.',
                      buttonText: 'Crear evento',
                      outlined: true,
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute<void>(
                            builder: (_) => const CreateEventView(),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
              BarraInteractiva(
                selected: BarraInteractivaItem.crear,
                onTap: (BarraInteractivaItem item) {
                  if (item == BarraInteractivaItem.crear) {
                    return;
                  }
                  navigateFromBar(context, item);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CreateTopBar extends StatelessWidget {
  const _CreateTopBar();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.fromLTRB(16, 12, 16, 8),
      child: Center(
        child: Text(
          'LOOP',
          style: TextStyle(
            color: AppColors.primaryDark,
            fontSize: 18,
            fontWeight: FontWeight.w900,
          ),
        ),
      ),
    );
  }
}

class _CreateOptionCard extends StatelessWidget {
  const _CreateOptionCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.buttonText,
    required this.onTap,
    this.outlined = false,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final String buttonText;
  final VoidCallback onTap;
  final bool outlined;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: AppColors.primaryDark.withValues(alpha: 0.07),
            blurRadius: 14,
            offset: const Offset(0, 7),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Container(
            height: 112,
            decoration: BoxDecoration(
              color: AppColors.inputBackground,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(icon, size: 46, color: AppColors.primary),
          ),
          const SizedBox(height: 14),
          Text(
            title,
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontSize: 18,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            subtitle,
            style: const TextStyle(
              color: AppColors.textSecondary,
              height: 1.35,
            ),
          ),
          const SizedBox(height: 14),
          SizedBox(
            height: 44,
            child: outlined
                ? OutlinedButton(
                    onPressed: onTap,
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.primary,
                      side: const BorderSide(color: AppColors.primary),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    child: Text(buttonText),
                  )
                : ElevatedButton(
                    onPressed: onTap,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: AppColors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    child: Text(buttonText),
                  ),
          ),
        ],
      ),
    );
  }
}
