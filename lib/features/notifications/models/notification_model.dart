enum NotificationType {
  evento,
  comunidad,
  mencion,
  recordatorio,
  comentario,
  solicitud,
}

class NotificationModel {
  const NotificationModel({
    required this.id,
    required this.type,
    required this.title,
    required this.body,
    required this.timeLabel,
    required this.groupLabel,
    required this.isUnread,
    required this.authorInitials,
    this.quote,
    this.eventId,
    this.communityId,
    this.postId,
    this.userId,
  });

  final int id;
  final NotificationType type;
  final String title;
  final String body;
  final String timeLabel;
  final String groupLabel;
  final bool isUnread;
  final String authorInitials;
  final String? quote;
  final int? eventId;
  final int? communityId;
  final int? postId;
  final int? userId;
}
