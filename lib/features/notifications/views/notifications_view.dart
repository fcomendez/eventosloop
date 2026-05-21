import 'package:eventosloop/core/navigation/detail_navigation.dart';
import 'package:eventosloop/core/theme/app_colors.dart';
import 'package:eventosloop/features/notifications/models/notification_model.dart';
import 'package:eventosloop/features/notifications/services/notification_mock_service.dart';
import 'package:flutter/material.dart';

enum NotificationFilter { all, eventos, comunidades, menciones }

class NotificationsView extends StatefulWidget {
  const NotificationsView({super.key});

  @override
  State<NotificationsView> createState() => _NotificationsViewState();
}

class _NotificationsViewState extends State<NotificationsView> {
  final NotificationMockService _service = NotificationMockService();
  NotificationFilter _filter = NotificationFilter.all;
  List<NotificationModel> _items = <NotificationModel>[];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final List<NotificationModel> items = await _service.fetchAll();
    if (!mounted) {
      return;
    }
    setState(() {
      _items = items;
      _loading = false;
    });
  }

  List<NotificationModel> get _filtered {
    return _items.where((NotificationModel item) {
      return switch (_filter) {
        NotificationFilter.all => true,
        NotificationFilter.eventos =>
          item.type == NotificationType.evento ||
              item.type == NotificationType.recordatorio ||
              item.type == NotificationType.solicitud,
        NotificationFilter.comunidades =>
          item.type == NotificationType.comunidad,
        NotificationFilter.menciones =>
          item.type == NotificationType.mencion ||
              item.type == NotificationType.comentario,
      };
    }).toList();
  }

  int get _unreadToday => _items
      .where((NotificationModel n) => n.groupLabel == 'Hoy' && n.isUnread)
      .length;

  void _openNotification(NotificationModel item) {
    if (item.type == NotificationType.solicitud && item.eventId != null) {
      openParticipantRequests(
        context,
        eventId: item.eventId!,
        eventTitle: item.body,
      );
      return;
    }
    if (item.postId != null) {
      openPostDetail(context, item.postId!);
      return;
    }
    if (item.eventId != null) {
      openEventDetail(context, item.eventId!);
      return;
    }
    if (item.communityId != null) {
      openCommunityDetail(context, item.communityId!);
      return;
    }
    if (item.userId != null) {
      openUserProfile(context, item.userId!);
    }
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
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    _TopBar(onBack: () => Navigator.pop(context)),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(18, 8, 18, 0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          const Text(
                            'Notificaciones',
                            style: TextStyle(
                              color: AppColors.textPrimary,
                              fontSize: 28,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Tienes $_unreadToday actualizaciones sin leer hoy',
                            style: const TextStyle(
                              color: AppColors.textSecondary,
                            ),
                          ),
                          const SizedBox(height: 14),
                          _FilterRow(
                            selected: _filter,
                            onChanged: (NotificationFilter value) {
                              setState(() {
                                _filter = value;
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: ListView(
                        padding: const EdgeInsets.fromLTRB(18, 16, 18, 18),
                        children: _buildGroupedList(),
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }

  List<Widget> _buildGroupedList() {
    final List<Widget> widgets = <Widget>[];
    String? currentGroup;
    for (final NotificationModel item in _filtered) {
      if (item.groupLabel != currentGroup) {
        currentGroup = item.groupLabel;
        widgets.add(
          Padding(
            padding: const EdgeInsets.only(bottom: 10, top: 4),
            child: Text(
              currentGroup.toUpperCase(),
              style: const TextStyle(
                color: AppColors.textSecondary,
                fontWeight: FontWeight.w900,
                fontSize: 12,
              ),
            ),
          ),
        );
      }
      widgets.add(
        _NotificationTile(
          item: item,
          onTap: () => _openNotification(item),
        ),
      );
      widgets.add(const SizedBox(height: 10));
    }
    widgets.add(
      OutlinedButton(
        onPressed: () {},
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.primary,
          side: const BorderSide(color: AppColors.divider),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          padding: const EdgeInsets.symmetric(vertical: 14),
        ),
        child: const Text(
          'Ver notificaciones anteriores',
          style: TextStyle(fontWeight: FontWeight.w900),
        ),
      ),
    );
    return widgets;
  }
}

class _TopBar extends StatelessWidget {
  const _TopBar({required this.onBack});

  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 8, 16, 0),
      child: Row(
        children: <Widget>[
          IconButton(
            onPressed: onBack,
            icon: const Icon(Icons.arrow_back),
            color: AppColors.primaryDark,
          ),
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
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.search),
            color: AppColors.primaryDark,
          ),
        ],
      ),
    );
  }
}

class _FilterRow extends StatelessWidget {
  const _FilterRow({
    required this.selected,
    required this.onChanged,
  });

  final NotificationFilter selected;
  final ValueChanged<NotificationFilter> onChanged;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: <Widget>[
          _chip('Todas', NotificationFilter.all),
          const SizedBox(width: 8),
          _chip('Eventos', NotificationFilter.eventos),
          const SizedBox(width: 8),
          _chip('Comunidades', NotificationFilter.comunidades),
          const SizedBox(width: 8),
          _chip('Menciones', NotificationFilter.menciones),
        ],
      ),
    );
  }

  Widget _chip(String label, NotificationFilter value) {
    final bool active = selected == value;
    return InkWell(
      onTap: () => onChanged(value),
      borderRadius: BorderRadius.circular(18),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 9),
        decoration: BoxDecoration(
          color: active ? AppColors.primaryDark : AppColors.white,
          borderRadius: BorderRadius.circular(18),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: active ? AppColors.white : AppColors.textSecondary,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
    );
  }
}

class _NotificationTile extends StatelessWidget {
  const _NotificationTile({
    required this.item,
    required this.onTap,
  });

  final NotificationModel item;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: AppColors.primaryDark.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Stack(
              clipBehavior: Clip.none,
              children: <Widget>[
                CircleAvatar(
                  radius: 22,
                  backgroundColor: AppColors.primary.withValues(alpha: 0.16),
                  child: Text(
                    item.authorInitials,
                    style: const TextStyle(
                      color: AppColors.primaryDark,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
                Positioned(
                  right: -2,
                  bottom: -2,
                  child: Container(
                    width: 20,
                    height: 20,
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      shape: BoxShape.circle,
                      border: Border.all(color: AppColors.white, width: 2),
                    ),
                    child: Icon(
                      _iconFor(item.type),
                      size: 11,
                      color: AppColors.white,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  RichText(
                    text: TextSpan(
                      style: const TextStyle(
                        color: AppColors.textPrimary,
                        height: 1.35,
                      ),
                      children: <TextSpan>[
                        TextSpan(
                          text: item.title,
                          style: const TextStyle(fontWeight: FontWeight.w800),
                        ),
                        if (item.body.isNotEmpty)
                          TextSpan(text: ': ${item.body}'),
                      ],
                    ),
                  ),
                  if (item.quote != null) ...<Widget>[
                    const SizedBox(height: 8),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: AppColors.cardBackground,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        '"${item.quote!}"',
                        style: const TextStyle(
                          color: AppColors.textSecondary,
                          fontStyle: FontStyle.italic,
                          height: 1.3,
                        ),
                      ),
                    ),
                  ],
                  const SizedBox(height: 6),
                  Text(
                    item.timeLabel,
                    style: const TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            if (item.isUnread)
              Container(
                width: 8,
                height: 8,
                margin: const EdgeInsets.only(top: 6),
                decoration: const BoxDecoration(
                  color: AppColors.primary,
                  shape: BoxShape.circle,
                ),
              ),
          ],
        ),
      ),
    );
  }

  IconData _iconFor(NotificationType type) {
    return switch (type) {
      NotificationType.evento => Icons.event,
      NotificationType.comunidad => Icons.campaign_outlined,
      NotificationType.mencion => Icons.alternate_email,
      NotificationType.recordatorio => Icons.notifications_active,
      NotificationType.comentario => Icons.mode_comment_outlined,
      NotificationType.solicitud => Icons.how_to_reg_outlined,
    };
  }
}
