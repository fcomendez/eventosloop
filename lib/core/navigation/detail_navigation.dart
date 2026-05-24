import 'package:eventosloop/features/communities/views/community_detail_view.dart';
import 'package:eventosloop/features/events/views/event_detail_view.dart';
import 'package:eventosloop/features/events/views/participant_requests_view.dart';
import 'package:eventosloop/features/notifications/views/notifications_view.dart';
import 'package:eventosloop/features/posts/views/post_detail_view.dart';
import 'package:eventosloop/features/profile/views/profile_view.dart';
import 'package:flutter/material.dart';

void openEventDetail(BuildContext context, int eventId) {
  Navigator.of(context).push(
    MaterialPageRoute<void>(
      builder: (_) => EventDetailView(eventId: eventId),
    ),
  );
}

void openCommunityDetail(BuildContext context, int communityId) {
  Navigator.of(context).push(
    MaterialPageRoute<void>(
      builder: (_) => CommunityDetailView(communityId: communityId),
    ),
  );
}

void openPostDetail(BuildContext context, int postId) {
  Navigator.of(context).push(
    MaterialPageRoute<void>(
      builder: (_) => PostDetailView(postId: postId),
    ),
  );
}

void openUserProfile(BuildContext context, int userId) {
  Navigator.of(context).push(
    MaterialPageRoute<void>(
      builder: (_) => ProfileView(userId: userId),
    ),
  );
}

void openNotifications(BuildContext context) {
  Navigator.of(context).push(
    MaterialPageRoute<void>(
      builder: (_) => const NotificationsView(),
    ),
  );
}

void openParticipantRequests(
  BuildContext context, {
  required int eventId,
  required String eventTitle,
}) {
  Navigator.of(context).push(
    MaterialPageRoute<void>(
      builder: (_) => ParticipantRequestsView(
        eventId: eventId,
        eventTitle: eventTitle,
      ),
    ),
  );
}
