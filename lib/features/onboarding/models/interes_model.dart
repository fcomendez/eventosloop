import 'package:flutter/material.dart';

class InteresModel {
  const InteresModel({
    required this.idInteres,
    required this.categoria,
    required this.nombre,
    required this.slug,
    required this.icono,
    required this.colorHex,
  });

  final int idInteres;
  final String categoria;
  final String nombre;
  final String slug;
  final String icono;
  final String colorHex;

  factory InteresModel.fromJson(Map<String, dynamic> json) {
    return InteresModel(
      idInteres: (json['id_interes'] as num).toInt(),
      categoria: json['categoria'] as String? ?? 'GENERAL',
      nombre: json['nombre'] as String? ?? '',
      slug: json['slug'] as String? ?? '',
      icono: json['icono'] as String? ?? 'interests',
      colorHex: json['color_hex'] as String? ?? '#0682BC',
    );
  }

  Color get color {
    final String hex = colorHex.replaceFirst('#', '');
    return Color(int.parse('FF$hex', radix: 16));
  }

  static const Map<String, IconData> _iconMap = <String, IconData>{
    'directions_run': Icons.directions_run,
    'timer': Icons.timer,
    'sports_soccer': Icons.sports_soccer,
    'sports_basketball': Icons.sports_basketball,
    'sports_volleyball': Icons.sports_volleyball,
    'hiking': Icons.hiking,
    'terrain': Icons.terrain,
    'directions_bike': Icons.directions_bike,
    'roller_skating': Icons.roller_skating,
    'self_improvement': Icons.self_improvement,
    'spa': Icons.spa,
    'sports_mma': Icons.sports_mma,
    'sports_kabaddi': Icons.sports_kabaddi,
    'restaurant': Icons.restaurant,
    'coffee': Icons.coffee,
    'wine_bar': Icons.wine_bar,
    'local_bar': Icons.local_bar,
    'soup_kitchen': Icons.soup_kitchen,
    'cake': Icons.cake,
    'lunch_dining': Icons.lunch_dining,
    'movie': Icons.movie,
    'theaters': Icons.theaters,
    'music_note': Icons.music_note,
    'celebration': Icons.celebration,
    'museum': Icons.museum,
    'photo_camera': Icons.photo_camera,
    'menu_book': Icons.menu_book,
    'extension': Icons.extension,
    'sports': Icons.sports,
    'sports_esports': Icons.sports_esports,
    'stadia_controller': Icons.sports_esports,
    'quiz': Icons.quiz,
    'mic': Icons.mic,
    'translate': Icons.translate,
    'palette': Icons.palette,
    'format_paint': Icons.format_paint,
    'content_cut': Icons.content_cut,
    'groups': Icons.groups,
    'lightbulb': Icons.lightbulb,
    'record_voice_over': Icons.record_voice_over,
    'volunteer_activism': Icons.volunteer_activism,
    'pets': Icons.pets,
    'flight': Icons.flight,
    'camping': Icons.holiday_village,
    'yard': Icons.yard,
    'handyman': Icons.handyman,
    'nightlight': Icons.nightlight,
    'diamond': Icons.diamond,
    'interests': Icons.interests,
  };

  IconData get iconData => _iconMap[icono] ?? Icons.interests;
}
