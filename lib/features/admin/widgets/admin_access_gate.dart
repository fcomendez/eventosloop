import 'package:eventosloop/core/theme/app_colors.dart';
import 'package:eventosloop/features/admin/services/admin_access_service.dart';
import 'package:flutter/material.dart';

/// Bloquea el panel admin si el usuario no tiene rol ADMIN o MODERADOR.
class AdminAccessGate extends StatefulWidget {
  const AdminAccessGate({super.key, required this.child});

  final Widget child;

  @override
  State<AdminAccessGate> createState() => _AdminAccessGateState();
}

class _AdminAccessGateState extends State<AdminAccessGate> {
  final AdminAccessService _access = AdminAccessService();
  bool _loading = true;
  bool _allowed = false;

  @override
  void initState() {
    super.initState();
    _check();
  }

  Future<void> _check() async {
    final bool allowed = await _access.puedeAccederAdmin();
    if (mounted) {
      setState(() {
        _allowed = allowed;
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }
    if (!_allowed) {
      return Scaffold(
        appBar: AppBar(title: const Text('Acceso restringido')),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                const Icon(
                  Icons.lock_outline,
                  size: 48,
                  color: AppColors.textSecondary,
                ),
                const SizedBox(height: 16),
                const Text(
                  'Panel de administracion',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Solo usuarios con rol ADMIN o MODERADOR pueden acceder.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: AppColors.textSecondary),
                ),
                const SizedBox(height: 20),
                OutlinedButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Volver'),
                ),
              ],
            ),
          ),
        ),
      );
    }
    return widget.child;
  }
}
