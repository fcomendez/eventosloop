import 'package:eventosloop/core/theme/app_colors.dart';
import 'package:eventosloop/core/widgets/loop_event_map.dart';
import 'package:eventosloop/features/events/models/event_model.dart';
import 'package:eventosloop/features/events/services/event_mock_service.dart';
import 'package:flutter/material.dart';

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
              : _event == null
                  ? _NotFound(onBack: () => Navigator.pop(context))
                  : Column(
                      children: <Widget>[
                        _TopBar(onBack: () => Navigator.pop(context)),
                        Expanded(
                          child: ListView(
                            padding: const EdgeInsets.fromLTRB(18, 8, 18, 18),
                            children: <Widget>[
                              _HeroImage(
                                color: _parseHex(_event!.coverColorHex),
                                isFlash: _event!.isFlash,
                              ),
                              const SizedBox(height: 14),
                              _InfoCard(event: _event!),
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
                              const SizedBox(height: 14),
                              _ChatSection(eventTitle: _event!.title),
                            ],
                          ),
                        ),
                        _BottomAction(
                          onTap: () {},
                        ),
                      ],
                    ),
        ),
      ),
    );
  }
}

class _TopBar extends StatelessWidget {
  const _TopBar({required this.onBack});

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
            onPressed: () {},
            icon: const Icon(Icons.share_outlined),
            color: AppColors.primaryDark,
          ),
        ],
      ),
    );
  }
}

class _HeroImage extends StatelessWidget {
  const _HeroImage({required this.color, required this.isFlash});

  final Color color;
  final bool isFlash;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 190,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Stack(
        children: <Widget>[
          Center(
            child: Icon(
              Icons.confirmation_number_outlined,
              size: 64,
              color: AppColors.white.withValues(alpha: 0.9),
            ),
          ),
          if (isFlash)
            Positioned(
              left: 12,
              top: 12,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
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
    );
  }
}

class _InfoCard extends StatelessWidget {
  const _InfoCard({required this.event});

  final EventModel event;

  @override
  Widget build(BuildContext context) {
    return _SectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              CircleAvatar(
                radius: 16,
                backgroundColor: AppColors.primary.withValues(alpha: 0.16),
                child: Text(
                  event.hostName.substring(0, 1),
                  style: const TextStyle(
                    color: AppColors.primaryDark,
                    fontWeight: FontWeight.w900,
                    fontSize: 12,
                  ),
                ),
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
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: <Widget>[
              _Chip(label: event.category),
              if (event.subCategory != null) _Chip(label: event.subCategory!),
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

class _ChatSection extends StatelessWidget {
  const _ChatSection({required this.eventTitle});

  final String eventTitle;

  @override
  Widget build(BuildContext context) {
    return _SectionCard(
      title: 'Chat grupal',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              const Icon(Icons.chat_bubble_outline, color: AppColors.primary),
              const SizedBox(width: 8),
              const Expanded(
                child: Text(
                  'Acceso privado',
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.error.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text(
                  'PRIVADO',
                  style: TextStyle(
                    color: AppColors.error,
                    fontSize: 10,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.cardBackground,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Text(
              'Hay mensajes nuevos en el chat de $eventTitle. El acceso se valida al unirte al evento.',
              style: const TextStyle(
                color: AppColors.textSecondary,
                height: 1.35,
              ),
            ),
          ),
          const SizedBox(height: 10),
          OutlinedButton(
            onPressed: () {},
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.primary,
              side: const BorderSide(color: AppColors.divider),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
              ),
            ),
            child: const Text('Solicitar acceso al chat'),
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
  const _BottomAction({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(18, 0, 18, 12),
      child: SizedBox(
        width: double.infinity,
        child: DecoratedBox(
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: <Color>[AppColors.primaryDark, AppColors.primary],
            ),
            borderRadius: BorderRadius.circular(22),
          ),
          child: ElevatedButton(
            onPressed: onTap,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.transparent,
              shadowColor: Colors.transparent,
              foregroundColor: AppColors.white,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(22),
              ),
            ),
            child: const Text(
              'Participar',
              style: TextStyle(fontWeight: FontWeight.w900, fontSize: 16),
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
        _TopBar(onBack: onBack),
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
