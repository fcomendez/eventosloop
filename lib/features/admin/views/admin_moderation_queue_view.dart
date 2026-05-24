import 'package:eventosloop/core/theme/app_colors.dart';
import 'package:eventosloop/features/admin/models/admin_community_models.dart';
import 'package:eventosloop/features/admin/models/admin_models.dart';
import 'package:eventosloop/features/admin/navigation/admin_navigation.dart';
import 'package:eventosloop/features/admin/services/admin_supabase_service.dart';
import 'package:eventosloop/features/admin/widgets/admin_shell.dart';
import 'package:flutter/material.dart';

class AdminModerationQueueView extends StatefulWidget {
  const AdminModerationQueueView({super.key});

  @override
  State<AdminModerationQueueView> createState() =>
      _AdminModerationQueueViewState();
}

class _AdminModerationQueueViewState extends State<AdminModerationQueueView> {
  final AdminSupabaseService _service = AdminSupabaseService();
  bool _loading = true;
  List<AdminModerationStat> _stats = <AdminModerationStat>[];
  List<AdminReportQueueRow> _queue = <AdminReportQueueRow>[];
  String _filter = 'Todos';

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    try {
      final List<AdminModerationStat> stats =
          await _service.fetchModerationStats();
      final List<AdminReportQueueRow> queue = await _service.fetchReportQueue();
      if (mounted) {
        setState(() {
          _stats = stats;
          _queue = queue;
          _loading = false;
        });
      }
    } catch (_) {
      if (mounted) {
        setState(() => _loading = false);
      }
    }
  }

  List<AdminReportQueueRow> get _filteredQueue {
    return switch (_filter) {
      'Pendientes' => _queue
          .where((AdminReportQueueRow r) => r.status == AdminReportStatus.pending)
          .toList(),
      'Resueltos' => _queue
          .where((AdminReportQueueRow r) => r.status == AdminReportStatus.reviewed)
          .toList(),
      _ => _queue,
    };
  }

  int get _pendingCount => _queue
      .where((AdminReportQueueRow r) => r.status == AdminReportStatus.pending)
      .length;

  @override
  Widget build(BuildContext context) {
    final List<AdminReportQueueRow> queue = _filteredQueue;

    return AdminShell(
      selectedTopTab: AdminTopTab.dashboard,
      selectedSidebar: AdminSidebarItem.moderation,
      onTopTabChanged: (AdminTopTab tab) =>
          handleAdminTopTabNavigation(context, tab),
      onSidebarChanged: (AdminSidebarItem item) =>
          handleAdminSidebarNavigation(context, item, replace: true),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                AdminPageHeader(
                  title: 'Moderacion de contenido',
                  subtitle:
                      'Cola de reportes desde reporte_publicacion y reporte_evento.',
                  trailing: <Widget>[
                    if (_pendingCount > 0)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFCE8EA),
                          borderRadius: BorderRadius.circular(999),
                        ),
                        child: Text(
                          '$_pendingCount pendientes',
                          style: const TextStyle(
                            color: Color(0xFFD64545),
                            fontWeight: FontWeight.w800,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    IconButton(
                      onPressed: _load,
                      icon: const Icon(Icons.refresh),
                    ),
                  ],
                ),
                const SizedBox(height: 18),
                if (_stats.isNotEmpty)
                  LayoutBuilder(
                    builder: (BuildContext context, BoxConstraints constraints) {
                      final int columns = constraints.maxWidth >= 700 ? 3 : 1;
                      return GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: _stats.length,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: columns,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                          childAspectRatio: columns == 3 ? 1.8 : 2.4,
                        ),
                        itemBuilder: (BuildContext context, int index) {
                          final AdminModerationStat stat = _stats[index];
                          return AdminSectionCard(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(stat.label,
                                    style: const TextStyle(
                                        color: AppColors.textSecondary)),
                                const SizedBox(height: 8),
                                Text(stat.value,
                                    style: const TextStyle(
                                        fontSize: 30,
                                        fontWeight: FontWeight.w900)),
                                const Spacer(),
                                Text(stat.subtitle,
                                    style: TextStyle(
                                        color: Color(stat.subtitleColor),
                                        fontSize: 12)),
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
                              child: Text('Cola de reportes',
                                  style:
                                      TextStyle(fontWeight: FontWeight.w900)),
                            ),
                            DropdownButton<String>(
                              value: _filter,
                              items: const <DropdownMenuItem<String>>[
                                DropdownMenuItem(
                                    value: 'Todos', child: Text('Todos')),
                                DropdownMenuItem(
                                    value: 'Pendientes',
                                    child: Text('Pendientes')),
                                DropdownMenuItem(
                                    value: 'Resueltos',
                                    child: Text('Resueltos')),
                              ],
                              onChanged: (String? v) {
                                if (v != null) setState(() => _filter = v);
                              },
                            ),
                          ],
                        ),
                      ),
                      const Divider(height: 1),
                      if (queue.isEmpty)
                        const Padding(
                          padding: EdgeInsets.all(24),
                          child: Text('No hay reportes en la cola.'),
                        )
                      else
                        ...queue.map((AdminReportQueueRow row) {
                          return InkWell(
                            onTap: () => openAdminModerationReview(
                              context,
                              reportId: row.incidentReportId,
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Row(
                                children: <Widget>[
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Text(row.objectLabel,
                                            style: const TextStyle(
                                                fontWeight: FontWeight.w900)),
                                        Text(
                                          '${row.reporterHandle} · ${row.objectAuthor}',
                                          style: const TextStyle(
                                              fontSize: 12,
                                              color:
                                                  AppColors.textSecondary),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Text(row.reason,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.w700)),
                                  const SizedBox(width: 12),
                                  Text(
                                    row.status == AdminReportStatus.pending
                                        ? 'Pendiente'
                                        : 'Resuelto',
                                    style: TextStyle(
                                      color: row.status ==
                                              AdminReportStatus.pending
                                          ? const Color(0xFFE08A3A)
                                          : AppColors.primary,
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}
