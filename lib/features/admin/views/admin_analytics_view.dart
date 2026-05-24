import 'package:eventosloop/core/theme/app_colors.dart';
import 'package:eventosloop/features/admin/models/admin_models.dart';
import 'package:eventosloop/features/admin/navigation/admin_navigation.dart';
import 'package:eventosloop/features/admin/services/admin_supabase_service.dart';
import 'package:eventosloop/features/admin/widgets/admin_shell.dart';
import 'package:flutter/material.dart';

class AdminAnalyticsView extends StatefulWidget {
  const AdminAnalyticsView({super.key});

  @override
  State<AdminAnalyticsView> createState() => _AdminAnalyticsViewState();
}

class _AdminAnalyticsViewState extends State<AdminAnalyticsView> {
  final AdminSupabaseService _service = AdminSupabaseService();
  bool _loading = true;
  List<AdminInterestRanking> _rankings = <AdminInterestRanking>[];
  String _topInterest = '—';
  String _topGrowth = '—';
  int _activeUsers = 0;
  double _avgInterests = 0;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    try {
      final highlights = await _service.fetchAnalyticsHighlights();
      final List<AdminInterestRanking> rankings =
          await _service.fetchInterestRankings();
      if (mounted) {
        setState(() {
          _topInterest = highlights.topInterest;
          _topGrowth = highlights.topGrowth;
          _activeUsers = highlights.activeUsers;
          _avgInterests = highlights.avgInterests;
          _rankings = rankings;
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
      selectedTopTab: AdminTopTab.analytics,
      selectedSidebar: AdminSidebarItem.contentFeed,
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
                            'Ecosistema de intereses',
                            style: TextStyle(
                              color: AppColors.textPrimary,
                              fontSize: 28,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                          SizedBox(height: 6),
                          Text(
                            'Ranking real segun usuario_intereses en la base de datos.',
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
                    ),
                  ],
                ),
                const SizedBox(height: 18),
                _MetricHighlightCard(
                  title: _topInterest,
                  value: 'Interes con mas usuarios ($_topGrowth)',
                  icon: Icons.show_chart_outlined,
                ),
                const SizedBox(height: 12),
                _MetricHighlightCard(
                  title: '$_activeUsers',
                  value: 'Usuarios registrados en LOOP',
                  icon: Icons.groups_outlined,
                ),
                const SizedBox(height: 12),
                _MetricHighlightCard(
                  title: _avgInterests.toStringAsFixed(1),
                  value: 'Intereses promedio por usuario activo',
                  icon: Icons.interests_outlined,
                ),
                const SizedBox(height: 18),
                AdminSectionCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      const Text(
                        'Ranking de intereses',
                        style: TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 20,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      const SizedBox(height: 14),
                      if (_rankings.isEmpty)
                        const Text('Aun no hay intereses asignados a usuarios.')
                      else ...<Widget>[
                        const Row(
                          children: <Widget>[
                            Expanded(flex: 1, child: _TableHeader('RANGO')),
                            Expanded(flex: 4, child: _TableHeader('INTERES')),
                            Expanded(flex: 3, child: _TableHeader('USUARIOS')),
                            Expanded(flex: 4, child: _TableHeader('CUOTA')),
                          ],
                        ),
                        const Divider(height: 20),
                        ..._rankings.map((AdminInterestRanking item) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 14),
                            child: Row(
                              children: <Widget>[
                                Expanded(
                                  flex: 1,
                                  child: Text(
                                    '${item.rank}',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w900,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 4,
                                  child: Row(
                                    children: <Widget>[
                                      Container(
                                        width: 34,
                                        height: 34,
                                        decoration: BoxDecoration(
                                          color: AppColors.inputBackground,
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                        child: Icon(
                                          item.icon,
                                          size: 18,
                                          color: AppColors.primary,
                                        ),
                                      ),
                                      const SizedBox(width: 10),
                                      Expanded(
                                        child: Text(
                                          item.name,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.w800,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Expanded(
                                  flex: 3,
                                  child: Text(
                                    item.usersLabel,
                                    style: const TextStyle(
                                      color: AppColors.textSecondary,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 4,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: <Widget>[
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(999),
                                        child: LinearProgressIndicator(
                                          value: item.marketShare,
                                          minHeight: 8,
                                          backgroundColor: AppColors.inputBackground,
                                          color: Color(item.barColor),
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        '${(item.marketShare * 100).round()}%',
                                        style: const TextStyle(
                                          fontSize: 11,
                                          color: AppColors.textSecondary,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        }),
                      ],
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}

class _MetricHighlightCard extends StatelessWidget {
  const _MetricHighlightCard({
    required this.title,
    required this.value,
    required this.icon,
  });

  final String title;
  final String value;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return AdminSectionCard(
      child: Row(
        children: <Widget>[
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: AppColors.primary),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                Text(
                  value,
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontWeight: FontWeight.w600,
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

class _TableHeader extends StatelessWidget {
  const _TableHeader(this.label);

  final String label;

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: const TextStyle(
        fontSize: 11,
        letterSpacing: 0.6,
        color: AppColors.textSecondary,
        fontWeight: FontWeight.w800,
      ),
    );
  }
}
