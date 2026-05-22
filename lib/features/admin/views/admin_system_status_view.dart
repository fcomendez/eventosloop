import 'package:eventosloop/core/theme/app_colors.dart';
import 'package:eventosloop/features/admin/models/admin_models.dart';
import 'package:eventosloop/features/admin/models/admin_ops_models.dart';
import 'package:eventosloop/features/admin/navigation/admin_navigation.dart';
import 'package:eventosloop/features/admin/services/admin_mock_service.dart';
import 'package:eventosloop/features/admin/widgets/admin_shell.dart';
import 'package:flutter/material.dart';

class AdminSystemStatusView extends StatefulWidget {
  const AdminSystemStatusView({super.key});

  @override
  State<AdminSystemStatusView> createState() => _AdminSystemStatusViewState();
}

class _AdminSystemStatusViewState extends State<AdminSystemStatusView> {
  final AdminMockService _service = AdminMockService();

  @override
  Widget build(BuildContext context) {
    final List<AdminServiceStatusRow> services = _service.fetchServiceStatuses();
    final List<AdminSystemIncidentRow> incidents = _service.fetchSystemIncidents();

    return AdminShell(
      selectedTopTab: AdminTopTab.dashboard,
      selectedSidebar: AdminSidebarItem.systemStatus,
      onTopTabChanged: (AdminTopTab tab) =>
          handleAdminTopTabNavigation(context, tab),
      onSidebarChanged: (AdminSidebarItem item) =>
          handleAdminSidebarNavigation(context, item, replace: true),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          AdminPageHeader(
            title: 'Estado del sistema',
            subtitle:
                'Monitorea salud de infraestructura, latencia e incidentes recientes en los servicios LOOP.',
            trailing: <Widget>[
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: const Color(0xFF2E9E6A).withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Icon(Icons.circle, size: 8, color: Color(0xFF2E9E6A)),
                    SizedBox(width: 6),
                    Text(
                      'Todos los sistemas operativos',
                      style: TextStyle(
                        color: Color(0xFF2E9E6A),
                        fontWeight: FontWeight.w800,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
              final int columns = constraints.maxWidth >= 720 ? 2 : 1;
              return GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: services.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: columns,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: columns == 2 ? 2.8 : 2.4,
                ),
                itemBuilder: (BuildContext context, int index) {
                  return _ServiceCard(service: services[index]);
                },
              );
            },
          ),
          const SizedBox(height: 18),
          AdminSectionCard(
            padding: EdgeInsets.zero,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 14, 16, 10),
                  child: Row(
                    children: <Widget>[
                      const Expanded(
                        child: Text(
                          'Incidentes recientes',
                          style: TextStyle(
                            fontWeight: FontWeight.w900,
                            fontSize: 18,
                          ),
                        ),
                      ),
                      OutlinedButton(onPressed: () {}, child: const Text('Ver adm_log')),
                    ],
                  ),
                ),
                const Divider(height: 1),
                ...incidents.map((AdminSystemIncidentRow incident) {
                  return Column(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Container(
                              width: 4,
                              height: 44,
                              decoration: BoxDecoration(
                                color: Color(incident.severityColor),
                                borderRadius: BorderRadius.circular(4),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Row(
                                    children: <Widget>[
                                      Text(
                                        incident.service,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.w900,
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        incident.timeLabel,
                                        style: const TextStyle(
                                          fontSize: 12,
                                          color: AppColors.textSecondary,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    incident.message,
                                    style: const TextStyle(
                                      color: AppColors.textSecondary,
                                      height: 1.35,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (incident != incidents.last) const Divider(height: 1),
                    ],
                  );
                }),
              ],
            ),
          ),
          const SizedBox(height: 16),
          const AdminSectionCard(
            child: Row(
              children: <Widget>[
                Icon(Icons.info_outline, color: AppColors.primary),
                SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        'Plataforma LOOP V2.1.1',
                        style: TextStyle(fontWeight: FontWeight.w900),
                      ),
                      Text(
                        'Ultimo deploy: 21 oct 2025 · Entorno: Produccion · Region: sa-east-1',
                        style: TextStyle(
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
        ],
      ),
    );
  }
}

class _ServiceCard extends StatelessWidget {
  const _ServiceCard({required this.service});

  final AdminServiceStatusRow service;

  @override
  Widget build(BuildContext context) {
    final (String label, Color color, IconData icon) = switch (service.health) {
      AdminServiceHealth.operational => (
          'Operativo',
          const Color(0xFF2E9E6A),
          Icons.check_circle_outline,
        ),
      AdminServiceHealth.degraded => (
          'Degradado',
          const Color(0xFFE08A3A),
          Icons.warning_amber_outlined,
        ),
      AdminServiceHealth.down => (
          'Caido',
          AppColors.error,
          Icons.error_outline,
        ),
    };

    return AdminSectionCard(
      child: Row(
        children: <Widget>[
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  service.name,
                  style: const TextStyle(
                    fontWeight: FontWeight.w900,
                    fontSize: 16,
                  ),
                ),
                Text(
                  service.description,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: <Widget>[
                    _MetricChip(label: label, color: color),
                    const SizedBox(width: 8),
                    _MetricChip(
                      label: service.latencyLabel,
                      color: AppColors.textSecondary,
                    ),
                    const SizedBox(width: 8),
                    _MetricChip(
                      label: service.uptimeLabel,
                      color: AppColors.primary,
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

class _MetricChip extends StatelessWidget {
  const _MetricChip({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: 10,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }
}
