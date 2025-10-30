import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_piano_pro/note_model.dart';
import 'package:pianist_vip_pro/screen/main_widget_function/custom_piano.dart';
import 'package:pianist_vip_pro/screen/main_widget_function/header_game_ui.dart';
import 'package:pianist_vip_pro/screen/main_widget_function/practice_header.dart';
import '../../../services/practice_service/get_piano_colors.dart';
import '../../../services/common_service/soundfont_service.dart';
import '../../../services/piano_question_service/piano_question_service.dart';
import '../../services/common_service/piano_detection_service.dart';
import '../../../models/piano_question_model.dart';

class PianoQuestionScreen extends StatefulWidget {
  final int lessonId;

  const PianoQuestionScreen({Key? key, required this.lessonId})
      : super(key: key);

  @override
  State<PianoQuestionScreen> createState() => _PianoQuestionScreenState();
}

class _PianoQuestionScreenState extends State<PianoQuestionScreen> {
  final ValueNotifier<Set<int>> pressedKeys = ValueNotifier<Set<int>>({});
  final List<String> noteNames = [
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

  String? currentTargetNote;
  int? currentTargetMidi;
  int score = 0;
  int totalAttempts = 0;
  bool isAnswered = false;
  List<PianoQuestion> questions = [];
  int currentQuestionIndex = 0;
  bool isLoading = true;
  final PianoDetectionService _pianoDetectionService = PianoDetectionService();
  bool _isMicrophoneMode = false;
  bool _isMicrophoneReady = false;

  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    SoundfontService.loadSoundfont();
    _initializeMicrophone();
    _loadQuestions();
  }

  @override
  void dispose() {
    pressedKeys.value.forEach((key) {
      SoundfontService.stopNote(key);
    });
    SoundfontService.dispose();
    _pianoDetectionService.dispose();
    pressedKeys.dispose();
    SystemChrome.setPreferredOrientations(DeviceOrientation.values);

    super.dispose();
  }

  Future<void> _initializeMicrophone() async {
    final success = await _pianoDetectionService.initialize();
    setState(() {
      _isMicrophoneReady = success;
    });
  }

  void _loadQuestions() async {
    final fetchedQuestions =
        await PianoQuestionService().fetchPianoQuestions(widget.lessonId);
    setState(() {
      questions = fetchedQuestions;
      isLoading = false;
    });
    _generateNewTarget();
  }

  void _generateNewTarget() {
    if (questions.isEmpty) return;
    final currentQuestion = questions[currentQuestionIndex % questions.length];
    final midiNumbers = currentQuestion.midiNumbers;
    if (midiNumbers.isNotEmpty) {
      currentTargetMidi = midiNumbers[Random().nextInt(midiNumbers.length)];
      currentTargetNote = noteNames[currentTargetMidi! % 12];
      isAnswered = false;
      pressedKeys.value = {};

      if (_isMicrophoneMode && _isMicrophoneReady) {
        _startListening();
      }
    }
  }

  void _startListening() {
    _pianoDetectionService.startDetection((detectedNotes) {
      if (isAnswered || !_isMicrophoneMode) return;
      if (_pianoDetectionService.checkNoteMatch(
          detectedNotes, currentTargetNote ?? '')) {
        _handleCorrectAnswer();
      }
    });
  }

  void _stopListening() {
    _pianoDetectionService.stopDetection();
  }

  void _handleCorrectAnswer() {
    if (isAnswered) return;

    setState(() {
      isAnswered = true;
      totalAttempts++;
      score++;
    });

    if (currentTargetMidi != null && !_isMicrophoneMode) {
      SoundfontService.playNote(currentTargetMidi!);
    }

    Future.delayed(const Duration(milliseconds: 100), () {
      if (mounted) {
        setState(() {
          currentQuestionIndex++;
        });
        _generateNewTarget();
      }
    });
  }

  void _toggleMode() {
    setState(() {
      _isMicrophoneMode = !_isMicrophoneMode;
    });

    if (_isMicrophoneMode) {
      if (_isMicrophoneReady) {
        _startListening();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Microphone chưa sẵn sàng!')),
        );
        setState(() {
          _isMicrophoneMode = false;
        });
      }
    } else {
      _stopListening();
    }
  }

  void _handlePianoTap(NoteModel? note) {
    if (note == null || isAnswered || _isMicrophoneMode) return;
    final tappedName = noteNames[note.midiNoteNumber % 12];
    final targetName = noteNames[currentTargetMidi! % 12];

    setState(() {
      isAnswered = true;
      totalAttempts++;
      if (tappedName == targetName) score++;
      pressedKeys.value = {note.midiNoteNumber};
    });

    SoundfontService.playNote(note.midiNoteNumber);
    Future.delayed(const Duration(milliseconds: 100), () {
      if (mounted) {
        setState(() {
          currentQuestionIndex++;
        });
        _generateNewTarget();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    double correctRate = totalAttempts == 0 ? 0 : (score / totalAttempts) * 100;
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.grey.shade900, Colors.black, Colors.grey.shade800],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              AppHeader(
                  title: "Nhận diện phím",
                  onBack: () => Navigator.pop(context)),

              // Toggle button cho chế độ
              Padding(
                padding: const EdgeInsets.all(0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      _isMicrophoneMode ? Icons.mic : Icons.touch_app,
                      color: _isMicrophoneMode
                          ? Colors.redAccent
                          : Colors.blueAccent,
                      size: 24,
                    ),
                    const SizedBox(width: 12),
                    Text(
                      _isMicrophoneMode
                          ? 'Chế độ: Nghe Microphone'
                          : 'Chế độ: Bấm phím',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Switch(
                      value: _isMicrophoneMode,
                      onChanged:
                          _isMicrophoneReady ? (_) => _toggleMode() : null,
                      activeColor: Colors.redAccent,
                      inactiveThumbColor: Colors.blueAccent,
                    ),
                  ],
                ),
              ),

              Row(
                children: [
                  Expanded(
                    child: HeaderGameUi()
                        .buildStat("🏆 Điểm", '$score', Colors.orangeAccent),
                  ),
                  Expanded(
                    child: Center(
                      child: HeaderGameUi().buildStat("🎯 Nốt cần chơi",
                          currentTargetNote ?? "-", Colors.greenAccent),
                    ),
                  ),
                  Expanded(
                    child: HeaderGameUi().buildStat(
                        "📊 Tỉ lệ đúng",
                        '${correctRate.toStringAsFixed(0)}%',
                        Colors.blueAccent),
                  ),
                ],
              ),
              const SizedBox(height: 80),
              Expanded(
                child: isLoading
                    ? Center(child: const CircularProgressIndicator())
                    : ValueListenableBuilder(
                        valueListenable: pressedKeys,
                        builder: (context, _, child) {
                          return CustomPiano(
                              buttonColors: getPianoColors(currentTargetMidi,
                                  pressedKeys.value, isAnswered),
                              onNotePressed: _handlePianoTap,
                              noteCount: 20,
                              whiteHeight: 150);
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
