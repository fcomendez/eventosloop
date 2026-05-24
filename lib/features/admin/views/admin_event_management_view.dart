import 'package:eventosloop/core/theme/app_colors.dart';
import 'package:eventosloop/features/admin/models/admin_directory_models.dart';
import 'package:eventosloop/features/admin/models/admin_models.dart';
import 'package:eventosloop/features/admin/navigation/admin_navigation.dart';
import 'package:eventosloop/features/admin/services/admin_mock_service.dart';
import 'package:eventosloop/features/admin/widgets/admin_shell.dart';
import 'package:flutter/material.dart';

class AdminEventManagementView extends StatefulWidget {
  const AdminEventManagementView({super.key});

  @override
  State<AdminEventManagementView> createState() =>
      _AdminEventManagementViewState();
}

class _AdminEventManagementViewState extends State<AdminEventManagementView> {
  final AdminMockService _service = AdminMockService();
  int _page = 1;

  @override
  Widget build(BuildContext context) {
    final List<AdminEventStat> stats = _service.fetchEventStats();
    final List<AdminEventRow> events = _service.fetchLiveEvents();

    return AdminShell(
      selectedTopTab: AdminTopTab.dashboard,
      selectedSidebar: AdminSidebarItem.contentFeed,
      onTopTabChanged: (AdminTopTab tab) =>
          handleAdminTopTabNavigation(context, tab),
      onSidebarChanged: (AdminSidebarItem item) =>
          handleAdminSidebarNavigation(context, item, replace: true),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const Text(
            'Gestion de eventos',
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 28,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            'Supervisa encuentros comunitarios, audita conversaciones y gestiona la participacion en la red LOOP.',
            style: TextStyle(color: AppColors.textSecondary, height: 1.35),
          ),
          const SizedBox(height: 18),
          LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
              final int columns = constraints.maxWidth >= 700 ? 4 : 2;
              return GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: stats.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: columns,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: columns == 4 ? 2.2 : 2.0,
                ),
                itemBuilder: (BuildContext context, int index) {
                  final AdminEventStat stat = stats[index];
                  return AdminSectionCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          stat.label,
                          style: const TextStyle(
                            color: AppColors.textSecondary,
                            fontWeight: FontWeight.w700,
                            fontSize: 13,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          stat.value,
                          style: const TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.w900,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              );
            },
          ),
          const SizedBox(height: 18),
          AdminSectionCard(
            padding: EdgeInsets.zero,
            child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 14, 16, 10),
                  child: Row(
                    children: <Widget>[
                      const Expanded(
                        child: Text(
                          'Eventos en vivo',
                          style: TextStyle(
                            fontWeight: FontWeight.w900,
                            fontSize: 18,
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFF2E9E6A).withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: const Text(
                          'EN VIVO',
                          style: TextStyle(
                            color: Color(0xFF2E9E6A),
                            fontSize: 10,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ),
                      const SizedBox(width: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.inputBackground,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: const Text(
                          'AUTOACTUALIZACION',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w800,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      OutlinedButton(onPressed: () {}, child: const Text('Filtrar')),
                      const SizedBox(width: 8),
                      OutlinedButton(onPressed: () {}, child: const Text('Exportar CSV')),
                    ],
                  ),
                ),
                const Divider(height: 1),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(minWidth: 820),
                    child: Column(
                      children: <Widget>[
                        const Padding(
                          padding: EdgeInsets.fromLTRB(16, 10, 16, 10),
                          child: Row(
                            children: <Widget>[
                              SizedBox(width: 180, child: _Head('EVENTO')),
                              SizedBox(width: 140, child: _Head('COMUNIDAD')),
                              SizedBox(width: 90, child: _Head('TIPO')),
                              SizedBox(width: 110, child: _Head('PARTICIPANTES')),
                              SizedBox(width: 160, child: _Head('ESTADO CHAT')),
                              SizedBox(width: 100, child: _Head('ACCIONES')),
                            ],
                          ),
                        ),
                        ...events.map((AdminEventRow event) {
                          return Column(
                            children: <Widget>[
                              Container(
                                color: event.needsModeration
                                    ? AppColors.error.withValues(alpha: 0.04)
                                    : null,
                                padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    SizedBox(
                                      width: 180,
                                      child: Row(
                                        children: <Widget>[
                                          Container(
                                            width: 36,
                                            height: 36,
                                            decoration: BoxDecoration(
                                              color: Color(event.iconColor),
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                            child: const Icon(
                                              Icons.event_outlined,
                                              color: AppColors.white,
                                              size: 18,
                                            ),
                                          ),
                                          const SizedBox(width: 8),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: <Widget>[
                                                Text(
                                                  event.name,
                                                  style: const TextStyle(
                                                    fontWeight: FontWeight.w900,
                                                    fontSize: 12,
                                                  ),
                                                ),
                                                Text(
                                                  event.dateLabel,
                                                  style: const TextStyle(
                                                    fontSize: 11,
                                                    color: AppColors.textSecondary,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      width: 140,
                                      child: Text(
                                        event.community,
                                        style: const TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 90,
                                      child: _TypeBadge(type: event.type),
                                    ),
                                    SizedBox(
                                      width: 110,
                                      child: Row(
                                        children: <Widget>[
                                          const CircleAvatar(
                                            radius: 10,
                                            backgroundColor:
                                                AppColors.inputBackground,
                                            child: Icon(Icons.person,
                                                size: 10, color: AppColors.primary),
                                          ),
                                          const SizedBox(width: 4),
                                          Text(
                                            event.participantsLabel,
                                            style: const TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      width: 160,
                                      child: _ChatStatusPill(
                                        status: event.chatStatus,
                                        detail: event.chatDetail,
                                      ),
                                    ),
                                    SizedBox(
                                      width: 100,
                                      child: OutlinedButton(
                                        onPressed: () {},
                                        style: OutlinedButton.styleFrom(
                                          foregroundColor: event.needsModeration
                                              ? AppColors.error
                                              : AppColors.primary,
                                          side: BorderSide(
                                            color: event.needsModeration
                                                ? AppColors.error
                                                : AppColors.divider,
                                          ),
                                        ),
                                        child: const Text(
                                          'Auditar chat',
                                          style: TextStyle(fontSize: 11),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              if (event != events.last)
                                const Divider(height: 1),
                            ],
                          );
                        }),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: Row(
                    children: <Widget>[
                      const Text(
                        'Mostrando 4 de 1.284 eventos',
                        style: TextStyle(
                          color: AppColors.textSecondary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const Spacer(),
                      IconButton(
                        onPressed: _page > 1 ? () => setState(() => _page--) : null,
                        icon: const Icon(Icons.chevron_left),
                      ),
                      ...List<Widget>.generate(3, (int i) {
                        final int p = i + 1;
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 2),
                          child: Text(
                            '$p',
                            style: TextStyle(
                              fontWeight:
                                  p == _page ? FontWeight.w900 : FontWeight.w600,
                              color: p == _page
                                  ? AppColors.primary
                                  : AppColors.textSecondary,
                            ),
                          ),
                        );
                      }),
                      IconButton(
                        onPressed: () => setState(() => _page = 2),
                        icon: const Icon(Icons.chevron_right),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Head extends StatelessWidget {
  const _Head(this.label);

  final String label;

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: const TextStyle(
        fontSize: 10,
        letterSpacing: 0.5,
        color: AppColors.textSecondary,
        fontWeight: FontWeight.w800,
      ),
    );
  }
}

class _TypeBadge extends StatelessWidget {
  const _TypeBadge({required this.type});

  final AdminEventType type;

  @override
  Widget build(BuildContext context) {
    final bool isPublic = type == AdminEventType.publicEvent;
    final Color color =
        isPublic ? AppColors.primary : const Color(0xFF7B61B5);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        isPublic ? 'PUBLICO' : 'PRIVADO',
        style: TextStyle(
          color: color,
          fontSize: 10,
          fontWeight: FontWeight.w900,
        ),
      ),
    );
  }
}

class _ChatStatusPill extends StatelessWidget {
  const _ChatStatusPill({
    required this.status,
    required this.detail,
  });

  final AdminEventChatStatus status;
  final String detail;

  @override
  Widget build(BuildContext context) {
    final Color color = switch (status) {
      AdminEventChatStatus.active => const Color(0xFF2E9E6A),
      AdminEventChatStatus.quiet => AppColors.textSecondary,
      AdminEventChatStatus.moderationRequired => AppColors.error,
    };
    return Row(
      children: <Widget>[
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 6),
        Expanded(
          child: Text(
            detail,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.w700,
              fontSize: 11,
            ),
          ),
        ),
      ],
    );
  }
}
