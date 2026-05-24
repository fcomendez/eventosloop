import 'package:eventosloop/core/config/app_env.dart';
import 'package:eventosloop/core/theme/app_colors.dart';
import 'package:eventosloop/features/communities/models/community_list_item.dart';
import 'package:eventosloop/features/communities/services/community_supabase_service.dart';
import 'package:flutter/material.dart';

class AdminCommunityActionsDialog extends StatefulWidget {
  const AdminCommunityActionsDialog({
    super.key,
    required this.community,
  });

  final CommunityListItem community;

  @override
  State<AdminCommunityActionsDialog> createState() =>
      _AdminCommunityActionsDialogState();
}

class _AdminCommunityActionsDialogState
    extends State<AdminCommunityActionsDialog> {
  final CommunitySupabaseService _service = CommunitySupabaseService();
  List<CommunityMemberItem> _members = <CommunityMemberItem>[];
  bool _loadingMembers = true;
  bool _processing = false;

  @override
  void initState() {
    super.initState();
    _loadMembers();
  }

  Future<void> _loadMembers() async {
    if (!widget.community.isActive) {
      setState(() {
        _loadingMembers = false;
      });
      return;
    }
    try {
      final List<CommunityMemberItem> members =
          await _service.listarMiembros(widget.community.id);
      if (mounted) {
        setState(() {
          _members = members;
          _loadingMembers = false;
        });
      }
    } catch (_) {
      if (mounted) {
        setState(() => _loadingMembers = false);
      }
    }
  }

  Future<void> _aprobar() async {
    setState(() => _processing = true);
    try {
      await _service.aprobarComunidad(widget.community.id);
      if (mounted) {
        Navigator.pop(context, true);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al aprobar: $e')),
        );
        setState(() => _processing = false);
      }
    }
  }

  Future<void> _cambiarRol(CommunityMemberItem member, String nuevoRol) async {
    try {
      await _service.asignarRolMiembro(
        communityId: widget.community.id,
        usuarioId: member.usuarioId,
        rol: nuevoRol,
      );
      await _loadMembers();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Rol de ${member.displayName} actualizado a $nuevoRol'),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('No se pudo asignar rol: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final CommunityListItem c = widget.community;
    return AlertDialog(
      title: Text(c.name),
      content: SizedBox(
        width: 420,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                'Estado: ${c.estado} · ${c.privacidad}',
                style: const TextStyle(color: AppColors.textSecondary),
              ),
              if (c.interestTags.isNotEmpty) ...<Widget>[
                const SizedBox(height: 10),
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: c.interestTags
                      .map(
                        (CommunityInterestTag tag) => Chip(
                          label: Text(tag.name),
                          visualDensity: VisualDensity.compact,
                        ),
                      )
                      .toList(),
                ),
              ],
              if (c.isPending && AppEnv.useSupabase) ...<Widget>[
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: _processing ? null : _aprobar,
                    icon: const Icon(Icons.check_circle_outline, size: 18),
                    label: const Text('Aprobar (PENDIENTE → ACTIVA)'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF2E9E6A),
                      foregroundColor: AppColors.white,
                    ),
                  ),
                ),
              ],
              if (c.isActive) ...<Widget>[
                const SizedBox(height: 16),
                const Text(
                  'Asignar moderadores',
                  style: TextStyle(fontWeight: FontWeight.w800),
                ),
                const SizedBox(height: 8),
                if (_loadingMembers)
                  const Center(child: CircularProgressIndicator())
                else if (_members.isEmpty)
                  const Text('Sin miembros aun.')
                else
                  ..._members.map((CommunityMemberItem member) {
                    return ListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Text(member.displayName),
                      subtitle: Text('Rol actual: ${member.rol}'),
                      trailing: DropdownButton<String>(
                        value: member.rol,
                        items: const <DropdownMenuItem<String>>[
                          DropdownMenuItem<String>(
                            value: 'MIEMBRO',
                            child: Text('MIEMBRO'),
                          ),
                          DropdownMenuItem<String>(
                            value: 'MODERADOR',
                            child: Text('MODERADOR'),
                          ),
                          DropdownMenuItem<String>(
                            value: 'LIDER',
                            child: Text('LIDER'),
                          ),
                        ],
                        onChanged: (String? value) {
                          if (value != null && value != member.rol) {
                            _cambiarRol(member, value);
                          }
                        },
                      ),
                    );
                  }),
              ],
            ],
          ),
        ),
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cerrar'),
        ),
      ],
    );
  }
}
