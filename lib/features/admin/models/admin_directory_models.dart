enum AdminUserStatus { active, pending, suspended }

class AdminUserRow {
  const AdminUserRow({
    required this.name,
    required this.email,
    required this.role,
    required this.interests,
    required this.joinedLabel,
    required this.status,
    required this.avatarColor,
  });

  final String name;
  final String email;
  final String role;
  final List<String> interests;
  final String joinedLabel;
  final AdminUserStatus status;
  final int avatarColor;
}

enum AdminEventType { publicEvent, privateEvent }

enum AdminEventChatStatus { active, quiet, moderationRequired }

class AdminEventRow {
  const AdminEventRow({
    required this.name,
    required this.dateLabel,
    required this.community,
    required this.type,
    required this.participantsLabel,
    required this.chatStatus,
    required this.chatDetail,
    required this.iconColor,
    required this.needsModeration,
  });

  final String name;
  final String dateLabel;
  final String community;
  final AdminEventType type;
  final String participantsLabel;
  final AdminEventChatStatus chatStatus;
  final String chatDetail;
  final int iconColor;
  final bool needsModeration;
}

class AdminEventStat {
  const AdminEventStat({
    required this.label,
    required this.value,
  });

  final String label;
  final String value;
}
