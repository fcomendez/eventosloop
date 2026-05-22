import 'package:eventosloop/features/events/models/event_status.dart';

class EventModel {
  const EventModel({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.hostName,
    required this.dateLabel,
    required this.timeLabel,
    required this.address,
    required this.locationName,
    required this.comuna,
    required this.latitude,
    required this.longitude,
    required this.capacity,
    required this.joinedCount,
    required this.coverColorHex,
    required this.communityId,
    this.subCategory,
    this.isFlash = false,
    this.isHighlighted = false,
    this.isPrivate = false,
    this.whatsappLink,
    this.isHostedByMe = false,
    this.status = EventStatus.active,
    this.hostAvatarUrl,
  });

  final int id;
  final String title;
  final String description;
  final String category;
  final String? subCategory;
  final String hostName;
  final String dateLabel;
  final String timeLabel;
  final String address;
  final String locationName;
  final String comuna;
  final double latitude;
  final double longitude;
  final int capacity;
  final int joinedCount;
  final String coverColorHex;
  final int communityId;
  final bool isFlash;
  final bool isHighlighted;
  final bool isPrivate;
  final String? whatsappLink;
  final bool isHostedByMe;
  final EventStatus status;
  final String? hostAvatarUrl;

  double get capacityProgress =>
      capacity <= 0 ? 0 : (joinedCount / capacity).clamp(0, 1);

  bool get isDeleted => status == EventStatus.deleted;

  bool get isSuspended => status == EventStatus.suspended;

  bool get isJoinableByParticipants =>
      status == EventStatus.active && !isHostedByMe;
}
