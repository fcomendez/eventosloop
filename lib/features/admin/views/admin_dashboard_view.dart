import 'package:eventosloop/core/theme/app_colors.dart';
import 'package:eventosloop/features/admin/models/admin_models.dart';
import 'package:eventosloop/features/admin/navigation/admin_navigation.dart';
import 'package:eventosloop/features/admin/services/admin_mock_service.dart';
import 'package:eventosloop/features/admin/widgets/admin_shell.dart';
import 'package:flutter/material.dart';

class AdminDashboardView extends StatefulWidget {
  const AdminDashboardView({super.key});

  @override
  State<AdminDashboardView> createState() => _AdminDashboardViewState();
}

class _AdminDashboardViewState extends State<AdminDashboardView> {
  final AdminMockService _service = AdminMockService();
  bool _monthlyGrowth = true;

  @override
  Widget build(BuildContext context) {
    final List<AdminKpiMetric> kpis = _service.fetchDashboardKpis();
    final List<AdminGrowthPoint> growth = _service.fetchGrowthSeries(
      monthly: _monthlyGrowth,
    );

    return AdminShell(
      selectedTopTab: AdminTopTab.dashboard,
      selectedSidebar: AdminSidebarItem.userManagement,
      onTopTabChanged: (AdminTopTab tab) =>
          handleAdminTopTabNavigation(context, tab),
      onSidebarChanged: (AdminSidebarItem item) =>
          handleAdminSidebarNavigation(context, item, replace: true),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const Text(
            'Resumen de la plataforma',
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 28,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            'Metricas operativas en tiempo real de usuarios, contenido y comunidades.',
            style: TextStyle(color: AppColors.textSecondary, height: 1.35),
          ),
          const SizedBox(height: 18),
          LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
              final int columns = constraints.maxWidth >= 720 ? 4 : 2;
              return GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: kpis.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: columns,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: columns == 4 ? 1.35 : 1.15,
                ),
                itemBuilder: (BuildContext context, int index) {
                  return AdminKpiCard(metric: kpis[index]);
                },
              );
            },
          ),
          const SizedBox(height: 18),
          AdminSectionCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            'Analitica de crecimiento de usuarios',
                            style: TextStyle(
                              color: AppColors.textPrimary,
                              fontSize: 20,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'Registros acumulados (ultimos 30 dias)',
                            style: TextStyle(
                              color: AppColors.textSecondary,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ),
                    AdminPeriodToggle(
                      options: const <String>['Diario', 'Mensual'],
                      selected: _monthlyGrowth ? 'Mensual' : 'Diario',
                      onChanged: (String value) {
                        setState(() {
                          _monthlyGrowth = value == 'Mensual';
                        });
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                AdminGrowthChart(points: growth),
              ],
            ),
          ),
          const SizedBox(height: 24),
          const Center(
            child: Text(
              '© 2026 LOOP Global. Todos los derechos reservados. Sistema V2.1.1',
              style: TextStyle(color: AppColors.textSecondary, fontSize: 11),
            ),
          ),
        ],
      ),
    );
  }
}
