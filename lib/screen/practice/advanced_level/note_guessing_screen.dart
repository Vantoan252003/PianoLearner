import 'package:flutter/material.dart';
import 'package:pianist_vip_pro/screen/main_widget_function/custom_piano.dart';
import 'package:pianist_vip_pro/screen/main_widget_function/header_game_ui.dart';
import 'package:pianist_vip_pro/services/soundfont_service.dart';
import 'dart:math';
import 'package:flutter_piano_pro/note_model.dart';
import '../../main_widget_function/treble_music_staff.dart';
import '../../../services/practice_service/get_piano_colors.dart';

class NoteGuessingScreen extends StatefulWidget {
  const NoteGuessingScreen({Key? key}) : super(key: key);

  @override
  State<NoteGuessingScreen> createState() => _NoteGuessingScreenState();
}

class _NoteGuessingScreenState extends State<NoteGuessingScreen> {
  final List<String> notes = [
    'C',
    'D',
    'E',
    'F',
    'G',
    'A',
    'B',
    'C#',
    'D#',
    'F#',
    'G#',
    'A#'
  ];

  String? currentNote;
  int currentPosition = 0; // Position on staff (0-12)
  int? currentTargetMidi;
  String? selectedAnswer;
  int score = 0;
  int totalAttempts = 0;
  int streak = 0;
  int bestStreak = 0;
  bool isAnswered = false;

  final ValueNotifier<Set<int>> pressedKeys = ValueNotifier<Set<int>>({});
  Map<int, NoteModel> pointerAndNote = {};

  @override
  void initState() {
    super.initState();
    SoundfontService.loadSoundfont();
    _generateRandomNote();
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

  void _generateRandomNote() {
    final random = Random();
    final note = notes[random.nextInt(notes.length)];
    final midi = _noteToMidi(note);
    setState(() {
      currentNote = note;
      currentTargetMidi = midi;
      currentPosition = random.nextInt(13); // 0-12 for staff positions
      selectedAnswer = null;
      isAnswered = false;
      pressedKeys.value = {};
    });
  }

  int _noteToMidi(String note) {
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
    return 48 + noteMap[note]!; // C3 as base
  }

  void _checkAnswer(String answer) {
    final pressedMidi = _noteToMidi(answer);
    setState(() {
      selectedAnswer = answer;
      isAnswered = true;
      totalAttempts++;
      pressedKeys.value = {pressedMidi};

      if (answer == currentNote) {
        score++;
        streak++;
        if (streak > bestStreak) {
          bestStreak = streak;
        }
      } else {
        streak = 0;
      }
    });

    Future.delayed(const Duration(milliseconds: 800), () {
      if (mounted) {
        _generateRandomNote();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.grey.shade900,
              Colors.black,
              Colors.grey.shade800,
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () => Navigator.pop(context),
                    ),
                    const SizedBox(width: 12),
                    const Text(
                      'Đoán nốt',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),

              // Stats
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    HeaderGameUi().buildStat('Điểm', '$score', Colors.blue),
                    HeaderGameUi().buildStat('Combo', '$streak', Colors.orange),
                    HeaderGameUi()
                        .buildStat('Best', '$bestStreak', Colors.green),
                    HeaderGameUi().buildStat(
                      'Chính xác',
                      totalAttempts > 0
                          ? '${((score / totalAttempts) * 100).toStringAsFixed(0)}%'
                          : '0%',
                      Colors.purple,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 30),

              // Music staff
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                padding:
                    const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: SizedBox(
                  height: 150,
                  width: 400,
                  child: CustomPaint(
                    painter: StaffAndNotePainter(currentNote),
                  ),
                ),
              ),

              const SizedBox(height: 30),

              ValueListenableBuilder(
                valueListenable: pressedKeys,
                builder: (context, _, child) {
                  return CustomPiano(
                    buttonColors: getPianoColors(
                        currentTargetMidi, pressedKeys.value, isAnswered),
                    onNotePressed: _handlePianoTap,
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _handlePianoTap(NoteModel? note) {
    if (note == null || isAnswered) return;
    final tappedName = _getNoteNameFromMidi(note.midiNoteNumber);

    setState(() {
      isAnswered = true;
      totalAttempts++;
      pressedKeys.value = {note.midiNoteNumber};
      if (tappedName == currentNote) {
        score++;
        streak++;
        if (streak > bestStreak) {
          bestStreak = streak;
        }
      } else {
        streak = 0;
      }
    });

    SoundfontService.playNote(note.midiNoteNumber);
    Future.delayed(const Duration(milliseconds: 800), () {
      if (mounted) _generateRandomNote();
    });
  }

  String _getNoteNameFromMidi(int midiNote) {
    final noteNames = [
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
    return noteNames[midiNote % 12];
  }
}
