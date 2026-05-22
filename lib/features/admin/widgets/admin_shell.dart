import 'package:eventosloop/core/theme/app_colors.dart';
import 'package:eventosloop/features/admin/models/admin_models.dart';
import 'package:flutter/material.dart';

class AdminShell extends StatelessWidget {
  const AdminShell({
    super.key,
    required this.selectedTopTab,
    required this.selectedSidebar,
    required this.body,
    this.onTopTabChanged,
    this.onSidebarChanged,
    this.showBackToApp = true,
  });

  final AdminTopTab selectedTopTab;
  final AdminSidebarItem selectedSidebar;
  final Widget body;
  final ValueChanged<AdminTopTab>? onTopTabChanged;
  final ValueChanged<AdminSidebarItem>? onSidebarChanged;
  final bool showBackToApp;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final bool wide = constraints.maxWidth >= 860;
        return Scaffold(
          backgroundColor: const Color(0xFFEEF3F8),
          drawer: wide
              ? null
              : Drawer(
                  child: SafeArea(
                    child: _SidebarPanel(
                      selected: selectedSidebar,
                      onSelected: (AdminSidebarItem item) {
                        Navigator.of(context).pop();
                        onSidebarChanged?.call(item);
                      },
                      compact: true,
                    ),
                  ),
                ),
          body: Builder(
            builder: (BuildContext scaffoldContext) {
              return SafeArea(
                child: Column(
                  children: <Widget>[
                    _TopBar(
                      wide: wide,
                      showBackToApp: showBackToApp,
                      onMenuTap: wide
                          ? null
                          : () => Scaffold.of(scaffoldContext).openDrawer(),
                    ),
                    _TopTabs(
                      selected: selectedTopTab,
                      onChanged: onTopTabChanged,
                    ),
                    Expanded(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          if (wide)
                            SizedBox(
                              width: 230,
                              child: _SidebarPanel(
                                selected: selectedSidebar,
                                onSelected: onSidebarChanged,
                              ),
                            ),
                          Expanded(
                            child: SingleChildScrollView(
                              padding:
                                  const EdgeInsets.fromLTRB(16, 12, 16, 24),
                              child: body,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }
}

class _TopBar extends StatelessWidget {
  const _TopBar({
    required this.wide,
    required this.showBackToApp,
    this.onMenuTap,
  });

  final bool wide;
  final bool showBackToApp;
  final VoidCallback? onMenuTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(8, 8, 16, 8),
      decoration: BoxDecoration(
        color: AppColors.white,
        border: Border(
          bottom: BorderSide(color: AppColors.divider.withValues(alpha: 0.5)),
        ),
      ),
      child: Row(
        children: <Widget>[
          if (onMenuTap != null)
            IconButton(
              onPressed: onMenuTap,
              icon: const Icon(Icons.menu),
              color: AppColors.primaryDark,
            ),
          if (showBackToApp)
            IconButton(
              onPressed: () => Navigator.of(context).pop(),
              icon: const Icon(Icons.arrow_back),
              color: AppColors.primaryDark,
              tooltip: 'Volver a la app',
            ),
          const Expanded(
            child: Text(
              'LOOP',
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: AppColors.primaryDark,
                fontSize: 22,
                fontWeight: FontWeight.w900,
                letterSpacing: 0.5,
              ),
            ),
          ),
          if (wide)
            SizedBox(
              width: 220,
              height: 38,
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Busqueda global...',
                  hintStyle: TextStyle(
                    color: AppColors.textSecondary.withValues(alpha: 0.8),
                    fontSize: 13,
                  ),
                  prefixIcon: const Icon(Icons.search, size: 18),
                  contentPadding: EdgeInsets.zero,
                ),
              ),
            ),
          if (wide) const SizedBox(width: 12),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.notifications_none),
            color: AppColors.textSecondary,
          ),
          if (wide)
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.help_outline),
              color: AppColors.textSecondary,
            ),
          const CircleAvatar(
            radius: 16,
            backgroundColor: AppColors.inputBackground,
            child: Icon(Icons.person, size: 18, color: AppColors.primary),
          ),
        ],
      ),
    );
  }
}

class _TopTabs extends StatelessWidget {
  const _TopTabs({
    required this.selected,
    this.onChanged,
  });

  final AdminTopTab selected;
  final ValueChanged<AdminTopTab>? onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: AppColors.white,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: AdminTopTab.values.map((AdminTopTab tab) {
            final bool active = tab == selected;
            final String label = switch (tab) {
              AdminTopTab.dashboard => 'Panel',
              AdminTopTab.analytics => 'Analitica',
              AdminTopTab.community => 'Comunidad',
            };
            return Padding(
              padding: const EdgeInsets.only(right: 8, bottom: 8, top: 4),
              child: TextButton(
                onPressed: onChanged == null ? null : () => onChanged!(tab),
                style: TextButton.styleFrom(
                  foregroundColor:
                      active ? AppColors.primary : AppColors.textSecondary,
                  backgroundColor: active
                      ? AppColors.primary.withValues(alpha: 0.08)
                      : Colors.transparent,
                ),
                child: Text(
                  label,
                  style: TextStyle(
                    fontWeight: active ? FontWeight.w900 : FontWeight.w600,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}

class _SidebarPanel extends StatelessWidget {
  const _SidebarPanel({
    required this.selected,
    this.onSelected,
    this.compact = false,
  });

  final AdminSidebarItem selected;
  final ValueChanged<AdminSidebarItem>? onSelected;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.white,
      padding:
          EdgeInsets.fromLTRB(compact ? 12 : 16, 16, compact ? 12 : 16, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Row(
            children: <Widget>[
              Container(
                width: 34,
                height: 34,
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.admin_panel_settings_outlined,
                    color: AppColors.white, size: 18),
              ),
              const SizedBox(width: 10),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'Panel de administracion',
                      style: TextStyle(
                        fontWeight: FontWeight.w900,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    Text(
                      'CONTROL GLOBAL',
                      style: TextStyle(
                        fontSize: 10,
                        letterSpacing: 0.6,
                        color: AppColors.textSecondary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          ...AdminSidebarItem.values.map((AdminSidebarItem item) {
            final bool active = item == selected;
            final (IconData icon, String label) = switch (item) {
              AdminSidebarItem.userManagement => (
                  Icons.group_outlined,
                  'Gestion de usuarios'
                ),
              AdminSidebarItem.contentFeed => (
                  Icons.article_outlined,
                  'Contenido y eventos'
                ),
              AdminSidebarItem.moderation => (
                  Icons.gavel_outlined,
                  'Moderacion'
                ),
              AdminSidebarItem.adConsole => (
                  Icons.campaign_outlined,
                  'Consola de anuncios'
                ),
              AdminSidebarItem.systemStatus => (
                  Icons.monitor_heart_outlined,
                  'Estado del sistema'
                ),
            };
            return Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: Material(
                color: active
                    ? AppColors.primary.withValues(alpha: 0.1)
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(10),
                child: InkWell(
                  borderRadius: BorderRadius.circular(10),
                  onTap: onSelected == null ? null : () => onSelected!(item),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 10),
                    child: Row(
                      children: <Widget>[
                        Icon(
                          icon,
                          size: 18,
                          color: active
                              ? AppColors.primary
                              : AppColors.textSecondary,
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            label,
                            style: TextStyle(
                              color: active
                                  ? AppColors.primaryDark
                                  : AppColors.textSecondary,
                              fontWeight:
                                  active ? FontWeight.w800 : FontWeight.w600,
                              fontSize: 13,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }),
          const Spacer(),
          SizedBox(
            height: 42,
            child: ElevatedButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Reporte generado (mock)')),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: AppColors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text('Generar reporte'),
            ),
          ),
        ],
      ),
    );
  }
}

class AdminSectionCard extends StatelessWidget {
  const AdminSectionCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(16),
  });

  final Widget child;
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: padding,
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: AppColors.primaryDark.withValues(alpha: 0.05),
            blurRadius: 14,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: child,
    );
  }
}

class AdminKpiCard extends StatelessWidget {
  const AdminKpiCard({super.key, required this.metric});

  final AdminKpiMetric metric;

  @override
  Widget build(BuildContext context) {
    return AdminSectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            metric.label,
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w700,
              fontSize: 13,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            metric.value,
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontSize: 28,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: Color(metric.badgeColor).withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(999),
            ),
            child: Text(
              metric.badgeLabel,
              style: TextStyle(
                color: Color(metric.badgeColor),
                fontSize: 11,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class AdminGrowthChart extends StatelessWidget {
  const AdminGrowthChart({super.key, required this.points});

  final List<AdminGrowthPoint> points;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 220,
      width: double.infinity,
      child: CustomPaint(
        painter: _GrowthChartPainter(points: points),
        child: Padding(
          padding: const EdgeInsets.only(left: 8, right: 8, bottom: 8),
          child: Align(
            alignment: Alignment.bottomCenter,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: points
                  .map(
                    (AdminGrowthPoint p) => Expanded(
                      child: Text(
                        p.label,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 9,
                          color: AppColors.textSecondary,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  )
                  .toList(),
            ),
          ),
        ),
      ),
    );
  }
}

class _GrowthChartPainter extends CustomPainter {
  _GrowthChartPainter({required this.points});

  final List<AdminGrowthPoint> points;

  @override
  void paint(Canvas canvas, Size size) {
    if (points.isEmpty) {
      return;
    }

    final Paint fillPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: <Color>[
          AppColors.primary.withValues(alpha: 0.28),
          AppColors.primary.withValues(alpha: 0.02),
        ],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    final Paint linePaint = Paint()
      ..color = AppColors.primary
      ..strokeWidth = 2.5
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final double bottom = size.height - 24;
    final double stepX = size.width / (points.length - 1);

    final Path linePath = Path();
    final Path fillPath = Path()..moveTo(0, bottom);

    for (int i = 0; i < points.length; i++) {
      final double x = i * stepX;
      final double y = bottom - (points[i].value * (bottom - 16));
      if (i == 0) {
        linePath.moveTo(x, y);
        fillPath.lineTo(x, y);
      } else {
        linePath.lineTo(x, y);
        fillPath.lineTo(x, y);
      }
    }

    fillPath
      ..lineTo(size.width, bottom)
      ..close();

    canvas.drawPath(fillPath, fillPaint);
    canvas.drawPath(linePath, linePaint);
  }

  @override
  bool shouldRepaint(covariant _GrowthChartPainter oldDelegate) {
    return oldDelegate.points != points;
  }
}

class AdminPeriodToggle extends StatelessWidget {
  const AdminPeriodToggle({
    super.key,
    required this.options,
    required this.selected,
    required this.onChanged,
  });

  final List<String> options;
  final String selected;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 6,
      children: options.map((String option) {
        final bool active = option == selected;
        return OutlinedButton(
          onPressed: () => onChanged(option),
          style: OutlinedButton.styleFrom(
            minimumSize: const Size(0, 34),
            padding: const EdgeInsets.symmetric(horizontal: 12),
            foregroundColor:
                active ? AppColors.primary : AppColors.textSecondary,
            backgroundColor:
                active ? AppColors.primary.withValues(alpha: 0.08) : null,
            side: BorderSide(
              color: active ? AppColors.primary : AppColors.divider,
            ),
          ),
          child: Text(
            option,
            style: TextStyle(
              fontWeight: active ? FontWeight.w800 : FontWeight.w600,
              fontSize: 12,
            ),
          ),
        );
      }).toList(),
    );
  }
}
