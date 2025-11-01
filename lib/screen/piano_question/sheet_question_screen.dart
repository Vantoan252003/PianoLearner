import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pianist_vip_pro/screen/main_widget_function/custom_piano.dart';
import 'package:pianist_vip_pro/screen/main_widget_function/header_game_ui.dart';
import 'package:pianist_vip_pro/screen/main_widget_function/treble_music_staff.dart';
import 'package:pianist_vip_pro/services/common_service/soundfont_service.dart';
import 'dart:math';
import 'package:flutter_piano_pro/note_model.dart';
import '../../../services/practice_service/get_piano_colors.dart';
import '../../services/common_service/piano_game_service.dart';

class NoteGuessingScreen extends StatefulWidget {
  final int lessonId;

  const NoteGuessingScreen({Key? key, required this.lessonId})
      : super(key: key);

  @override
  State<NoteGuessingScreen> createState() => _NoteGuessingScreenState();
}

class _NoteGuessingScreenState extends State<NoteGuessingScreen> {
  late PianoGameService _gameService;
  final ValueNotifier<Set<int>> pressedKeys = ValueNotifier<Set<int>>({});
  Map<int, NoteModel> pointerAndNote = {};
  int currentPosition = 0; // Position on staff (0-12)
  String? selectedAnswer;

  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    SoundfontService.loadSoundfont();

    _gameService = PianoGameService(widget.lessonId);
    _gameService.onCorrectDetected = _handleCorrectAnswer;
    _initializeGame();
  }

  Future<void> _initializeGame() async {
    await _gameService.initializeMicrophone();
    await _gameService.loadQuestions();
    setState(() {});
    _generateRandomNote();
  }

  @override
  void dispose() {
    pressedKeys.value.forEach((key) {
      SoundfontService.stopNote(key);
    });
    SoundfontService.dispose();
    _gameService.dispose();
    pressedKeys.dispose();
    SystemChrome.setPreferredOrientations(DeviceOrientation.values);
    super.dispose();
  }

  void _generateRandomNote() {
    _gameService.generateNewTarget();
    setState(() {
      currentPosition = Random().nextInt(13);
      selectedAnswer = null;
      pressedKeys.value = {};
    });
  }

  void _handleCorrectAnswer() {
    final isGameFinished = _gameService.handleCorrectAnswer(updateStreak: true);
    setState(() {});

    if (_gameService.currentTargetMidi != null &&
        !_gameService.isMicrophoneMode) {
      SoundfontService.playNote(_gameService.currentTargetMidi!);
    }

    if (isGameFinished) {
      _gameService.finishGame(context);
      return;
    }

    Future.delayed(const Duration(milliseconds: 800), () {
      if (mounted) {
        _generateRandomNote();
      }
    });
  }

  void _handlePianoTap(NoteModel? note) {
    if (note == null ||
        _gameService.isAnswered ||
        _gameService.isMicrophoneMode) return;

    final (isCorrect, isGameFinished) = _gameService.handlePianoTap(
      note.midiNoteNumber,
      _gameService.currentTargetMidi,
      updateStreak: true,
    );

    setState(() {
      pressedKeys.value = {note.midiNoteNumber};
    });

    SoundfontService.playNote(note.midiNoteNumber);

    if (isGameFinished) {
      _gameService.finishGame(context);
      return;
    }

    Future.delayed(const Duration(milliseconds: 800), () {
      if (mounted) {
        _generateRandomNote();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Đoán nốt",
          style: TextStyle(color: Colors.white, fontSize: 18),
        ),
        backgroundColor: Colors.grey.shade900,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12.0),
            child: Row(
              children: [
                Icon(
                  _gameService.isMicrophoneMode ? Icons.mic : Icons.touch_app,
                  color: _gameService.isMicrophoneMode
                      ? Colors.redAccent
                      : Colors.blueAccent,
                  size: 20,
                ),
                const SizedBox(width: 4),
                Text(
                  _gameService.isMicrophoneMode ? 'Mic' : 'Touch',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(width: 4),
                Switch(
                  value: _gameService.isMicrophoneMode,
                  onChanged: _gameService.isMicrophoneReady
                      ? (_) => _gameService.toggleMode(
                          context, (mode) => setState(() {}))
                      : null,
                  activeColor: Colors.redAccent,
                  inactiveThumbColor: Colors.blueAccent,
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
              ],
            ),
          ),
        ],
        toolbarHeight: 50, // Smaller app bar
      ),
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
          child: _gameService.isLoading
              ? const Center(child: CircularProgressIndicator())
              : Column(
                  children: [
                    // Compact Stats Row
                    Container(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          HeaderGameUi().buildStat(
                              'Điểm', '${_gameService.score}', Colors.blue),
                          HeaderGameUi().buildStat(
                              'Combo', '${_gameService.streak}', Colors.orange),
                          HeaderGameUi().buildStat(
                            'Câu hỏi',
                            '${_gameService.totalAttempts}/${_gameService.maxQuestions}',
                            Colors.purple,
                          ),
                        ],
                      ),
                    ),

                    // Compact Music Staff
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 16),
                      padding: const EdgeInsets.symmetric(
                          vertical: 16, horizontal: 16),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.05),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: SizedBox(
                        height: 80,
                        width: double.infinity,
                        child: CustomPaint(
                          painter: StaffAndNotePainter(
                              _gameService.currentTargetNote),
                        ),
                      ),
                    ),

                    // Compact Piano
                    Expanded(
                      child: ValueListenableBuilder(
                        valueListenable: pressedKeys,
                        builder: (context, _, child) {
                          return CustomPiano(
                            buttonColors: getPianoColors(
                                _gameService.currentTargetMidi,
                                pressedKeys.value,
                                _gameService.isAnswered),
                            onNotePressed: _handlePianoTap,
                            noteCount: 15,
                            whiteHeight: 120,
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
