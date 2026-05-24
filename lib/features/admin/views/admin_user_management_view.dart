import 'package:eventosloop/core/config/app_env.dart';
import 'package:eventosloop/core/theme/app_colors.dart';
import 'package:eventosloop/features/admin/models/admin_directory_models.dart';
import 'package:eventosloop/features/admin/models/admin_models.dart';
import 'package:eventosloop/features/admin/navigation/admin_navigation.dart';
import 'package:eventosloop/features/admin/services/admin_access_service.dart';
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
  final AdminUserSupabaseService _userService = AdminUserSupabaseService();
  final AdminAccessService _accessService = AdminAccessService();
  List<AdminUserRow> _users = <AdminUserRow>[];
  bool _loading = true;
  bool _isAdmin = false;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    try {
      final bool isAdmin = await _accessService.esAdminPrincipal();
      final List<AdminUserRow> users = await _userService.listarUsuarios();
      if (mounted) {
        setState(() {
          _users = users;
          _isAdmin = isAdmin;
          _loading = false;
        });
      }
    } catch (_) {
      if (mounted) {
        setState(() => _loading = false);
      }
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

  Future<void> _openActions(AdminUserRow user) async {
    if (!_isAdmin) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Solo ADMIN puede modificar roles y estados.'),
        ),
      );
      return;
    }
    final String? action = await showModalBottomSheet<String>(
      context: context,
      builder: (_) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ListTile(
              title: Text('Gestionar ${user.name}'),
              subtitle: Text(user.email),
            ),
            const Divider(height: 1),
            ListTile(
              leading: const Icon(Icons.admin_panel_settings_outlined),
              title: const Text('Asignar rol ADMIN'),
              onTap: () => Navigator.pop(context, 'ADMIN'),
            ),
            ListTile(
              leading: const Icon(Icons.shield_outlined),
              title: const Text('Asignar rol MODERADOR'),
              onTap: () => Navigator.pop(context, 'MODERADOR'),
            ),
            ListTile(
              leading: const Icon(Icons.person_outline),
              title: const Text('Asignar rol USER'),
              onTap: () => Navigator.pop(context, 'USER'),
            ),
            ListTile(
              leading: const Icon(Icons.block, color: AppColors.error),
              title: const Text('Suspender cuenta'),
              onTap: () => Navigator.pop(context, 'SUSPEND'),
            ),
            ListTile(
              leading: const Icon(Icons.check_circle_outline,
                  color: Color(0xFF2E9E6A)),
              title: const Text('Activar cuenta'),
              onTap: () => Navigator.pop(context, 'ACTIVATE'),
            ),
          ],
        ),
      ),
    );
    if (action == null) {
      return;
    }
    try {
      if (action == 'SUSPEND') {
        await _userService.actualizarEstado(
          usuarioId: user.idUsuario,
          estado: 'SUSPENDIDO',
        );
      } else if (action == 'ACTIVATE') {
        await _userService.actualizarEstado(
          usuarioId: user.idUsuario,
          estado: 'ACTIVO',
        );
      } else {
        await _userService.actualizarRol(
          usuarioId: user.idUsuario,
          nuevoRol: action,
        );
      }
      await _load();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Usuario actualizado')),
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
            subtitle: AppEnv.useSupabase
                ? 'Datos desde public.usuario · ${_isAdmin ? 'Puedes editar roles' : 'Solo lectura'}'
                : 'Conecta Supabase',
            trailing: <Widget>[
              IconButton(
                onPressed: _load,
                icon: const Icon(Icons.refresh),
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
                    child: users.isEmpty
                        ? const Padding(
                            padding: EdgeInsets.all(24),
                            child: Text('No hay usuarios.'),
                          )
                        : ListView.separated(
                            itemCount: users.length,
                            separatorBuilder: (_, __) => const Divider(height: 1),
                            itemBuilder: (BuildContext context, int index) {
                              final AdminUserRow user = users[index];
                              return ListTile(
                                leading: CircleAvatar(
                                  backgroundColor: Color(user.avatarColor),
                                  child: Text(
                                    user.name.isNotEmpty
                                        ? user.name.substring(0, 1).toUpperCase()
                                        : '?',
                                    style: const TextStyle(
                                      color: AppColors.white,
                                      fontWeight: FontWeight.w900,
                                    ),
                                  ),
                                ),
                                title: Text(user.name,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w900)),
                                subtitle: Text(
                                  '${user.email} · ${user.role} · ${user.joinedLabel}',
                                ),
                                trailing: _isAdmin
                                    ? IconButton(
                                        icon: const Icon(Icons.more_vert),
                                        onPressed: () => _openActions(user),
                                      )
                                    : _UserStatusPill(status: user.status),
                              );
                            },
                          ),
                  ),
          ),
        ],
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
    return Text(label,
        style: TextStyle(color: color, fontWeight: FontWeight.w800));
  }
}
