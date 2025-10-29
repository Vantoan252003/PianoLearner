// piano_question_model.dart

class PianoQuestion {
  final int lessonId;
  final List<int> midiNumbers;
  final String difficulty;

  PianoQuestion({
    required this.lessonId,
    required this.midiNumbers,
    required this.difficulty,
  });

  factory PianoQuestion.fromJson(Map<String, dynamic> json) {
    return PianoQuestion(
      lessonId: json['lessonId'] as int,
      midiNumbers: List<int>.from(json['midiNumbers']),
      difficulty: json['difficulty'] as String,
    );
  }

  /// Chuyển đối tượng thành JSON
  Map<String, dynamic> toJson() {
    return {
      'lessonId': lessonId,
      'midiNumbers': midiNumbers,
      'difficulty': difficulty,
    };
  }

  /// Hàm tiện ích để parse danh sách JSON
  static List<PianoQuestion> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((json) => PianoQuestion.fromJson(json)).toList();
  }
}
