class Courses {
  final int courseId;
  final String courseName;
  final String description;
  final String? thumbnailUrl;
  final String difficultyLevel;
  final int durationWeeks;
  final int totalLessons;
  final DateTime? createAt;

  Courses({
    required this.courseId,
    required this.courseName,
    required this.description,
    this.thumbnailUrl,
    required this.difficultyLevel,
    required this.durationWeeks,
    required this.totalLessons,
    this.createAt,
  });

  factory Courses.fromJson(Map<String, dynamic> json) {
    return Courses(
      courseId: json['courseId'] ?? 0,
      courseName: json['courseName'] ?? '',
      description: json['description'] ?? '',
      thumbnailUrl: json['thumbnailUrl'],
      difficultyLevel: json['difficultyLevel'] ?? '',
      durationWeeks: json['durationWeeks'] ?? 0,
      totalLessons: json['totalLessons'] ?? 0,
      createAt:
          json['createAt'] != null ? DateTime.tryParse(json['createAt']) : null,
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'courseId': courseId,
      'courseName': courseName,
      'description': description,
      'thumbnailUrl': thumbnailUrl,
      'difficultyLevel': difficultyLevel,
      'durationWeeks': durationWeeks,
      'totalLessons': totalLessons,
      'createAt': createAt?.toIso8601String(),
    };
  }
}
