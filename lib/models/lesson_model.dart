class Lesson {
  final int lessonId;
  final int courseId;
  final String lessonTitle;
  final int lessonOrder;
  final String description;
  final String videoUrl;
  final int expReward;

  Lesson({
    required this.lessonId,
    required this.courseId,
    required this.lessonTitle,
    required this.lessonOrder,
    required this.description,
    required this.videoUrl,
    required this.expReward,
  });

  factory Lesson.fromJson(Map<String, dynamic> json) {
    return Lesson(
      lessonId: json['lessonId'],
      courseId: json['courseId'],
      lessonTitle: json['lessonTitle'],
      lessonOrder: json['lessonOrder'],
      description: json['description'],
      videoUrl: json['videoUrl'],
      expReward: json['expReward'],
    );
  }
}
