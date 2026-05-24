import 'package:eventosloop/core/config/app_env.dart';
import 'package:eventosloop/core/theme/app_colors.dart';
import 'package:eventosloop/features/admin/models/admin_models.dart';
import 'package:eventosloop/features/admin/navigation/admin_navigation.dart';
import 'package:eventosloop/features/admin/services/admin_supabase_service.dart';
import 'package:eventosloop/features/admin/widgets/admin_shell.dart';
import 'package:flutter/material.dart';

class AdminDashboardView extends StatefulWidget {
  const AdminDashboardView({super.key});

  @override
  State<AdminDashboardView> createState() => _AdminDashboardViewState();
}

class _AdminDashboardViewState extends State<AdminDashboardView> {
  final AdminSupabaseService _service = AdminSupabaseService();
  bool _monthlyGrowth = true;
  bool _loading = true;
  List<AdminKpiMetric> _kpis = <AdminKpiMetric>[];
  List<AdminGrowthPoint> _growth = <AdminGrowthPoint>[];
  String? _error;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final List<AdminKpiMetric> kpis = await _service.fetchDashboardKpis();
      final List<AdminGrowthPoint> growth =
          await _service.fetchGrowthSeries(monthly: _monthlyGrowth);
      if (mounted) {
        setState(() {
          _kpis = kpis;
          _growth = growth;
          _loading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = e.toString();
          _loading = false;
        });
      }
    }
  }

  Future<void> _togglePeriod(bool monthly) async {
    setState(() => _monthlyGrowth = monthly);
    final List<AdminGrowthPoint> growth =
        await _service.fetchGrowthSeries(monthly: monthly);
    if (mounted) {
      setState(() => _growth = growth);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AdminShell(
      selectedTopTab: AdminTopTab.dashboard,
      selectedSidebar: AdminSidebarItem.userManagement,
      onTopTabChanged: (AdminTopTab tab) =>
          handleAdminTopTabNavigation(context, tab),
      onSidebarChanged: (AdminSidebarItem item) =>
          handleAdminSidebarNavigation(context, item, replace: true),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            'Resumen de la plataforma',
                            style: TextStyle(
                              color: AppColors.textPrimary,
                              fontSize: 28,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                          SizedBox(height: 6),
                          Text(
                            'Metricas en tiempo real desde Supabase.',
                            style: TextStyle(
                              color: AppColors.textSecondary,
                              height: 1.35,
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      onPressed: _load,
                      icon: const Icon(Icons.refresh),
                      tooltip: 'Recargar',
                    ),
                  ],
                ),
                if (_error != null) ...<Widget>[
                  const SizedBox(height: 12),
                  Text(_error!, style: const TextStyle(color: AppColors.error)),
                ],
                const SizedBox(height: 18),
                if (_kpis.isEmpty && AppEnv.useSupabase)
                  const Text('No hay datos disponibles.')
                else
                  LayoutBuilder(
                    builder: (BuildContext context, BoxConstraints constraints) {
                      final int columns = constraints.maxWidth >= 720 ? 4 : 2;
                      return GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: _kpis.length,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: columns,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                          childAspectRatio: columns == 4 ? 1.35 : 1.15,
                        ),
                        itemBuilder: (BuildContext context, int index) {
                          return AdminKpiCard(metric: _kpis[index]);
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
                                  'Crecimiento de usuarios',
                                  style: TextStyle(
                                    color: AppColors.textPrimary,
                                    fontSize: 20,
                                    fontWeight: FontWeight.w900,
                                  ),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  'Registros acumulados',
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
                              _togglePeriod(value == 'Mensual');
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      if (_growth.isEmpty)
                        const Text('Sin registros en el periodo.')
                      else
                        AdminGrowthChart(points: _growth),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}
