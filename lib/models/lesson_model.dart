class Lesson {
  final int lessonId;
  final int courseId;
  final String lessonTitle;
  final int lessonOrder;
  final String description;
  final String videoUrl;
  final int expReward;
  final String? lessonType; // 'piano_key', 'sheet_music', 'chord', etc.

  Lesson({
    required this.lessonId,
    required this.courseId,
    required this.lessonTitle,
    required this.lessonOrder,
    required this.description,
    required this.videoUrl,
    required this.expReward,
    this.lessonType,
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
      lessonType: json['lessonType'] as String?,
    );
  }

  /// Determine lesson type based on available data
  /// Priority: lessonType field > lessonOrder logic > default
  String getLessonType() {
    // If backend provides lessonType, use it
    if (lessonType != null && lessonType!.isNotEmpty) {
      return lessonType!;
    }

    // Fallback logic based on lessonOrder
    // Lessons 1-2: piano key recognition
    // Lessons 3+: sheet music reading
    if (lessonId <= 2) {
      return 'piano_key';
    } else if (lessonId >= 5) {
      return 'chord_lesson';
    } else {
      return 'sheet_music';
    }
  }

  /// Check if this is a piano key recognition lesson
  bool isPianoKeyLesson() => getLessonType() == 'piano_key';
  bool isSheetMusicLesson() => getLessonType() == 'sheet_music';
  bool isChordMusicLesson() => getLessonType() == 'chord_lesson';
}
