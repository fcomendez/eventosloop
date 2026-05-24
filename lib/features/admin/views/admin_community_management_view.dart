import 'package:eventosloop/core/config/app_env.dart';
import 'package:eventosloop/core/theme/app_colors.dart';
import 'package:eventosloop/features/admin/models/admin_community_models.dart';
import 'package:eventosloop/features/admin/models/admin_models.dart';
import 'package:eventosloop/features/admin/navigation/admin_navigation.dart';
import 'package:eventosloop/features/admin/services/admin_mock_service.dart';
import 'package:eventosloop/features/admin/widgets/admin_community_actions_dialog.dart';
import 'package:eventosloop/features/admin/widgets/admin_shell.dart';
import 'package:eventosloop/features/communities/models/community_list_item.dart';
import 'package:eventosloop/features/communities/services/community_supabase_service.dart';
import 'package:flutter/material.dart';

class AdminCommunityManagementView extends StatefulWidget {
  const AdminCommunityManagementView({super.key});

  @override
  State<AdminCommunityManagementView> createState() =>
      _AdminCommunityManagementViewState();
}

class _AdminCommunityManagementViewState
    extends State<AdminCommunityManagementView> {
  final AdminMockService _mockService = AdminMockService();
  final CommunitySupabaseService _communityService = CommunitySupabaseService();
  List<CommunityListItem> _communities = <CommunityListItem>[];
  bool _loading = true;
  bool _usingMock = false;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    if (AppEnv.useSupabase) {
      try {
        final List<CommunityListItem> items =
            await _communityService.listarParaAdmin();
        if (mounted) {
          setState(() {
            _communities = items;
            _usingMock = false;
            _loading = false;
          });
        }
        return;
      } catch (_) {
        // Fallback al mock.
      }
    }
    final List<AdminCommunityRow> mockRows = _mockService.fetchCommunities();
    if (mounted) {
      setState(() {
        _communities = mockRows.map(_mockToListItem).toList();
        _usingMock = true;
        _loading = false;
      });
    }
  }

  CommunityListItem _mockToListItem(AdminCommunityRow row) {
    return CommunityListItem(
      id: row.id,
      name: row.name,
      description: '',
      privacidad: 'PUBLICA',
      estado: switch (row.status) {
        AdminCommunityStatus.pending => 'PENDIENTE',
        AdminCommunityStatus.active => 'ACTIVA',
        AdminCommunityStatus.banned => 'BLOQUEADA',
      },
      interestTags: <CommunityInterestTag>[
        CommunityInterestTag(
          id: 0,
          name: row.category,
          colorHex: '#0682BC',
        ),
      ],
      memberCount: int.tryParse(row.engagementLabel.replaceAll(RegExp(r'[^0-9]'), '')) ?? 0,
      leadCreatorName: row.leadCreator,
    );
  }

  List<CommunityListItem> get _filteredCommunities {
    if (_searchQuery.trim().isEmpty) {
      return _communities;
    }
    final String q = _searchQuery.toLowerCase();
    return _communities
        .where(
          (CommunityListItem c) =>
              c.name.toLowerCase().contains(q) ||
              c.primaryCategory.toLowerCase().contains(q),
        )
        .toList();
  }

  AdminCommunityStatus _statusFor(CommunityListItem item) {
    return switch (item.estado) {
      'PENDIENTE' => AdminCommunityStatus.pending,
      'BLOQUEADA' => AdminCommunityStatus.banned,
      _ => AdminCommunityStatus.active,
    };
  }

  Future<void> _openActions(CommunityListItem item) async {
    if (_usingMock) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Conecta Supabase para gestionar comunidades reales.'),
        ),
      );
      return;
    }
    final bool? changed = await showDialog<bool>(
      context: context,
      builder: (_) => AdminCommunityActionsDialog(community: item),
    );
    if (changed == true) {
      await _load();
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<CommunityListItem> communities = _filteredCommunities;

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
            subtitle: _usingMock
                ? 'Conecta Supabase para gestion real'
                : 'Aprobacion, moderadores e intereses',
            trailing: <Widget>[
              IconButton(
                onPressed: _load,
                icon: const Icon(Icons.refresh),
                tooltip: 'Recargar',
              ),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: 280,
            height: 38,
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Buscar comunidades...',
                hintStyle: const TextStyle(fontSize: 13),
                prefixIcon: const Icon(Icons.search, size: 18),
                contentPadding: EdgeInsets.zero,
              ),
              onChanged: (String value) => setState(() => _searchQuery = value),
            ),
          ),
          const SizedBox(height: 18),
          Expanded(
            child: _loading
                ? const Center(child: CircularProgressIndicator())
                : AdminSectionCard(
                    padding: EdgeInsets.zero,
                    child: Column(
                      children: <Widget>[
                        const Padding(
                          padding: EdgeInsets.fromLTRB(16, 14, 16, 10),
                          child: Row(
                            children: <Widget>[
                              Expanded(flex: 4, child: _TableHead('COMUNIDAD')),
                              Expanded(flex: 3, child: _TableHead('CREADOR LIDER')),
                              Expanded(flex: 2, child: _TableHead('MIEMBROS')),
                              Expanded(flex: 2, child: _TableHead('ESTADO')),
                              Expanded(flex: 2, child: _TableHead('ACCIONES')),
                            ],
                          ),
                        ),
                        const Divider(height: 1),
                        if (communities.isEmpty)
                          const Padding(
                            padding: EdgeInsets.all(24),
                            child: Text('No hay comunidades registradas.'),
                          )
                        else
                          Expanded(
                            child: ListView.separated(
                              itemCount: communities.length,
                              separatorBuilder: (_, __) => const Divider(height: 1),
                              itemBuilder: (BuildContext context, int index) {
                                final CommunityListItem row = communities[index];
                                return Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(16, 12, 16, 12),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: <Widget>[
                                      Expanded(
                                        flex: 4,
                                        child: Row(
                                          children: <Widget>[
                                            Container(
                                              width: 44,
                                              height: 44,
                                              decoration: BoxDecoration(
                                                color: AppColors.primary
                                                    .withValues(alpha: 0.15),
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                              ),
                                              child: const Icon(
                                                Icons.groups,
                                                color: AppColors.primary,
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
                                                      fontWeight:
                                                          FontWeight.w900,
                                                      color:
                                                          AppColors.textPrimary,
                                                    ),
                                                  ),
                                                  Text(
                                                    row.primaryCategory,
                                                    style: const TextStyle(
                                                      fontSize: 11,
                                                      color: AppColors
                                                          .textSecondary,
                                                      fontWeight:
                                                          FontWeight.w700,
                                                    ),
                                                  ),
                                                  if (row.interestTags.isNotEmpty)
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                        top: 4,
                                                      ),
                                                      child: Wrap(
                                                        spacing: 4,
                                                        runSpacing: 4,
                                                        children: row
                                                            .interestTags
                                                            .map(
                                                              (
                                                                CommunityInterestTag
                                                                    tag,
                                                              ) =>
                                                                  Chip(
                                                                label: Text(
                                                                  tag.name,
                                                                  style:
                                                                      const TextStyle(
                                                                    fontSize: 9,
                                                                  ),
                                                                ),
                                                                visualDensity:
                                                                    VisualDensity
                                                                        .compact,
                                                                padding:
                                                                    EdgeInsets
                                                                        .zero,
                                                              ),
                                                            )
                                                            .toList(),
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
                                        child: Text(
                                          row.leadCreatorName ?? '—',
                                          style: const TextStyle(
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 2,
                                        child: Text(
                                          '${row.memberCount}',
                                          style: const TextStyle(
                                            fontWeight: FontWeight.w900,
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 2,
                                        child: _StatusPill(
                                          status: _statusFor(row),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 2,
                                        child: IconButton(
                                          onPressed: () => _openActions(row),
                                          icon: const Icon(
                                            Icons.edit_outlined,
                                            size: 18,
                                          ),
                                          color: AppColors.textSecondary,
                                          tooltip: row.isPending
                                              ? 'Aprobar solicitud'
                                              : 'Gestionar miembros',
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ),
                      ],
                    ),
                  ),
          ),
          const SizedBox(height: 14),
          Text(
            'Mostrando ${communities.length} comunidad${communities.length == 1 ? '' : 'es'}',
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w600,
            ),
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
    final (String label, Color color, IconData icon) = switch (status) {
      AdminCommunityStatus.pending => (
          'Pendiente',
          const Color(0xFF7B61B5),
          Icons.hourglass_top,
        ),
      AdminCommunityStatus.active => (
          'Activa',
          const Color(0xFF2E9E6A),
          Icons.check_circle_outline,
        ),
      AdminCommunityStatus.banned => (
          'Bloqueada',
          AppColors.error,
          Icons.cancel_outlined,
        ),
    };
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Icon(icon, size: 14, color: color),
        const SizedBox(width: 4),
        Text(
          label,
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
