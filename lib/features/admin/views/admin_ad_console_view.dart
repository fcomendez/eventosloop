import 'package:eventosloop/core/theme/app_colors.dart';
import 'package:eventosloop/features/admin/models/admin_models.dart';
import 'package:eventosloop/features/admin/models/admin_ops_models.dart';
import 'package:eventosloop/features/admin/navigation/admin_navigation.dart';
import 'package:eventosloop/features/admin/services/admin_mock_service.dart';
import 'package:eventosloop/features/admin/widgets/admin_shell.dart';
import 'package:flutter/material.dart';

class AdminAdConsoleView extends StatefulWidget {
  const AdminAdConsoleView({super.key});

  @override
  State<AdminAdConsoleView> createState() => _AdminAdConsoleViewState();
}

class _AdminAdConsoleViewState extends State<AdminAdConsoleView> {
  final AdminMockService _service = AdminMockService();
  String _statusFilter = 'Todas';

  @override
  Widget build(BuildContext context) {
    final List<AdminAdStat> stats = _service.fetchAdStats();
    final List<AdminAdCampaignRow> allCampaigns = _service.fetchAdCampaigns();
    final List<AdminAdCampaignRow> campaigns = _filteredCampaigns(allCampaigns);

    return AdminShell(
      selectedTopTab: AdminTopTab.dashboard,
      selectedSidebar: AdminSidebarItem.adConsole,
      onTopTabChanged: (AdminTopTab tab) =>
          handleAdminTopTabNavigation(context, tab),
      onSidebarChanged: (AdminSidebarItem item) =>
          handleAdminSidebarNavigation(context, item, replace: true),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'Consola de anuncios',
                      style: TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 28,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    SizedBox(height: 6),
                    Text(
                      'Gestiona campanas promocionales, ubicaciones y rendimiento en LOOP.',
                      style: TextStyle(color: AppColors.textSecondary, height: 1.35),
                    ),
                  ],
                ),
              ),
              OutlinedButton(onPressed: () {}, child: const Text('Exportar')),
              const SizedBox(width: 8),
              ElevatedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.add, size: 18),
                label: const Text('Nueva campana'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: AppColors.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
              final int columns = constraints.maxWidth >= 700 ? 4 : 2;
              return GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: stats.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: columns,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: columns == 4 ? 2.0 : 1.8,
                ),
                itemBuilder: (BuildContext context, int index) {
                  final AdminAdStat stat = stats[index];
                  return AdminSectionCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          stat.label,
                          style: const TextStyle(
                            color: AppColors.textSecondary,
                            fontWeight: FontWeight.w700,
                            fontSize: 13,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          stat.value,
                          style: const TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              );
            },
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            children: <String>['Todas', 'En curso', 'Pausada', 'Programada'].map(
              (String filter) {
                final bool active = filter == _statusFilter;
                return FilterChip(
                  label: Text(filter),
                  selected: active,
                  onSelected: (_) => setState(() => _statusFilter = filter),
                  selectedColor: AppColors.primaryDark,
                  checkmarkColor: AppColors.white,
                  labelStyle: TextStyle(
                    color: active ? AppColors.white : AppColors.primaryDark,
                    fontWeight: FontWeight.w700,
                    fontSize: 12,
                  ),
                  backgroundColor: AppColors.primary.withValues(alpha: 0.08),
                  side: BorderSide.none,
                );
              },
            ).toList(),
          ),
          const SizedBox(height: 14),
          AdminSectionCard(
            padding: EdgeInsets.zero,
            child: Column(
              children: <Widget>[
                const Padding(
                  padding: EdgeInsets.fromLTRB(16, 14, 16, 10),
                  child: Row(
                    children: <Widget>[
                      Expanded(flex: 3, child: _Head('CAMPANA')),
                      Expanded(flex: 2, child: _Head('UBICACION')),
                      Expanded(flex: 2, child: _Head('PRESUPUESTO')),
                      Expanded(flex: 2, child: _Head('IMPRESIONES')),
                      Expanded(flex: 1, child: _Head('CTR')),
                      Expanded(flex: 2, child: _Head('ESTADO')),
                      SizedBox(width: 72, child: _Head('ACCIONES')),
                    ],
                  ),
                ),
                const Divider(height: 1),
                ...campaigns.map((AdminAdCampaignRow row) {
                  return Column(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
                        child: Row(
                          children: <Widget>[
                            Expanded(
                              flex: 3,
                              child: Row(
                                children: <Widget>[
                                  Container(
                                    width: 36,
                                    height: 36,
                                    decoration: BoxDecoration(
                                      color: Color(row.accentColor),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: const Icon(
                                      Icons.campaign_outlined,
                                      color: AppColors.white,
                                      size: 18,
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: Text(
                                      row.name,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w900,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Expanded(flex: 2, child: Text(row.placement, style: const TextStyle(fontSize: 12))),
                            Expanded(flex: 2, child: Text(row.budgetLabel, style: const TextStyle(fontWeight: FontWeight.w700))),
                            Expanded(flex: 2, child: Text(row.impressionsLabel)),
                            Expanded(flex: 1, child: Text(row.ctrLabel)),
                            Expanded(flex: 2, child: _CampaignStatusPill(status: row.status)),
                            SizedBox(
                              width: 72,
                              child: Row(
                                children: <Widget>[
                                  IconButton(
                                    onPressed: () {},
                                    icon: const Icon(Icons.edit_outlined, size: 18),
                                    color: AppColors.textSecondary,
                                  ),
                                  IconButton(
                                    onPressed: () {},
                                    icon: const Icon(Icons.pause_circle_outline, size: 18),
                                    color: AppColors.primary,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (row != campaigns.last) const Divider(height: 1),
                    ],
                  );
                }),
              ],
            ),
          ),
        ],
      ),
    );
  }

  List<AdminAdCampaignRow> _filteredCampaigns(List<AdminAdCampaignRow> rows) {
    if (_statusFilter == 'Todas') return rows;
    final AdminAdCampaignStatus? status = switch (_statusFilter) {
      'En curso' => AdminAdCampaignStatus.running,
      'Pausada' => AdminAdCampaignStatus.paused,
      'Programada' => AdminAdCampaignStatus.scheduled,
      _ => null,
    };
    if (status == null) return rows;
    return rows.where((AdminAdCampaignRow row) => row.status == status).toList();
  }
}

class _Head extends StatelessWidget {
  const _Head(this.label);

  final String label;

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: const TextStyle(
        fontSize: 10,
        letterSpacing: 0.5,
        color: AppColors.textSecondary,
        fontWeight: FontWeight.w800,
      ),
    );
  }
}

class _CampaignStatusPill extends StatelessWidget {
  const _CampaignStatusPill({required this.status});

  final AdminAdCampaignStatus status;

  @override
  Widget build(BuildContext context) {
    final (String label, Color color) = switch (status) {
      AdminAdCampaignStatus.running => ('En curso', const Color(0xFF2E9E6A)),
      AdminAdCampaignStatus.paused => ('Pausada', const Color(0xFFE08A3A)),
      AdminAdCampaignStatus.scheduled => ('Programada', AppColors.primary),
      AdminAdCampaignStatus.ended => ('Finalizada', AppColors.textSecondary),
    };
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: 11,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }
}
