import 'package:eventosloop/core/theme/app_colors.dart';
import 'package:eventosloop/features/profile/views/profile_interests_settings_view.dart';
import 'package:eventosloop/features/profile/views/profile_personal_info_view.dart';
import 'package:flutter/material.dart';

class ProfileSettingsView extends StatefulWidget {
  const ProfileSettingsView({super.key});

  @override
  State<ProfileSettingsView> createState() => _ProfileSettingsViewState();
}

class _ProfileSettingsViewState extends State<ProfileSettingsView> {
  RangeValues _ageRange = const RangeValues(18, 35);
  bool _notifyRecommendedEvents = true;
  bool _showProfileStats = true;

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
              _topBar(context),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(18, 12, 18, 24),
                  children: <Widget>[
                    const Text(
                      'Configuracion de perfil',
                      style: TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 25,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      'Ajusta como LOOP personaliza tus eventos, busquedas y notificaciones.',
                      style: TextStyle(
                        color: AppColors.textSecondary,
                        height: 1.35,
                      ),
                    ),
                    const SizedBox(height: 18),
                    _sectionCard(
                      title: 'Rango etario para eventos',
                      icon: Icons.tune,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            '${_ageRange.start.round()} a ${_ageRange.end.round()} anos',
                            style: const TextStyle(
                              color: AppColors.primaryDark,
                              fontSize: 20,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                          const SizedBox(height: 6),
                          const Text(
                            'Este rango filtra eventos sugeridos, resultados del buscador y notificaciones relevantes.',
                            style: TextStyle(
                              color: AppColors.textSecondary,
                              fontSize: 13,
                              height: 1.35,
                            ),
                          ),
                          const SizedBox(height: 10),
                          RangeSlider(
                            min: 13,
                            max: 80,
                            divisions: 67,
                            values: _ageRange,
                            labels: RangeLabels(
                              '${_ageRange.start.round()}',
                              '${_ageRange.end.round()}',
                            ),
                            activeColor: AppColors.primary,
                            inactiveColor: AppColors.divider,
                            onChanged: (RangeValues value) {
                              setState(() {
                                _ageRange = value;
                              });
                            },
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: const <Widget>[
                              Text(
                                '13',
                                style: TextStyle(color: AppColors.textSecondary),
                              ),
                              Text(
                                '80+',
                                style: TextStyle(color: AppColors.textSecondary),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 14),
                    _sectionCard(
                      title: 'Preferencias',
                      icon: Icons.settings_suggest_outlined,
                      child: Column(
                        children: <Widget>[
                          SwitchListTile(
                            contentPadding: EdgeInsets.zero,
                            activeColor: AppColors.primary,
                            title: const Text('Notificar eventos recomendados'),
                            subtitle: const Text(
                              'Usa intereses, comunidades y rango etario.',
                            ),
                            value: _notifyRecommendedEvents,
                            onChanged: (bool value) {
                              setState(() {
                                _notifyRecommendedEvents = value;
                              });
                            },
                          ),
                          SwitchListTile(
                            contentPadding: EdgeInsets.zero,
                            activeColor: AppColors.primary,
                            title: const Text('Mostrar estadisticas del perfil'),
                            subtitle: const Text(
                              'Permite ver actividad, eventos pasados y comunidades.',
                            ),
                            value: _showProfileStats,
                            onChanged: (bool value) {
                              setState(() {
                                _showProfileStats = value;
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 14),
                    _sectionCard(
                      title: 'Cuenta',
                      icon: Icons.person_outline,
                      child: Column(
                        children: <Widget>[
                          _settingsAction(
                            icon: Icons.edit_outlined,
                            title: 'Editar informacion personal',
                            subtitle: 'Nombre, username, avatar y biografia.',
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute<void>(
                                  builder: (_) => const ProfilePersonalInfoView(),
                                ),
                              );
                            },
                          ),
                          const Divider(height: 18),
                          _settingsAction(
                            icon: Icons.interests_outlined,
                            title: 'Editar intereses',
                            subtitle: 'Actualiza el motor de recomendaciones.',
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute<void>(
                                  builder: (_) =>
                                      const ProfileInterestsSettingsView(),
                                ),
                              );
                            },
                          ),
                          const Divider(height: 18),
                          _settingsAction(
                            icon: Icons.group_outlined,
                            title: 'Seguidores y seguidos',
                            subtitle: 'Administra conexiones del perfil.',
                            onTap: () {},
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 18),
                    SizedBox(
                      height: 48,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: AppColors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Configuracion guardada localmente'),
                            ),
                          );
                        },
                        child: const Text('Guardar configuracion'),
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
          const SizedBox(width: 4),
          const Text(
            'LOOP',
            style: TextStyle(
              color: AppColors.primaryDark,
              fontSize: 18,
              fontWeight: FontWeight.w900,
            ),
          ),
          const Spacer(),
          const Icon(Icons.settings_outlined, color: AppColors.primaryDark),
        ],
      ),
    );
  }

  Widget _sectionCard({
    required String title,
    required IconData icon,
    required Widget child,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: AppColors.primaryDark.withValues(alpha: 0.05),
            blurRadius: 12,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              CircleAvatar(
                radius: 16,
                backgroundColor: AppColors.primary.withValues(alpha: 0.12),
                child: Icon(icon, color: AppColors.primary, size: 18),
              ),
              const SizedBox(width: 10),
              Text(
                title,
                style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 17,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          child,
        ],
      ),
    );
  }

  Widget _settingsAction({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return InkWell(
      borderRadius: BorderRadius.circular(10),
      onTap: onTap,
      child: Row(
        children: <Widget>[
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: AppColors.inputBackground,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: AppColors.primaryDark, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  title,
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                Text(
                  subtitle,
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          const Icon(Icons.chevron_right, color: AppColors.textSecondary),
        ],
      ),
    );
  }
}
