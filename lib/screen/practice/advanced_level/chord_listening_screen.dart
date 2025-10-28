import 'package:flutter/material.dart';
import 'dart:math';

class ChordListeningScreen extends StatefulWidget {
  const ChordListeningScreen({Key? key}) : super(key: key);

  @override
  State<ChordListeningScreen> createState() => _ChordListeningScreenState();
}

class _ChordListeningScreenState extends State<ChordListeningScreen> {
  final Map<String, List<String>> chords = {
    'C Major': ['C', 'E', 'G'],
    'C Minor': ['C', 'D#', 'G'],
    'D Major': ['D', 'F#', 'A'],
    'D Minor': ['D', 'F', 'A'],
    'E Major': ['E', 'G#', 'B'],
    'E Minor': ['E', 'G', 'B'],
    'F Major': ['F', 'A', 'C'],
    'F Minor': ['F', 'G#', 'C'],
    'G Major': ['G', 'B', 'D'],
    'G Minor': ['G', 'A#', 'D'],
    'A Major': ['A', 'C#', 'E'],
    'A Minor': ['A', 'C', 'E'],
  };

  String? currentChord;
  List<String>? currentNotes;
  String? selectedAnswer;
  bool isPlaying = false;
  int score = 0;
  int totalAttempts = 0;

  @override
  void initState() {
    super.initState();
    _generateRandomChord();
  }

  void _generateRandomChord() {
    final random = Random();
    final chordNames = chords.keys.toList();
    final selectedChord = chordNames[random.nextInt(chordNames.length)];
    
    setState(() {
      currentChord = selectedChord;
      currentNotes = chords[selectedChord];
      selectedAnswer = null;
      isPlaying = false;
    });
  }

  void _playChord() {
    setState(() {
      isPlaying = true;
    });

    // Giả lập phát âm thanh hợp âm
    Future.delayed(const Duration(milliseconds: 1500), () {
      if (mounted) {
        setState(() {
          isPlaying = false;
        });
      }
    });
  }

  void _checkAnswer(String answer) {
    setState(() {
      selectedAnswer = answer;
      totalAttempts++;
      if (answer == currentChord) {
        score++;
      }
    });

    Future.delayed(const Duration(milliseconds: 1200), () {
      if (mounted) {
        _generateRandomChord();
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
                      'Luyện nghe hợp âm',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
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
                          '$score',
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
                          totalAttempts > 0
                              ? '${((score / totalAttempts) * 100).toStringAsFixed(0)}%'
                              : '0%',
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

              // Play button
              GestureDetector(
                onTap: isPlaying ? null : _playChord,
                child: Container(
                  width: 150,
                  height: 150,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: isPlaying
                          ? [Colors.teal.shade600, Colors.teal.shade800]
                          : [Colors.teal.shade400, Colors.teal.shade600],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.teal.withOpacity(0.5),
                        blurRadius: 20,
                        spreadRadius: 5,
                      ),
                    ],
                  ),
                  child: Icon(
                    isPlaying ? Icons.volume_up : Icons.play_arrow,
                    size: 60,
                    color: Colors.white,
                  ),
                ),
              ),

              const SizedBox(height: 20),

              Text(
                isPlaying ? 'Đang phát...' : 'Nhấn để nghe hợp âm',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.7),
                  fontSize: 16,
                ),
              ),

              const SizedBox(height: 30),

              // Hint (only show after playing)
              if (isPlaying || selectedAnswer != null)
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.teal.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: Colors.teal.withOpacity(0.3),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.lightbulb_outline,
                        color: Colors.tealAccent,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Gợi ý: ${currentNotes?.join(" - ") ?? ""}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),

              const SizedBox(height: 20),

              // Answer options
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  children: chords.keys.map((chordName) {
                    final isCorrect = selectedAnswer == chordName && chordName == currentChord;
                    final isWrong = selectedAnswer == chordName && chordName != currentChord;
                    final isCorrectAnswer = selectedAnswer != null && chordName == currentChord;

                    Color? backgroundColor;
                    Color? borderColor;

                    if (isCorrect) {
                      backgroundColor = Colors.green.withOpacity(0.3);
                      borderColor = Colors.green;
                    } else if (isWrong) {
                      backgroundColor = Colors.red.withOpacity(0.3);
                      borderColor = Colors.red;
                    } else if (isCorrectAnswer) {
                      backgroundColor = Colors.green.withOpacity(0.2);
                      borderColor = Colors.green.withOpacity(0.5);
                    }

                    return Container(
                      margin: const EdgeInsets.only(bottom: 10),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: selectedAnswer == null
                              ? () => _checkAnswer(chordName)
                              : null,
                          borderRadius: BorderRadius.circular(12),
                          child: Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: backgroundColor ?? Colors.white.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: borderColor ?? Colors.teal.withOpacity(0.2),
                                width: 2,
                              ),
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        chordName,
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        chords[chordName]?.join(' - ') ?? '',
                                        style: TextStyle(
                                          color: Colors.white.withOpacity(0.6),
                                          fontSize: 12,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                if (isCorrect)
                                  const Icon(
                                    Icons.check_circle,
                                    color: Colors.green,
                                  )
                                else if (isWrong)
                                  const Icon(
                                    Icons.cancel,
                                    color: Colors.red,
                                  )
                                else if (isCorrectAnswer)
                                  const Icon(
                                    Icons.check_circle_outline,
                                    color: Colors.green,
                                  ),
                              ],
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
      ),
    );
  }
}
