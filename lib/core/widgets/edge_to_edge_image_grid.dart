import 'package:eventosloop/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

class EdgeToEdgeGridItem {
  const EdgeToEdgeGridItem({
    required this.id,
    required this.label,
    required this.colorHex,
    this.onTap,
  });

  final int id;
  final String label;
  final String colorHex;
  final VoidCallback? onTap;
}

/// Cuadricula 3 columnas a sangre completa, sin esquinas redondeadas.
class EdgeToEdgeImageGrid extends StatelessWidget {
  const EdgeToEdgeImageGrid({
    super.key,
    required this.items,
    this.columns = 3,
  });

  final List<EdgeToEdgeGridItem> items;
  final int columns;

  static const Color _cellBorder = Color(0x33FFFFFF);

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) {
      return const SizedBox.shrink();
    }

    final double width = MediaQuery.sizeOf(context).width;
    final double tileSize = width / columns;
    final int rowCount = (items.length / columns).ceil();

    return MediaQuery.removePadding(
      context: context,
      removeLeft: true,
      removeRight: true,
      child: SizedBox(
        width: width,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: List<Widget>.generate(rowCount, (int row) {
            return SizedBox(
              height: tileSize,
              child: Row(
                children: List<Widget>.generate(columns, (int col) {
                  final int index = row * columns + col;
                  if (index >= items.length) {
                    return SizedBox(width: tileSize, height: tileSize);
                  }
                  final EdgeToEdgeGridItem item = items[index];
                  final bool showRightBorder = col < columns - 1;
                  final bool showBottomBorder = row < rowCount - 1;
                  return SizedBox(
                    width: tileSize,
                    height: tileSize,
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: item.onTap,
                        splashColor: AppColors.white.withValues(alpha: 0.12),
                        child: Ink(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: <Color>[
                                _parseHex(item.colorHex),
                                AppColors.primaryDark.withValues(alpha: 0.85),
                              ],
                            ),
                            border: Border(
                              right: showRightBorder
                                  ? const BorderSide(
                                      color: _cellBorder,
                                      width: 1,
                                    )
                                  : BorderSide.none,
                              bottom: showBottomBorder
                                  ? const BorderSide(
                                      color: _cellBorder,
                                      width: 1,
                                    )
                                  : BorderSide.none,
                            ),
                          ),
                          child: Center(
                            child: Text(
                              item.label,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                color: AppColors.white,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                }),
              ),
            );
          }),
        ),
      ),
    );
  }

  static Color _parseHex(String hex) {
    return Color(int.parse('FF${hex.replaceFirst('#', '')}', radix: 16));
  }
}
