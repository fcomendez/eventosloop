import 'package:eventosloop/core/theme/app_colors.dart';
import 'package:eventosloop/features/admin/models/admin_models.dart';
import 'package:eventosloop/features/admin/services/admin_mock_service.dart';
import 'package:eventosloop/features/admin/views/admin_analytics_view.dart';
import 'package:eventosloop/features/admin/views/admin_moderation_review_view.dart';
import 'package:eventosloop/features/admin/widgets/admin_shell.dart';
import 'package:flutter/material.dart';

void openAdminDashboard(BuildContext context) {
  Navigator.of(context).push(
    MaterialPageRoute<void>(builder: (_) => const AdminDashboardView()),
  );
}

class AdminDashboardView extends StatefulWidget {
  const AdminDashboardView({super.key});

  @override
  State<AdminDashboardView> createState() => _AdminDashboardViewState();
}

class _AdminDashboardViewState extends State<AdminDashboardView> {
  final AdminMockService _service = AdminMockService();
  bool _monthlyGrowth = true;

  void _handleSidebar(AdminSidebarItem item) {
    if (item == AdminSidebarItem.moderation) {
      Navigator.of(context).push(
        MaterialPageRoute<void>(
          builder: (_) => const AdminModerationReviewView(),
        ),
      );
      return;
    }
    if (item == AdminSidebarItem.contentFeed) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute<void>(builder: (_) => const AdminAnalyticsView()),
      );
      return;
    }
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('${item.name} — proximamente')),
    );
  }

  void _handleTopTab(AdminTopTab tab) {
    if (tab == AdminTopTab.analytics) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute<void>(builder: (_) => const AdminAnalyticsView()),
      );
    } else if (tab == AdminTopTab.community) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Community admin — proximamente')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<AdminKpiMetric> kpis = _service.fetchDashboardKpis();
    final List<AdminGrowthPoint> growth = _service.fetchGrowthSeries(
      monthly: _monthlyGrowth,
    );

    return AdminShell(
      selectedTopTab: AdminTopTab.dashboard,
      selectedSidebar: AdminSidebarItem.userManagement,
      onTopTabChanged: _handleTopTab,
      onSidebarChanged: _handleSidebar,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const Text(
            'Platform Overview',
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 28,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            'Real-time operational metrics across users, content and communities.',
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
                            'User Growth Analytics',
                            style: TextStyle(
                              color: AppColors.textPrimary,
                              fontSize: 20,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'Cumulative registration metrics (Last 30 Days)',
                            style: TextStyle(
                              color: AppColors.textSecondary,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ),
                    AdminPeriodToggle(
                      options: const <String>['Daily', 'Monthly'],
                      selected: _monthlyGrowth ? 'Monthly' : 'Daily',
                      onChanged: (String value) {
                        setState(() {
                          _monthlyGrowth = value == 'Monthly';
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
              '© 2026 LOOP Global. All rights reserved. System V2.1.1',
              style: TextStyle(color: AppColors.textSecondary, fontSize: 11),
            ),
          ),
        ],
      ),
    );
  }
}
