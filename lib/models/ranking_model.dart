class RankingModel {
  final int userId;
  final String fullName;
  final String email;
  final String? avatarUrl;
  final String levelName;
  final int totalExp;
  final int streakDays;
  final int totalLessonsCompleted;
  final int totalAchievementsUnlocked;
  final int totalLearningTimeMinutes;
  final int ranking;

  RankingModel({
    required this.userId,
    required this.fullName,
    required this.email,
    this.avatarUrl,
    required this.levelName,
    required this.totalExp,
    required this.streakDays,
    required this.totalLessonsCompleted,
    required this.totalAchievementsUnlocked,
    required this.totalLearningTimeMinutes,
    required this.ranking,
  });

  factory RankingModel.fromJson(Map<String, dynamic> json) {
    return RankingModel(
      userId: json['userId'] as int,
      fullName: json['fullName'] as String,
      email: json['email'] as String,
      avatarUrl: json['avatarUrl'] as String?,
      levelName: json['levelName'] as String,
      totalExp: json['totalExp'] as int,
      streakDays: json['streakDays'] as int,
      totalLessonsCompleted: json['totalLessonsCompleted'] as int,
      totalAchievementsUnlocked: json['totalAchievementsUnlocked'] as int,
      totalLearningTimeMinutes: json['totalLearningTimeMinutes'] as int,
      ranking: json['ranking'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'fullName': fullName,
      'email': email,
      'avatarUrl': avatarUrl,
      'levelName': levelName,
      'totalExp': totalExp,
      'streakDays': streakDays,
      'totalLessonsCompleted': totalLessonsCompleted,
      'totalAchievementsUnlocked': totalAchievementsUnlocked,
      'totalLearningTimeMinutes': totalLearningTimeMinutes,
      'ranking': ranking,
    };
  }

  static List<RankingModel> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((json) => RankingModel.fromJson(json)).toList();
  }

  // Helper để lấy màu theo level
  String get levelColor {
    switch (levelName.toLowerCase()) {
      case 'beginner':
        return 'green';
      case 'intermediate':
        return 'blue';
      case 'advanced':
        return 'purple';
      default:
        return 'grey';
    }
  }

  // Helper để format thời gian học
  String get formattedLearningTime {
    if (totalLearningTimeMinutes < 60) {
      return '$totalLearningTimeMinutes phút';
    }
    final hours = totalLearningTimeMinutes ~/ 60;
    final minutes = totalLearningTimeMinutes % 60;
    return '${hours}h ${minutes}p';
  }

  // Helper để lấy tên viết tắt
  String get initials {
    final names = fullName.split(' ');
    if (names.length >= 2) {
      return '${names[0][0]}${names[names.length - 1][0]}'.toUpperCase();
    }
    return fullName.substring(0, 1).toUpperCase();
  }
}
