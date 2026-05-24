import 'package:eventosloop/core/config/app_env.dart';
import 'package:eventosloop/core/theme/app_colors.dart';
import 'package:eventosloop/features/communities/models/community_list_item.dart';
import 'package:eventosloop/features/communities/services/community_supabase_service.dart';
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
  final CommunitySupabaseService _communityService = CommunitySupabaseService();
  final Set<int> _joinedIds = <int>{};
  List<CommunitySuggestionModel> _communities = <CommunitySuggestionModel>[];
  bool _loading = true;
  String? _error;

  bool get _puedeContinuar => _joinedIds.isNotEmpty;

  @override
  void initState() {
    super.initState();
    _loadCommunities();
  }

  Future<void> _loadCommunities() async {
    if (!AppEnv.useSupabase) {
      setState(() {
        _communities = _mockCommunities;
        _loading = false;
      });
      return;
    }
    try {
      final List<CommunityListItem> items =
          await _communityService.listarExplorables();
      if (!mounted) {
        return;
      }
      setState(() {
        _communities = items.map(_mapToSuggestion).toList();
        _loading = false;
      });
    } catch (e) {
      if (!mounted) {
        return;
      }
      setState(() {
        _error = '$e';
        _communities = _mockCommunities;
        _loading = false;
      });
    }
  }

  CommunitySuggestionModel _mapToSuggestion(CommunityListItem item) {
    return CommunitySuggestionModel(
      id: item.id,
      title: item.name,
      category: item.primaryCategory,
      membersLabel: item.membersLabel,
      imageTag: 'community',
      description: item.description,
      interestTags: item.interestTags.map((CommunityInterestTag t) => t.name).toList(),
    );
  }

  static const List<CommunitySuggestionModel> _mockCommunities =
      <CommunitySuggestionModel>[
    CommunitySuggestionModel(
      id: 5,
      title: 'Laboratorio de Diseno Urbano',
      category: 'Arquitectura',
      membersLabel: '12.4k miembros',
      imageTag: 'urban',
      description:
          'Exploramos el futuro de la vida urbana y la arquitectura sostenible.',
    ),
    CommunitySuggestionModel(
      id: 6,
      title: 'Vecindario FC',
      category: 'Deportes',
      membersLabel: '842 miembros',
      imageTag: 'futbol',
    ),
    CommunitySuggestionModel(
      id: 8,
      title: 'Creadores Digitales',
      category: 'Tecnologia',
      membersLabel: '5.1k miembros',
      imageTag: 'digital',
    ),
  ];

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

  Future<void> _continuar() async {
    if (!_puedeContinuar) {
      return;
    }
    if (AppEnv.useSupabase) {
      try {
        await _communityService.unirseVarias(_joinedIds.toList());
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error al unirse: $e')),
          );
        }
        return;
      }
    }
    if (!mounted) {
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
                  child: _loading
                      ? const Center(child: CircularProgressIndicator())
                      : ListView(
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
                              'Elige al menos una para personalizar tu experiencia. '
                              'Solo se muestran comunidades publicas activas.',
                              style: TextStyle(
                                color: AppColors.textSecondary,
                                fontSize: 13,
                              ),
                            ),
                            if (_error != null) ...<Widget>[
                              const SizedBox(height: 8),
                              Text(
                                'Usando datos de respaldo: $_error',
                                style: const TextStyle(
                                  color: AppColors.error,
                                  fontSize: 12,
                                ),
                              ),
                            ],
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
                            if (_communities.isEmpty)
                              const Padding(
                                padding: EdgeInsets.symmetric(vertical: 24),
                                child: Text(
                                  'No hay comunidades publicas disponibles aun.',
                                  style: TextStyle(
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                              )
                            else
                              ..._communities.map(_listCard),
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
                            '${model.membersLabel} · ${model.category}',
                            style: const TextStyle(
                              color: AppColors.textSecondary,
                              fontSize: 12,
                            ),
                          ),
                          if (model.interestTags.isNotEmpty)
                            Padding(
                              padding: const EdgeInsets.only(top: 4),
                              child: Wrap(
                                spacing: 4,
                                runSpacing: 4,
                                children: model.interestTags
                                    .map(
                                      (String tag) => Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 6,
                                          vertical: 2,
                                        ),
                                        decoration: BoxDecoration(
                                          color: AppColors.primary
                                              .withValues(alpha: 0.12),
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        child: Text(
                                          tag,
                                          style: const TextStyle(
                                            fontSize: 10,
                                            fontWeight: FontWeight.w700,
                                            color: AppColors.primaryDark,
                                          ),
                                        ),
                                      ),
                                    )
                                    .toList(),
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
