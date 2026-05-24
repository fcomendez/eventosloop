import 'package:eventosloop/core/config/app_env.dart';
import 'package:eventosloop/core/theme/app_colors.dart';
import 'package:eventosloop/features/admin/models/admin_directory_models.dart';
import 'package:eventosloop/features/admin/models/admin_models.dart';
import 'package:eventosloop/features/admin/navigation/admin_navigation.dart';
import 'package:eventosloop/features/admin/services/admin_mock_service.dart';
import 'package:eventosloop/features/admin/services/admin_user_supabase_service.dart';
import 'package:eventosloop/features/admin/widgets/admin_shell.dart';
import 'package:flutter/material.dart';

class AdminUserManagementView extends StatefulWidget {
  const AdminUserManagementView({super.key});

  @override
  State<AdminUserManagementView> createState() =>
      _AdminUserManagementViewState();
}

class _AdminUserManagementViewState extends State<AdminUserManagementView> {
  final AdminMockService _mockService = AdminMockService();
  final AdminUserSupabaseService _userService = AdminUserSupabaseService();
  List<AdminUserRow> _users = <AdminUserRow>[];
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
        final List<AdminUserRow> users = await _userService.listarUsuarios();
        if (mounted) {
          setState(() {
            _users = users;
            _usingMock = false;
            _loading = false;
          });
        }
        return;
      } catch (_) {}
    }
    if (mounted) {
      setState(() {
        _users = _mockService.fetchUsers();
        _usingMock = true;
        _loading = false;
      });
    }
  }

  List<AdminUserRow> get _filteredUsers {
    if (_searchQuery.trim().isEmpty) {
      return _users;
    }
    final String q = _searchQuery.toLowerCase();
    return _users
        .where(
          (AdminUserRow user) =>
              user.name.toLowerCase().contains(q) ||
              user.email.toLowerCase().contains(q) ||
              user.role.toLowerCase().contains(q),
        )
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final List<AdminUserRow> users = _filteredUsers;

    return AdminShell(
      selectedTopTab: AdminTopTab.dashboard,
      selectedSidebar: AdminSidebarItem.userManagement,
      onTopTabChanged: (AdminTopTab tab) =>
          handleAdminTopTabNavigation(context, tab),
      onSidebarChanged: (AdminSidebarItem item) =>
          handleAdminSidebarNavigation(context, item, replace: true),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          AdminPageHeader(
            eyebrow: 'DIRECTORIO',
            title: 'Gestion de usuarios',
            subtitle: _usingMock
                ? 'Datos mock — conecta Supabase para listado real'
                : 'Listado de solo lectura desde public.usuario',
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
            width: 320,
            child: TextField(
              decoration: const InputDecoration(
                hintText: 'Buscar por nombre, email o rol',
                prefixIcon: Icon(Icons.search, size: 18),
              ),
              onChanged: (String value) => setState(() => _searchQuery = value),
            ),
          ),
          const SizedBox(height: 16),
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
                              Expanded(flex: 4, child: _Head('PERFIL')),
                              Expanded(flex: 2, child: _Head('ROL')),
                              Expanded(flex: 3, child: _Head('INTERESES')),
                              Expanded(flex: 2, child: _Head('REGISTRO')),
                              Expanded(flex: 2, child: _Head('ESTADO')),
                            ],
                          ),
                        ),
                        const Divider(height: 1),
                        if (users.isEmpty)
                          const Padding(
                            padding: EdgeInsets.all(24),
                            child: Text('No hay usuarios para mostrar.'),
                          )
                        else
                          Expanded(
                            child: ListView.separated(
                              itemCount: users.length,
                              separatorBuilder: (_, __) =>
                                  const Divider(height: 1),
                              itemBuilder: (BuildContext context, int index) {
                                final AdminUserRow user = users[index];
                                return Padding(
                                  padding: const EdgeInsets.fromLTRB(
                                    16,
                                    12,
                                    16,
                                    12,
                                  ),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: <Widget>[
                                      Expanded(
                                        flex: 4,
                                        child: Row(
                                          children: <Widget>[
                                            CircleAvatar(
                                              radius: 18,
                                              backgroundColor:
                                                  Color(user.avatarColor),
                                              child: Text(
                                                user.name.isNotEmpty
                                                    ? user.name
                                                        .substring(0, 1)
                                                        .toUpperCase()
                                                    : '?',
                                                style: const TextStyle(
                                                  color: AppColors.white,
                                                  fontWeight: FontWeight.w900,
                                                ),
                                              ),
                                            ),
                                            const SizedBox(width: 10),
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: <Widget>[
                                                  Text(
                                                    user.name,
                                                    style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.w900,
                                                    ),
                                                  ),
                                                  Text(
                                                    user.email,
                                                    style: const TextStyle(
                                                      fontSize: 12,
                                                      color: AppColors
                                                          .textSecondary,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Expanded(
                                        flex: 2,
                                        child: _RoleBadge(label: user.role),
                                      ),
                                      Expanded(
                                        flex: 3,
                                        child: user.interests.isEmpty
                                            ? const Text(
                                                '—',
                                                style: TextStyle(
                                                  color:
                                                      AppColors.textSecondary,
                                                ),
                                              )
                                            : Wrap(
                                                spacing: 6,
                                                runSpacing: 6,
                                                children: user.interests
                                                    .map(
                                                      (String i) =>
                                                          _InterestBadge(
                                                        label: i,
                                                      ),
                                                    )
                                                    .toList(),
                                              ),
                                      ),
                                      Expanded(
                                        flex: 2,
                                        child: Text(
                                          user.joinedLabel,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 12,
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 2,
                                        child: _UserStatusPill(
                                          status: user.status,
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
            'Mostrando ${users.length} usuario${users.length == 1 ? '' : 's'}',
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

class _Head extends StatelessWidget {
  const _Head(this.label);

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

class _RoleBadge extends StatelessWidget {
  const _RoleBadge({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: AppColors.primary,
          fontWeight: FontWeight.w800,
          fontSize: 11,
        ),
      ),
    );
  }
}

class _InterestBadge extends StatelessWidget {
  const _InterestBadge({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.inputBackground,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          color: AppColors.primaryDark,
        ),
      ),
    );
  }
}

class _UserStatusPill extends StatelessWidget {
  const _UserStatusPill({required this.status});

  final AdminUserStatus status;

  @override
  Widget build(BuildContext context) {
    final (String label, Color color) = switch (status) {
      AdminUserStatus.active => ('ACTIVO', const Color(0xFF2E9E6A)),
      AdminUserStatus.pending => ('PENDIENTE', const Color(0xFF7B61B5)),
      AdminUserStatus.suspended => ('SUSPENDIDO', AppColors.error),
    };
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: TextStyle(
            color: color,
            fontWeight: FontWeight.w800,
            fontSize: 11,
          ),
        ),
      ],
    );
  }
}
