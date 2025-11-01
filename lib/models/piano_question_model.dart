class PianoQuestion {
  final int lessonId;
  final List<int> midiNumbers;
  final String difficulty;
  final int questionCount;
  final List<List<int>>? chord;

  PianoQuestion(
      {required this.lessonId,
      required this.midiNumbers,
      required this.difficulty,
      required this.questionCount,
      this.chord});

  factory PianoQuestion.fromJson(Map<String, dynamic> json) {
    return PianoQuestion(
      lessonId: json['lessonId'] as int,
      midiNumbers: List<int>.from(json['midiNumbers']),
      difficulty: json['difficulty'] as String,
      questionCount: json['questionCount'] as int,
      chord: json['chord'] != null
          ? List<List<int>>.from(
              (json['chord'] as List).map((c) => List<int>.from(c as List)))
          : null,
    );
  }

  /// Chuyển đối tượng thành JSON
  Map<String, dynamic> toJson() {
    return {
      'lessonId': lessonId,
      'midiNumbers': midiNumbers,
      'difficulty': difficulty,
      'questionCount': questionCount,
      'chord': chord,
    };
  }

  /// Hàm tiện ích để parse danh sách JSON
  static List<PianoQuestion> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((json) => PianoQuestion.fromJson(json)).toList();
  }
}
