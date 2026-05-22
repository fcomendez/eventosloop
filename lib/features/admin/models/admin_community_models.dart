import 'package:flutter/material.dart';

enum AdminCommunityStatus { active, banned }

class AdminCommunityRow {
  const AdminCommunityRow({
    required this.id,
    required this.name,
    required this.category,
    required this.leadCreator,
    required this.engagementLabel,
    required this.postsLabel,
    required this.status,
    required this.thumbnailColor,
    required this.canUnblock,
  });

  final int id;
  final String name;
  final String category;
  final String leadCreator;
  final String engagementLabel;
  final String postsLabel;
  final AdminCommunityStatus status;
  final int thumbnailColor;
  final bool canUnblock;
}

class AdminModerationStat {
  const AdminModerationStat({
    required this.label,
    required this.value,
    required this.subtitle,
    required this.subtitleColor,
    required this.icon,
  });

  final String label;
  final String value;
  final String subtitle;
  final int subtitleColor;
  final IconData icon;
}

enum AdminReportStatus { pending, reviewed }

class AdminReportQueueRow {
  const AdminReportQueueRow({
    required this.id,
    required this.dateLabel,
    required this.reporterHandle,
    required this.objectLabel,
    required this.objectAuthor,
    required this.reason,
    required this.reasonColor,
    required this.status,
    required this.actionLabel,
    required this.incidentReportId,
  });

  final String id;
  final String dateLabel;
  final String reporterHandle;
  final String objectLabel;
  final String objectAuthor;
  final String reason;
  final int reasonColor;
  final AdminReportStatus status;
  final String actionLabel;
  final String incidentReportId;
}
