class User {
  final int userId;
  final String fullName;
  final String email;
  final String? avatarUrl;
  final String role;
  final String levelName;
  final int totalExp;
  final int streakDays;
  final int totalLessonsCompleted;
  final int totalLessonsTaken;
  final int totalLearningTimeMinutes;
  final double averageCompletionPercentage;
  final int totalAchievementsUnlocked;
  final int totalAchievementExpGain;
  final DateTime createdAt;
  final DateTime? lastLogin;
  final DateTime? lastPracticeDate;

  User({
    required this.userId,
    required this.fullName,
    required this.email,
    this.avatarUrl,
    this.role = 'learner',
    required this.levelName,
    required this.totalExp,
    required this.streakDays,
    this.totalLessonsCompleted = 0,
    this.totalLessonsTaken = 0,
    this.totalLearningTimeMinutes = 0,
    this.averageCompletionPercentage = 0.0,
    this.totalAchievementsUnlocked = 0,
    this.totalAchievementExpGain = 0,
    required this.createdAt,
    this.lastLogin,
    this.lastPracticeDate,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      userId: json["userId"] ?? json["user_id"] ?? 0,
      fullName: json["fullName"] ?? json["full_name"] ?? '',
      email: json["email"] ?? '',
      avatarUrl: json["avatarUrl"] ?? json["avatar_url"],
      role: json["role"] ?? 'learner',
      levelName: json["levelName"] ?? json["level_name"] ?? 'Beginner',
      totalExp: json["totalExp"] ?? json["total_exp"] ?? 0,
      streakDays: json["streakDays"] ?? json["streak_days"] ?? 0,
      totalLessonsCompleted:
          json["totalLessonsCompleted"] ?? json["total_lessons_completed"] ?? 0,
      totalLessonsTaken:
          json["totalLessonsTaken"] ?? json["total_lessons_taken"] ?? 0,
      totalLearningTimeMinutes: json["totalLearningTimeMinutes"] ??
          json["total_learning_time_minutes"] ??
          0,
      averageCompletionPercentage: (json["averageCompletionPercentage"] ??
              json["average_completion_percentage"] ??
              0.0)
          .toDouble(),
      totalAchievementsUnlocked: json["totalAchievementsUnlocked"] ??
          json["total_achievements_unlocked"] ??
          0,
      totalAchievementExpGain: json["totalAchievementExpGain"] ??
          json["total_achievement_exp_gain"] ??
          0,
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
      lastPracticeDate: json["lastPracticeDate"] != null
          ? DateTime.parse(json["lastPracticeDate"])
          : json["last_practice_date"] != null
              ? DateTime.parse(json["last_practice_date"])
              : null,
    );
  }
  Map<String, dynamic> toJson() {
    return {
      "userId": userId,
      "fullName": fullName,
      "email": email,
      "avatarUrl": avatarUrl,
      "role": role,
      "levelName": levelName,
      "totalExp": totalExp,
      "streakDays": streakDays,
      "totalLessonsCompleted": totalLessonsCompleted,
      "totalLessonsTaken": totalLessonsTaken,
      "totalLearningTimeMinutes": totalLearningTimeMinutes,
      "averageCompletionPercentage": averageCompletionPercentage,
      "totalAchievementsUnlocked": totalAchievementsUnlocked,
      "totalAchievementExpGain": totalAchievementExpGain,
      "createdAt": createdAt.toIso8601String(),
      "lastLogin": lastLogin?.toIso8601String(),
      "lastPracticeDate": lastPracticeDate?.toIso8601String(),
    };
  }
}
