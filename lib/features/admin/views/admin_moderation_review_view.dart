import 'package:eventosloop/core/theme/app_colors.dart';
import 'package:eventosloop/features/admin/models/admin_community_models.dart';
import 'package:eventosloop/features/admin/models/admin_models.dart';
import 'package:eventosloop/features/admin/navigation/admin_navigation.dart';
import 'package:eventosloop/features/admin/services/admin_supabase_service.dart';
import 'package:eventosloop/features/admin/widgets/admin_shell.dart';
import 'package:flutter/material.dart';

class AdminModerationReviewView extends StatefulWidget {
  const AdminModerationReviewView({super.key, this.reportId});

  final String? reportId;

  @override
  State<AdminModerationReviewView> createState() =>
      _AdminModerationReviewViewState();
}

class _AdminModerationReviewViewState extends State<AdminModerationReviewView> {
  final AdminSupabaseService _service = AdminSupabaseService();
  AdminModerationAction? _selectedAction;
  final TextEditingController _noteController = TextEditingController();
  AdminModerationIncident? _incident;
  bool _loading = true;
  bool _processing = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    if (widget.reportId == null) {
      setState(() => _loading = false);
      return;
    }
    try {
      final AdminModerationIncident? incident =
          await _service.fetchModerationIncident(widget.reportId!);
      if (mounted) {
        setState(() {
          _incident = incident;
          _loading = false;
        });
      }
    } catch (_) {
      if (mounted) {
        setState(() => _loading = false);
      }
    }
  }

  Future<void> _confirmAction() async {
    if (_selectedAction == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Selecciona una accion de moderacion')),
      );
      return;
    }
    if (_incident == null || widget.reportId == null) {
      return;
    }
    setState(() => _processing = true);
    try {
      await _service.resolveReport(
        reportId: widget.reportId!,
        action: _selectedAction!,
        note: _noteController.text.trim(),
      );
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Accion registrada correctamente')),
        );
        Navigator.of(context).pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
        setState(() => _processing = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return AdminShell(
        selectedTopTab: AdminTopTab.dashboard,
        selectedSidebar: AdminSidebarItem.moderation,
        onSidebarChanged: (AdminSidebarItem item) =>
            handleAdminSidebarNavigation(context, item, replace: true),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    final AdminModerationIncident? incident = _incident;
    if (incident == null) {
      return AdminShell(
        selectedTopTab: AdminTopTab.dashboard,
        selectedSidebar: AdminSidebarItem.moderation,
        onSidebarChanged: (AdminSidebarItem item) =>
            handleAdminSidebarNavigation(context, item, replace: true),
        body: const Center(child: Text('Reporte no encontrado.')),
      );
    }

    return AdminShell(
      selectedTopTab: AdminTopTab.dashboard,
      selectedSidebar: AdminSidebarItem.moderation,
      onSidebarChanged: (AdminSidebarItem item) =>
          handleAdminSidebarNavigation(context, item, replace: true),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            'Reporte #${incident.reportId}',
            style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w900),
          ),
          const SizedBox(height: 18),
          LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
              final bool wide = constraints.maxWidth >= 900;
              final Widget left = Column(
                children: <Widget>[
                  _ReportedContentCard(incident: incident),
                  const SizedBox(height: 12),
                  _InfoCard(
                    title: 'Estadisticas de cuenta',
                    rows: <(String, String)>[
                      ('Registro', incident.joinedLabel),
                      ('Estado', incident.statusLabel),
                      ('Seguidores', incident.followersLabel),
                      ('Reportes pendientes', incident.pendingReportsLabel),
                    ],
                  ),
                  if (incident.previousActions.isNotEmpty) ...<Widget>[
                    const SizedBox(height: 12),
                    _InfoCard(
                      title: 'Acciones previas (adm_log)',
                      bullets: incident.previousActions,
                    ),
                  ],
                ],
              );
              final Widget right = Column(
                children: <Widget>[
                  _ReportingDetailsCard(incident: incident),
                  const SizedBox(height: 12),
                  _ActionSelectionCard(
                    selected: _selectedAction,
                    onSelected: (AdminModerationAction action) {
                      setState(() => _selectedAction = action);
                    },
                  ),
                  const SizedBox(height: 12),
                  AdminSectionCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        const Text('Nota de resolucion (interna)',
                            style: TextStyle(fontWeight: FontWeight.w900)),
                        const SizedBox(height: 10),
                        TextField(
                          controller: _noteController,
                          maxLines: 4,
                          decoration: const InputDecoration(
                            hintText: 'Describe el motivo de tu decision...',
                          ),
                        ),
                        const SizedBox(height: 12),
                        SizedBox(
                          width: double.infinity,
                          height: 46,
                          child: ElevatedButton.icon(
                            onPressed: _processing ? null : _confirmAction,
                            icon: _processing
                                ? const SizedBox(
                                    width: 18,
                                    height: 18,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: AppColors.white,
                                    ),
                                  )
                                : const Icon(Icons.check_circle_outline),
                            label: const Text('Confirmar accion'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary,
                              foregroundColor: AppColors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              );
              if (!wide) {
                return Column(
                  children: <Widget>[left, const SizedBox(height: 12), right],
                );
              }
              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Expanded(flex: 3, child: left),
                  const SizedBox(width: 16),
                  Expanded(flex: 2, child: right),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}

class _ReportedContentCard extends StatelessWidget {
  const _ReportedContentCard({required this.incident});

  final AdminModerationIncident incident;

  @override
  Widget build(BuildContext context) {
    final String typeLabel = incident.contentType == AdminReportContentType.post
        ? 'Publicacion'
        : 'Evento';
    return AdminSectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(incident.authorName,
                        style: const TextStyle(fontWeight: FontWeight.w900)),
                    Text('${incident.authorHandle} · $typeLabel · ${incident.postedLabel}',
                        style: const TextStyle(
                            fontSize: 12, color: AppColors.textSecondary)),
                  ],
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.error.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(incident.riskLabel,
                    style: const TextStyle(
                        color: AppColors.error,
                        fontWeight: FontWeight.w900,
                        fontSize: 10)),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Text(incident.content, style: const TextStyle(height: 1.45)),
          if (incident.mediaUrl != null && incident.mediaUrl!.isNotEmpty) ...<Widget>[
            const SizedBox(height: 14),
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                incident.mediaUrl!,
                height: 160,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  height: 80,
                  color: AppColors.inputBackground,
                  alignment: Alignment.center,
                  child: const Text('Imagen no disponible'),
                ),
              ),
            ),
          ],
          const SizedBox(height: 12),
          Row(
            children: <Widget>[
              _StatChip(Icons.favorite_border, incident.likesLabel),
              const SizedBox(width: 12),
              _StatChip(Icons.mode_comment_outlined, incident.commentsLabel),
            ],
          ),
        ],
      ),
    );
  }
}

class _StatChip extends StatelessWidget {
  const _StatChip(this.icon, this.label);
  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Icon(icon, size: 16, color: AppColors.textSecondary),
        const SizedBox(width: 4),
        Text(label,
            style: const TextStyle(
                color: AppColors.textSecondary, fontWeight: FontWeight.w700)),
      ],
    );
  }
}

class _InfoCard extends StatelessWidget {
  const _InfoCard({
    required this.title,
    this.rows = const <(String, String)>[],
    this.bullets = const <String>[],
  });

  final String title;
  final List<(String, String)> rows;
  final List<String> bullets;

  @override
  Widget build(BuildContext context) {
    return AdminSectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(title, style: const TextStyle(fontWeight: FontWeight.w900)),
          const SizedBox(height: 10),
          ...rows.map(
            ((String, String) row) => Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: Text('${row.$1}: ${row.$2}',
                  style: const TextStyle(fontWeight: FontWeight.w600)),
            ),
          ),
          ...bullets.map(
            (String item) => Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: Text('• $item'),
            ),
          ),
        ],
      ),
    );
  }
}

class _ReportingDetailsCard extends StatelessWidget {
  const _ReportingDetailsCard({required this.incident});
  final AdminModerationIncident incident;

  @override
  Widget build(BuildContext context) {
    return AdminSectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const Text('Detalles del reporte',
              style: TextStyle(fontWeight: FontWeight.w900)),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            children: incident.reasonTags
                .map((String tag) => Chip(label: Text(tag)))
                .toList(),
          ),
          const SizedBox(height: 8),
          Text(incident.reportVolumeLabel,
              style: const TextStyle(fontWeight: FontWeight.w800)),
          if (incident.reporterComments.isNotEmpty) ...<Widget>[
            const SizedBox(height: 12),
            const Text('Comentarios del reportante',
                style: TextStyle(fontWeight: FontWeight.w800)),
            ...incident.reporterComments.map(
              (String c) => Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(c),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _ActionSelectionCard extends StatelessWidget {
  const _ActionSelectionCard({
    required this.selected,
    required this.onSelected,
  });

  final AdminModerationAction? selected;
  final ValueChanged<AdminModerationAction> onSelected;

  @override
  Widget build(BuildContext context) {
    return AdminSectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const Text('Seleccionar accion',
              style: TextStyle(fontWeight: FontWeight.w900)),
          const SizedBox(height: 10),
          _ActionTile(
            title: 'Advertir usuario',
            subtitle: 'Notificacion + marcar reporte resuelto',
            selected: selected == AdminModerationAction.warnUser,
            onTap: () => onSelected(AdminModerationAction.warnUser),
          ),
          _ActionTile(
            title: 'Eliminar contenido',
            subtitle: 'Elimina post o cancela evento',
            selected: selected == AdminModerationAction.deleteContent,
            onTap: () => onSelected(AdminModerationAction.deleteContent),
          ),
          _ActionTile(
            title: 'Suspender usuario',
            subtitle: 'Estado SUSPENDIDO en la cuenta',
            danger: true,
            selected: selected == AdminModerationAction.permanentBan,
            onTap: () => onSelected(AdminModerationAction.permanentBan),
          ),
        ],
      ),
    );
  }
}

class _ActionTile extends StatelessWidget {
  const _ActionTile({
    required this.title,
    required this.subtitle,
    required this.selected,
    required this.onTap,
    this.danger = false,
  });

  final String title;
  final String subtitle;
  final bool selected;
  final VoidCallback onTap;
  final bool danger;

  @override
  Widget build(BuildContext context) {
    final Color accent = danger ? AppColors.error : AppColors.primary;
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Material(
        color: selected ? accent.withValues(alpha: 0.08) : AppColors.inputBackground,
        borderRadius: BorderRadius.circular(10),
        child: InkWell(
          borderRadius: BorderRadius.circular(10),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: <Widget>[
                Icon(
                  selected ? Icons.radio_button_checked : Icons.radio_button_off,
                  color: accent,
                  size: 18,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(title,
                          style: TextStyle(
                              fontWeight: FontWeight.w900, color: accent)),
                      Text(subtitle,
                          style: const TextStyle(
                              fontSize: 12, color: AppColors.textSecondary)),
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
}
