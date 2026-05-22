import 'package:eventosloop/core/theme/app_colors.dart';
import 'package:eventosloop/features/admin/models/admin_models.dart';
import 'package:eventosloop/features/admin/services/admin_mock_service.dart';
import 'package:eventosloop/features/admin/views/admin_dashboard_view.dart';
import 'package:eventosloop/features/admin/views/admin_moderation_review_view.dart';
import 'package:eventosloop/features/admin/widgets/admin_shell.dart';
import 'package:flutter/material.dart';

class AdminAnalyticsView extends StatefulWidget {
  const AdminAnalyticsView({super.key});

  @override
  State<AdminAnalyticsView> createState() => _AdminAnalyticsViewState();
}

class _AdminAnalyticsViewState extends State<AdminAnalyticsView> {
  final AdminMockService _service = AdminMockService();
  String _rankingPeriod = 'Weekly';

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
      return;
    }
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('${item.name} — proximamente')),
    );
  }

  void _handleTopTab(AdminTopTab tab) {
    if (tab == AdminTopTab.dashboard) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute<void>(builder: (_) => const AdminDashboardView()),
      );
    } else if (tab == AdminTopTab.community) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Community admin — proximamente')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<AdminInterestRanking> rankings = _service.fetchInterestRankings();

    return AdminShell(
      selectedTopTab: AdminTopTab.analytics,
      selectedSidebar: AdminSidebarItem.contentFeed,
      onTopTabChanged: _handleTopTab,
      onSidebarChanged: _handleSidebar,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const Text(
            'Interest Ecosystem',
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 28,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            'Track engagement velocity and user affinity across 42 categories.',
            style: TextStyle(color: AppColors.textSecondary, height: 1.35),
          ),
          const SizedBox(height: 18),
          LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
              final bool wide = constraints.maxWidth >= 700;
              final Widget cards = Column(
                children: <Widget>[
                  _MetricHighlightCard(
                    title: 'Digital Art',
                    value: '+24.5% Growth this week',
                    icon: Icons.show_chart_outlined,
                  ),
                  const SizedBox(height: 12),
                  _MetricHighlightCard(
                    title: '1.2M',
                    value: 'Total Active Participants',
                    icon: Icons.groups_outlined,
                  ),
                  const SizedBox(height: 12),
                  _MetricHighlightCard(
                    title: '18.4 min',
                    value: 'Avg. session per interest',
                    icon: Icons.timer_outlined,
                  ),
                ],
              );
              if (!wide) {
                return cards;
              }
              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Expanded(child: cards),
                ],
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
                      child: Text(
                        'Trending Interest Rankings',
                        style: TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 20,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                    AdminPeriodToggle(
                      options: const <String>['Daily', 'Weekly', 'Monthly'],
                      selected: _rankingPeriod,
                      onChanged: (String value) {
                        setState(() => _rankingPeriod = value);
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                const Row(
                  children: <Widget>[
                    Expanded(flex: 1, child: _TableHeader('RANK')),
                    Expanded(flex: 4, child: _TableHeader('INTEREST NAME')),
                    Expanded(flex: 3, child: _TableHeader('USERS')),
                    Expanded(flex: 4, child: _TableHeader('MARKET SHARE')),
                  ],
                ),
                const Divider(height: 20),
                ...rankings.map((AdminInterestRanking item) {
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
                              color: AppColors.textPrimary,
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
                                child: Icon(item.icon,
                                    size: 18, color: AppColors.primary),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  item.name,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w800,
                                    color: AppColors.textPrimary,
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
                Center(
                  child: TextButton(
                    onPressed: () {},
                    child: const Text('View Comprehensive List →'),
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
                    color: AppColors.textPrimary,
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
