import 'package:eventosloop/core/theme/app_colors.dart';
import 'package:eventosloop/features/communities/views/community_detail_view.dart';
import 'package:eventosloop/features/feed/views/feed_home_view.dart';
import 'package:eventosloop/features/onboarding/models/community_suggestion_model.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class JoinCommunitiesView extends StatefulWidget {
  const JoinCommunitiesView({super.key});

  @override
  State<JoinCommunitiesView> createState() => _JoinCommunitiesViewState();
}

class _JoinCommunitiesViewState extends State<JoinCommunitiesView> {
  final Set<int> _joinedIds = <int>{};

  static const List<CommunitySuggestionModel> _topSuggestions =
      <CommunitySuggestionModel>[
    CommunitySuggestionModel(
      id: 5,
      title: 'Laboratorio de Diseño Urbano',
      category: 'Arquitectura',
      membersLabel: '12.4k miembros',
      imageTag: 'urban',
      description:
          'Exploramos el futuro de la vida urbana y la arquitectura sostenible.',
    ),
  ];

  static const List<CommunitySuggestionModel> _cards = <CommunitySuggestionModel>[
    CommunitySuggestionModel(
      id: 6,
      title: 'Vecindario FC',
      category: 'Deportes',
      membersLabel: '842 miembros',
      imageTag: 'futbol',
    ),
    CommunitySuggestionModel(
      id: 7,
      title: 'Grupo de Estudio',
      category: 'Educación',
      membersLabel: '2k miembros',
      imageTag: 'study',
    ),
  ];

  static const List<CommunitySuggestionModel> _discoverMore =
      <CommunitySuggestionModel>[
    CommunitySuggestionModel(
      id: 8,
      title: 'Creadores Digitales',
      category: 'Tecnología',
      membersLabel: '5.1k miembros',
      imageTag: 'digital',
    ),
    CommunitySuggestionModel(
      id: 9,
      title: 'Jardineros Urbanos',
      category: 'Estilo de vida',
      membersLabel: '1.8k miembros',
      imageTag: 'garden',
    ),
    CommunitySuggestionModel(
      id: 10,
      title: 'Mañanas Zen',
      category: 'Bienestar',
      membersLabel: '3.4k miembros',
      imageTag: 'zen',
    ),
  ];

  bool get _puedeContinuar => _joinedIds.isNotEmpty;

  void _toggleJoin(int communityId) {
    setState(() {
      if (_joinedIds.contains(communityId)) {
        _joinedIds.remove(communityId);
      } else {
        _joinedIds.add(communityId);
      }
    });
  }

  void _abrirDetalle(CommunitySuggestionModel model) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => CommunityDetailView(communityId: model.id),
      ),
    );
  }

  void _continuar() {
    if (!_puedeContinuar) {
      return;
    }
    final String email =
        Supabase.instance.client.auth.currentUser?.email ?? '';
    Navigator.of(context).pushReplacement(
      MaterialPageRoute<void>(
        builder: (_) => FeedHomeView(email: email),
      ),
    );
  }

  void _mostrarAvisoSeleccion() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Elige al menos una comunidad para continuar.'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: _puedeContinuar,
      onPopInvokedWithResult: (bool didPop, Object? result) {
        if (!didPop) {
          _mostrarAvisoSeleccion();
        }
      },
      child: Scaffold(
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
                _topBar(),
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.fromLTRB(16, 10, 16, 24),
                    children: <Widget>[
                      const Text(
                        'Unirse a comunidades',
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.w500,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 6),
                      const Text(
                        'Elige al menos una para personalizar tu experiencia.',
                        style: TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 13,
                        ),
                      ),
                      const SizedBox(height: 10),
                      TextField(
                        decoration: InputDecoration(
                          hintText: 'Buscar comunidades...',
                          prefixIcon: const Icon(Icons.search),
                          fillColor: const Color(0xFFE4EEF9),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                      const SizedBox(height: 18),
                      const Row(
                        children: <Widget>[
                          Expanded(
                            child: Text(
                              'Sugeridas para ti',
                              style: TextStyle(
                                fontWeight: FontWeight.w700,
                                color: AppColors.textPrimary,
                              ),
                            ),
                          ),
                          Text(
                            'Ver todas',
                            style: TextStyle(
                              color: AppColors.primary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      ..._topSuggestions.map(_buildHeroCard),
                      const SizedBox(height: 10),
                      Row(
                        children: _cards
                            .map((CommunitySuggestionModel model) => Expanded(
                                  child: Padding(
                                    padding: EdgeInsets.only(
                                      right: model == _cards.first ? 8 : 0,
                                      left: model == _cards.last ? 8 : 0,
                                    ),
                                    child: _miniCard(model),
                                  ),
                                ))
                            .toList(),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Descubrir más',
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 8),
                      ..._discoverMore.map(_listCard),
                      const SizedBox(height: 14),
                      SizedBox(
                        height: 46,
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            foregroundColor: AppColors.white,
                            disabledBackgroundColor:
                                AppColors.primary.withValues(alpha: 0.35),
                            disabledForegroundColor:
                                AppColors.white.withValues(alpha: 0.7),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          onPressed: _puedeContinuar ? _continuar : null,
                          child: Text(
                            _puedeContinuar
                                ? 'Continuar (${_joinedIds.length} seleccionada${_joinedIds.length == 1 ? '' : 's'})'
                                : 'Continuar (elige al menos 1)',
                            textAlign: TextAlign.center,
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
      ),
    );
  }

  Widget _topBar() {
    return const Padding(
      padding: EdgeInsets.fromLTRB(16, 12, 16, 6),
      child: Center(
        child: Text(
          'LOOP',
          style: TextStyle(
            color: AppColors.primaryDark,
            fontWeight: FontWeight.w800,
            fontSize: 20,
          ),
        ),
      ),
    );
  }

  Widget _buildHeroCard(CommunitySuggestionModel model) {
    final bool isJoined = _joinedIds.contains(model.id);
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFF065A92),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(12),
              onTap: () => _abrirDetalle(model),
              child: Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.35),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Text(
                        'TENDENCIA',
                        style: TextStyle(
                          color: AppColors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      model.title,
                      style: const TextStyle(
                        color: AppColors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      model.description ??
                          'Toca para ver la ficha completa de la comunidad.',
                      style: TextStyle(
                        color: AppColors.white.withValues(alpha: 0.85),
                        height: 1.35,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 6),
          Row(
            children: <Widget>[
              Text(
                model.membersLabel,
                style: TextStyle(
                  color: AppColors.white.withValues(alpha: 0.8),
                  fontSize: 12,
                ),
              ),
              const Spacer(),
              _joinButton(model.id, isJoined),
            ],
          ),
        ],
      ),
    );
  }

  Widget _miniCard(CommunitySuggestionModel model) {
    final bool isJoined = _joinedIds.contains(model.id);
    return Material(
      color: AppColors.cardBackground,
      borderRadius: BorderRadius.circular(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          InkWell(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(14)),
            onTap: () => _abrirDetalle(model),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(12, 12, 12, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Icon(
                    Icons.groups_2,
                    color: AppColors.primary.withValues(alpha: 0.9),
                    size: 26,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    model.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    model.membersLabel,
                    style: const TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Center(child: _joinButton(model.id, isJoined)),
          ),
        ],
      ),
    );
  }

  Widget _listCard(CommunitySuggestionModel model) {
    final bool isJoined = _joinedIds.contains(model.id);
    return Material(
      color: AppColors.cardBackground,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(10),
        child: Row(
          children: <Widget>[
            Expanded(
              child: InkWell(
                borderRadius: BorderRadius.circular(10),
                onTap: () => _abrirDetalle(model),
                child: Row(
                  children: <Widget>[
                    Container(
                      width: 46,
                      height: 46,
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(
                        Icons.hub_outlined,
                        color: AppColors.primaryDark,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            model.title,
                            style: const TextStyle(
                              fontWeight: FontWeight.w700,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          Text(
                            '${model.membersLabel} • ${model.category}',
                            style: const TextStyle(
                              color: AppColors.textSecondary,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 8),
            _joinButton(model.id, isJoined),
          ],
        ),
      ),
    );
  }

  Widget _joinButton(int communityId, bool isJoined) {
    return SizedBox(
      height: 32,
      child: ElevatedButton(
        onPressed: () => _toggleJoin(communityId),
        style: ElevatedButton.styleFrom(
          backgroundColor: isJoined ? AppColors.divider : AppColors.primary,
          foregroundColor: isJoined ? AppColors.textPrimary : AppColors.white,
          padding: const EdgeInsets.symmetric(horizontal: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          elevation: 0,
        ),
        child: Text(
          isJoined ? 'Unido' : 'Unirse',
          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
        ),
      ),
    );
  }
}
