import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:eventosloop/core/config/app_env.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Buckets de Supabase Storage para separar tipos de media.
enum MediaBucket {
  avatars('avatars'),
  events('events'),
  posts('posts'),
  communities('communities');

  const MediaBucket(this.id);

  final String id;
}

/// Sube imagenes a Supabase Storage cuando esta disponible.
/// Si Storage no responde, persiste una data-URL compacta (solo archivos pequeños).
class MediaStorageService {
  MediaStorageService({SupabaseClient? client}) : _client = client;

  final SupabaseClient? _client;

  static const int _maxDataUrlBytes = 180 * 1024;

  SupabaseClient get _supabase => _client ?? Supabase.instance.client;

  Future<String?> uploadImage({
    required File file,
    required MediaBucket bucket,
    String? subfolder,
  }) async {
    if (!AppEnv.useSupabase) {
      return null;
    }

    final Uint8List bytes = await file.readAsBytes();
    final String ext = _extension(file.path);
    final String name =
        '${DateTime.now().millisecondsSinceEpoch}_${bucket.id.hashCode}.$ext';
    final String path =
        subfolder == null || subfolder.trim().isEmpty
            ? name
            : '${subfolder.trim()}/$name';

    try {
      await _supabase.storage.from(bucket.id).uploadBinary(
            path,
            bytes,
            fileOptions: FileOptions(
              contentType: _mimeForExt(ext),
              upsert: true,
            ),
          );
      return _supabase.storage.from(bucket.id).getPublicUrl(path);
    } catch (_) {
      if (bytes.length <= _maxDataUrlBytes) {
        final String mime = _mimeForExt(ext);
        final String b64 = base64Encode(bytes);
        return 'data:$mime;base64,$b64';
      }
      return null;
    }
  }

  String _extension(String path) {
    final int dot = path.lastIndexOf('.');
    if (dot == -1) {
      return 'jpg';
    }
    return path.substring(dot + 1).toLowerCase();
  }

  String _mimeForExt(String ext) {
    return switch (ext) {
      'png' => 'image/png',
      'webp' => 'image/webp',
      'gif' => 'image/gif',
      _ => 'image/jpeg',
    };
  }
}
