import 'package:eventosloop/core/navigation/detail_navigation.dart';
import 'package:eventosloop/core/theme/app_colors.dart';
import 'package:eventosloop/core/widgets/content_options_sheet.dart';
import 'package:eventosloop/core/widgets/loop_event_map.dart';
import 'package:eventosloop/core/widgets/loop_user_avatar.dart';
import 'package:eventosloop/features/create/views/edit_event_view.dart';
import 'package:eventosloop/features/events/models/event_model.dart';
import 'package:eventosloop/features/events/models/event_status.dart';
import 'package:eventosloop/features/events/services/event_mock_service.dart';
import 'package:eventosloop/features/report/models/report_content_model.dart';
import 'package:eventosloop/features/report/views/report_content_view.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class EventDetailView extends StatefulWidget {
  const EventDetailView({super.key, required this.eventId});

  final int eventId;

  @override
  State<EventDetailView> createState() => _EventDetailViewState();
}

class _EventDetailViewState extends State<EventDetailView> {
  final EventMockService _service = EventMockService();
  EventModel? _event;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final EventModel? event = await _service.fetchById(widget.eventId);
    if (!mounted) {
      return;
    }
    setState(() {
      _event = event;
      _loading = false;
    });
  }

  Future<void> _openEditEvent(EventModel event) async {
    final bool? updated = await Navigator.of(context).push<bool>(
      MaterialPageRoute<bool>(
        builder: (_) => EditEventView(eventId: event.id),
      ),
    );
    if (updated == true) {
      await _load();
    }
  }

  Future<void> _changeStatus(EventStatus status) async {
    if (_event == null) {
      return;
    }
    await _service.updateEventStatus(eventId: _event!.id, status: status);
    if (!mounted) {
      return;
    }
    await _load();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Estado actualizado a ${status.label}')),
    );
  }

  void _openOptions(EventModel event) {
    final List<ContentOptionItem> options = <ContentOptionItem>[
      if (event.isHostedByMe)
        ContentOptionItem(
          icon: Icons.edit_outlined,
          label: 'Editar evento',
          subtitle: 'Actualiza fecha, lugar, cupo o descripcion.',
          onTap: () => _openEditEvent(event),
        ),
      ContentOptionItem(
        icon: Icons.flag_outlined,
        label: 'Reportar evento',
          subtitle: 'Informa contenido engañoso, inapropiado o peligroso.',
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute<void>(
              builder: (_) => ReportContentView(
                contentType: ReportContentType.event,
                contentId: event.id,
                contentTitle: event.title,
              ),
            ),
          );
        },
      ),
    ];

    showContentOptionsSheet(
      context,
      title: 'Opciones del evento',
      options: options,
    );
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
              : _event == null
                  ? _NotFound(onBack: () => Navigator.pop(context))
                  : Column(
                      children: <Widget>[
                        _TopBar(
                          onBack: () => Navigator.pop(context),
                          onOptions: () => _openOptions(_event!),
                        ),
                        Expanded(
                          child: ListView(
                            padding: const EdgeInsets.fromLTRB(18, 8, 18, 18),
                            children: <Widget>[
                              _EventHeaderCard(event: _event!),
                              if (_event!.isSuspended && !_event!.isHostedByMe) ...<Widget>[
                                const SizedBox(height: 14),
                                const _StatusNotice(
                                  message:
                                      'Este evento esta suspendido temporalmente. La inscripcion no esta disponible.',
                                  color: AppColors.error,
                                ),
                              ],
                              if (_event!.isDeleted) ...<Widget>[
                                const SizedBox(height: 14),
                                _StatusNotice(
                                  message: _event!.isHostedByMe
                                      ? 'Marcaste este evento como eliminado. Solo tu puedes verlo y reactivarlo.'
                                      : 'Este evento ya no esta disponible.',
                                  color: AppColors.textSecondary,
                                ),
                              ],
                              if (_event!.isHostedByMe) ...<Widget>[
                                const SizedBox(height: 14),
                                _CreatorManagementCard(
                                  event: _event!,
                                  onEdit: () => _openEditEvent(_event!),
                                  onManageRequests: _event!.isPrivate
                                      ? () => openParticipantRequests(
                                            context,
                                            eventId: _event!.id,
                                            eventTitle: _event!.title,
                                          )
                                      : null,
                                  onStatusChanged: _changeStatus,
                                ),
                              ],
                              const SizedBox(height: 14),
                              _CapacityCard(event: _event!),
                              const SizedBox(height: 14),
                              _SectionCard(
                                title: 'Localizacion',
                                child: LoopEventMap(
                                  latitude: _event!.latitude,
                                  longitude: _event!.longitude,
                                  locationName: _event!.locationName,
                                  address: '${_event!.address}, ${_event!.comuna}',
                                ),
                              ),
                              if (_event!.whatsappLink != null) ...<Widget>[
                                const SizedBox(height: 14),
                                _WhatsAppSection(link: _event!.whatsappLink!),
                              ],
                            ],
                          ),
                        ),
                        _BottomAction(event: _event!),
                      ],
                    ),
        ),
      ),
    );
  }
}

class _TopBar extends StatelessWidget {
  const _TopBar({required this.onBack, required this.onOptions});

  final VoidCallback onBack;
  final VoidCallback onOptions;

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
          const Expanded(
            child: Text(
              'Detalle de evento',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppColors.primaryDark,
                fontSize: 17,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
          IconButton(
            onPressed: onOptions,
            icon: const Icon(Icons.more_vert),
            color: AppColors.primaryDark,
          ),
        ],
      ),
    );
  }
}

class _EventHeaderCard extends StatelessWidget {
  const _EventHeaderCard({required this.event});

  final EventModel event;

  Color _parseHex(String value) {
    final String clean = value.replaceFirst('#', '');
    return Color(int.parse('FF$clean', radix: 16));
  }

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
            height: 190,
            color: _parseHex(event.coverColorHex),
            child: Stack(
              children: <Widget>[
                Center(
                  child: Icon(
                    Icons.confirmation_number_outlined,
                    size: 64,
                    color: AppColors.white.withValues(alpha: 0.9),
                  ),
                ),
                if (event.isFlash)
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
                      child: const Text(
                        'EVENTO FLASH',
                        style: TextStyle(
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
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    LoopUserAvatar(
                      avatarUrl: event.hostAvatarUrl,
                      initials: event.hostName.isNotEmpty
                          ? event.hostName.substring(0, 1).toUpperCase()
                          : '?',
                      radius: 16,
                      fontSize: 12,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Organizado por ${event.hostName}',
                        style: const TextStyle(
                          color: AppColors.textSecondary,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  event.title,
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 22,
                    fontWeight: FontWeight.w900,
                    height: 1.2,
                  ),
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: <Widget>[
                    _Chip(label: event.category),
                    if (event.subCategory != null)
                      _Chip(label: event.subCategory!),
                    _StatusChip(status: event.status),
                    if (event.isPrivate) const _Chip(label: 'Privado'),
                  ],
                ),
                const SizedBox(height: 14),
                _DetailRow(
                  icon: Icons.calendar_month_outlined,
                  label: 'FECHA',
                  value: event.dateLabel,
                ),
                const SizedBox(height: 8),
                _DetailRow(
                  icon: Icons.access_time,
                  label: 'HORA',
                  value: event.timeLabel,
                ),
                const SizedBox(height: 8),
                _DetailRow(
                  icon: Icons.location_on_outlined,
                  label: 'DIRECCION',
                  value: '${event.address}, ${event.comuna}',
                ),
                const SizedBox(height: 12),
                Text(
                  event.description,
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    height: 1.4,
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

class _SectionCard extends StatelessWidget {
  const _SectionCard({
    required this.child,
    this.title,
  });

  final Widget child;
  final String? title;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
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
          if (title != null) ...<Widget>[
            Text(
              title!,
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontSize: 16,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: 12),
          ],
          child,
        ],
      ),
    );
  }
}

class _CapacityCard extends StatelessWidget {
  const _CapacityCard({required this.event});

  final EventModel event;

  @override
  Widget build(BuildContext context) {
    return _SectionCard(
      title: 'Participantes',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              const Expanded(
                child: Text(
                  'Inscritos',
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              Text(
                '${event.joinedCount} / ${event.capacity}',
                style: const TextStyle(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: event.capacityProgress,
              minHeight: 8,
              backgroundColor: AppColors.divider.withValues(alpha: 0.35),
              color: AppColors.primary,
            ),
          ),
        ],
      ),
    );
  }
}

class _WhatsAppSection extends StatelessWidget {
  const _WhatsAppSection({required this.link});

  final String link;

  Future<void> _openWhatsApp() async {
    final Uri uri = Uri.parse(link);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    return _SectionCard(
      title: 'Grupo de WhatsApp',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const Text(
            'La coordinacion del evento se realiza por WhatsApp. Al participar podras acceder al grupo.',
            style: TextStyle(
              color: AppColors.textSecondary,
              height: 1.35,
            ),
          ),
          const SizedBox(height: 12),
          OutlinedButton.icon(
            onPressed: _openWhatsApp,
            icon: const Icon(Icons.open_in_new, size: 18),
            label: const Text('Abrir grupo de WhatsApp'),
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.primary,
              side: const BorderSide(color: AppColors.divider),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _StatusChip extends StatelessWidget {
  const _StatusChip({required this.status});

  final EventStatus status;

  @override
  Widget build(BuildContext context) {
    final Color color = switch (status) {
      EventStatus.active => const Color(0xFF2E9E6A),
      EventStatus.suspended => const Color(0xFFE08A3A),
      EventStatus.deleted => AppColors.error,
    };
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        status.label,
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.w800,
          fontSize: 12,
        ),
      ),
    );
  }
}

class _StatusNotice extends StatelessWidget {
  const _StatusNotice({
    required this.message,
    required this.color,
  });

  final String message;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: color.withValues(alpha: 0.25)),
      ),
      child: Text(
        message,
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.w700,
          height: 1.35,
        ),
      ),
    );
  }
}

class _CreatorManagementCard extends StatelessWidget {
  const _CreatorManagementCard({
    required this.event,
    required this.onEdit,
    required this.onStatusChanged,
    this.onManageRequests,
  });

  final EventModel event;
  final VoidCallback onEdit;
  final ValueChanged<EventStatus> onStatusChanged;
  final VoidCallback? onManageRequests;

  @override
  Widget build(BuildContext context) {
    return _SectionCard(
      title: 'Gestion del evento',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          const Text(
            'Eres el creador de este evento. Puedes editarlo, cambiar su estado o revisar solicitudes.',
            style: TextStyle(
              color: AppColors.textSecondary,
              height: 1.35,
            ),
          ),
          const SizedBox(height: 14),
          const Text(
            'Estado del evento',
            style: TextStyle(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: EventStatus.values.map((EventStatus status) {
              final bool selected = event.status == status;
              return ChoiceChip(
                label: Text(status.label),
                selected: selected,
                onSelected: (_) => onStatusChanged(status),
                selectedColor: AppColors.primary.withValues(alpha: 0.16),
                labelStyle: TextStyle(
                  color: selected ? AppColors.primaryDark : AppColors.textSecondary,
                  fontWeight: FontWeight.w800,
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 14),
          OutlinedButton.icon(
            onPressed: onEdit,
            icon: const Icon(Icons.edit_outlined, size: 18),
            label: const Text('Editar evento'),
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.primary,
              side: const BorderSide(color: AppColors.divider),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
              ),
            ),
          ),
          if (onManageRequests != null) ...<Widget>[
            const SizedBox(height: 10),
            ElevatedButton.icon(
              onPressed: onManageRequests,
              icon: const Icon(Icons.group_add_outlined, size: 18),
              label: const Text('Gestionar solicitudes'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: AppColors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  const _DetailRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Icon(icon, size: 18, color: AppColors.textSecondary),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                label,
                style: const TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 10,
                  fontWeight: FontWeight.w900,
                ),
              ),
              Text(
                value,
                style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _Chip extends StatelessWidget {
  const _Chip({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: AppColors.primary,
          fontWeight: FontWeight.w800,
          fontSize: 12,
        ),
      ),
    );
  }
}

class _BottomAction extends StatelessWidget {
  const _BottomAction({required this.event});

  final EventModel event;

  @override
  Widget build(BuildContext context) {
    if (event.isHostedByMe) {
      return Padding(
        padding: const EdgeInsets.fromLTRB(18, 0, 18, 12),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: AppColors.divider),
          ),
          child: const Text(
            'Estas viendo tu propio evento como creador.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      );
    }

    final bool canJoin = event.isJoinableByParticipants;
    return Padding(
      padding: const EdgeInsets.fromLTRB(18, 0, 18, 12),
      child: SizedBox(
        width: double.infinity,
        child: DecoratedBox(
          decoration: BoxDecoration(
            gradient: canJoin
                ? const LinearGradient(
                    colors: <Color>[AppColors.primaryDark, AppColors.primary],
                  )
                : null,
            color: canJoin ? null : AppColors.divider.withValues(alpha: 0.45),
            borderRadius: BorderRadius.circular(22),
          ),
          child: ElevatedButton(
            onPressed: canJoin ? () {} : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.transparent,
              shadowColor: Colors.transparent,
              disabledBackgroundColor: Colors.transparent,
              foregroundColor: AppColors.white,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(22),
              ),
            ),
            child: Text(
              canJoin
                  ? (event.isPrivate
                      ? 'Solicitar participacion'
                      : 'Participar')
                  : 'Inscripcion no disponible',
              style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 16),
            ),
          ),
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
        _TopBar(onBack: onBack, onOptions: () {}),
        const Expanded(
          child: Center(
            child: Text(
              'Evento no encontrado',
              style: TextStyle(color: AppColors.textSecondary),
            ),
          ),
        ),
      ],
    );
  }
}
