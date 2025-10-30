class UserStatistics {
  final int userId;
  final String fullName;
  final String email;
  final String levelName;
  final int totalExp;
  final int streakDays;
  final int lessonsCompleted;
  final int achievementsUnlocked;
  final int totalPracticeMinutes;

  UserStatistics({
    required this.userId,
    required this.fullName,
    required this.email,
    required this.levelName,
    required this.totalExp,
    required this.streakDays,
    this.lessonsCompleted = 0,
    this.achievementsUnlocked = 0,
    this.totalPracticeMinutes = 0,
  });

  factory UserStatistics.fromJson(Map<String, dynamic> json) {
    return UserStatistics(
      userId: json['userId'] ?? json['user_id'] ?? 0,
      fullName: json['fullName'] ?? json['full_name'] ?? '',
      email: json['email'] ?? '',
      levelName: json['levelName'] ?? json['level_name'] ?? 'Beginner',
      totalExp: json['totalExp'] ?? json['total_exp'] ?? 0,
      streakDays: json['streakDays'] ?? json['streak_days'] ?? 0,
      lessonsCompleted:
          json['lessonsCompleted'] ?? json['lessons_completed'] ?? 0,
      achievementsUnlocked:
          json['achievementsUnlocked'] ?? json['achievements_unlocked'] ?? 0,
      totalPracticeMinutes:
          json['totalPracticeMinutes'] ?? json['total_practice_minutes'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'full_name': fullName,
      'email': email,
      'level_name': levelName,
      'total_exp': totalExp,
      'streak_days': streakDays,
      'lessons_completed': lessonsCompleted,
      'achievements_unlocked': achievementsUnlocked,
      'total_practice_minutes': totalPracticeMinutes,
    };
  }
}
