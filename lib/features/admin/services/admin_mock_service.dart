import 'package:eventosloop/features/admin/models/admin_models.dart';
import 'package:eventosloop/features/admin/models/admin_community_models.dart';
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

  AdminModerationIncident fetchSampleIncident({String reportId = '849201'}) {
    return AdminModerationIncident(
      reportId: reportId,
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

  List<AdminCommunityRow> fetchCommunities() {
    return const <AdminCommunityRow>[
      AdminCommunityRow(
        id: 1,
        name: 'Tech Hub Global',
        category: 'TECHNOLOGY',
        leadCreator: 'Alec Rivera',
        engagementLabel: '12.4K',
        postsLabel: '8.2K POSTS',
        status: AdminCommunityStatus.active,
        thumbnailColor: 0xFF005F9A,
        canUnblock: false,
      ),
      AdminCommunityRow(
        id: 2,
        name: 'Green Earth Collective',
        category: 'SUSTAINABILITY',
        leadCreator: 'Sofia Mendez',
        engagementLabel: '9.1K',
        postsLabel: '5.4K POSTS',
        status: AdminCommunityStatus.active,
        thumbnailColor: 0xFF2E9E6A,
        canUnblock: false,
      ),
      AdminCommunityRow(
        id: 3,
        name: 'Urban Sketchers',
        category: 'ART & DESIGN',
        leadCreator: 'Leo Park',
        engagementLabel: '6.8K',
        postsLabel: '3.1K POSTS',
        status: AdminCommunityStatus.banned,
        thumbnailColor: 0xFF7B61B5,
        canUnblock: true,
      ),
      AdminCommunityRow(
        id: 4,
        name: 'Mindful Mornings',
        category: 'WELLNESS',
        leadCreator: 'Elena Solis',
        engagementLabel: '4.2K',
        postsLabel: '2.0K POSTS',
        status: AdminCommunityStatus.active,
        thumbnailColor: 0xFF0682BC,
        canUnblock: false,
      ),
    ];
  }

  List<AdminModerationStat> fetchModerationStats() {
    return const <AdminModerationStat>[
      AdminModerationStat(
        label: 'Total Reports',
        value: '1,482',
        subtitle: '+5% from yesterday',
        subtitleColor: 0xFF2E9E6A,
        icon: Icons.trending_up,
      ),
      AdminModerationStat(
        label: 'Avg Response Time',
        value: '14m',
        subtitle: 'Within service target',
        subtitleColor: 0xFF2E9E6A,
        icon: Icons.check_circle_outline,
      ),
      AdminModerationStat(
        label: 'Resolved Today',
        value: '342',
        subtitle: 'High efficiency streak',
        subtitleColor: 0xFF0682BC,
        icon: Icons.bolt_outlined,
      ),
    ];
  }

  List<AdminReportQueueRow> fetchReportQueue() {
    return const <AdminReportQueueRow>[
      AdminReportQueueRow(
        id: '1',
        dateLabel: 'Oct 21, 14:20',
        reporterHandle: '@julia_v',
        objectLabel: 'Post ID: 8823-X',
        objectAuthor: '@marcus_22',
        reason: 'Harassment',
        reasonColor: 0xFFD64545,
        status: AdminReportStatus.pending,
        actionLabel: 'Processed by AI',
        incidentReportId: '849201',
      ),
      AdminReportQueueRow(
        id: '2',
        dateLabel: 'Oct 21, 13:05',
        reporterHandle: '@diego.dev',
        objectLabel: 'Comment: 1122-Y',
        objectAuthor: '@spam_bot',
        reason: 'Spam',
        reasonColor: 0xFF0682BC,
        status: AdminReportStatus.reviewed,
        actionLabel: 'Processed by AI',
        incidentReportId: '849202',
      ),
      AdminReportQueueRow(
        id: '3',
        dateLabel: 'Oct 21, 11:48',
        reporterHandle: '@camila.foodie',
        objectLabel: 'Post ID: 7710-Z',
        objectAuthor: '@unknown_user',
        reason: 'Inappropriate',
        reasonColor: 0xFFE08A3A,
        status: AdminReportStatus.pending,
        actionLabel: 'Processed by AI',
        incidentReportId: '849203',
      ),
      AdminReportQueueRow(
        id: '4',
        dateLabel: 'Oct 21, 10:12',
        reporterHandle: '@martina.loop',
        objectLabel: 'Post ID: 6601-A',
        objectAuthor: '@fake_profile',
        reason: 'Impersonation',
        reasonColor: 0xFF5B79AA,
        status: AdminReportStatus.pending,
        actionLabel: 'Processed by AI',
        incidentReportId: '849204',
      ),
    ];
  }
}
