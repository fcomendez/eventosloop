String relativeTimeLabel(DateTime dateTime) {
  final Duration diff = DateTime.now().difference(dateTime.toLocal());
  if (diff.inMinutes < 1) {
    return 'ahora';
  }
  if (diff.inMinutes < 60) {
    return 'hace ${diff.inMinutes} min';
  }
  if (diff.inHours < 24) {
    return 'hace ${diff.inHours} h';
  }
  if (diff.inDays == 1) {
    return 'ayer';
  }
  if (diff.inDays < 7) {
    return 'hace ${diff.inDays} dias';
  }
  return '${dateTime.day.toString().padLeft(2, '0')}/'
      '${dateTime.month.toString().padLeft(2, '0')}/'
      '${dateTime.year}';
}

String authorInitials({String? nombres, String? apellidos, String? username}) {
  final String n = (nombres ?? '').trim();
  final String a = (apellidos ?? '').trim();
  if (n.isNotEmpty || a.isNotEmpty) {
    final StringBuffer buffer = StringBuffer();
    if (n.isNotEmpty) {
      buffer.write(n[0].toUpperCase());
    }
    if (a.isNotEmpty) {
      buffer.write(a[0].toUpperCase());
    }
    return buffer.toString();
  }
  final String u = (username ?? 'U').replaceAll('@', '').trim();
  return u.isEmpty ? 'U' : u.substring(0, 1).toUpperCase();
}
