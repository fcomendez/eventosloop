import 'package:eventosloop/core/navigation/detail_navigation.dart';
import 'package:eventosloop/core/theme/app_colors.dart';
import 'package:eventosloop/core/widgets/full_bleed_publication_card.dart';
import 'package:eventosloop/features/communities/models/community_model.dart';
import 'package:eventosloop/features/communities/services/community_detail_mock_service.dart';
import 'package:eventosloop/features/events/models/event_model.dart';
import 'package:eventosloop/features/events/services/event_mock_service.dart';
import 'package:flutter/material.dart';

class CommunityDetailView extends StatefulWidget {
  const CommunityDetailView({super.key, required this.communityId});

  final int communityId;

  @override
  State<CommunityDetailView> createState() => _CommunityDetailViewState();
}

class _CommunityDetailViewState extends State<CommunityDetailView> {
  final CommunityDetailMockService _communityService =
      CommunityDetailMockService();
  final EventMockService _eventService = EventMockService();

  CommunityModel? _community;
  List<CommunityPostModel> _posts = <CommunityPostModel>[];
  List<EventModel> _events = <EventModel>[];
  int _selectedTab = 0;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final CommunityModel? community =
        await _communityService.fetchById(widget.communityId);
    final List<CommunityPostModel> posts =
        await _communityService.fetchPosts(widget.communityId);
    final List<EventModel> events =
        await _eventService.fetchByCommunityId(widget.communityId);
    if (!mounted) {
      return;
    }
    setState(() {
      _community = community;
      _posts = posts;
      _events = events;
      _loading = false;
    });
  }

  Color _parseHex(String value) {
    final String clean = value.replaceFirst('#', '');
    return Color(int.parse('FF$clean', radix: 16));
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
          child: _loading
              ? const Center(child: CircularProgressIndicator())
              : _community == null
                  ? _NotFound(onBack: () => Navigator.pop(context))
                  : Column(
                      children: <Widget>[
                        _TopBar(
                          title: _community!.name,
                          onBack: () => Navigator.pop(context),
                        ),
                        Expanded(
                          child: ListView(
                            padding: EdgeInsets.zero,
                            children: <Widget>[
                              Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(18, 8, 18, 0),
                                child: Column(
                                  children: <Widget>[
                                    _CommunityHeader(
                                      color:
                                          _parseHex(_community!.coverColorHex),
                                      name: _community!.name,
                                      tags: _community!.tags,
                                      isActive: _community!.isActive,
                                      description: _community!.description,
                                      activityLabel:
                                          _community!.activityLabel,
                                    ),
                                    const SizedBox(height: 16),
                                    _ContentTabs(
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
                              const SizedBox(height: 14),
                              if (_selectedTab == 0) ...<Widget>[
                                ..._posts.map(
                                  (CommunityPostModel post) =>
                                      FullBleedPublicationCard(
                                    userLabel: post.authorName,
                                    contextLabel:
                                        '${post.publishedLabel} · ${post.linkedTo}',
                                    title: post.title,
                                    body: post.body,
                                    imageLabel: post.mediaLabel,
                                    imageColorHex: post.mediaColorHex,
                                    likes: post.likesCount,
                                    comments: post.commentsCount,
                                    onOpen: () =>
                                        openPostDetail(context, post.id),
                                  ),
                                ),
                              ] else
                                Padding(
                                  padding: const EdgeInsets.fromLTRB(
                                    18,
                                    0,
                                    18,
                                    22,
                                  ),
                                  child: Column(
                                    children: _events
                                        .map(
                                          (EventModel event) =>
                                              _CommunityEventTile(
                                            event: event,
                                            onTap: () => openEventDetail(
                                              context,
                                              event.id,
                                            ),
                                          ),
                                        )
                                        .toList(),
                                  ),
                                ),
                              if (_selectedTab == 0 && _posts.isEmpty)
                                const Padding(
                                  padding: EdgeInsets.all(18),
                                  child: _EmptyState(
                                    message:
                                        'Aun no hay publicaciones en esta comunidad.',
                                  ),
                                ),
                              if (_selectedTab == 1 && _events.isEmpty)
                                const Padding(
                                  padding: EdgeInsets.all(18),
                                  child: _EmptyState(
                                    message:
                                        'No hay eventos vinculados por ahora.',
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

class _TopBar extends StatelessWidget {
  const _TopBar({required this.title, required this.onBack});

  final String title;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 8, 16, 4),
      child: Row(
        children: <Widget>[
          IconButton(
            onPressed: onBack,
            icon: const Icon(Icons.arrow_back),
            color: AppColors.primaryDark,
          ),
          Expanded(
            child: Text(
              title,
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: AppColors.primaryDark,
                fontSize: 17,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
          const SizedBox(width: 48),
        ],
      ),
    );
  }
}

class _CommunityHeader extends StatelessWidget {
  const _CommunityHeader({
    required this.color,
    required this.name,
    required this.tags,
    required this.isActive,
    required this.description,
    required this.activityLabel,
  });

  final Color color;
  final String name;
  final List<String> tags;
  final bool isActive;
  final String description;
  final String activityLabel;

  @override
  Widget build(BuildContext context) {
    return Container(
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
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Container(
            height: 150,
            color: color,
            child: Stack(
              children: <Widget>[
                Center(
                  child: Icon(
                    Icons.groups_outlined,
                    size: 56,
                    color: AppColors.white.withValues(alpha: 0.88),
                  ),
                ),
                if (isActive)
                  Positioned(
                    left: 12,
                    top: 12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.white.withValues(alpha: 0.92),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: const Text(
                        'COMUNIDAD ACTIVA',
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
                  name,
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 24,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: tags
                      .map(
                        (String tag) => Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 5,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Text(
                            tag,
                            style: const TextStyle(
                              color: AppColors.primary,
                              fontWeight: FontWeight.w800,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      )
                      .toList(),
                ),
              ],
            ),
          ),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
            color: AppColors.cardBackground,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const Text(
                  'Sobre nuestra comunidad',
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 16,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  description,
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: <Widget>[
                    const Icon(Icons.people_outline,
                        color: AppColors.primary, size: 18),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        activityLabel,
                        style: const TextStyle(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
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

class _ContentTabs extends StatelessWidget {
  const _ContentTabs({
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
          _tab(index: 0, label: 'Posts'),
          _tab(index: 1, label: 'Eventos'),
        ],
      ),
    );
  }

  Widget _tab({required int index, required String label}) {
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

class _CommunityEventTile extends StatelessWidget {
  const _CommunityEventTile({
    required this.event,
    required this.onTap,
  });

  final EventModel event;
  final VoidCallback onTap;

  Color _parseHex(String value) {
    final String clean = value.replaceFirst('#', '');
    return Color(int.parse('FF$clean', radix: 16));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: AppColors.primaryDark.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            height: 110,
            decoration: BoxDecoration(
              color: _parseHex(event.coverColorHex),
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(18),
              ),
            ),
            child: Stack(
              children: <Widget>[
                Center(
                  child: Icon(
                    Icons.event_available_outlined,
                    size: 42,
                    color: AppColors.white.withValues(alpha: 0.9),
                  ),
                ),
                Positioned(
                  left: 12,
                  top: 12,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.white.withValues(alpha: 0.92),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Text(
                      event.category.toUpperCase(),
                      style: const TextStyle(
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
                  event.title,
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w900,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 8),
                _meta(Icons.calendar_month_outlined, event.dateLabel),
                const SizedBox(height: 4),
                _meta(Icons.access_time, event.timeLabel),
                const SizedBox(height: 4),
                _meta(Icons.location_on_outlined, event.comuna),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: onTap,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: AppColors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18),
                      ),
                    ),
                    child: const Text('Ver detalle'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _meta(IconData icon, String text) {
    return Row(
      children: <Widget>[
        Icon(icon, size: 16, color: AppColors.textSecondary),
        const SizedBox(width: 6),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(color: AppColors.textSecondary),
          ),
        ),
      ],
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 24),
      child: Center(
        child: Text(
          message,
          textAlign: TextAlign.center,
          style: const TextStyle(color: AppColors.textSecondary),
        ),
      ),
    );
  }
}

class _NotFound extends StatelessWidget {
  const _NotFound({required this.onBack});

  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        _TopBar(title: 'Comunidad', onBack: onBack),
        const Expanded(
          child: Center(
            child: Text(
              'Comunidad no encontrada',
              style: TextStyle(color: AppColors.textSecondary),
            ),
          ),
        ),
      ],
    );
  }
}
