class AuthSessionModel {
  AuthSessionModel({
    required this.accessToken,
    required this.refreshToken,
    required this.userId,
    required this.email,
  });

  final String accessToken;
  final String refreshToken;
  final int userId;
  final String email;

  factory AuthSessionModel.fromJson(Map<String, dynamic> json) {
    return AuthSessionModel(
      accessToken: json['access_token'] as String? ?? '',
      refreshToken: json['refresh_token'] as String? ?? '',
      userId: (json['user_id'] as num?)?.toInt() ?? 0,
      email: json['email'] as String? ?? '',
    );
  }
}
