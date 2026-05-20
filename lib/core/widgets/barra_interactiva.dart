import 'package:eventosloop/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

enum BarraInteractivaItem {
  perfil,
  comunidades,
  crear,
  explorar,
  inicio,
}

class BarraInteractiva extends StatelessWidget {
  const BarraInteractiva({
    super.key,
    required this.selected,
    this.onTap,
  });

  final BarraInteractivaItem selected;
  final ValueChanged<BarraInteractivaItem>? onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.white,
        border: Border(
          top: BorderSide(color: AppColors.divider.withValues(alpha: 0.6)),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          _item(BarraInteractivaItem.perfil, Icons.person_outline),
          _item(BarraInteractivaItem.comunidades, Icons.calendar_today_outlined),
          _item(BarraInteractivaItem.crear, Icons.add_circle_outline),
          _item(BarraInteractivaItem.explorar, Icons.search),
          _item(BarraInteractivaItem.inicio, Icons.home_outlined),
        ],
      ),
    );
  }

  Widget _item(BarraInteractivaItem item, IconData icon) {
    final bool isSelected = selected == item;
    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: onTap == null ? null : () => onTap!(item),
      child: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primary.withValues(alpha: 0.14)
              : Colors.transparent,
          shape: BoxShape.circle,
        ),
        child: Icon(
          icon,
          color: isSelected ? AppColors.primary : AppColors.textSecondary,
          size: 22,
        ),
      ),
    );
  }
}
