import 'package:eventosloop/core/navigation/detail_navigation.dart';
import 'package:eventosloop/core/theme/app_colors.dart';
import 'package:eventosloop/core/widgets/barra_interactiva.dart';
import 'package:eventosloop/core/widgets/full_bleed_publication_card.dart';
import 'package:eventosloop/features/explore/models/explore_catalog_models.dart';
import 'package:eventosloop/features/explore/services/explore_service.dart';
import 'package:eventosloop/features/explore/services/explore_search_service.dart';
import 'package:eventosloop/features/explore/views/explore_catalog_list_views.dart';
import 'package:eventosloop/features/main_navigation/views/nav_placeholder_view.dart';
import 'package:flutter/material.dart';

enum ExploreFilter { personas, comunidades, eventos }

class ExploreView extends StatefulWidget {
  const ExploreView({super.key});

  @override
  State<ExploreView> createState() => _ExploreViewState();
}

class _ExploreViewState extends State<ExploreView> {
  final TextEditingController _searchController = TextEditingController();
  ExploreFilter _selectedFilter = ExploreFilter.eventos;
  String _query = '';

  bool get _searching => _query.trim().isNotEmpty;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
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
              _SearchHeader(
                controller: _searchController,
                selectedFilter: _selectedFilter,
                onQueryChanged: (String value) {
                  setState(() {
                    _query = value;
                  });
                },
                onFilterChanged: (ExploreFilter filter) {
                  setState(() {
                    _selectedFilter = filter;
                  });
                },
              ),
              Expanded(
                child: _searching
                    ? _SearchResults(
                        filter: _selectedFilter,
                        query: _query,
                      )
                    : const _ExploreHome(),
              ),
              BarraInteractiva(
                selected: BarraInteractivaItem.explorar,
                onTap: (BarraInteractivaItem item) {
                  if (item == BarraInteractivaItem.explorar) {
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

class _SearchHeader extends StatelessWidget {
  const _SearchHeader({
    required this.controller,
    required this.selectedFilter,
    required this.onQueryChanged,
    required this.onFilterChanged,
  });

  final TextEditingController controller;
  final ExploreFilter selectedFilter;
  final ValueChanged<String> onQueryChanged;
  final ValueChanged<ExploreFilter> onFilterChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
      decoration: BoxDecoration(
        color: AppColors.white.withValues(alpha: 0.94),
        border: Border(
          bottom: BorderSide(color: AppColors.divider.withValues(alpha: 0.45)),
        ),
      ),
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(
                child: TextField(
                  controller: controller,
                  onChanged: onQueryChanged,
                  decoration: InputDecoration(
                    hintText: 'Buscar en LOOP',
                    prefixIcon: const Icon(Icons.search, size: 20),
                    suffixIcon: controller.text.isEmpty
                        ? null
                        : IconButton(
                            onPressed: () {
                              controller.clear();
                              onQueryChanged('');
                            },
                            icon: const Icon(Icons.close, size: 18),
                          ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: <Widget>[
              _FilterChip(
                label: 'Personas',
                selected: selectedFilter == ExploreFilter.personas,
                onTap: () => onFilterChanged(ExploreFilter.personas),
              ),
              const SizedBox(width: 8),
              _FilterChip(
                label: 'Comunidades',
                selected: selectedFilter == ExploreFilter.comunidades,
                onTap: () => onFilterChanged(ExploreFilter.comunidades),
              ),
              const SizedBox(width: 8),
              _FilterChip(
                label: 'Eventos',
                selected: selectedFilter == ExploreFilter.eventos,
                onTap: () => onFilterChanged(ExploreFilter.eventos),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  const _FilterChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 160),
          padding: const EdgeInsets.symmetric(vertical: 9),
          decoration: BoxDecoration(
            color: selected ? AppColors.primary : AppColors.inputBackground,
            borderRadius: BorderRadius.circular(18),
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: selected ? AppColors.white : AppColors.textSecondary,
              fontSize: 12,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
      ),
    );
  }
}

class _ExploreHome extends StatefulWidget {
  const _ExploreHome();

  @override
  State<_ExploreHome> createState() => _ExploreHomeState();
}

class _ExploreHomeState extends State<_ExploreHome> {
  static final ExploreService _service = ExploreService();
  List<ExploreNearbyEventItem> _nearbyEvents = <ExploreNearbyEventItem>[];
  List<ExploreRecommendedCommunityItem> _communities =
      <ExploreRecommendedCommunityItem>[];
  List<ExploreUpcomingEventItem> _upcomingEvents =
      <ExploreUpcomingEventItem>[];
  bool _loadingNearby = true;
  bool _loadingCommunities = true;
  bool _loadingUpcoming = true;

  @override
  void initState() {
    super.initState();
    _loadNearby();
    _loadCommunities();
    _loadUpcoming();
  }

  Future<void> _loadNearby() async {
    final List<ExploreNearbyEventItem> items =
        await _service.fetchNearbyPreview(limit: 6);
    if (mounted) {
      setState(() {
        _nearbyEvents = items;
        _loadingNearby = false;
      });
    }
  }

  Future<void> _loadCommunities() async {
    final List<ExploreRecommendedCommunityItem> items =
        await _service.fetchRecommendedCommunities();
    if (mounted) {
      setState(() {
        _communities = items;
        _loadingCommunities = false;
      });
    }
  }

  Future<void> _loadUpcoming() async {
    final List<ExploreUpcomingEventItem> items =
        await _service.fetchUpcomingEvents();
    if (mounted) {
      setState(() {
        _upcomingEvents = items;
        _loadingUpcoming = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.only(bottom: 22),
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              _ExploreSectionTitle(
                title: 'Eventos cerca de ti',
                action: 'Ver todo',
                onAction: () {
                  Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      builder: (_) => const NearbyEventsListView(),
                    ),
                  );
                },
              ),
              _NearbyEventsCarousel(
                items: _nearbyEvents,
                loading: _loadingNearby,
              ),
              const SizedBox(height: 18),
              _ExploreSectionTitle(
                title: 'Comunidades recomendadas',
                action: 'Ver todo',
                onAction: () {
                  Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      builder: (_) => const RecommendedCommunitiesListView(),
                    ),
                  );
                },
              ),
              _CommunitiesCarousel(
                items: _communities,
                loading: _loadingCommunities,
              ),
              const SizedBox(height: 18),
              _ExploreSectionTitle(
                title: 'Eventos proximos',
                action: 'Ver todo',
                onAction: () {
                  Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      builder: (_) => const UpcomingEventsListView(),
                    ),
                  );
                },
              ),
              _UpcomingEventsCarousel(
                items: _upcomingEvents,
                loading: _loadingUpcoming,
              ),
            ],
          ),
        ),
        const SizedBox(height: 18),
        const Padding(
          padding: EdgeInsets.fromLTRB(16, 0, 16, 10),
          child: Text(
            'Publicaciones destacadas',
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 18,
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
        FutureBuilder<List<ExploreFeaturedPostItem>>(
          future: _service.fetchFeaturedPosts(),
          builder: (
            BuildContext context,
            AsyncSnapshot<List<ExploreFeaturedPostItem>> snapshot,
          ) {
            if (!snapshot.hasData) {
              return const Padding(
                padding: EdgeInsets.all(24),
                child: Center(child: CircularProgressIndicator()),
              );
            }
            if (snapshot.data!.isEmpty) {
              return const Padding(
                padding: EdgeInsets.all(24),
                child: Text(
                  'No hay publicaciones destacadas.',
                  style: TextStyle(color: AppColors.textSecondary),
                ),
              );
            }
            return Column(
              children: snapshot.data!
                  .map(
                    (ExploreFeaturedPostItem post) => FullBleedPublicationCard(
                      userLabel: post.user,
                      contextLabel: post.linkedTo,
                      imageLabel: post.isTextOnly ? null : post.imageLabel,
                      imageColorHex: post.imageColorHex,
                      caption: post.caption,
                      likes: post.likes,
                      comments: post.comments,
                      title: post.title,
                      body: post.body,
                      replies: post.replies,
                      onOpen: () => openPostDetail(context, post.postId),
                    ),
                  )
                  .toList(),
            );
          },
        ),
      ],
    );
  }
}

class _ExploreSectionTitle extends StatelessWidget {
  const _ExploreSectionTitle({
    required this.title,
    this.action,
    this.onAction,
  });

  final String title;
  final String? action;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontSize: 18,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
          if (action != null)
            InkWell(
              onTap: onAction,
              borderRadius: BorderRadius.circular(8),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                child: Text(
                  action!,
                  style: const TextStyle(
                    color: AppColors.primary,
                    fontSize: 12,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _NearbyEventsCarousel extends StatelessWidget {
  const _NearbyEventsCarousel({
    required this.items,
    this.loading = false,
  });

  final List<ExploreNearbyEventItem> items;
  final bool loading;

  Color _parseHex(String hex) {
    return Color(int.parse('FF${hex.replaceFirst('#', '')}', radix: 16));
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const SizedBox(
        height: 180,
        child: Center(child: CircularProgressIndicator()),
      );
    }
    if (items.isEmpty) {
      return const SizedBox(
        height: 180,
        child: Center(
          child: Text(
            'No hay eventos cercanos disponibles.',
            style: TextStyle(color: AppColors.textSecondary),
          ),
        ),
      );
    }
    return SizedBox(
      height: 180,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: items
            .map(
              (ExploreNearbyEventItem item) => _EventCompactCard(
                eventId: item.eventId,
                title: item.title,
                meta: '${item.comuna} · ${item.distanceLabel}',
                date: item.dateLabel,
                color: _parseHex(item.colorHex),
              ),
            )
            .toList(),
      ),
    );
  }
}

class _CommunitiesCarousel extends StatelessWidget {
  const _CommunitiesCarousel({
    required this.items,
    this.loading = false,
  });

  final List<ExploreRecommendedCommunityItem> items;
  final bool loading;

  Color _parseHex(String hex) {
    return Color(int.parse('FF${hex.replaceFirst('#', '')}', radix: 16));
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const SizedBox(
        height: 148,
        child: Center(child: CircularProgressIndicator()),
      );
    }
    if (items.isEmpty) {
      return const SizedBox(
        height: 148,
        child: Center(
          child: Text(
            'No hay comunidades publicas disponibles.',
            style: TextStyle(color: AppColors.textSecondary),
          ),
        ),
      );
    }
    return SizedBox(
      height: 148,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: items
            .map(
              (ExploreRecommendedCommunityItem item) => InkWell(
                onTap: () => openCommunityDetail(context, item.communityId),
                borderRadius: BorderRadius.circular(16),
                child: _CommunityCard(
                  title: item.title,
                  members: item.membersLabel,
                  color: _parseHex(item.colorHex),
                ),
              ),
            )
            .toList(),
      ),
    );
  }
}

class _UpcomingEventsCarousel extends StatelessWidget {
  const _UpcomingEventsCarousel({
    required this.items,
    this.loading = false,
  });

  final List<ExploreUpcomingEventItem> items;
  final bool loading;

  Color _parseHex(String hex) {
    return Color(int.parse('FF${hex.replaceFirst('#', '')}', radix: 16));
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const SizedBox(
        height: 190,
        child: Center(child: CircularProgressIndicator()),
      );
    }
    if (items.isEmpty) {
      return const SizedBox(
        height: 190,
        child: Center(
          child: Text(
            'No hay eventos proximos disponibles.',
            style: TextStyle(color: AppColors.textSecondary),
          ),
        ),
      );
    }
    return SizedBox(
      height: 190,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: items
            .map(
              (ExploreUpcomingEventItem item) => _EventCompactCard(
                eventId: item.eventId,
                title: item.title,
                meta: item.locationLabel,
                date: item.dateLabel,
                color: _parseHex(item.colorHex),
              ),
            )
            .toList(),
      ),
    );
  }
}

class _EventCompactCard extends StatelessWidget {
  const _EventCompactCard({
    required this.eventId,
    required this.title,
    required this.meta,
    required this.date,
    required this.color,
  });

  final int eventId;
  final String title;
  final String meta;
  final String date;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => openEventDetail(context, eventId),
      borderRadius: BorderRadius.circular(16),
      child: Container(
      width: 158,
      margin: const EdgeInsets.only(right: 12),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: AppColors.primaryDark.withValues(alpha: 0.06),
            blurRadius: 12,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            height: 82,
            decoration: BoxDecoration(
              color: color,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(16),
              ),
            ),
            child: Center(
              child: Icon(
                Icons.event_available_outlined,
                color: AppColors.white.withValues(alpha: 0.92),
                size: 34,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  meta,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: Text(
                        date,
                        style: const TextStyle(
                          color: AppColors.primary,
                          fontSize: 12,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                    const Text(
                      'Ver',
                      style: TextStyle(
                        color: AppColors.primaryDark,
                        fontSize: 12,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ],
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

class _CommunityCard extends StatelessWidget {
  const _CommunityCard({
    required this.title,
    required this.members,
    required this.color,
  });

  final String title;
  final String members;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 150,
      margin: const EdgeInsets.only(right: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const CircleAvatar(
            radius: 17,
            backgroundColor: AppColors.white,
            child: Icon(Icons.groups_outlined, color: AppColors.primary),
          ),
          const Spacer(),
          Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: AppColors.white,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            members,
            style: TextStyle(
              color: AppColors.white.withValues(alpha: 0.78),
              fontSize: 12,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: AppColors.white.withValues(alpha: 0.16),
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Text(
              'Unirme',
              style: TextStyle(
                color: AppColors.white,
                fontSize: 11,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SearchResults extends StatefulWidget {
  const _SearchResults({
    required this.filter,
    required this.query,
  });

  final ExploreFilter filter;
  final String query;

  @override
  State<_SearchResults> createState() => _SearchResultsState();
}

class _SearchResultsState extends State<_SearchResults> {
  final ExploreSearchService _service = ExploreSearchService();
  late Future<List<dynamic>> _future;

  @override
  void initState() {
    super.initState();
    _future = _load();
  }

  @override
  void didUpdateWidget(covariant _SearchResults oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.query != widget.query || oldWidget.filter != widget.filter) {
      _future = _load();
    }
  }

  Future<List<dynamic>> _load() {
    switch (widget.filter) {
      case ExploreFilter.personas:
        return _service.searchPersons(widget.query);
      case ExploreFilter.comunidades:
        return _service.searchCommunities(widget.query);
      case ExploreFilter.eventos:
        return _service.searchEvents(widget.query);
    }
  }

  @override
  Widget build(BuildContext context) {
    final String title = switch (widget.filter) {
      ExploreFilter.personas => 'Personas',
      ExploreFilter.comunidades => 'Comunidades',
      ExploreFilter.eventos => 'Eventos',
    };

    return FutureBuilder<List<dynamic>>(
      future: _future,
      builder: (BuildContext context, AsyncSnapshot<List<dynamic>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        final List<dynamic> results = snapshot.data ?? <dynamic>[];
        return ListView(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 22),
          children: <Widget>[
            Text(
              '$title para "${widget.query.trim()}"',
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontSize: 20,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: 12),
            if (results.isEmpty)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 24),
                child: Text(
                  'No se encontraron resultados.',
                  style: TextStyle(color: AppColors.textSecondary),
                ),
              )
            else if (widget.filter == ExploreFilter.personas)
              ...results.cast<ExploreSearchPerson>().map(
                    (ExploreSearchPerson person) => _PersonResult(
                      userId: person.userId,
                      name: person.name,
                      username: person.username,
                    ),
                  )
            else if (widget.filter == ExploreFilter.comunidades)
              ...results.cast<ExploreSearchCommunity>().map(
                    (ExploreSearchCommunity community) => _CommunityResult(
                      communityId: community.communityId,
                      name: community.name,
                      members: community.membersLabel,
                    ),
                  )
            else
              ...results.cast<ExploreSearchEvent>().map(
                    (ExploreSearchEvent event) => _EventResult(
                      eventId: event.eventId,
                      name: event.name,
                      meta: event.meta,
                    ),
                  ),
          ],
        );
      },
    );
  }
}

class _PersonResult extends StatelessWidget {
  const _PersonResult({
    required this.userId,
    required this.name,
    required this.username,
  });

  final int userId;
  final String name;
  final String username;

  @override
  Widget build(BuildContext context) {
    return _ResultTile(
      icon: Icons.person_outline,
      title: name,
      subtitle: username,
      action: 'Ver perfil',
      onAction: () => openUserProfile(context, userId),
    );
  }
}

class _CommunityResult extends StatelessWidget {
  const _CommunityResult({
    required this.communityId,
    required this.name,
    required this.members,
  });

  final int communityId;
  final String name;
  final String members;

  @override
  Widget build(BuildContext context) {
    return _ResultTile(
      icon: Icons.groups_outlined,
      title: name,
      subtitle: members,
      action: 'Ver',
      onAction: () => openCommunityDetail(context, communityId),
    );
  }
}

class _EventResult extends StatelessWidget {
  const _EventResult({
    required this.eventId,
    required this.name,
    required this.meta,
  });

  final int eventId;
  final String name;
  final String meta;

  @override
  Widget build(BuildContext context) {
    return _ResultTile(
      icon: Icons.event_available_outlined,
      title: name,
      subtitle: meta,
      action: 'Ver evento',
      onAction: () => openEventDetail(context, eventId),
    );
  }
}

class _ResultTile extends StatelessWidget {
  const _ResultTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.action,
    this.onAction,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final String action;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onAction,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          children: <Widget>[
            CircleAvatar(
              radius: 20,
              backgroundColor: AppColors.inputBackground,
              child: Icon(icon, color: AppColors.primary),
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
                      fontWeight: FontWeight.w900,
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
            Text(
              action,
              style: const TextStyle(
                color: AppColors.primary,
                fontSize: 12,
                fontWeight: FontWeight.w900,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
