import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_piano_pro/note_model.dart';
import 'package:pianist_vip_pro/screen/main_widget_function/header_game_ui.dart';
import '../../main_widget_function/custom_piano.dart';
import '../../main_widget_function/practice_header.dart';

import '../../../services/practice_service/get_piano_colors.dart';
import '../../../services/soundfont_service.dart';

class KeyRecognitionScreen extends StatefulWidget {
  const KeyRecognitionScreen({Key? key}) : super(key: key);

  @override
  State<KeyRecognitionScreen> createState() => _KeyRecognitionScreenState();
}

class _KeyRecognitionScreenState extends State<KeyRecognitionScreen> {
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

  @override
  void initState() {
    super.initState();
    SoundfontService.loadSoundfont();
    _generateNewTarget();
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

  void _generateNewTarget() {
    final midiNote = 48 + Random().nextInt(24);
    setState(() {
      currentTargetMidi = midiNote;
      currentTargetNote = noteNames[midiNote % 12];
      isAnswered = false;
      pressedKeys.value = {};
    });
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
      if (mounted) _generateNewTarget();
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
