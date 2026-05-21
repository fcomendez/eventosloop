import 'package:eventosloop/core/theme/app_colors.dart';
import 'package:eventosloop/core/widgets/barra_interactiva.dart';
import 'package:eventosloop/features/create/views/create_hub_view.dart';
import 'package:eventosloop/features/feed/views/feed_home_view.dart';
import 'package:eventosloop/features/profile/views/profile_view.dart';
import 'package:flutter/material.dart';

class NavPlaceholderView extends StatelessWidget {
  const NavPlaceholderView({
    super.key,
    required this.selected,
    required this.title,
    required this.message,
  });

  final BarraInteractivaItem selected;
  final String title;
  final String message;

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
              _topBar(),
              Expanded(
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(22),
                      decoration: BoxDecoration(
                        color: AppColors.cardBackground,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Icon(
                            _iconFor(selected),
                            size: 52,
                            color: AppColors.primary,
                          ),
                          const SizedBox(height: 14),
                          Text(
                            title,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: AppColors.textPrimary,
                              fontSize: 22,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            message,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: AppColors.textSecondary,
                              height: 1.35,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              BarraInteractiva(
                selected: selected,
                onTap: (BarraInteractivaItem item) =>
                    navigateFromBar(context, item),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _topBar() {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
      child: Row(
        children: <Widget>[
          const Text(
            'LOOP',
            style: TextStyle(
              color: AppColors.primaryDark,
              fontSize: 18,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(width: 8),
          Text(
            title,
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 12,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

  IconData _iconFor(BarraInteractivaItem item) {
    switch (item) {
      case BarraInteractivaItem.perfil:
        return Icons.person_outline;
      case BarraInteractivaItem.comunidades:
        return Icons.calendar_today_outlined;
      case BarraInteractivaItem.crear:
        return Icons.add_circle_outline;
      case BarraInteractivaItem.explorar:
        return Icons.search;
      case BarraInteractivaItem.inicio:
        return Icons.home_outlined;
    }
  }
}

void navigateFromBar(BuildContext context, BarraInteractivaItem item) {
  Widget destination;
  switch (item) {
    case BarraInteractivaItem.perfil:
      destination = const ProfileView();
      break;
    case BarraInteractivaItem.comunidades:
      destination = const NavPlaceholderView(
        selected: BarraInteractivaItem.comunidades,
        title: 'Comunidades y eventos',
        message: 'Aqui va comunidades y eventos',
      );
      break;
    case BarraInteractivaItem.crear:
      destination = const CreateHubView();
      break;
    case BarraInteractivaItem.explorar:
      destination = const NavPlaceholderView(
        selected: BarraInteractivaItem.explorar,
        title: 'Explorador',
        message: 'Aqui va explorador',
      );
      break;
    case BarraInteractivaItem.inicio:
      destination = const FeedHomeView(email: '');
      break;
  }

  Navigator.of(context).pushReplacement(
    MaterialPageRoute<void>(builder: (_) => destination),
  );
}
