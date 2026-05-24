class CommunityInterestTag {
  const CommunityInterestTag({
    required this.id,
    required this.name,
    required this.colorHex,
  });

  final int id;
  final String name;
  final String colorHex;

  factory CommunityInterestTag.fromJson(Map<String, dynamic> json) {
    final Map<String, dynamic>? interes =
        json['intereses'] as Map<String, dynamic>?;
    return CommunityInterestTag(
      id: (json['id_interes'] as num).toInt(),
      name: interes?['nombre'] as String? ?? 'Interes',
      colorHex: interes?['color_hex'] as String? ?? '#0682BC',
    );
  }
}

class CommunityListItem {
  const CommunityListItem({
    required this.id,
    required this.name,
    required this.description,
    required this.privacidad,
    required this.estado,
    required this.interestTags,
    required this.memberCount,
    this.leadCreatorName,
    this.bannerUrl,
  });

  final int id;
  final String name;
  final String description;
  final String privacidad;
  final String estado;
  final List<CommunityInterestTag> interestTags;
  final int memberCount;
  final String? leadCreatorName;
  final String? bannerUrl;

  bool get isPublic => privacidad == 'PUBLICA';
  bool get isActive => estado == 'ACTIVA';
  bool get isPending => estado == 'PENDIENTE';

  String get primaryCategory =>
      interestTags.isNotEmpty ? interestTags.first.name : 'General';

  String get membersLabel {
    if (memberCount >= 1000) {
      return '${(memberCount / 1000).toStringAsFixed(1)}k miembros';
    }
    return '$memberCount miembros';
  }

  factory CommunityListItem.fromJson(Map<String, dynamic> json) {
    final List<dynamic> rawInterests =
        json['comunidad_intereses'] as List<dynamic>? ?? <dynamic>[];
    final List<CommunityInterestTag> tags = rawInterests
        .map(
          (dynamic row) =>
              CommunityInterestTag.fromJson(row as Map<String, dynamic>),
        )
        .toList();

    int memberCount = 0;
    final dynamic memberAgg = json['miembro_comunidad'];
    if (memberAgg is List && memberAgg.isNotEmpty) {
      final dynamic countValue = memberAgg.first['count'];
      if (countValue is num) {
        memberCount = countValue.toInt();
      }
    }

    final Map<String, dynamic>? creador =
        json['creador'] as Map<String, dynamic>?;
    final String? nombres = creador?['nombres'] as String?;
    final String? apellidos = creador?['apellidos'] as String?;
    final String leadName = <String>[
      if (nombres != null && nombres.trim().isNotEmpty) nombres.trim(),
      if (apellidos != null && apellidos.trim().isNotEmpty) apellidos.trim(),
    ].join(' ').trim();

    return CommunityListItem(
      id: (json['id_comunidad'] as num).toInt(),
      name: json['nombre'] as String? ?? '',
      description: json['descripcion'] as String? ?? '',
      privacidad: json['privacidad'] as String? ?? 'PUBLICA',
      estado: json['estado'] as String? ?? 'PENDIENTE',
      interestTags: tags,
      memberCount: memberCount,
      leadCreatorName: leadName.isEmpty
          ? (creador?['username'] as String?)
          : leadName,
      bannerUrl: json['banner_url'] as String?,
    );
  }
}

class CommunityMemberItem {
  const CommunityMemberItem({
    required this.usuarioId,
    required this.displayName,
    required this.rol,
  });

  final int usuarioId;
  final String displayName;
  final String rol;
}
