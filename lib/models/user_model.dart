class User {
  final int userId;
  final String fullName;
  final String email;
  final String? avatarUrl;
  final String levelName;
  final int totalExp;
  final int streakDays;
  final DateTime createdAt;
  final DateTime? lastLogin;
  User({
    required this.userId,
    required this.fullName,
    required this.email,
    this.avatarUrl,
    required this.levelName,
    required this.totalExp,
    required this.streakDays,
    required this.createdAt,
    this.lastLogin,
  });
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      userId: json["userId"] ?? json["user_id"] ?? 0,
      fullName: json["fullName"] ?? json["full_name"] ?? '',
      email: json["email"] ?? '',
      avatarUrl: json["avatarUrl"] ?? json["avatar_url"],
      levelName: json["levelName"] ?? json["level_name"] ?? 'Beginner',
      totalExp: json["totalExp"] ?? json["total_exp"] ?? 0,
      streakDays: json["streakDays"] ?? json["streak_days"] ?? 0,
      createdAt: json["createdAt"] != null
          ? DateTime.parse(json["createdAt"])
          : json["created_at"] != null
              ? DateTime.parse(json["created_at"])
              : DateTime.now(),
      lastLogin: json["lastLogin"] != null
          ? DateTime.parse(json["lastLogin"])
          : json["last_login"] != null
              ? DateTime.parse(json["last_login"])
              : null,
    );
  }
  Map<String, dynamic> toJson() {
    return {
      "user_id": userId,
      "full_name": fullName,
      "email": email,
      "avatar_url": avatarUrl,
      "levelName": levelName,
      "total_exp": totalExp,
      "streak_days": streakDays,
      "created_at": createdAt.toIso8601String(),
      "last_login": lastLogin?.toIso8601String(),
    };
  }
}
