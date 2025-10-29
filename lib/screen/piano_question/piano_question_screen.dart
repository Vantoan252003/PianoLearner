import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_piano_pro/note_model.dart';
import 'package:pianist_vip_pro/screen/main_widget_function/custom_piano.dart';
import 'package:pianist_vip_pro/screen/main_widget_function/header_game_ui.dart';
import 'package:pianist_vip_pro/screen/main_widget_function/practice_header.dart';
import '../../../services/practice_service/get_piano_colors.dart';
import '../../../services/common_service/soundfont_service.dart';
import '../../../services/piano_question_service/piano_question_service.dart';
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

  @override
  void initState() {
    super.initState();
    SoundfontService.loadSoundfont();
    _loadQuestions();
  }

  @override
  void dispose() {
    pressedKeys.value.forEach((key) {
      SoundfontService.stopNote(key);
    });
    SoundfontService.dispose();
    pressedKeys.dispose();

    super.dispose();
  }

  void _loadQuestions() async {
    try {
      final fetchedQuestions =
          await PianoQuestionService().fetchPianoQuestions(widget.lessonId);
      setState(() {
        questions = fetchedQuestions;
      });
      _generateNewTarget();
    } catch (e) {
      // Handle error, maybe show snackbar
      print('Error loading questions: $e');
    }
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
    }
  }

  void _handlePianoTap(NoteModel? note) {
    if (note == null || isAnswered) return;
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
              Expanded(
                child: HeaderGameUi().buildStat("🎯 Nốt cần chơi",
                    currentTargetNote ?? "-", Colors.greenAccent),
              ),
              Expanded(
                child: HeaderGameUi()
                    .buildStat("🏆 Điểm", '$score', Colors.orangeAccent),
              ),
              Expanded(
                child: HeaderGameUi().buildStat("📊 Tỉ lệ đúng",
                    '${correctRate.toStringAsFixed(0)}%', Colors.blueAccent),
              ),
              Expanded(
                child: ValueListenableBuilder(
                  valueListenable: pressedKeys,
                  builder: (context, _, child) {
                    return CustomPiano(
                      buttonColors: getPianoColors(
                          currentTargetMidi, pressedKeys.value, isAnswered),
                      onNotePressed: _handlePianoTap,
                    );
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
