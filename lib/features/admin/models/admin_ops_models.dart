enum AdminAdCampaignStatus { running, paused, scheduled, ended }

class AdminAdCampaignRow {
  const AdminAdCampaignRow({
    required this.name,
    required this.placement,
    required this.budgetLabel,
    required this.impressionsLabel,
    required this.ctrLabel,
    required this.status,
    required this.accentColor,
  });

  final String name;
  final String placement;
  final String budgetLabel;
  final String impressionsLabel;
  final String ctrLabel;
  final AdminAdCampaignStatus status;
  final int accentColor;
}

class AdminAdStat {
  const AdminAdStat({required this.label, required this.value});

  final String label;
  final String value;
}

enum AdminServiceHealth { operational, degraded, down }

class AdminServiceStatusRow {
  const AdminServiceStatusRow({
    required this.name,
    required this.description,
    required this.health,
    required this.latencyLabel,
    required this.uptimeLabel,
  });

  final String name;
  final String description;
  final AdminServiceHealth health;
  final String latencyLabel;
  final String uptimeLabel;
}

class AdminSystemIncidentRow {
  const AdminSystemIncidentRow({
    required this.timeLabel,
    required this.service,
    required this.message,
    required this.severityColor,
  });

  final String timeLabel;
  final String service;
  final String message;
  final int severityColor;
}
