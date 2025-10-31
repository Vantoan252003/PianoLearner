import 'dart:math';
import 'package:flutter/material.dart';
import '../../models/piano_question_model.dart';
import 'piano_detection_service.dart';
import '../piano_question_service/piano_question_service.dart';
import '../user_progress_service/user_progress_service.dart';

class PianoGameService {
  final int lessonId;
  final PianoDetectionService _pianoDetectionService = PianoDetectionService();

  static const List<String> noteNames = [
    'C',
    'C#',
    'D',
    'D#',
    'E',
    'F',
    'F#',
    'G',
    'G#',
    'A',
    'A#',
    'B'
  ];

  int score = 0;
  int totalAttempts = 0;
  bool isAnswered = false;
  List<PianoQuestion> questions = [];
  int currentQuestionIndex = 0;
  bool isLoading = true;
  bool _isMicrophoneMode = false;
  bool _isMicrophoneReady = false;
  static const int maxQuestions = 15;
  DateTime? _startTime;
  int streak = 0;
  int bestStreak = 0;
  int? currentTargetMidi;
  String? currentTargetNote;
  Function? onCorrectDetected;
  PianoGameService(this.lessonId);
  bool get isMicrophoneMode => _isMicrophoneMode;
  bool get isMicrophoneReady => _isMicrophoneReady;
  int get remainingQuestions => maxQuestions - totalAttempts;
  double get accuracy => totalAttempts > 0 ? (score / totalAttempts) * 100 : 0;
  Future<bool> initializeMicrophone() async {
    final success = await _pianoDetectionService.initialize();
    _isMicrophoneReady = success;
    return success;
  }

  Future<void> loadQuestions() async {
    try {
      isLoading = true;
      questions = await PianoQuestionService().fetchPianoQuestions(lessonId);
      _startTime = DateTime.now();
      isLoading = false;
    } catch (e) {
      isLoading = false;
      rethrow;
    }
  }

  void generateNewTarget({int? positionForStaff}) {
    if (questions.isEmpty) return;

    final currentQuestion = questions[currentQuestionIndex % questions.length];
    final midiNumbers = currentQuestion.midiNumbers;

    if (midiNumbers.isNotEmpty) {
      final random = Random();
      currentTargetMidi = midiNumbers[random.nextInt(midiNumbers.length)];
      currentTargetNote = noteNames[currentTargetMidi! % 12];
      isAnswered = false;
      if (_isMicrophoneMode && _isMicrophoneReady) {
        startListening();
      }
    }
  }

  void startListening() {
    _pianoDetectionService.startDetection((detectedNotes) {
      if (isAnswered || !_isMicrophoneMode) return;

      if (_pianoDetectionService.checkNoteMatch(
          detectedNotes, currentTargetNote ?? '')) {
        if (onCorrectDetected != null) {
          onCorrectDetected!();
        }
      }
    });
  }

  void stopListening() {
    _pianoDetectionService.stopDetection();
  }

  bool handleCorrectAnswer({bool updateStreak = true}) {
    if (isAnswered) return false;

    isAnswered = true;
    totalAttempts++;
    score++;

    if (updateStreak) {
      streak++;
      if (streak > bestStreak) {
        bestStreak = streak;
      }
    }

    // Kiểm tra nếu đã đủ số câu hỏi
    if (totalAttempts >= maxQuestions) {
      return true; // Game kết thúc
    }

    return false; // Tiếp tục chơi
  }

  void handleWrongAnswer() {
    if (isAnswered) return;

    isAnswered = true;
    totalAttempts++;
    streak = 0;
  }

  void nextQuestion() {
    currentQuestionIndex++;
    generateNewTarget();
  }

  void toggleMode(BuildContext context, Function(bool) onModeChanged) {
    _isMicrophoneMode = !_isMicrophoneMode;
    onModeChanged(_isMicrophoneMode);

    if (_isMicrophoneMode) {
      if (_isMicrophoneReady) {
        if (!isAnswered) {
          startListening();
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Microphone chưa sẵn sàng!')),
        );
        _isMicrophoneMode = false;
        onModeChanged(false);
      }
    } else {
      stopListening();
    }
  }

  (bool, bool) handlePianoTap(int midiNoteNumber, int? targetMidi,
      {bool updateStreak = true}) {
    if (isAnswered || _isMicrophoneMode) return (false, false);

    final tappedName = noteNames[midiNoteNumber % 12];
    final targetName = noteNames[targetMidi! % 12];
    final isCorrect = tappedName == targetName;

    isAnswered = true;
    totalAttempts++;

    if (isCorrect) {
      score++;
      if (updateStreak) {
        streak++;
        if (streak > bestStreak) {
          bestStreak = streak;
        }
      }
    } else if (updateStreak) {
      streak = 0;
    }
    final isGameFinished = totalAttempts >= maxQuestions;

    return (isCorrect, isGameFinished);
  }

  Future<void> finishGame(BuildContext context) async {
    final timeSpentMinutes = _startTime != null
        ? DateTime.now().difference(_startTime!).inMinutes
        : 0;

    final completionPercentage =
        totalAttempts > 0 ? ((score / totalAttempts) * 100).round() : 0;

    final isCompleted = completionPercentage >= 95;

    try {
      await CoursesService().updateUserProgress(
        lessonId: lessonId,
        completionPercentage: completionPercentage,
        timeSpentMinutes: timeSpentMinutes,
        isCompleted: isCompleted,
      );

      if (context.mounted) {
        showResultDialog(context, completionPercentage, isCompleted);
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Lỗi khi lưu tiến trình: $e')),
        );
      }
    }
  }

  /// Hiển thị dialog kết quả
  void showResultDialog(
      BuildContext context, int completionPercentage, bool isCompleted,
      {bool showStreak = false}) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            isCompleted ? '🎉 Hoàn thành!' : '📊 Kết quả',
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Điểm: $score/$maxQuestions',
                style: const TextStyle(fontSize: 20),
              ),
              const SizedBox(height: 10),
              Text(
                'Tỉ lệ đúng: $completionPercentage%',
                style: const TextStyle(fontSize: 18),
              ),
              if (showStreak && bestStreak > 0) ...[
                const SizedBox(height: 10),
                Text(
                  'Combo tốt nhất: $bestStreak',
                  style: const TextStyle(fontSize: 18),
                ),
              ],
              const SizedBox(height: 10),
              Text(
                isCompleted
                    ? 'Bạn đã hoàn thành bài học!'
                    : 'Hãy cố gắng thêm nhé!',
                style: TextStyle(
                  fontSize: 16,
                  color: isCompleted ? Colors.green : Colors.orange,
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  static int noteToMidi(String note, {int octave = 3}) {
    const noteMap = {
      'C': 0,
      'C#': 1,
      'D': 2,
      'D#': 3,
      'E': 4,
      'F': 5,
      'F#': 6,
      'G': 7,
      'G#': 8,
      'A': 9,
      'A#': 10,
      'B': 11,
    };
    return (octave + 1) * 12 + (noteMap[note] ?? 0);
  }

  static String midiToNote(int midiNumber) {
    return noteNames[midiNumber % 12];
  }

  void resetGame() {
    score = 0;
    totalAttempts = 0;
    streak = 0;
    bestStreak = 0;
    currentQuestionIndex = 0;
    isAnswered = false;
    currentTargetMidi = null;
    currentTargetNote = null;
    _startTime = DateTime.now();
  }

  void dispose() {
    _pianoDetectionService.dispose();
  }
}
