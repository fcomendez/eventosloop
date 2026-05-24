class UserCommunityOption {
  const UserCommunityOption({
    required this.id,
    required this.name,
  });

  final String id;
  final String name;
}

class UserCommunitiesMock {
  const UserCommunitiesMock._();

  static const List<UserCommunityOption> participando = <UserCommunityOption>[
    UserCommunityOption(id: 'creative', name: 'Creative Collective'),
    UserCommunityOption(id: 'tech', name: 'Tech Founders Circle'),
    UserCommunityOption(id: 'opensource', name: 'Open Source Explorers'),
    UserCommunityOption(id: 'canvas', name: 'Digital Canvas Lab'),
  ];
}
