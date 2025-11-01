import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pianist_vip_pro/services/common_service/soundfont_service.dart';
import '../../services/common_service/piano_game_service.dart';
import '../../services/common_service/chord_translator_service.dart';

class ChordQuestionScreenV2 extends StatefulWidget {
  final int lessonId;

  const ChordQuestionScreenV2({Key? key, required this.lessonId})
      : super(key: key);

  @override
  State<ChordQuestionScreenV2> createState() => _ChordQuestionScreenV2State();
}

class _ChordQuestionScreenV2State extends State<ChordQuestionScreenV2> {
  late PianoGameService _gameService;
  final ValueNotifier<Set<int>> pressedKeys = ValueNotifier<Set<int>>({});
  List<int> selectedChordNotes = [];
  String? submittedAnswer;

  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    SoundfontService.loadSoundfont();

    _gameService = PianoGameService(widget.lessonId);
    _gameService.onCorrectDetected = _handleCorrectAnswer;
    _initializeGame();
  }

  Future<void> _initializeGame() async {
    await _gameService.initializeMicrophone();
    await _gameService.loadQuestions();
    if (mounted) {
      setState(() {});
      _generateRandomChord();
    }
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

  void _generateRandomChord() {
    _gameService.generateNewChord();
    setState(() {
      selectedChordNotes = [];
      submittedAnswer = null;
      pressedKeys.value = {};
    });
  }

  void _handleCorrectAnswer() {
    final isGameFinished = _gameService.handleCorrectAnswer(updateStreak: true);
    setState(() {
      submittedAnswer = 'correct';
    });

    if (isGameFinished) {
      Future.delayed(const Duration(milliseconds: 1500), () {
        if (mounted) {
          _gameService.finishGame(context);
        }
      });
      return;
    }

    Future.delayed(const Duration(milliseconds: 1500), () {
      if (mounted) {
        _generateRandomChord();
      }
    });
  }

  void _toggleNote(int midiNumber) {
    if (submittedAnswer != null || _gameService.isMicrophoneMode)
      return; // Không cho phép chọn khi đã submit hoặc ở chế độ mic

    setState(() {
      if (selectedChordNotes.contains(midiNumber)) {
        selectedChordNotes.remove(midiNumber);
        pressedKeys.value.remove(midiNumber);
      } else {
        selectedChordNotes.add(midiNumber);
        pressedKeys.value = {...pressedKeys.value, midiNumber};
      }
    });

    // Phát âm thanh khi bấm phím
    SoundfontService.playNote(midiNumber);
    Future.delayed(const Duration(milliseconds: 300), () {
      SoundfontService.stopNote(midiNumber);
    });
  }

  void _submitAnswer() {
    if (selectedChordNotes.isEmpty) return;

    final (isCorrect, isGameFinished) = _gameService.handleChordPianoTap(
      selectedChordNotes,
      updateStreak: true,
    );

    setState(() {
      submittedAnswer = isCorrect ? 'correct' : 'wrong';
    });

    if (isGameFinished) {
      Future.delayed(const Duration(milliseconds: 1500), () {
        if (mounted) {
          _gameService.finishGame(context);
        }
      });
      return;
    }

    Future.delayed(const Duration(milliseconds: 1500), () {
      if (mounted) {
        _generateRandomChord();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final currentChord = _gameService.currentChord ?? [];

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
          child: _gameService.isLoading
              ? const Center(child: CircularProgressIndicator())
              : Column(
                  children: [
                    // Header
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.arrow_back,
                                color: Colors.white),
                            onPressed: () => Navigator.pop(context),
                          ),
                          const Text(
                            'Nhận diện hợp âm',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          Row(
                            children: [
                              Icon(
                                _gameService.isMicrophoneMode
                                    ? Icons.mic
                                    : Icons.touch_app,
                                color: _gameService.isMicrophoneMode
                                    ? Colors.redAccent
                                    : Colors.blueAccent,
                                size: 20,
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
                                materialTapTargetSize:
                                    MaterialTapTargetSize.shrinkWrap,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    // Score
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
                          Column(
                            children: [
                              const Text(
                                'Điểm',
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 14,
                                ),
                              ),
                              Text(
                                '${_gameService.score}',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          Column(
                            children: [
                              const Text(
                                'Độ chính xác',
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 14,
                                ),
                              ),
                              Text(
                                _gameService.totalAttempts > 0
                                    ? '${((_gameService.score / _gameService.totalAttempts) * 100).toStringAsFixed(0)}%'
                                    : '0%',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          Column(
                            children: [
                              const Text(
                                'Câu hỏi',
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 14,
                                ),
                              ),
                              Text(
                                '${_gameService.totalAttempts}/${_gameService.maxQuestions}',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 30),

                    // Question - Hiển thị hợp âm hiện tại
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 20),
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.pink.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: Colors.pink.withOpacity(0.5),
                          width: 2,
                        ),
                      ),
                      child: Column(
                        children: [
                          const Text(
                            'Chọn các nốt tạo thành hợp âm:',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            ChordTranslatorService.translateChord(currentChord),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Selected notes display
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 20),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        children: [
                          const Text(
                            'Đã chọn:',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Wrap(
                            spacing: 8,
                            children: selectedChordNotes.map((midi) {
                              return Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.pink.withOpacity(0.3),
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                    color: Colors.pink,
                                  ),
                                ),
                                child: Text(
                                  PianoGameService.midiToNote(midi),
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),
                    Expanded(
                      child: GridView.count(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        crossAxisCount: 4,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                        childAspectRatio: 1.2,
                        children: _buildNoteGrid(currentChord),
                      ),
                    ),

                    // Submit button (chỉ hiển thị ở chế độ Touch)
                    if (!_gameService.isMicrophoneMode)
                      Container(
                        margin: const EdgeInsets.all(20),
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: (selectedChordNotes.isNotEmpty &&
                                  submittedAnswer == null)
                              ? _submitAnswer
                              : null,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.pink,
                            disabledBackgroundColor:
                                Colors.grey.withOpacity(0.3),
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Text(
                            submittedAnswer == 'correct'
                                ? '✓ Chính xác!'
                                : submittedAnswer == 'wrong'
                                    ? '✗ Sai rồi!'
                                    : 'Xác nhận',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      )
                    else
                      Container(
                        margin: const EdgeInsets.all(20),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.blue.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: Colors.blue.withOpacity(0.5),
                            width: 2,
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.mic,
                              color: Colors.blue.shade300,
                              size: 24,
                            ),
                            const SizedBox(width: 12),
                            Text(
                              submittedAnswer == 'correct'
                                  ? '✓ Chính xác!'
                                  : submittedAnswer == 'wrong'
                                      ? '✗ Sai rồi!'
                                      : 'Đang nghe microphone...',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.blue.shade300,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
        ),
      ),
    );
  }

  List<Widget> _buildNoteGrid(List<int> targetChord) {
    final allNotes = [
      60, // C4
      61, // C#4
      62, // D4
      63, // D#4
      64, // E4
      65, // F4
      66, // F#4
      67, // G4
      68, // G#4
      69, // A4
      70, // A#4
      71, // B4
    ];

    return allNotes.map((midiNumber) {
      final isSelected = selectedChordNotes.contains(midiNumber);
      final isCorrectNote = targetChord.contains(midiNumber) ||
          targetChord.any((target) => target % 12 == midiNumber % 12);
      final showCorrect = submittedAnswer != null && isCorrectNote;
      final showWrong = submittedAnswer != null && isSelected && !isCorrectNote;

      Color backgroundColor;
      Color borderColor;

      if (showCorrect) {
        backgroundColor = Colors.green.withOpacity(0.3);
        borderColor = Colors.green;
      } else if (showWrong) {
        backgroundColor = Colors.red.withOpacity(0.3);
        borderColor = Colors.red;
      } else if (isSelected) {
        backgroundColor = Colors.pink.withOpacity(0.3);
        borderColor = Colors.pink;
      } else {
        backgroundColor = Colors.white.withOpacity(0.1);
        borderColor = Colors.white.withOpacity(0.2);
      }

      return Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => _toggleNote(midiNumber),
          borderRadius: BorderRadius.circular(12),
          child: Container(
            decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: borderColor,
                width: 2,
              ),
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    PianoGameService.midiToNote(midiNumber),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    midiNumber.toString(),
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 10,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }).toList();
  }
}
