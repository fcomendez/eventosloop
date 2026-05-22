import 'package:eventosloop/core/theme/app_colors.dart';
import 'package:eventosloop/features/admin/models/admin_community_models.dart';
import 'package:eventosloop/features/admin/models/admin_models.dart';
import 'package:eventosloop/features/admin/navigation/admin_navigation.dart';
import 'package:eventosloop/features/admin/services/admin_mock_service.dart';
import 'package:eventosloop/features/admin/widgets/admin_shell.dart';
import 'package:flutter/material.dart';

class AdminCommunityManagementView extends StatefulWidget {
  const AdminCommunityManagementView({super.key});

  @override
  State<AdminCommunityManagementView> createState() =>
      _AdminCommunityManagementViewState();
}

class _AdminCommunityManagementViewState
    extends State<AdminCommunityManagementView> {
  final AdminMockService _service = AdminMockService();
  String _interestFilter = 'Todos los intereses';
  int _currentPage = 1;

  static const List<String> _interestFilters = <String>[
    'Todos los intereses',
    'Tecnologia',
    'Sostenibilidad',
    'Arte y diseno',
    'Bienestar',
  ];

  @override
  Widget build(BuildContext context) {
    final List<AdminCommunityRow> communities = _service.fetchCommunities();

    return AdminShell(
      selectedTopTab: AdminTopTab.community,
      selectedSidebar: AdminSidebarItem.userManagement,
      onTopTabChanged: (AdminTopTab tab) =>
          handleAdminTopTabNavigation(context, tab),
      onSidebarChanged: (AdminSidebarItem item) =>
          handleAdminSidebarNavigation(context, item, replace: true),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          AdminPageHeader(
            title: 'Gestion de comunidades',
            subtitle: 'Curacion y monitoreo de comunidades globales',
            trailing: <Widget>[
              OutlinedButton(
                onPressed: () {},
                child: const Text('Ajustes de filtros'),
              ),
              ElevatedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.add, size: 18),
                label: const Text('Nueva comunidad'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: AppColors.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: <Widget>[
              ..._interestFilters.map((String filter) {
                final bool active = filter == _interestFilter;
                return FilterChip(
                  label: Text(filter),
                  selected: active,
                  onSelected: (_) => setState(() => _interestFilter = filter),
                  selectedColor: AppColors.primaryDark,
                  checkmarkColor: AppColors.white,
                  labelStyle: TextStyle(
                    color: active ? AppColors.white : AppColors.primaryDark,
                    fontWeight: FontWeight.w700,
                    fontSize: 12,
                  ),
                  backgroundColor: AppColors.primary.withValues(alpha: 0.08),
                  side: BorderSide.none,
                );
              }),
              const SizedBox(width: 8),
              SizedBox(
                width: 220,
                height: 38,
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Buscar comunidades...',
                    hintStyle: const TextStyle(fontSize: 13),
                    prefixIcon: const Icon(Icons.search, size: 18),
                    contentPadding: EdgeInsets.zero,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          AdminSectionCard(
            padding: EdgeInsets.zero,
            child: Column(
              children: <Widget>[
                const Padding(
                  padding: EdgeInsets.fromLTRB(16, 14, 16, 10),
                  child: Row(
                    children: <Widget>[
                      Expanded(flex: 4, child: _TableHead('COMUNIDAD')),
                      Expanded(flex: 3, child: _TableHead('CREADOR LIDER')),
                      Expanded(flex: 2, child: _TableHead('ENGAGEMENT')),
                      Expanded(flex: 2, child: _TableHead('ESTADO')),
                      Expanded(flex: 2, child: _TableHead('ACCIONES')),
                    ],
                  ),
                ),
                const Divider(height: 1),
                ...communities.map((AdminCommunityRow row) {
                  return Column(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Expanded(
                              flex: 4,
                              child: Row(
                                children: <Widget>[
                                  Container(
                                    width: 44,
                                    height: 44,
                                    decoration: BoxDecoration(
                                      color: Color(row.thumbnailColor),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Text(
                                          row.name,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.w900,
                                            color: AppColors.textPrimary,
                                          ),
                                        ),
                                        Text(
                                          row.category,
                                          style: const TextStyle(
                                            fontSize: 11,
                                            color: AppColors.textSecondary,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              flex: 3,
                              child: Row(
                                children: <Widget>[
                                  const CircleAvatar(
                                    radius: 14,
                                    backgroundColor: AppColors.inputBackground,
                                    child: Icon(Icons.person,
                                        size: 14, color: AppColors.primary),
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      row.leadCreator,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    row.engagementLabel,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w900,
                                    ),
                                  ),
                                  Text(
                                    row.postsLabel,
                                    style: const TextStyle(
                                      fontSize: 11,
                                      color: AppColors.textSecondary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: _StatusPill(status: row.status),
                            ),
                            Expanded(
                              flex: 2,
                              child: Row(
                                children: <Widget>[
                                  IconButton(
                                    onPressed: () {},
                                    icon: const Icon(Icons.edit_outlined,
                                        size: 18),
                                    color: AppColors.textSecondary,
                                  ),
                                  IconButton(
                                    onPressed: () {},
                                    icon: Icon(
                                      row.canUnblock
                                          ? Icons.refresh
                                          : Icons.block_outlined,
                                      size: 18,
                                    ),
                                    color: row.canUnblock
                                        ? AppColors.primary
                                        : AppColors.error,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (row != communities.last)
                        const Divider(height: 1),
                    ],
                  );
                }),
              ],
            ),
          ),
          const SizedBox(height: 14),
          Row(
            children: <Widget>[
              const Text(
                'Mostrando 4 de 126 comunidades',
                style: TextStyle(
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const Spacer(),
              IconButton(
                onPressed: _currentPage > 1
                    ? () => setState(() => _currentPage--)
                    : null,
                icon: const Icon(Icons.chevron_left),
              ),
              ...List<Widget>.generate(3, (int index) {
                final int page = index + 1;
                final bool active = page == _currentPage;
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 2),
                  child: CircleAvatar(
                    radius: 14,
                    backgroundColor:
                        active ? AppColors.primaryDark : Colors.transparent,
                    child: Text(
                      '$page',
                      style: TextStyle(
                        color: active ? AppColors.white : AppColors.textSecondary,
                        fontWeight: FontWeight.w800,
                        fontSize: 12,
                      ),
                    ),
                  ),
                );
              }),
              IconButton(
                onPressed: () => setState(() => _currentPage = 2),
                icon: const Icon(Icons.chevron_right),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _TableHead extends StatelessWidget {
  const _TableHead(this.label);

  final String label;

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: const TextStyle(
        fontSize: 10,
        letterSpacing: 0.6,
        color: AppColors.textSecondary,
        fontWeight: FontWeight.w800,
      ),
    );
  }
}

class _StatusPill extends StatelessWidget {
  const _StatusPill({required this.status});

  final AdminCommunityStatus status;

  @override
  Widget build(BuildContext context) {
    final bool active = status == AdminCommunityStatus.active;
    final Color color = active ? const Color(0xFF2E9E6A) : AppColors.error;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Icon(
          active ? Icons.add_circle_outline : Icons.cancel_outlined,
          size: 14,
          color: color,
        ),
        const SizedBox(width: 4),
        Text(
          active ? 'Activa' : 'Bloqueada',
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
