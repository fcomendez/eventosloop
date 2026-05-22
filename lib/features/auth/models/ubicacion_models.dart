class RegionOption {
  const RegionOption({required this.id, required this.nombre});

  final int id;
  final String nombre;

  factory RegionOption.fromJson(Map<String, dynamic> json) {
    return RegionOption(
      id: (json['id_region'] as num).toInt(),
      nombre: json['nombre'] as String,
    );
  }
}

class ComunaOption {
  const ComunaOption({
    required this.id,
    required this.nombre,
    required this.regionId,
  });

  final int id;
  final String nombre;
  final int regionId;

  factory ComunaOption.fromJson(Map<String, dynamic> json) {
    return ComunaOption(
      id: (json['id_comuna'] as num).toInt(),
      nombre: json['nombre'] as String,
      regionId: (json['region_id_region'] as num).toInt(),
    );
  }
}
