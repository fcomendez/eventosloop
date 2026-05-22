import 'package:eventosloop/features/admin/models/admin_models.dart';
import 'package:flutter/material.dart';

class AdminMockService {
  List<AdminKpiMetric> fetchDashboardKpis() {
    return const <AdminKpiMetric>[
      AdminKpiMetric(
        label: 'New Users',
        value: '2,842',
        badgeLabel: '+12.4%',
        badgeColor: 0xFF2E9E6A,
      ),
      AdminKpiMetric(
        label: 'Posts Today',
        value: '14,120',
        badgeLabel: '+8.2%',
        badgeColor: 0xFF2E9E6A,
      ),
      AdminKpiMetric(
        label: 'Active Communities',
        value: '854',
        badgeLabel: 'Stable',
        badgeColor: 0xFF0682BC,
      ),
      AdminKpiMetric(
        label: 'Pending Alerts',
        value: '14',
        badgeLabel: 'Urgent',
        badgeColor: 0xFFD64545,
      ),
    ];
  }

  List<AdminGrowthPoint> fetchGrowthSeries({required bool monthly}) {
    if (monthly) {
      return const <AdminGrowthPoint>[
        AdminGrowthPoint(label: 'AUG 20', value: 0.18),
        AdminGrowthPoint(label: 'AUG 24', value: 0.24),
        AdminGrowthPoint(label: 'AUG 28', value: 0.31),
        AdminGrowthPoint(label: 'SEP 01', value: 0.36),
        AdminGrowthPoint(label: 'SEP 05', value: 0.42),
        AdminGrowthPoint(label: 'SEP 09', value: 0.48),
        AdminGrowthPoint(label: 'SEP 13', value: 0.55),
        AdminGrowthPoint(label: 'SEP 17', value: 0.63),
        AdminGrowthPoint(label: 'SEP 20', value: 0.71),
        AdminGrowthPoint(label: 'SEP 24', value: 0.82),
      ];
    }
    return const <AdminGrowthPoint>[
      AdminGrowthPoint(label: 'LUN', value: 0.22),
      AdminGrowthPoint(label: 'MAR', value: 0.28),
      AdminGrowthPoint(label: 'MIE', value: 0.35),
      AdminGrowthPoint(label: 'JUE', value: 0.41),
      AdminGrowthPoint(label: 'VIE', value: 0.52),
      AdminGrowthPoint(label: 'SAB', value: 0.61),
      AdminGrowthPoint(label: 'DOM', value: 0.68),
    ];
  }

  List<AdminInterestRanking> fetchInterestRankings() {
    return const <AdminInterestRanking>[
      AdminInterestRanking(
        rank: 1,
        name: 'Technology',
        usersLabel: '842,102',
        marketShare: 0.82,
        icon: Icons.memory_outlined,
        barColor: 0xFF005F9A,
      ),
      AdminInterestRanking(
        rank: 2,
        name: 'Football',
        usersLabel: '615,449',
        marketShare: 0.66,
        icon: Icons.sports_soccer_outlined,
        barColor: 0xFF7B61B5,
      ),
      AdminInterestRanking(
        rank: 3,
        name: 'Digital Art',
        usersLabel: '502,991',
        marketShare: 0.54,
        icon: Icons.brush_outlined,
        barColor: 0xFF0682BC,
      ),
      AdminInterestRanking(
        rank: 4,
        name: 'Wellness',
        usersLabel: '428,211',
        marketShare: 0.42,
        icon: Icons.self_improvement_outlined,
        barColor: 0xFF9AB4D3,
      ),
      AdminInterestRanking(
        rank: 5,
        name: 'Business',
        usersLabel: '311,558',
        marketShare: 0.31,
        icon: Icons.business_center_outlined,
        barColor: 0xFFB8C9DE,
      ),
    ];
  }

  AdminModerationIncident fetchSampleIncident() {
    return const AdminModerationIncident(
      reportId: '849201',
      authorName: 'Marcus Vance',
      authorHandle: '@marcus_22',
      postedLabel: 'Publicado hace 4 horas',
      riskLabel: 'HIGH RISK',
      content:
          'The ecosystem is falling because of the leadership. We need to start pushing back harder against the moderators who are silencing our community. If they will not listen, we make them listen. This is the start of the takeover.',
      likesLabel: '1.2k',
      commentsLabel: '458',
      joinedLabel: 'Jan 12, 2023',
      statusLabel: 'Verified',
      followersLabel: '12.4k',
      pendingReportsLabel: '3 Pending',
      reasonTags: <String>['Harassment', 'Incitement'],
      reportVolumeLabel: '42 reports in last 12h',
      reporterComments: <String>[
        'This post is targeting our community moderators with hostile language.',
        'Feels like coordinated harassment. Several accounts reposted the same tone.',
      ],
      previousActions: <String>[
        'Warning: Hate Speech (2mo ago)',
        'Resolved: Dismissed (1yr ago)',
      ],
    );
  }
}
