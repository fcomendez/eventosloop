import 'package:eventosloop/core/navigation/detail_navigation.dart';
import 'package:eventosloop/core/theme/app_colors.dart';
import 'package:eventosloop/features/explore/models/explore_catalog_models.dart';
import 'package:eventosloop/features/explore/services/explore_mock_service.dart';
import 'package:flutter/material.dart';

class NearbyEventsListView extends StatefulWidget {
  const NearbyEventsListView({super.key});

  @override
  State<NearbyEventsListView> createState() => _NearbyEventsListViewState();
}

class _NearbyEventsListViewState extends State<NearbyEventsListView> {
  final ExploreMockService _service = ExploreMockService();
  UserLocationContext? _location;
  List<ExploreNearbyEventItem> _items = <ExploreNearbyEventItem>[];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final UserLocationContext location = await _service.fetchUserLocation();
    final List<ExploreNearbyEventItem> items =
        await _service.fetchNearbyEvents();
    if (!mounted) {
      return;
    }
    setState(() {
      _location = location;
      _items = items;
      _loading = false;
    });
  }

  Color _parseHex(String hex) {
    return Color(int.parse('FF${hex.replaceFirst('#', '')}', radix: 16));
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
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              _ExploreListTopBar(title: 'Eventos cerca de ti'),
              if (_loading)
                const Expanded(child: Center(child: CircularProgressIndicator()))
              else
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                    children: <Widget>[
                      Text(
                        'Filtrado por ${_location!.region} · ${_location!.comuna}',
                        style: const TextStyle(
                          color: AppColors.textSecondary,
                          height: 1.35,
                        ),
                      ),
                      const SizedBox(height: 14),
                      ..._items.map(
                        (ExploreNearbyEventItem item) => _EventListTile(
                          title: item.title,
                          subtitle:
                              '${item.comuna} · ${item.distanceLabel} · ${item.dateLabel}',
                          color: _parseHex(item.colorHex),
                          onTap: () => openEventDetail(context, item.eventId),
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
}

class RecommendedCommunitiesListView extends StatefulWidget {
  const RecommendedCommunitiesListView({super.key});

  @override
  State<RecommendedCommunitiesListView> createState() =>
      _RecommendedCommunitiesListViewState();
}

class _RecommendedCommunitiesListViewState
    extends State<RecommendedCommunitiesListView> {
  final ExploreMockService _service = ExploreMockService();
  List<ExploreRecommendedCommunityItem> _items =
      <ExploreRecommendedCommunityItem>[];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final List<ExploreRecommendedCommunityItem> items =
        await _service.fetchRecommendedCommunities();
    if (!mounted) {
      return;
    }
    setState(() {
      _items = items;
      _loading = false;
    });
  }

  Color _parseHex(String hex) {
    return Color(int.parse('FF${hex.replaceFirst('#', '')}', radix: 16));
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
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              const _ExploreListTopBar(title: 'Comunidades recomendadas'),
              if (_loading)
                const Expanded(child: Center(child: CircularProgressIndicator()))
              else
                Expanded(
                  child: ListView.separated(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                    itemCount: _items.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (BuildContext context, int index) {
                      final ExploreRecommendedCommunityItem item =
                          _items[index];
                      return InkWell(
                        onTap: () =>
                            openCommunityDetail(context, item.communityId),
                        borderRadius: BorderRadius.circular(16),
                        child: Container(
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: _parseHex(item.colorHex),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                item.title,
                                style: const TextStyle(
                                  color: AppColors.white,
                                  fontWeight: FontWeight.w900,
                                  fontSize: 18,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                item.membersLabel,
                                style: TextStyle(
                                  color: AppColors.white.withValues(alpha: 0.82),
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                item.matchLabel,
                                style: TextStyle(
                                  color: AppColors.white.withValues(alpha: 0.9),
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class UpcomingEventsListView extends StatefulWidget {
  const UpcomingEventsListView({super.key});

  @override
  State<UpcomingEventsListView> createState() => _UpcomingEventsListViewState();
}

class _UpcomingEventsListViewState extends State<UpcomingEventsListView> {
  final ExploreMockService _service = ExploreMockService();
  List<ExploreUpcomingEventItem> _items = <ExploreUpcomingEventItem>[];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final List<ExploreUpcomingEventItem> items =
        await _service.fetchUpcomingEvents();
    if (!mounted) {
      return;
    }
    setState(() {
      _items = items;
      _loading = false;
    });
  }

  Color _parseHex(String hex) {
    return Color(int.parse('FF${hex.replaceFirst('#', '')}', radix: 16));
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
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              const _ExploreListTopBar(title: 'Eventos proximos'),
              if (_loading)
                const Expanded(child: Center(child: CircularProgressIndicator()))
              else
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                    children: <Widget>[
                      const Text(
                        'Proximos eventos en tu region y comunas cercanas.',
                        style: TextStyle(
                          color: AppColors.textSecondary,
                          height: 1.35,
                        ),
                      ),
                      const SizedBox(height: 14),
                      ..._items.map(
                        (ExploreUpcomingEventItem item) => _EventListTile(
                          title: item.title,
                          subtitle:
                              '${item.locationLabel} · ${item.comuna} · ${item.dateLabel}',
                          color: _parseHex(item.colorHex),
                          onTap: () => openEventDetail(context, item.eventId),
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
}

class _ExploreListTopBar extends StatelessWidget {
  const _ExploreListTopBar({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 8, 16, 8),
      child: Row(
        children: <Widget>[
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back),
            color: AppColors.primaryDark,
          ),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w900,
                fontSize: 18,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _EventListTile extends StatelessWidget {
  const _EventListTile({
    required this.title,
    required this.subtitle,
    required this.color,
    required this.onTap,
  });

  final String title;
  final String subtitle;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            children: <Widget>[
              Container(
                width: 72,
                height: 72,
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: const BorderRadius.horizontal(
                    left: Radius.circular(16),
                  ),
                ),
                child: Icon(
                  Icons.event_available_outlined,
                  color: AppColors.white.withValues(alpha: 0.92),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(12),
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
                      const SizedBox(height: 4),
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
              ),
            ],
          ),
        ),
      ),
    );
  }
}
