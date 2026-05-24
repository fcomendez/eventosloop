import 'package:eventosloop/core/config/app_env.dart';
import 'package:eventosloop/core/navigation/detail_navigation.dart';
import 'package:eventosloop/core/theme/app_colors.dart';
import 'package:eventosloop/core/widgets/pending_requests_banner.dart';
import 'package:eventosloop/core/widgets/barra_interactiva.dart';
import 'package:eventosloop/features/communities/models/community_list_item.dart';
import 'package:eventosloop/features/communities/services/community_supabase_service.dart';
import 'package:eventosloop/features/events/models/event_model.dart';
import 'package:eventosloop/features/events/models/event_participation_status.dart';
import 'package:eventosloop/features/events/services/event_service.dart';
import 'package:eventosloop/features/main_navigation/views/nav_placeholder_view.dart';
import 'package:flutter/material.dart';

class CommunitiesEventsView extends StatefulWidget {
  const CommunitiesEventsView({super.key});

  @override
  State<CommunitiesEventsView> createState() => _CommunitiesEventsViewState();
}

class _CommunitiesEventsViewState extends State<CommunitiesEventsView> {
  int _selectedTab = 0;

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
              const _TopBar(),
              Padding(
                padding: const EdgeInsets.fromLTRB(18, 8, 18, 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    const Text(
                      'Mis comunidades y eventos',
                      style: TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 24,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      'Revisa las comunidades donde participas y los eventos en los que estas inscrito.',
                      style: TextStyle(
                        color: AppColors.textSecondary,
                        height: 1.35,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _SegmentedTabs(
                      selectedTab: _selectedTab,
                      onChanged: (int value) {
                        setState(() {
                          _selectedTab = value;
                        });
                      },
                    ),
                  ],
                ),
              ),
              const PendingRequestsBanner(),
              Expanded(
                child: _selectedTab == 0
                    ? const _CommunitiesList()
                    : const _RegisteredEventsList(),
              ),
              BarraInteractiva(
                selected: BarraInteractivaItem.comunidades,
                onTap: (BarraInteractivaItem item) {
                  if (item == BarraInteractivaItem.comunidades) {
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

class _TopBar extends StatelessWidget {
  const _TopBar();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
      child: Row(
        children: <Widget>[
          const Expanded(
            child: Text(
              'LOOP',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppColors.primaryDark,
                fontSize: 18,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SegmentedTabs extends StatelessWidget {
  const _SegmentedTabs({
    required this.selectedTab,
    required this.onChanged,
  });

  final int selectedTab;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: <Widget>[
          _tab(index: 0, label: 'Comunidades'),
          _tab(index: 1, label: 'Eventos'),
        ],
      ),
    );
  }

  Widget _tab({
    required int index,
    required String label,
  }) {
    final bool active = selectedTab == index;
    return Expanded(
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () => onChanged(index),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 160),
          padding: const EdgeInsets.symmetric(vertical: 11),
          decoration: BoxDecoration(
            color: active ? AppColors.primary : Colors.transparent,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: active ? AppColors.white : AppColors.textSecondary,
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
      ),
    );
  }
}

class _CommunitiesList extends StatefulWidget {
  const _CommunitiesList();

  @override
  State<_CommunitiesList> createState() => _CommunitiesListState();
}

class _CommunitiesListState extends State<_CommunitiesList> {
  final CommunitySupabaseService _service = CommunitySupabaseService();
  List<CommunityListItem> _items = <CommunityListItem>[];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    if (!AppEnv.useSupabase) {
      if (mounted) {
        setState(() {
          _loading = false;
        });
      }
      return;
    }
    final List<CommunityListItem> items = await _service.listarMisComunidades();
    if (mounted) {
      setState(() {
        _items = items;
        _loading = false;
      });
    }
  }

  Color _colorFor(CommunityListItem item) {
    if (item.interestTags.isEmpty) {
      return AppColors.primary;
    }
    final String hex = item.interestTags.first.colorHex.replaceAll('#', '');
    if (hex.length != 6) {
      return AppColors.primary;
    }
    return Color(int.parse('FF$hex', radix: 16));
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (_items.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Text(
            'Aun no te has unido a ninguna comunidad.',
            textAlign: TextAlign.center,
            style: TextStyle(color: AppColors.textSecondary),
          ),
        ),
      );
    }
    return RefreshIndicator(
      onRefresh: _load,
      child: ListView(
        padding: const EdgeInsets.fromLTRB(18, 4, 18, 22),
        children: _items
            .map(
              (CommunityListItem item) => _CommunityMemberCard(
                id: item.id,
                title: item.name,
                category: item.primaryCategory,
                description: item.description,
                activity: item.membersLabel,
                color: _colorFor(item),
              ),
            )
            .toList(),
      ),
    );
  }
}

class _CommunityMemberCard extends StatelessWidget {
  const _CommunityMemberCard({
    required this.id,
    required this.title,
    required this.category,
    required this.description,
    required this.activity,
    required this.color,
  });

  final int id;
  final String title;
  final String category;
  final String description;
  final String activity;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(18),
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
            height: 128,
            decoration: BoxDecoration(
              color: color,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(18),
              ),
            ),
            child: Stack(
              children: <Widget>[
                Center(
                  child: Icon(
                    Icons.groups_outlined,
                    size: 48,
                    color: AppColors.white.withValues(alpha: 0.86),
                  ),
                ),
                Positioned(
                  right: 12,
                  top: 12,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: AppColors.white.withValues(alpha: 0.9),
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: const Text(
                      'ACTIVA',
                      style: TextStyle(
                        color: AppColors.primaryDark,
                        fontSize: 10,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  category.toUpperCase(),
                  style: const TextStyle(
                    color: AppColors.primary,
                    fontSize: 11,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 5),
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
                  description,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    height: 1.34,
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: <Widget>[
                    const Icon(
                      Icons.people_outline,
                      size: 17,
                      color: AppColors.textSecondary,
                    ),
                    const SizedBox(width: 5),
                    Text(
                      activity,
                      style: const TextStyle(color: AppColors.textSecondary),
                    ),
                    const Spacer(),
                    OutlinedButton(
                      onPressed: () => openCommunityDetail(context, id),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.primary,
                        side: const BorderSide(color: AppColors.divider),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18),
                        ),
                      ),
                      child: const Text('Ver'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _RegisteredEventsList extends StatefulWidget {
  const _RegisteredEventsList();

  @override
  State<_RegisteredEventsList> createState() => _RegisteredEventsListState();
}

class _RegisteredEventsListState extends State<_RegisteredEventsList> {
  final EventService _service = EventService();
  List<EventModel> _events = <EventModel>[];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final List<EventModel> events = await _service.listarMisEventosInscritos();
    if (mounted) {
      setState(() {
        _events = events;
        _loading = false;
      });
    }
  }

  Color _colorFor(EventModel event) {
    final String hex = event.coverColorHex.replaceAll('#', '');
    if (hex.length != 6) {
      return AppColors.primaryDark;
    }
    return Color(int.parse('FF$hex', radix: 16));
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (_events.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Text(
            'No tienes eventos inscritos todavia.',
            textAlign: TextAlign.center,
            style: TextStyle(color: AppColors.textSecondary),
          ),
        ),
      );
    }
    return RefreshIndicator(
      onRefresh: _load,
      child: ListView(
        padding: const EdgeInsets.fromLTRB(18, 4, 18, 22),
        children: _events
            .map(
              (EventModel event) => _RegisteredEventCard(
                eventId: event.id,
                title: event.title,
                category: event.category,
                date: event.dateLabel,
                time: event.timeLabel,
                color: _colorFor(event),
                highlighted: event.participationStatus ==
                    EventParticipationStatus.pending,
                statusLabel: event.participationStatus ==
                        EventParticipationStatus.pending
                    ? 'PENDIENTE'
                    : null,
              ),
            )
            .toList(),
      ),
    );
  }
}

class _RegisteredEventCard extends StatelessWidget {
  const _RegisteredEventCard({
    required this.eventId,
    required this.title,
    required this.category,
    required this.date,
    required this.time,
    required this.color,
    this.highlighted = false,
    this.statusLabel,
  });

  final int eventId;
  final String title;
  final String category;
  final String date;
  final String time;
  final Color color;
  final bool highlighted;
  final String? statusLabel;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 18),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(18),
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
            height: 150,
            decoration: BoxDecoration(
              color: color,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(18),
              ),
            ),
            child: Stack(
              children: <Widget>[
                Center(
                  child: Icon(
                    Icons.confirmation_number_outlined,
                    size: 52,
                    color: AppColors.white.withValues(alpha: 0.9),
                  ),
                ),
                if (highlighted && statusLabel != null)
                  Positioned(
                    left: 12,
                    top: 12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Text(
                        statusLabel!,
                        style: const TextStyle(
                          color: AppColors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  category.toUpperCase(),
                  style: const TextStyle(
                    color: AppColors.primary,
                    fontSize: 11,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  title,
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  children: <Widget>[
                    const Icon(
                      Icons.calendar_month_outlined,
                      size: 16,
                      color: AppColors.textSecondary,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      date,
                      style: const TextStyle(color: AppColors.textSecondary),
                    ),
                  ],
                ),
                const SizedBox(height: 5),
                Row(
                  children: <Widget>[
                    const Icon(
                      Icons.access_time,
                      size: 16,
                      color: AppColors.textSecondary,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      time,
                      style: const TextStyle(color: AppColors.textSecondary),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => openEventDetail(context, eventId),
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          highlighted ? AppColors.primary : AppColors.white,
                      foregroundColor:
                          highlighted ? AppColors.white : AppColors.primary,
                      side: highlighted
                          ? BorderSide.none
                          : const BorderSide(color: AppColors.primary),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18),
                      ),
                    ),
                    child: Text(
                      highlighted ? 'Ver entrada' : 'Detalles del evento',
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
