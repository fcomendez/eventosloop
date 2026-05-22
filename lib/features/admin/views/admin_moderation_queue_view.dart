import 'package:eventosloop/core/theme/app_colors.dart';
import 'package:eventosloop/features/admin/models/admin_community_models.dart';
import 'package:eventosloop/features/admin/models/admin_models.dart';
import 'package:eventosloop/features/admin/navigation/admin_navigation.dart';
import 'package:eventosloop/features/admin/services/admin_mock_service.dart';
import 'package:eventosloop/features/admin/widgets/admin_shell.dart';
import 'package:flutter/material.dart';

class AdminModerationQueueView extends StatefulWidget {
  const AdminModerationQueueView({super.key});

  @override
  State<AdminModerationQueueView> createState() =>
      _AdminModerationQueueViewState();
}

class _AdminModerationQueueViewState extends State<AdminModerationQueueView> {
  final AdminMockService _service = AdminMockService();
  int _page = 1;

  @override
  Widget build(BuildContext context) {
    final List<AdminModerationStat> stats = _service.fetchModerationStats();
    final List<AdminReportQueueRow> queue = _service.fetchReportQueue();

    return AdminShell(
      selectedTopTab: AdminTopTab.dashboard,
      selectedSidebar: AdminSidebarItem.moderation,
      onTopTabChanged: (AdminTopTab tab) =>
          handleAdminTopTabNavigation(context, tab),
      onSidebarChanged: (AdminSidebarItem item) =>
          handleAdminSidebarNavigation(context, item, replace: true),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'Moderacion de contenido',
                      style: TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 28,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    SizedBox(height: 6),
                    Text(
                      'Priorizamos la seguridad y los estandares comunitarios en todo el ecosistema LOOP.',
                      style: TextStyle(color: AppColors.textSecondary, height: 1.35),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: const Color(0xFFFCE8EA),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: const Text(
                  '12 reportes criticos',
                  style: TextStyle(
                    color: Color(0xFFD64545),
                    fontWeight: FontWeight.w800,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
              final int columns = constraints.maxWidth >= 700 ? 3 : 1;
              return GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: stats.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: columns,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: columns == 3 ? 1.8 : 2.4,
                ),
                itemBuilder: (BuildContext context, int index) {
                  final AdminModerationStat stat = stats[index];
                  return AdminSectionCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          stat.label,
                          style: const TextStyle(
                            color: AppColors.textSecondary,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          stat.value,
                          style: const TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.w900,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const Spacer(),
                        Row(
                          children: <Widget>[
                            Icon(stat.icon,
                                size: 16, color: Color(stat.subtitleColor)),
                            const SizedBox(width: 4),
                            Text(
                              stat.subtitle,
                              style: TextStyle(
                                color: Color(stat.subtitleColor),
                                fontWeight: FontWeight.w700,
                                fontSize: 12,
                              ),
                            ),
                          ],
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
                          'Cola de reportes activa',
                          style: TextStyle(
                            fontWeight: FontWeight.w900,
                            fontSize: 18,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ),
                      OutlinedButton(onPressed: () {}, child: const Text('Filtrar')),
                      const SizedBox(width: 8),
                      OutlinedButton(onPressed: () {}, child: const Text('Exportar')),
                    ],
                  ),
                ),
                const Divider(height: 1),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(minWidth: 720),
                    child: Column(
                      children: <Widget>[
                        const Padding(
                          padding: EdgeInsets.fromLTRB(16, 10, 16, 10),
                          child: Row(
                            children: <Widget>[
                              SizedBox(width: 110, child: _Head('FECHA')),
                              SizedBox(width: 120, child: _Head('REPORTADO POR')),
                              SizedBox(width: 180, child: _Head('OBJETO REPORTADO')),
                              SizedBox(width: 120, child: _Head('MOTIVO')),
                              SizedBox(width: 100, child: _Head('ESTADO')),
                              SizedBox(width: 120, child: _Head('ACCIONES')),
                            ],
                          ),
                        ),
                        ...queue.map((AdminReportQueueRow row) {
                          return InkWell(
                            onTap: () => openAdminModerationReview(
                              context,
                              reportId: row.incidentReportId,
                            ),
                            child: Column(
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: <Widget>[
                                      SizedBox(
                                        width: 110,
                                        child: Text(
                                          row.dateLabel,
                                          style: const TextStyle(fontSize: 12),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 120,
                                        child: Row(
                                          children: <Widget>[
                                            const CircleAvatar(
                                              radius: 12,
                                              backgroundColor:
                                                  AppColors.inputBackground,
                                              child: Icon(Icons.person,
                                                  size: 12, color: AppColors.primary),
                                            ),
                                            const SizedBox(width: 6),
                                            Expanded(
                                              child: Text(
                                                row.reporterHandle,
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.w700,
                                                  fontSize: 12,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(
                                        width: 180,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Text(
                                              row.objectLabel,
                                              style: const TextStyle(
                                                fontWeight: FontWeight.w800,
                                                fontSize: 12,
                                              ),
                                            ),
                                            Text(
                                              row.objectAuthor,
                                              style: const TextStyle(
                                                fontSize: 11,
                                                color: AppColors.textSecondary,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(
                                        width: 120,
                                        child: _ReasonTag(
                                          label: row.reason,
                                          color: row.reasonColor,
                                        ),
                                      ),
                                      SizedBox(
                                        width: 100,
                                        child: _StatusDot(status: row.status),
                                      ),
                                      SizedBox(
                                        width: 120,
                                        child: Text(
                                          row.actionLabel,
                                          style: const TextStyle(
                                            fontSize: 11,
                                            color: AppColors.textSecondary,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                if (row != queue.last) const Divider(height: 1),
                              ],
                            ),
                          );
                        }),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
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
                              fontWeight: p == _page ? FontWeight.w900 : FontWeight.w600,
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
          const SizedBox(height: 16),
          LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
              final bool wide = constraints.maxWidth >= 700;
              final Widget cards = Column(
                children: <Widget>[
                  _InfoCard(
                    icon: Icons.shield_outlined,
                    title: 'Normas comunitarias V.8',
                    body:
                        'Contrasta denuncias de acoso con las ultimas actualizaciones de politica antes de aplicar sanciones.',
                  ),
                  const SizedBox(height: 12),
                  Stack(
                    clipBehavior: Clip.none,
                    children: <Widget>[
                      _InfoCard(
                        icon: Icons.auto_awesome_outlined,
                        title: 'Orden inteligente activo',
                        body:
                            'La cola prioriza severidad, volumen de reportes e historial del autor.',
                      ),
                      Positioned(
                        right: 12,
                        bottom: -18,
                        child: ElevatedButton.icon(
                          onPressed: () {},
                          icon: const Icon(Icons.check_circle_outline, size: 18),
                          label: const Text('Resolver todo rapido'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            foregroundColor: AppColors.white,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 12,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  if (!wide) const SizedBox(height: 28),
                ],
              );
              if (!wide) {
                return cards;
              }
              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Expanded(child: cards),
                ],
              );
            },
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

class _ReasonTag extends StatelessWidget {
  const _ReasonTag({required this.label, required this.color});

  final String label;
  final int color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Color(color).withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: Color(color),
          fontSize: 11,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }
}

class _StatusDot extends StatelessWidget {
  const _StatusDot({required this.status});

  final AdminReportStatus status;

  @override
  Widget build(BuildContext context) {
    final bool pending = status == AdminReportStatus.pending;
    final Color color =
        pending ? const Color(0xFFE08A3A) : AppColors.primary;
    return Row(
      children: <Widget>[
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 6),
        Text(
          pending ? 'Pendiente' : 'Revisado',
          style: TextStyle(
            color: color,
            fontWeight: FontWeight.w800,
            fontSize: 12,
          ),
        ),
      ],
    );
  }
}

class _InfoCard extends StatelessWidget {
  const _InfoCard({
    required this.icon,
    required this.title,
    required this.body,
  });

  final IconData icon;
  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    return AdminSectionCard(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Icon(icon, color: AppColors.primary),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w900,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  body,
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    height: 1.35,
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
