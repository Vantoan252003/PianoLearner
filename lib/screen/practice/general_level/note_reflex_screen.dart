import 'package:flutter/material.dart';
import 'dart:math';
import 'dart:async';

class NoteReflexScreen extends StatefulWidget {
  const NoteReflexScreen({Key? key}) : super(key: key);

  @override
  State<NoteReflexScreen> createState() => _NoteReflexScreenState();
}

class _NoteReflexScreenState extends State<NoteReflexScreen> {
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
  String? selectedAnswer;
  int score = 0;
  int totalAttempts = 0;
  int timeLeft = 30;
  bool isGameActive = false;
  Timer? _gameTimer;
  Timer? _noteTimer;
  int noteTimeLimit = 3000;
  int noteTimeLeft = 0;

  @override
  void dispose() {
    _gameTimer?.cancel();
    _noteTimer?.cancel();
    super.dispose();
  }

  void _startGame() {
    setState(() {
      score = 0;
      totalAttempts = 0;
      timeLeft = 30;
      isGameActive = true;
      noteTimeLimit = 3000;
    });

    _generateRandomNote();

    _gameTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (timeLeft > 0) {
        setState(() {
          timeLeft--;
        });
      } else {
        _endGame();
      }
    });
  }

  void _endGame() {
    _gameTimer?.cancel();
    _noteTimer?.cancel();
    setState(() {
      isGameActive = false;
    });

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.grey.shade900,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: const Text(
          'Trò chơi kết thúc!',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Điểm của bạn:',
              style: TextStyle(
                color: Colors.white.withOpacity(0.7),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '$score',
              style: const TextStyle(
                color: Colors.amber,
                fontSize: 48,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Độ chính xác: ${totalAttempts > 0 ? ((score / totalAttempts) * 100).toStringAsFixed(0) : 0}%',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _startGame();
            },
            child: const Text(
              'Chơi lại',
              style: TextStyle(color: Colors.amber),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text(
              'OK',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  void _generateRandomNote() {
    if (!isGameActive) return;

    _noteTimer?.cancel();

    final random = Random();
    setState(() {
      currentNote = notes[random.nextInt(notes.length)];
      selectedAnswer = null;
      noteTimeLeft = noteTimeLimit;
    });

    if (noteTimeLimit > 1000) {
      noteTimeLimit -= 50;
    }

    _noteTimer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
      if (noteTimeLeft > 0) {
        setState(() {
          noteTimeLeft -= 100;
        });
      } else {
        _checkAnswer('');
      }
    });
  }

  void _checkAnswer(String answer) {
    _noteTimer?.cancel();

    setState(() {
      selectedAnswer = answer;
      totalAttempts++;
      if (answer == currentNote) {
        score++;
      }
    });

    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted && isGameActive) {
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
                      'Phản xạ nốt',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),

              if (!isGameActive)
                Expanded(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.flash_on,
                          size: 100,
                          color: Colors.amber.withOpacity(0.8),
                        ),
                        const SizedBox(height: 20),
                        const Text(
                          'Phản xạ nốt nhạc',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 40),
                          child: Text(
                            'Nhấn đúng nốt nhạc càng nhanh càng tốt!\nBạn có 30 giây. Trò chơi sẽ nhanh dần.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.7),
                              fontSize: 16,
                            ),
                          ),
                        ),
                        const SizedBox(height: 40),
                        ElevatedButton(
                          onPressed: _startGame,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.amber,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 48,
                              vertical: 16,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                          child: const Text(
                            'Bắt đầu',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              else
                Expanded(
                  child: Column(
                    children: [
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
                            _buildStat('Thời gian', '$timeLeft s', Colors.red),
                            _buildStat('Điểm', '$score', Colors.amber),
                            _buildStat(
                              'Chính xác',
                              totalAttempts > 0
                                  ? '${((score / totalAttempts) * 100).toStringAsFixed(0)}%'
                                  : '0%',
                              Colors.green,
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 40),

                      // Progress bar
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 40),
                        height: 8,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: FractionallySizedBox(
                          alignment: Alignment.centerLeft,
                          widthFactor: noteTimeLeft / noteTimeLimit,
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [Colors.amber, Colors.orange],
                              ),
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 30),

                      // Current note
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 60,
                          vertical: 30,
                        ),
                        child: Text(
                          currentNote ?? '',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 72,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),

                      const SizedBox(height: 30),

                      // Answer buttons
                      Expanded(
                        child: GridView.count(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          crossAxisCount: 4,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10,
                          childAspectRatio: 1.2,
                          children: notes.map((note) {
                            final isCorrect =
                                selectedAnswer == note && note == currentNote;
                            final isWrong =
                                selectedAnswer == note && note != currentNote;

                            Color backgroundColor;
                            Color borderColor;

                            if (isCorrect) {
                              backgroundColor = Colors.green.withOpacity(0.4);
                              borderColor = Colors.green;
                            } else if (isWrong) {
                              backgroundColor = Colors.red.withOpacity(0.4);
                              borderColor = Colors.red;
                            } else {
                              backgroundColor = Colors.white.withOpacity(0.1);
                              borderColor = Colors.amber.withOpacity(0.3);
                            }

                            return Material(
                              color: Colors.transparent,
                              child: InkWell(
                                onTap: selectedAnswer == null
                                    ? () => _checkAnswer(note)
                                    : null,
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
                                    child: Text(
                                      note,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
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

  Widget _buildStat(String label, String value, Color color) {
    return Column(
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 12,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            color: color,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
