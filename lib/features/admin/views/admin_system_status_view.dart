import 'package:eventosloop/core/theme/app_colors.dart';
import 'package:eventosloop/features/admin/models/admin_models.dart';
import 'package:eventosloop/features/admin/models/admin_ops_models.dart';
import 'package:eventosloop/features/admin/navigation/admin_navigation.dart';
import 'package:eventosloop/features/admin/services/admin_supabase_service.dart';
import 'package:eventosloop/features/admin/widgets/admin_shell.dart';
import 'package:flutter/material.dart';

class AdminSystemStatusView extends StatefulWidget {
  const AdminSystemStatusView({super.key});

  @override
  State<AdminSystemStatusView> createState() => _AdminSystemStatusViewState();
}

class _AdminSystemStatusViewState extends State<AdminSystemStatusView> {
  final AdminSupabaseService _service = AdminSupabaseService();
  bool _loading = true;
  List<AdminServiceStatusRow> _services = <AdminServiceStatusRow>[];
  List<AdminSystemIncidentRow> _incidents = <AdminSystemIncidentRow>[];

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    try {
      final List<AdminServiceStatusRow> services =
          await _service.fetchServiceStatuses();
      final List<AdminSystemIncidentRow> incidents =
          await _service.fetchSystemIncidents();
      if (mounted) {
        setState(() {
          _services = services;
          _incidents = incidents;
          _loading = false;
        });
      }
    } catch (_) {
      if (mounted) {
        setState(() => _loading = false);
      }
    }
  }

  bool get _allOperational => _services.every(
        (AdminServiceStatusRow s) => s.health == AdminServiceHealth.operational,
      );

  @override
  Widget build(BuildContext context) {
    return AdminShell(
      selectedTopTab: AdminTopTab.dashboard,
      selectedSidebar: AdminSidebarItem.systemStatus,
      onTopTabChanged: (AdminTopTab tab) =>
          handleAdminTopTabNavigation(context, tab),
      onSidebarChanged: (AdminSidebarItem item) =>
          handleAdminSidebarNavigation(context, item, replace: true),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                AdminPageHeader(
                  title: 'Estado del sistema',
                  subtitle: 'Health check real contra el stack Supabase local.',
                  trailing: <Widget>[
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: (_allOperational
                                ? const Color(0xFF2E9E6A)
                                : const Color(0xFFE08A3A))
                            .withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: Text(
                        _allOperational
                            ? 'Servicios operativos'
                            : 'Algun servicio degradado',
                        style: TextStyle(
                          color: _allOperational
                              ? const Color(0xFF2E9E6A)
                              : const Color(0xFFE08A3A),
                          fontWeight: FontWeight.w800,
                          fontSize: 12,
                        ),
                      ),
                    ),
                    IconButton(onPressed: _load, icon: const Icon(Icons.refresh)),
                  ],
                ),
                const SizedBox(height: 18),
                ..._services.map((AdminServiceStatusRow service) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: _ServiceCard(service: service),
                  );
                }),
                const SizedBox(height: 8),
                AdminSectionCard(
                  padding: EdgeInsets.zero,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      const Padding(
                        padding: EdgeInsets.fromLTRB(16, 14, 16, 10),
                        child: Text('Registro adm_log (acciones admin)',
                            style: TextStyle(fontWeight: FontWeight.w900)),
                      ),
                      const Divider(height: 1),
                      if (_incidents.isEmpty)
                        const Padding(
                          padding: EdgeInsets.all(24),
                          child: Text('Sin acciones administrativas registradas.'),
                        )
                      else
                        ..._incidents.map((AdminSystemIncidentRow incident) {
                          return ListTile(
                            leading: Container(
                              width: 4,
                              height: 40,
                              color: Color(incident.severityColor),
                            ),
                            title: Text(incident.service,
                                style: const TextStyle(fontWeight: FontWeight.w800)),
                            subtitle: Text(incident.message),
                            trailing: Text(incident.timeLabel,
                                style: const TextStyle(fontSize: 11)),
                          );
                        }),
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
    final (String label, Color color) = switch (service.health) {
      AdminServiceHealth.operational => ('Operativo', const Color(0xFF2E9E6A)),
      AdminServiceHealth.degraded => ('Degradado', const Color(0xFFE08A3A)),
      AdminServiceHealth.down => ('Caido', AppColors.error),
    };
    return AdminSectionCard(
      child: Row(
        children: <Widget>[
          Icon(Icons.dns_outlined, color: color, size: 32),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(service.name,
                    style: const TextStyle(fontWeight: FontWeight.w900)),
                Text(service.description,
                    style: const TextStyle(
                        fontSize: 12, color: AppColors.textSecondary)),
                const SizedBox(height: 6),
                Text(
                  '$label · ${service.latencyLabel} · ${service.uptimeLabel}',
                  style: TextStyle(
                    color: color,
                    fontWeight: FontWeight.w700,
                    fontSize: 12,
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
