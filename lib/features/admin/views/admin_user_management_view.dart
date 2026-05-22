import 'package:eventosloop/core/theme/app_colors.dart';
import 'package:eventosloop/features/admin/models/admin_directory_models.dart';
import 'package:eventosloop/features/admin/models/admin_models.dart';
import 'package:eventosloop/features/admin/navigation/admin_navigation.dart';
import 'package:eventosloop/features/admin/services/admin_mock_service.dart';
import 'package:eventosloop/features/admin/widgets/admin_shell.dart';
import 'package:flutter/material.dart';

class AdminUserManagementView extends StatefulWidget {
  const AdminUserManagementView({super.key});

  @override
  State<AdminUserManagementView> createState() =>
      _AdminUserManagementViewState();
}

class _AdminUserManagementViewState extends State<AdminUserManagementView> {
  final AdminMockService _service = AdminMockService();
  int _page = 1;

  @override
  Widget build(BuildContext context) {
    final List<AdminUserRow> users = _service.fetchUsers();

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
            trailing: <Widget>[
              OutlinedButton(onPressed: () {}, child: const Text('Filtros')),
              ElevatedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.person_add_outlined, size: 18),
                label: const Text('Crear usuario'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: AppColors.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          AdminSectionCard(
            child: Column(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Expanded(
                      flex: 3,
                      child: TextField(
                        decoration: const InputDecoration(
                          hintText: 'Busqueda avanzada por usuario',
                          prefixIcon: Icon(Icons.search, size: 18),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        initialValue: 'Todos los roles',
                        decoration: const InputDecoration(
                          contentPadding: EdgeInsets.symmetric(horizontal: 12),
                        ),
                        items: const <DropdownMenuItem<String>>[
                          DropdownMenuItem(
                            value: 'Todos los roles',
                            child: Text('Todos los roles'),
                          ),
                          DropdownMenuItem(
                            value: 'ADMIN',
                            child: Text('ADMIN'),
                          ),
                          DropdownMenuItem(
                            value: 'USER',
                            child: Text('USER'),
                          ),
                        ],
                        onChanged: (_) {},
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        initialValue: 'Cualquier estado',
                        decoration: const InputDecoration(
                          contentPadding: EdgeInsets.symmetric(horizontal: 12),
                        ),
                        items: const <DropdownMenuItem<String>>[
                          DropdownMenuItem(
                            value: 'Cualquier estado',
                            child: Text('Cualquier estado'),
                          ),
                          DropdownMenuItem(
                            value: 'ACTIVE',
                            child: Text('ACTIVO'),
                          ),
                          DropdownMenuItem(
                            value: 'PENDING',
                            child: Text('PENDIENTE'),
                          ),
                          DropdownMenuItem(
                            value: 'SUSPENDED',
                            child: Text('SUSPENDIDO'),
                          ),
                        ],
                        onChanged: (_) {},
                      ),
                    ),
                    const SizedBox(width: 12),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.inputBackground,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            'TOTAL ACTIVOS',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w800,
                              color: AppColors.textSecondary,
                            ),
                          ),
                          Text(
                            '12,482',
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                          Text(
                            '+14% este mes',
                            style: TextStyle(
                              fontSize: 11,
                              color: Color(0xFF2E9E6A),
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          AdminSectionCard(
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
                      SizedBox(width: 40, child: _Head('ACCIONES')),
                    ],
                  ),
                ),
                const Divider(height: 1),
                ...users.map((AdminUserRow user) {
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
                                  CircleAvatar(
                                    radius: 18,
                                    backgroundColor: Color(user.avatarColor),
                                    child: Text(
                                      user.name.substring(0, 1),
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
                                            fontWeight: FontWeight.w900,
                                          ),
                                        ),
                                        Text(
                                          user.email,
                                          style: const TextStyle(
                                            fontSize: 12,
                                            color: AppColors.textSecondary,
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
                              child: Wrap(
                                spacing: 6,
                                runSpacing: 6,
                                children: user.interests
                                    .map((String i) => _InterestBadge(label: i))
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
                              child: _UserStatusPill(status: user.status),
                            ),
                            const SizedBox(
                              width: 40,
                              child: Icon(Icons.more_vert,
                                  color: AppColors.textSecondary),
                            ),
                          ],
                        ),
                      ),
                      if (user != users.last) const Divider(height: 1),
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
                'Mostrando 1 a 4 de 12.482 usuarios',
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
                  child: CircleAvatar(
                    radius: 14,
                    backgroundColor:
                        p == _page ? AppColors.primaryDark : Colors.transparent,
                    child: Text(
                      '$p',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w800,
                        color: p == _page
                            ? AppColors.white
                            : AppColors.textSecondary,
                      ),
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
