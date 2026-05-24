class ParticipantRequestModel {
  const ParticipantRequestModel({
    required this.id,
    required this.userName,
    required this.userInitials,
    required this.communityName,
    required this.category,
    required this.skills,
    required this.eventId,
  });

  final int id;
  final String userName;
  final String userInitials;
  final String communityName;
  final String category;
  final List<String> skills;
  final int eventId;
}
