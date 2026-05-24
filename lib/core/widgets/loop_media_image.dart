import 'dart:convert';
import 'dart:typed_data';

import 'package:eventosloop/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

/// Muestra una imagen desde URL http(s) o data-URL base64.
class LoopMediaImage extends StatelessWidget {
  const LoopMediaImage({
    super.key,
    required this.url,
    this.height,
    this.width,
    this.fit = BoxFit.cover,
    this.fallbackColorHex = '#D9EAF5',
    this.fallbackLabel,
  });

  final String url;
  final double? height;
  final double? width;
  final BoxFit fit;
  final String fallbackColorHex;
  final String? fallbackLabel;

  @override
  Widget build(BuildContext context) {
    if (url.startsWith('data:')) {
      try {
        final String payload = url.contains(',') ? url.split(',').last : url;
        final Uint8List bytes = base64Decode(payload);
        return Image.memory(
          bytes,
          height: height,
          width: width,
          fit: fit,
          errorBuilder: (_, __, ___) => _fallback(),
        );
      } catch (_) {
        return _fallback();
      }
    }

    if (url.startsWith('http://') || url.startsWith('https://')) {
      return Image.network(
        url,
        height: height,
        width: width,
        fit: fit,
        loadingBuilder: (_, Widget child, ImageChunkEvent? progress) {
          if (progress == null) {
            return child;
          }
          return SizedBox(
            height: height,
            width: width,
            child: const Center(
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
          );
        },
        errorBuilder: (_, __, ___) => _fallback(),
      );
    }

    return _fallback();
  }

  Widget _fallback() {
    final Color base = _parseHex(fallbackColorHex);
    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: <Color>[base, AppColors.primaryDark.withValues(alpha: 0.9)],
        ),
      ),
      alignment: Alignment.center,
      child: fallbackLabel == null
          ? const Icon(Icons.image_outlined, color: AppColors.white, size: 36)
          : Text(
              fallbackLabel!,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: AppColors.white,
                fontWeight: FontWeight.w900,
              ),
            ),
    );
  }

  static Color _parseHex(String hex) {
    return Color(int.parse('FF${hex.replaceFirst('#', '')}', radix: 16));
  }
}
