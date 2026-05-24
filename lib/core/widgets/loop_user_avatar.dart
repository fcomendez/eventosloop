import 'package:eventosloop/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

/// Avatar de usuario: imagen de red si hay [avatarUrl], si no iniciales con gradiente LOOP.
class LoopUserAvatar extends StatelessWidget {
  const LoopUserAvatar({
    super.key,
    this.avatarUrl,
    required this.initials,
    this.radius = 18,
    this.fontSize,
    this.borderRadius,
    this.boxShadow,
    this.onTap,
  });

  final String? avatarUrl;
  final String initials;
  final double radius;
  final double? fontSize;
  final BorderRadius? borderRadius;
  final List<BoxShadow>? boxShadow;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final double size = radius * 2;
    final String cleanUrl = avatarUrl?.trim() ?? '';
    final BorderRadius clipRadius =
        borderRadius ?? BorderRadius.circular(radius);
    final Widget avatar = cleanUrl.isNotEmpty
        ? ClipRRect(
            borderRadius: clipRadius,
            child: Image.network(
              cleanUrl,
              width: size,
              height: size,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => _InitialsBadge(
                initials: initials,
                size: size,
                fontSize: fontSize ?? radius * 0.65,
                borderRadius: clipRadius,
                boxShadow: boxShadow,
              ),
            ),
          )
        : _InitialsBadge(
            initials: initials,
            size: size,
            fontSize: fontSize ?? radius * 0.65,
            borderRadius: clipRadius,
            boxShadow: boxShadow,
          );

    if (onTap == null) {
      return avatar;
    }
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        customBorder: const CircleBorder(),
        child: avatar,
      ),
    );
  }
}

class _InitialsBadge extends StatelessWidget {
  const _InitialsBadge({
    required this.initials,
    required this.size,
    required this.fontSize,
    required this.borderRadius,
    this.boxShadow,
  });

  final String initials;
  final double size;
  final double fontSize;
  final BorderRadius borderRadius;
  final List<BoxShadow>? boxShadow;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        borderRadius: borderRadius,
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: <Color>[Color(0xFF0E3554), Color(0xFFB8DFF6)],
        ),
        boxShadow: boxShadow,
      ),
      alignment: Alignment.center,
      child: Text(
        initials,
        style: TextStyle(
          color: AppColors.white,
          fontSize: fontSize,
          fontWeight: FontWeight.w900,
        ),
      ),
    );
  }
}
