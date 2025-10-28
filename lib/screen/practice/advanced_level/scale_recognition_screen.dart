import 'package:flutter/material.dart';
import 'package:flutter_piano_pro/note_model.dart';
import 'package:pianist_vip_pro/screen/main_widget_function/custom_piano.dart';
import 'package:pianist_vip_pro/screen/main_widget_function/header_game_ui.dart';
import 'package:pianist_vip_pro/services/practice_service/get_piano_colors.dart';
import 'dart:math';

import 'package:pianist_vip_pro/services/soundfont_service.dart';

class ScaleRecognitionScreen extends StatefulWidget {
  const ScaleRecognitionScreen({Key? key}) : super(key: key);

  @override
  State<ScaleRecognitionScreen> createState() => _ScaleRecognitionScreenState();
}

class _ScaleRecognitionScreenState extends State<ScaleRecognitionScreen> {
  final ValueNotifier<Set<int>> pressedKeys = ValueNotifier<Set<int>>({});

  int numberOfNotes = 3;
  List<int> targetNotes = [];
  List<int> playedNotes = [];
  bool isPlaying = false;
  bool isSetup = true;
  bool isAnswered = false;
  int score = 0;
  int totalAttempts = 0;

  @override
  void initState() {
    super.initState();
    SoundfontService.loadSoundfont();
  }

  @override
  void dispose() {
    pressedKeys.value.forEach((key) {
      SoundfontService.stopNote(key);
    });
    pressedKeys.dispose();
    super.dispose();
  }

  void _startGame() {
    setState(() {
      isSetup = false;
      _generateTargetNotes();
      _playTargetNotes();
    });
  }

  void _generateTargetNotes() {
    final random = Random();
    targetNotes = [];
    for (int i = 0; i < numberOfNotes; i++) {
      int note = 60 + random.nextInt(8); // C4 to G4 (8 notes)
      targetNotes.add(note);
    }
    playedNotes = [];
    pressedKeys.value = {};
    isAnswered = false;
  }

  Future<void> _playTargetNotes() async {
    setState(() {
      isPlaying = true;
    });
    for (int note in targetNotes) {
      SoundfontService.playNote(note);
      await Future.delayed(const Duration(milliseconds: 600));
      SoundfontService.stopNote(note);
      await Future.delayed(const Duration(milliseconds: 200));
    }
    setState(() {
      isPlaying = false;
    });
  }

  void _onPianoTap(NoteModel? note) {
    if (note == null || isPlaying || isAnswered) return;

    SoundfontService.playNote(note.midiNoteNumber);

    setState(() {
      playedNotes.add(note.midiNoteNumber);
      pressedKeys.value = {...pressedKeys.value, note.midiNoteNumber};
    });

    // Stop note after a short delay
    Future.delayed(const Duration(milliseconds: 300), () {
      SoundfontService.stopNote(note.midiNoteNumber);
      pressedKeys.value =
          pressedKeys.value.where((key) => key != note.midiNoteNumber).toSet();
    });

    // Auto check when played enough notes
    if (playedNotes.length == numberOfNotes) {
      Future.delayed(const Duration(milliseconds: 500), () {
        if (mounted) _checkAnswer();
      });
    }
  }

  void _checkAnswer() {
    setState(() {
      isAnswered = true;
      totalAttempts++;
      if (_isCorrect()) {
        score++;
      }
    });

    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        _generateTargetNotes();
        _playTargetNotes();
      }
    });
  }

  bool _isCorrect() {
    if (playedNotes.length != targetNotes.length) return false;
    for (int i = 0; i < targetNotes.length; i++) {
      if (playedNotes[i] != targetNotes[i]) return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
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
                      'Chơi lại nốt',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),

              if (isSetup) ...[
                Expanded(
                  child: Center(
                    child: Container(
                      padding: const EdgeInsets.all(40),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text(
                            'Chọn số nốt muốn thử:',
                            style: TextStyle(
                              fontSize: 24,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 30),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                'Số nốt: ',
                                style: TextStyle(
                                    fontSize: 20, color: Colors.white70),
                              ),
                              Text(
                                '$numberOfNotes',
                                style: const TextStyle(
                                  fontSize: 32,
                                  color: Colors.blue,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          Slider(
                            value: numberOfNotes.toDouble(),
                            min: 1,
                            max: 5,
                            divisions: 4,
                            label: '$numberOfNotes',
                            activeColor: Colors.blue,
                            onChanged: (value) {
                              setState(() {
                                numberOfNotes = value.toInt();
                              });
                            },
                          ),
                          const SizedBox(height: 30),
                          ElevatedButton.icon(
                            onPressed: _startGame,
                            icon: const Icon(Icons.play_arrow, size: 28),
                            label: const Text(
                              'Bắt đầu',
                              style: TextStyle(fontSize: 20),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 40,
                                vertical: 16,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ] else ...[
                // Game UI
                Expanded(
                  flex: 2,
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (isPlaying) ...[
                          const CircularProgressIndicator(color: Colors.blue),
                          const SizedBox(height: 20),
                          const Text(
                            'Đang phát nốt...',
                            style: TextStyle(fontSize: 20, color: Colors.white),
                          ),
                        ] else if (isAnswered) ...[
                          Icon(
                            _isCorrect() ? Icons.check_circle : Icons.cancel,
                            size: 64,
                            color: _isCorrect() ? Colors.green : Colors.red,
                          ),
                          const SizedBox(height: 10),
                          Text(
                            _isCorrect() ? 'Chính xác!' : 'Sai rồi!',
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: _isCorrect() ? Colors.green : Colors.red,
                            ),
                          ),
                          const SizedBox(height: 20),
                          Text(
                            'Đáp án: ${targetNotes.map((n) => _midiToNote(n)).join(' - ')}',
                            style: const TextStyle(
                                fontSize: 20, color: Colors.white70),
                          ),
                        ] else ...[
                          const Text(
                            'Chơi lại các nốt đã nghe:',
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ElevatedButton.icon(
                                onPressed: _playTargetNotes,
                                icon: const Icon(Icons.replay),
                                label: const Text('Nghe lại'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.blue,
                                  foregroundColor: Colors.white,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          Text(
                            'Đã chơi: ${playedNotes.map((n) => _midiToNote(n)).join(' - ')}',
                            style: const TextStyle(
                                fontSize: 18, color: Colors.blue),
                          ),
                        ],
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            HeaderGameUi()
                                .buildStat('Điểm', '$score', Colors.green),
                            HeaderGameUi().buildStat(
                                'Tổng', '$totalAttempts', Colors.orange),
                            HeaderGameUi().buildStat(
                              'Chính xác',
                              '${totalAttempts > 0 ? ((score / totalAttempts) * 100).toStringAsFixed(0) : 0}%',
                              Colors.purple,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                // Piano
                Expanded(
                  child: ValueListenableBuilder(
                    valueListenable: pressedKeys,
                    builder: (context, _, child) {
                      return CustomPiano(
                        noteCount: 8,
                        buttonColors:
                            getVirtualPianoColors(8, pressedKeys.value),
                        onNotePressed: _onPianoTap,
                      );
                    },
                  ),
                ),
              ],
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  String _midiToNote(int midi) {
    const notes = [
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
    return notes[midi % 12];
  }
}
