import 'package:eventosloop/features/admin/models/admin_community_models.dart';
import 'package:flutter/material.dart';

enum AdminTopTab { dashboard, analytics, community }

enum AdminSidebarItem {
  userManagement,
  contentFeed,
  moderation,
  adConsole,
  systemStatus,
}

class AdminKpiMetric {
  const AdminKpiMetric({
    required this.label,
    required this.value,
    required this.badgeLabel,
    required this.badgeColor,
  });

  final String label;
  final String value;
  final String badgeLabel;
  final int badgeColor;
}

class AdminGrowthPoint {
  const AdminGrowthPoint({required this.label, required this.value});

  final String label;
  final double value;
}

class AdminInterestRanking {
  const AdminInterestRanking({
    required this.rank,
    required this.name,
    required this.usersLabel,
    required this.marketShare,
    required this.icon,
    required this.barColor,
  });

  final int rank;
  final String name;
  final String usersLabel;
  final double marketShare;
  final IconData icon;
  final int barColor;
}

class AdminModerationIncident {
  const AdminModerationIncident({
    required this.reportId,
    required this.contentType,
    required this.contentId,
    required this.authorUserId,
    required this.authorName,
    required this.authorHandle,
    required this.postedLabel,
    required this.riskLabel,
    required this.content,
    this.mediaUrl,
    required this.likesLabel,
    required this.commentsLabel,
    required this.joinedLabel,
    required this.statusLabel,
    required this.followersLabel,
    required this.pendingReportsLabel,
    required this.reasonTags,
    required this.reportVolumeLabel,
    required this.reporterComments,
    required this.previousActions,
  });

  final String reportId;
  final AdminReportContentType contentType;
  final int contentId;
  final int authorUserId;
  final String authorName;
  final String authorHandle;
  final String postedLabel;
  final String riskLabel;
  final String content;
  final String? mediaUrl;
  final String likesLabel;
  final String commentsLabel;
  final String joinedLabel;
  final String statusLabel;
  final String followersLabel;
  final String pendingReportsLabel;
  final List<String> reasonTags;
  final String reportVolumeLabel;
  final List<String> reporterComments;
  final List<String> previousActions;
}

enum AdminModerationAction { warnUser, deleteContent, permanentBan }
