import 'package:eventosloop/features/admin/services/admin_access_service.dart';
import 'package:eventosloop/features/admin/widgets/admin_access_gate.dart';
import 'package:eventosloop/features/admin/models/admin_models.dart';
import 'package:eventosloop/features/admin/views/admin_ad_console_view.dart';
import 'package:eventosloop/features/admin/views/admin_analytics_view.dart';
import 'package:eventosloop/features/admin/views/admin_community_management_view.dart';
import 'package:eventosloop/features/admin/views/admin_dashboard_view.dart';
import 'package:eventosloop/features/admin/views/admin_event_management_view.dart';
import 'package:eventosloop/features/admin/views/admin_moderation_queue_view.dart';
import 'package:eventosloop/features/admin/views/admin_moderation_review_view.dart';
import 'package:eventosloop/features/admin/views/admin_system_status_view.dart';
import 'package:eventosloop/features/admin/views/admin_user_management_view.dart';
import 'package:eventosloop/features/feed/views/feed_home_view.dart';
import 'package:flutter/material.dart';

final AdminAccessService _adminAccess = AdminAccessService();

Route<void> _adminRoute(Widget child) {
  return MaterialPageRoute<void>(
    builder: (_) => AdminAccessGate(child: child),
  );
}

Future<void> openAdminDashboard(BuildContext context) async {
  if (!await _adminAccess.puedeAccederAdmin()) {
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No tienes permisos de administrador.'),
        ),
      );
    }
    return;
  }
  if (context.mounted) {
    Navigator.of(context).push(_adminRoute(const AdminDashboardView()));
  }
}

void openAdminCommunityManagement(BuildContext context) {
  Navigator.of(context).push(_adminRoute(const AdminCommunityManagementView()));
}

void openAdminModerationQueue(BuildContext context) {
  Navigator.of(context).push(_adminRoute(const AdminModerationQueueView()));
}

void handleAdminSidebarNavigation(
  BuildContext context,
  AdminSidebarItem item, {
  bool replace = false,
}) {
  final Widget target = switch (item) {
    AdminSidebarItem.userManagement => const AdminUserManagementView(),
    AdminSidebarItem.contentFeed => const AdminEventManagementView(),
    AdminSidebarItem.moderation => const AdminModerationQueueView(),
    AdminSidebarItem.adConsole => const AdminAdConsoleView(),
    AdminSidebarItem.systemStatus => const AdminSystemStatusView(),
  };

  final Route<void> route = _adminRoute(target);
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
    final Route<void> route = _adminRoute(const AdminCommunityManagementView());
    if (replace) {
      Navigator.of(context).pushReplacement(route);
    } else {
      Navigator.of(context).push(route);
    }
    return;
  }
  if (tab == AdminTopTab.analytics) {
    final Route<void> route = _adminRoute(const AdminAnalyticsView());
    if (replace) {
      Navigator.of(context).pushReplacement(route);
    } else {
      Navigator.of(context).push(route);
    }
    return;
  }
  if (tab == AdminTopTab.dashboard) {
    final Route<void> route = _adminRoute(const AdminDashboardView());
    if (replace) {
      Navigator.of(context).pushReplacement(route);
    } else {
      Navigator.of(context).push(route);
    }
  }
}

void openAdminModerationReview(BuildContext context, {String? reportId}) {
  Navigator.of(context).push(
    _adminRoute(AdminModerationReviewView(reportId: reportId)),
  );
}

void exitAdminToFeed(BuildContext context) {
  Navigator.of(context).pushAndRemoveUntil(
    MaterialPageRoute<void>(
      builder: (_) => const FeedHomeView(email: ''),
    ),
    (Route<dynamic> route) => false,
  );
}
