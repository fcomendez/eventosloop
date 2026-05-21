import 'package:eventosloop/features/communities/views/community_detail_view.dart';
import 'package:eventosloop/features/events/views/event_detail_view.dart';
import 'package:eventosloop/features/posts/views/post_detail_view.dart';
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
