class CommunityIdMapper {
  const CommunityIdMapper._();

  static String? communityIdToOptionId(int? communityId) {
    if (communityId == null) {
      return null;
    }
    return switch (communityId) {
      1 => 'creative',
      2 => 'tech',
      3 => 'opensource',
      4 => 'canvas',
      _ => null,
    };
  }

  static int? optionIdToCommunityId(String? optionId) {
    if (optionId == null) {
      return null;
    }
    return switch (optionId) {
      'creative' => 1,
      'tech' => 2,
      'opensource' => 3,
      'canvas' => 4,
      _ => null,
    };
  }
}
