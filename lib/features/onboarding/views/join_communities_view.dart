import 'package:eventosloop/core/theme/app_colors.dart';
import 'package:eventosloop/core/widgets/barra_interactiva.dart';
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
  final Set<String> _joined = <String>{};

  static const List<CommunitySuggestionModel> _topSuggestions =
      <CommunitySuggestionModel>[
        CommunitySuggestionModel(
          title: 'Urban Design Lab',
          category: 'Arquitectura',
          membersLabel: '12.4k miembros',
          imageTag: 'urban',
        ),
      ];

  static const List<CommunitySuggestionModel> _cards = <CommunitySuggestionModel>[
    CommunitySuggestionModel(
      title: 'FC neighborhood',
      category: 'Deportes',
      membersLabel: '842 miembros',
      imageTag: 'futbol',
    ),
    CommunitySuggestionModel(
      title: 'Study Group',
      category: 'Educacion',
      membersLabel: '2k miembros',
      imageTag: 'study',
    ),
  ];

  static const List<CommunitySuggestionModel> _discoverMore =
      <CommunitySuggestionModel>[
        CommunitySuggestionModel(
          title: 'Digital Creators',
          category: 'Tech',
          membersLabel: '5.1k miembros',
          imageTag: 'digital',
        ),
        CommunitySuggestionModel(
          title: 'Urban Gardeners',
          category: 'Lifestyle',
          membersLabel: '1.8k miembros',
          imageTag: 'garden',
        ),
        CommunitySuggestionModel(
          title: 'Zen Morning',
          category: 'Wellness',
          membersLabel: '3.4k miembros',
          imageTag: 'zen',
        ),
      ];

  void _toggleJoin(String title) {
    setState(() {
      if (_joined.contains(title)) {
        _joined.remove(title);
      } else {
        _joined.add(title);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                  padding: const EdgeInsets.fromLTRB(16, 10, 16, 12),
                  children: <Widget>[
                    const Text(
                      'Join Communities',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.w500,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      decoration: InputDecoration(
                        hintText: 'Find specific communities...',
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
                            'Suggested for you',
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                              color: AppColors.textPrimary,
                            ),
                          ),
                        ),
                        Text(
                          'View all',
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
                      'Discover More',
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
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: AppColors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: () {
                          final String email =
                              Supabase.instance.client.auth.currentUser?.email ?? '';
                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute<void>(
                              builder: (_) => FeedHomeView(email: email),
                            ),
                          );
                        },
                        child: const Text('Continuar'),
                      ),
                    ),
                  ],
                ),
              ),
              BarraInteractiva(
                selected: BarraInteractivaItem.comunidades,
                onTap: (_) {},
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _topBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 6),
      child: Row(
        children: <Widget>[
          const CircleAvatar(
            radius: 16,
            backgroundColor: AppColors.divider,
            child: Icon(Icons.person, color: AppColors.primaryDark, size: 18),
          ),
          const Spacer(),
          const Text(
            'LOOP',
            style: TextStyle(
              color: AppColors.primaryDark,
              fontWeight: FontWeight.w800,
              fontSize: 20,
            ),
          ),
          const Spacer(),
          Container(
            width: 32,
            height: 32,
            decoration: const BoxDecoration(
              color: AppColors.white,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.notifications_none, size: 18),
          ),
        ],
      ),
    );
  }

  Widget _buildHeroCard(CommunitySuggestionModel model) {
    final bool isJoined = _joined.contains(model.title);
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
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.35),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Text(
              'TRENDING',
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
            'Explorando el futuro de city living\nand sustainable architecture.',
            style: TextStyle(
              color: AppColors.white.withValues(alpha: 0.85),
              height: 1.35,
            ),
          ),
          const SizedBox(height: 10),
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
              _joinButton(model.title, isJoined),
            ],
          ),
        ],
      ),
    );
  }

  Widget _miniCard(CommunitySuggestionModel model) {
    final bool isJoined = _joined.contains(model.title);
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(14),
      ),
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
            maxLines: 1,
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
          const SizedBox(height: 10),
          Center(child: _joinButton(model.title, isJoined)),
        ],
      ),
    );
  }

  Widget _listCard(CommunitySuggestionModel model) {
    final bool isJoined = _joined.contains(model.title);
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: <Widget>[
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.hub_outlined, color: AppColors.primaryDark),
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
          _joinButton(model.title, isJoined),
        ],
      ),
    );
  }

  Widget _joinButton(String key, bool isJoined) {
    return SizedBox(
      height: 32,
      child: ElevatedButton(
        onPressed: () => _toggleJoin(key),
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
          isJoined ? 'Unido' : 'Join',
          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
        ),
      ),
    );
  }
}
