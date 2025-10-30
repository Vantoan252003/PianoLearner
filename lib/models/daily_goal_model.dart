class DailyGoal {
  final int goalId;
  final int userId;
  final DateTime goalDate;
  final int targetMinutes;
  final int completedMinutes;
  final bool isCompleted;

  DailyGoal({
    required this.goalId,
    required this.userId,
    required this.goalDate,
    this.targetMinutes = 30,
    this.completedMinutes = 0,
    this.isCompleted = false,
  });

  factory DailyGoal.fromJson(Map<String, dynamic> json) {
    return DailyGoal(
      goalId: json['goalId'] ?? json['goal_id'] ?? 0,
      userId: json['userId'] ?? json['user_id'] ?? 0,
      goalDate: json['goalDate'] != null
          ? DateTime.parse(json['goalDate'])
          : json['goal_date'] != null
              ? DateTime.parse(json['goal_date'])
              : DateTime.now(),
      targetMinutes: json['targetMinutes'] ?? json['target_minutes'] ?? 30,
      completedMinutes:
          json['completedMinutes'] ?? json['completed_minutes'] ?? 0,
      isCompleted: json['isCompleted'] ?? json['is_completed'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'goal_id': goalId,
      'user_id': userId,
      'goal_date': goalDate.toIso8601String(),
      'target_minutes': targetMinutes,
      'completed_minutes': completedMinutes,
      'is_completed': isCompleted,
    };
  }

  double get progress {
    if (targetMinutes == 0) return 0;
    return (completedMinutes / targetMinutes).clamp(0.0, 1.0);
  }
}
