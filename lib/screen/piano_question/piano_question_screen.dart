import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_piano_pro/note_model.dart';
import 'package:pianist_vip_pro/screen/main_widget_function/custom_piano.dart';
import 'package:pianist_vip_pro/screen/main_widget_function/header_game_ui.dart';
import '../../../services/practice_service/get_piano_colors.dart';
import '../../../services/common_service/soundfont_service.dart';
import '../../services/common_service/piano_game_service.dart';

class PianoQuestionScreen extends StatefulWidget {
  final int lessonId;

  const PianoQuestionScreen({Key? key, required this.lessonId})
      : super(key: key);

  @override
  State<PianoQuestionScreen> createState() => _PianoQuestionScreenState();
}

class _PianoQuestionScreenState extends State<PianoQuestionScreen> {
  final ValueNotifier<Set<int>> pressedKeys = ValueNotifier<Set<int>>({});
  late PianoGameService _gameService;

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
    _gameService.generateNewTarget();
  }

  void _handleCorrectAnswer() {
    final isGameFinished =
        _gameService.handleCorrectAnswer(updateStreak: false);
    setState(() {});

    if (_gameService.currentTargetMidi != null &&
        !_gameService.isMicrophoneMode) {
      SoundfontService.playNote(_gameService.currentTargetMidi!);
    }

    if (isGameFinished) {
      _gameService.finishGame(context);
      return;
    }

    Future.delayed(const Duration(milliseconds: 100), () {
      if (mounted) {
        _gameService.nextQuestion();
        setState(() {
          pressedKeys.value = {};
        });
      }
    });
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

  void _handlePianoTap(NoteModel? note) {
    if (note == null ||
        _gameService.isAnswered ||
        _gameService.isMicrophoneMode) return;

    final (isCorrect, isGameFinished) = _gameService.handlePianoTap(
      note.midiNoteNumber,
      _gameService.currentTargetMidi,
      updateStreak: false,
    );

    setState(() {
      pressedKeys.value = {note.midiNoteNumber};
    });

    SoundfontService.playNote(note.midiNoteNumber);

    if (isGameFinished) {
      _gameService.finishGame(context);
      return;
    }

    Future.delayed(const Duration(milliseconds: 100), () {
      if (mounted) {
        _gameService.nextQuestion();
        setState(() {
          pressedKeys.value = {};
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Nhận diện phím",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.grey.shade900,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              children: [
                Icon(
                  _gameService.isMicrophoneMode ? Icons.mic : Icons.touch_app,
                  color: _gameService.isMicrophoneMode
                      ? Colors.redAccent
                      : Colors.blueAccent,
                  size: 24,
                ),
                const SizedBox(width: 8),
                Text(
                  _gameService.isMicrophoneMode
                      ? 'Nghe Microphone'
                      : 'Bấm phím',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(width: 8),
                Switch(
                  value: _gameService.isMicrophoneMode,
                  onChanged: _gameService.isMicrophoneReady
                      ? (_) => _gameService.toggleMode(
                          context, (mode) => setState(() {}))
                      : null,
                  activeColor: Colors.redAccent,
                  inactiveThumbColor: Colors.blueAccent,
                ),
              ],
            ),
          ),
        ],
      ),
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
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: HeaderGameUi().buildStat("🏆 Điểm",
                        '${_gameService.score}', Colors.orangeAccent),
                  ),
                  Expanded(
                    child: Center(
                      child: HeaderGameUi().buildStat(
                          "🎯 Nốt cần chơi",
                          _gameService.currentTargetNote ?? "-",
                          Colors.greenAccent),
                    ),
                  ),
                  Expanded(
                    child: HeaderGameUi().buildStat(
                        "📊 Câu hỏi",
                        '${_gameService.totalAttempts}/${PianoGameService.maxQuestions}',
                        Colors.blueAccent),
                  ),
                ],
              ),
              const SizedBox(height: 80),
              Expanded(
                child: _gameService.isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : ValueListenableBuilder(
                        valueListenable: pressedKeys,
                        builder: (context, _, child) {
                          return CustomPiano(
                              buttonColors: getPianoColors(
                                  _gameService.currentTargetMidi,
                                  pressedKeys.value,
                                  _gameService.isAnswered),
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
