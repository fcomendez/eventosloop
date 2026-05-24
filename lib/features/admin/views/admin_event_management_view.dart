import 'package:eventosloop/core/navigation/detail_navigation.dart';
import 'package:eventosloop/core/theme/app_colors.dart';
import 'package:eventosloop/features/admin/models/admin_directory_models.dart';
import 'package:eventosloop/features/admin/models/admin_models.dart';
import 'package:eventosloop/features/admin/navigation/admin_navigation.dart';
import 'package:eventosloop/features/admin/services/admin_supabase_service.dart';
import 'package:eventosloop/features/admin/widgets/admin_shell.dart';
import 'package:flutter/material.dart';

class AdminEventManagementView extends StatefulWidget {
  const AdminEventManagementView({super.key});

  @override
  State<AdminEventManagementView> createState() =>
      _AdminEventManagementViewState();
}

class _AdminEventManagementViewState extends State<AdminEventManagementView> {
  final AdminSupabaseService _service = AdminSupabaseService();
  bool _loading = true;
  List<AdminEventStat> _stats = <AdminEventStat>[];
  List<AdminEventRow> _events = <AdminEventRow>[];

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    try {
      final List<AdminEventStat> stats = await _service.fetchEventStats();
      final List<AdminEventRow> events = await _service.fetchEvents();
      if (mounted) {
        setState(() {
          _stats = stats;
          _events = events;
          _loading = false;
        });
      }
    } catch (_) {
      if (mounted) {
        setState(() => _loading = false);
      }
    }
  }

  Future<void> _cancelEvent(AdminEventRow event) async {
    final bool? confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Cancelar evento'),
        content: Text('¿Cancelar "${event.name}"?'),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('No'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Si, cancelar'),
          ),
        ],
      ),
    );
    if (confirm != true) {
      return;
    }
    try {
      await _service.cancelEvent(event.idEvento);
      await _load();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Evento cancelado')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AdminShell(
      selectedTopTab: AdminTopTab.dashboard,
      selectedSidebar: AdminSidebarItem.contentFeed,
      onTopTabChanged: (AdminTopTab tab) =>
          handleAdminTopTabNavigation(context, tab),
      onSidebarChanged: (AdminSidebarItem item) =>
          handleAdminSidebarNavigation(context, item, replace: true),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            'Gestion de eventos',
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                          SizedBox(height: 6),
                          Text(
                            'Listado real desde public.evento.',
                            style: TextStyle(color: AppColors.textSecondary),
                          ),
                        ],
                      ),
                    ),
                    IconButton(onPressed: _load, icon: const Icon(Icons.refresh)),
                  ],
                ),
                const SizedBox(height: 18),
                if (_stats.isNotEmpty)
                  LayoutBuilder(
                    builder: (BuildContext context, BoxConstraints constraints) {
                      final int columns = constraints.maxWidth >= 700 ? 4 : 2;
                      return GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: _stats.length,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: columns,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                          childAspectRatio: 2.8,
                        ),
                        itemBuilder: (BuildContext context, int index) {
                          final AdminEventStat stat = _stats[index];
                          return AdminSectionCard(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Text(stat.label,
                                    style: const TextStyle(
                                        color: AppColors.textSecondary)),
                                Text(stat.value,
                                    style: const TextStyle(
                                        fontSize: 26,
                                        fontWeight: FontWeight.w900)),
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
                  child: _events.isEmpty
                      ? const Padding(
                          padding: EdgeInsets.all(24),
                          child: Text('No hay eventos registrados.'),
                        )
                      : Column(
                          children: _events.map((AdminEventRow event) {
                            return ListTile(
                              onTap: () => openEventDetail(context, event.idEvento),
                              leading: CircleAvatar(
                                backgroundColor: Color(event.iconColor),
                                child: const Icon(Icons.event, color: Colors.white),
                              ),
                              title: Text(event.name,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w900)),
                              subtitle: Text(
                                '${event.dateLabel} · ${event.community} · '
                                '${event.participantsLabel} participantes · ${event.chatDetail}',
                              ),
                              trailing: event.chatDetail == 'CANCELADO'
                                  ? const Text('Cancelado',
                                      style: TextStyle(
                                          color: AppColors.textSecondary))
                                  : IconButton(
                                      icon: Icon(
                                        Icons.cancel_outlined,
                                        color: event.needsModeration
                                            ? AppColors.error
                                            : AppColors.textSecondary,
                                      ),
                                      tooltip: 'Cancelar evento',
                                      onPressed: () => _cancelEvent(event),
                                    ),
                            );
                          }).toList(),
                        ),
                ),
              ],
            ),
    );
  }
}
