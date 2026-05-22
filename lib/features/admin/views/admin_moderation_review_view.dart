import 'package:eventosloop/core/theme/app_colors.dart';
import 'package:eventosloop/features/admin/models/admin_models.dart';
import 'package:eventosloop/features/admin/services/admin_mock_service.dart';
import 'package:eventosloop/features/admin/views/admin_analytics_view.dart';
import 'package:eventosloop/features/admin/views/admin_dashboard_view.dart';
import 'package:eventosloop/features/admin/widgets/admin_shell.dart';
import 'package:flutter/material.dart';

class AdminModerationReviewView extends StatefulWidget {
  const AdminModerationReviewView({super.key});

  @override
  State<AdminModerationReviewView> createState() =>
      _AdminModerationReviewViewState();
}

class _AdminModerationReviewViewState extends State<AdminModerationReviewView> {
  final AdminMockService _service = AdminMockService();
  AdminModerationAction? _selectedAction;
  final TextEditingController _noteController = TextEditingController();

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  void _handleSidebar(AdminSidebarItem item) {
    if (item == AdminSidebarItem.contentFeed) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute<void>(builder: (_) => const AdminAnalyticsView()),
      );
      return;
    }
    if (item == AdminSidebarItem.userManagement) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute<void>(builder: (_) => const AdminDashboardView()),
      );
      return;
    }
    if (item == AdminSidebarItem.moderation) {
      return;
    }
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('${item.name} — proximamente')),
    );
  }

  void _confirmAction() {
    if (_selectedAction == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Selecciona una accion de moderacion')),
      );
      return;
    }
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Accion registrada en adm_log (mock)')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final AdminModerationIncident incident = _service.fetchSampleIncident();

    return AdminShell(
      selectedTopTab: AdminTopTab.dashboard,
      selectedSidebar: AdminSidebarItem.moderation,
      onSidebarChanged: _handleSidebar,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Wrap(
            spacing: 6,
            runSpacing: 4,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: <Widget>[
              _BreadcrumbChip('Moderation'),
              const Icon(Icons.chevron_right, size: 16, color: AppColors.textSecondary),
              _BreadcrumbChip('Flagged Content'),
              const Icon(Icons.chevron_right, size: 16, color: AppColors.textSecondary),
              _BreadcrumbChip('Report #${incident.reportId}'),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: <Widget>[
              const Expanded(
                child: Text(
                  'Review Incident',
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 28,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
              OutlinedButton(onPressed: () {}, child: const Text('Skip Case')),
              const SizedBox(width: 8),
              OutlinedButton(onPressed: () {}, child: const Text('Escalate')),
            ],
          ),
          const SizedBox(height: 18),
          LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
              final bool wide = constraints.maxWidth >= 900;
              final Widget leftColumn = Column(
                children: <Widget>[
                  _ReportedPostCard(incident: incident),
                  const SizedBox(height: 12),
                  _InfoCard(
                    title: 'Account Stats',
                    rows: <(String, String)>[
                      ('Joined', incident.joinedLabel),
                      ('Status', incident.statusLabel),
                      ('Followers', incident.followersLabel),
                      ('Reports', incident.pendingReportsLabel),
                    ],
                    highlightLast: true,
                  ),
                  const SizedBox(height: 12),
                  _InfoCard(
                    title: 'Previous Actions',
                    bullets: incident.previousActions,
                  ),
                ],
              );

              final Widget rightColumn = Column(
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
                        const Text(
                          'Resolution Note (Internal)',
                          style: TextStyle(
                            fontWeight: FontWeight.w900,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 10),
                        TextField(
                          controller: _noteController,
                          maxLines: 4,
                          decoration: const InputDecoration(
                            hintText: 'Describe the reason for your decision...',
                          ),
                        ),
                        const SizedBox(height: 12),
                        SizedBox(
                          width: double.infinity,
                          height: 46,
                          child: ElevatedButton.icon(
                            onPressed: _confirmAction,
                            icon: const Icon(Icons.check_circle_outline),
                            label: const Text('Confirm Moderation Action'),
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
                  children: <Widget>[leftColumn, const SizedBox(height: 12), rightColumn],
                );
              }
              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Expanded(flex: 3, child: leftColumn),
                  const SizedBox(width: 16),
                  Expanded(flex: 2, child: rightColumn),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}

class _BreadcrumbChip extends StatelessWidget {
  const _BreadcrumbChip(this.label);

  final String label;

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: const TextStyle(
        color: AppColors.textSecondary,
        fontWeight: FontWeight.w700,
        fontSize: 12,
      ),
    );
  }
}

class _ReportedPostCard extends StatelessWidget {
  const _ReportedPostCard({required this.incident});

  final AdminModerationIncident incident;

  @override
  Widget build(BuildContext context) {
    return AdminSectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              const CircleAvatar(
                radius: 18,
                backgroundColor: AppColors.inputBackground,
                child: Icon(Icons.person, color: AppColors.primary),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      incident.authorName,
                      style: const TextStyle(
                        fontWeight: FontWeight.w900,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    Text(
                      '${incident.authorHandle} · ${incident.postedLabel}',
                      style: const TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.error.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  incident.riskLabel,
                  style: const TextStyle(
                    color: AppColors.error,
                    fontSize: 10,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Text(
            incident.content,
            style: const TextStyle(
              color: AppColors.textPrimary,
              height: 1.45,
            ),
          ),
          const SizedBox(height: 14),
          Container(
            height: 160,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: <Color>[Color(0xFF1B1F3B), Color(0xFF5B3FA0)],
              ),
            ),
            child: Stack(
              alignment: Alignment.bottomCenter,
              children: <Widget>[
                Container(
                  height: 70,
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.25),
                    borderRadius: const BorderRadius.vertical(
                      bottom: Radius.circular(12),
                    ),
                  ),
                ),
                Positioned(
                  top: 40,
                  child: Container(
                    width: 90,
                    height: 90,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: const Color(0xFFB57CFF).withValues(alpha: 0.85),
                      boxShadow: <BoxShadow>[
                        BoxShadow(
                          color: const Color(0xFFB57CFF).withValues(alpha: 0.5),
                          blurRadius: 30,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
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
        Text(
          label,
          style: const TextStyle(
            color: AppColors.textSecondary,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}

class _InfoCard extends StatelessWidget {
  const _InfoCard({
    required this.title,
    this.rows = const <(String, String)>[],
    this.bullets = const <String>[],
    this.highlightLast = false,
  });

  final String title;
  final List<(String, String)> rows;
  final List<String> bullets;
  final bool highlightLast;

  @override
  Widget build(BuildContext context) {
    return AdminSectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.w900,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 10),
          ...rows.asMap().entries.map((MapEntry<int, (String, String)> entry) {
            final int index = entry.key;
            final (String label, String value) = entry.value;
            final bool highlight = highlightLast && index == rows.length - 1;
            return Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: Row(
                children: <Widget>[
                  Text(
                    '$label: ',
                    style: const TextStyle(
                      color: AppColors.textSecondary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Text(
                    value,
                    style: TextStyle(
                      color: highlight ? AppColors.error : AppColors.textPrimary,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
            );
          }),
          ...bullets.map(
            (String item) => Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: Text('• $item', style: const TextStyle(height: 1.35)),
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
          const Text(
            'Reporting Details',
            style: TextStyle(
              fontWeight: FontWeight.w900,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            children: incident.reasonTags
                .map(
                  (String tag) => Chip(
                    label: Text(tag),
                    backgroundColor: AppColors.inputBackground,
                  ),
                )
                .toList(),
          ),
          const SizedBox(height: 8),
          Text(
            incident.reportVolumeLabel,
            style: const TextStyle(
              color: AppColors.error,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 12),
          const Text(
            'Reporter Comments',
            style: TextStyle(fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 8),
          ...incident.reporterComments.map(
            (String comment) => Container(
              width: double.infinity,
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(comment, style: const TextStyle(height: 1.35)),
            ),
          ),
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
          const Text(
            'Select Action',
            style: TextStyle(
              fontWeight: FontWeight.w900,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 10),
          _ActionTile(
            title: 'Warn User',
            subtitle: 'Send warning notification',
            selected: selected == AdminModerationAction.warnUser,
            onTap: () => onSelected(AdminModerationAction.warnUser),
          ),
          _ActionTile(
            title: 'Delete Content',
            subtitle: 'Remove post and all comments',
            selected: selected == AdminModerationAction.deleteContent,
            onTap: () => onSelected(AdminModerationAction.deleteContent),
          ),
          _ActionTile(
            title: 'Permanent Ban',
            subtitle: 'Revoke all access immediately',
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
                      Text(
                        title,
                        style: TextStyle(
                          fontWeight: FontWeight.w900,
                          color: danger ? AppColors.error : AppColors.textPrimary,
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
