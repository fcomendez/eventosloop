import 'package:eventosloop/core/theme/app_colors.dart';
import 'package:eventosloop/features/admin/models/admin_models.dart';
import 'package:eventosloop/features/admin/models/admin_ops_models.dart';
import 'package:eventosloop/features/admin/navigation/admin_navigation.dart';
import 'package:eventosloop/features/admin/services/admin_supabase_service.dart';
import 'package:eventosloop/features/admin/widgets/admin_shell.dart';
import 'package:flutter/material.dart';

class AdminAdConsoleView extends StatefulWidget {
  const AdminAdConsoleView({super.key});

  @override
  State<AdminAdConsoleView> createState() => _AdminAdConsoleViewState();
}

class _AdminAdConsoleViewState extends State<AdminAdConsoleView> {
  final AdminSupabaseService _service = AdminSupabaseService();
  bool _loading = true;
  List<AdminAdStat> _stats = <AdminAdStat>[];
  List<AdminAdCampaignRow> _campaigns = <AdminAdCampaignRow>[];

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    try {
      final List<AdminAdStat> stats = await _service.fetchAdStats();
      final List<AdminAdCampaignRow> campaigns =
          await _service.fetchAdCampaigns();
      if (mounted) {
        setState(() {
          _stats = stats;
          _campaigns = campaigns;
          _loading = false;
        });
      }
    } catch (_) {
      if (mounted) {
        setState(() => _loading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AdminShell(
      selectedTopTab: AdminTopTab.dashboard,
      selectedSidebar: AdminSidebarItem.adConsole,
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
                  title: 'Consola de promocion',
                  subtitle:
                      'Metricas derivadas del contenido organico (no hay tabla de campanas pagadas).',
                  trailing: <Widget>[
                    IconButton(onPressed: _load, icon: const Icon(Icons.refresh)),
                  ],
                ),
                const SizedBox(height: 18),
                LayoutBuilder(
                  builder: (BuildContext context, BoxConstraints constraints) {
                    final int columns = constraints.maxWidth >= 700 ? 4 : 2;
                    return GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: _stats.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: columns,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                        childAspectRatio: 2.0,
                      ),
                      itemBuilder: (BuildContext context, int index) {
                        final AdminAdStat stat = _stats[index];
                        return AdminSectionCard(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text(stat.label,
                                  style: const TextStyle(
                                      color: AppColors.textSecondary)),
                              Text(stat.value,
                                  style: const TextStyle(
                                      fontSize: 26,
                                      fontWeight: FontWeight.w900)),
                            ],
                          ),
                        );
                      },
                    );
                  },
                ),
                const SizedBox(height: 18),
                AdminSectionCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      const Text('Comunidades destacadas',
                          style: TextStyle(fontWeight: FontWeight.w900)),
                      const SizedBox(height: 12),
                      if (_campaigns.isEmpty)
                        const Text('No hay comunidades activas.')
                      else
                        ..._campaigns.map((AdminAdCampaignRow row) {
                          return ListTile(
                            contentPadding: EdgeInsets.zero,
                            leading: Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                color: Color(row.accentColor)
                                    .withValues(alpha: 0.2),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Icon(Icons.groups, color: AppColors.primary),
                            ),
                            title: Text(row.name,
                                style: const TextStyle(fontWeight: FontWeight.w800)),
                            subtitle: Text('Ubicacion: ${row.placement}'),
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
