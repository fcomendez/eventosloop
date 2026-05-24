import 'package:eventosloop/core/navigation/detail_navigation.dart';
import 'package:eventosloop/core/theme/app_colors.dart';
import 'package:eventosloop/features/events/services/participant_request_service.dart';
import 'package:eventosloop/features/events/services/participant_request_supabase_service.dart';
import 'package:flutter/material.dart';

class PendingRequestsBanner extends StatefulWidget {
  const PendingRequestsBanner({super.key});

  @override
  State<PendingRequestsBanner> createState() => _PendingRequestsBannerState();
}

class _PendingRequestsBannerState extends State<PendingRequestsBanner> {
  final ParticipantRequestService _service = ParticipantRequestService();
  ParticipantRequestSummary? _summary;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final ParticipantRequestSummary summary =
        await _service.fetchPendingSummary();
    if (mounted) {
      setState(() => _summary = summary);
    }
  }

  @override
  Widget build(BuildContext context) {
    final int pending = _summary?.totalPending ?? 0;
    if (pending <= 0 || _summary?.firstEventId == null) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.fromLTRB(18, 0, 18, 12),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => openParticipantRequests(
            context,
            eventId: _summary!.firstEventId!,
            eventTitle: _summary!.firstEventTitle ?? 'Evento',
          ),
          borderRadius: BorderRadius.circular(16),
          child: Ink(
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: <Color>[AppColors.primaryDark, AppColors.primary],
              ),
              borderRadius: BorderRadius.circular(16),
              boxShadow: <BoxShadow>[
                BoxShadow(
                  color: AppColors.primaryDark.withValues(alpha: 0.18),
                  blurRadius: 12,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Row(
                children: <Widget>[
                  Container(
                    width: 42,
                    height: 42,
                    decoration: BoxDecoration(
                      color: AppColors.white.withValues(alpha: 0.18),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.how_to_reg_outlined,
                      color: AppColors.white,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          '$pending solicitudes pendientes',
                          style: const TextStyle(
                            color: AppColors.white,
                            fontWeight: FontWeight.w900,
                            fontSize: 15,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          _summary!.firstEventTitle ?? 'Revisar solicitudes',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: AppColors.white.withValues(alpha: 0.88),
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Icon(
                    Icons.chevron_right,
                    color: AppColors.white,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
