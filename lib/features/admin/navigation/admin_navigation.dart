import 'package:eventosloop/features/admin/models/admin_models.dart';
import 'package:eventosloop/features/admin/views/admin_analytics_view.dart';
import 'package:eventosloop/features/admin/views/admin_community_management_view.dart';
import 'package:eventosloop/features/admin/views/admin_dashboard_view.dart';
import 'package:eventosloop/features/admin/views/admin_event_management_view.dart';
import 'package:eventosloop/features/admin/views/admin_moderation_queue_view.dart';
import 'package:eventosloop/features/admin/views/admin_moderation_review_view.dart';
import 'package:eventosloop/features/admin/views/admin_user_management_view.dart';
import 'package:flutter/material.dart';

void openAdminDashboard(BuildContext context) {
  Navigator.of(context).push(
    MaterialPageRoute<void>(builder: (_) => const AdminDashboardView()),
  );
}

void openAdminCommunityManagement(BuildContext context) {
  Navigator.of(context).push(
    MaterialPageRoute<void>(builder: (_) => const AdminCommunityManagementView()),
  );
}

void openAdminModerationQueue(BuildContext context) {
  Navigator.of(context).push(
    MaterialPageRoute<void>(builder: (_) => const AdminModerationQueueView()),
  );
}

void handleAdminSidebarNavigation(
  BuildContext context,
  AdminSidebarItem item, {
  bool replace = false,
}) {
  final Widget? target = switch (item) {
    AdminSidebarItem.userManagement => const AdminUserManagementView(),
    AdminSidebarItem.contentFeed => const AdminEventManagementView(),
    AdminSidebarItem.moderation => const AdminModerationQueueView(),
    AdminSidebarItem.adConsole || AdminSidebarItem.systemStatus => null,
  };

  if (target == null) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('${item.name} — proximamente')),
    );
    return;
  }

  final Route<void> route = MaterialPageRoute<void>(builder: (_) => target);
  if (replace) {
    Navigator.of(context).pushReplacement(route);
  } else {
    Navigator.of(context).push(route);
  }
}

void handleAdminTopTabNavigation(
  BuildContext context,
  AdminTopTab tab, {
  bool replace = true,
}) {
  if (tab == AdminTopTab.community) {
    final Route<void> route = MaterialPageRoute<void>(
      builder: (_) => const AdminCommunityManagementView(),
    );
    if (replace) {
      Navigator.of(context).pushReplacement(route);
    } else {
      Navigator.of(context).push(route);
    }
    return;
  }
  if (tab == AdminTopTab.analytics) {
    final Route<void> route = MaterialPageRoute<void>(
      builder: (_) => const AdminAnalyticsView(),
    );
    if (replace) {
      Navigator.of(context).pushReplacement(route);
    } else {
      Navigator.of(context).push(route);
    }
    return;
  }
  if (tab == AdminTopTab.dashboard) {
    final Route<void> route = MaterialPageRoute<void>(
      builder: (_) => const AdminDashboardView(),
    );
    if (replace) {
      Navigator.of(context).pushReplacement(route);
    } else {
      Navigator.of(context).push(route);
    }
  }
}

void openAdminModerationReview(BuildContext context, {String? reportId}) {
  Navigator.of(context).push(
    MaterialPageRoute<void>(
      builder: (_) => AdminModerationReviewView(reportId: reportId),
    ),
  );
}
