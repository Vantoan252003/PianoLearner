// user_progress_model.dart

class UserProgress {
  final int progressId;
  final int userId;
  final int lessonId;
  final bool isCompleted;
  final int completionPercentage;
  final int timeSpentMinutes;
  final DateTime? lastAccessed;
  final DateTime? completedAt;

  UserProgress({
    required this.progressId,
    required this.userId,
    required this.lessonId,
    required this.isCompleted,
    required this.completionPercentage,
    required this.timeSpentMinutes,
    this.lastAccessed,
    this.completedAt,
  });

  factory UserProgress.fromJson(Map<String, dynamic> json) {
    return UserProgress(
      progressId: json['progressId'],
      userId: json['userId'],
      lessonId: json['lessonId'],
      isCompleted: json['isCompleted'],
      completionPercentage: json['completionPercentage'],
      timeSpentMinutes: json['timeSpentMinutes'],
      lastAccessed: json['lastAccessed'] != null
          ? DateTime.parse(json['lastAccessed'])
          : null,
      completedAt: json['completedAt'] != null
          ? DateTime.parse(json['completedAt'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'progressId': progressId,
      'userId': userId,
      'lessonId': lessonId,
      'isCompleted': isCompleted,
      'completionPercentage': completionPercentage,
      'timeSpentMinutes': timeSpentMinutes,
      'lastAccessed': lastAccessed?.toIso8601String(),
      'completedAt': completedAt?.toIso8601String(),
    };
  }

  static List<UserProgress> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((json) => UserProgress.fromJson(json)).toList();
  }
}
