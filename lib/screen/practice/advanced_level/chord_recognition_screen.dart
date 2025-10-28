import 'package:flutter/material.dart';
import 'dart:math';

class ChordRecognitionScreen extends StatefulWidget {
  const ChordRecognitionScreen({Key? key}) : super(key: key);

  @override
  State<ChordRecognitionScreen> createState() => _ChordRecognitionScreenState();
}

class _ChordRecognitionScreenState extends State<ChordRecognitionScreen> {
  final Map<String, List<String>> chords = {
    'C Major': ['C', 'E', 'G'],
    'C Minor': ['C', 'D#', 'G'],
    'D Major': ['D', 'F#', 'A'],
    'D Minor': ['D', 'F', 'A'],
    'E Major': ['E', 'G#', 'B'],
    'E Minor': ['E', 'G', 'B'],
    'F Major': ['F', 'A', 'C'],
    'G Major': ['G', 'B', 'D'],
    'A Major': ['A', 'C#', 'E'],
    'A Minor': ['A', 'C', 'E'],
  };

  String? currentChord;
  List<String>? currentNotes;
  List<String> selectedNotes = [];
  String? submittedAnswer;
  int score = 0;
  int totalAttempts = 0;

  final List<String> allNotes = [
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
      currentNotes = List.from(chords[selectedChord]!);
      selectedNotes = [];
      submittedAnswer = null;
    });
  }

  void _toggleNote(String note) {
    if (submittedAnswer != null) return;

    setState(() {
      if (selectedNotes.contains(note)) {
        selectedNotes.remove(note);
      } else {
        selectedNotes.add(note);
      }
    });
  }

  void _submitAnswer() {
    if (selectedNotes.length != 3) return;

    setState(() {
      totalAttempts++;

      // Sort both lists for comparison
      final sortedSelected = List<String>.from(selectedNotes)..sort();
      final sortedCorrect = List<String>.from(currentNotes!)..sort();

      if (sortedSelected.toString() == sortedCorrect.toString()) {
        score++;
        submittedAnswer = 'correct';
      } else {
        submittedAnswer = 'wrong';
      }
    });

    Future.delayed(const Duration(milliseconds: 1500), () {
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
                      'Nhận diện hợp âm',
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

              // Question
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
                      'Chọn 3 nốt tạo thành hợp âm:',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      currentChord ?? '',
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
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Đã chọn: ',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(width: 8),
                    ...List.generate(3, (index) {
                      return Container(
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: index < selectedNotes.length
                              ? Colors.pink.withOpacity(0.3)
                              : Colors.grey.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: index < selectedNotes.length
                                ? Colors.pink
                                : Colors.grey,
                          ),
                        ),
                        child: Text(
                          index < selectedNotes.length
                              ? selectedNotes[index]
                              : '?',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      );
                    }),
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
                  children: allNotes.map((note) {
                    final isSelected = selectedNotes.contains(note);
                    final isCorrectNote = currentNotes?.contains(note) ?? false;
                    final showCorrect =
                        submittedAnswer != null && isCorrectNote;
                    final showWrong =
                        submittedAnswer != null && isSelected && !isCorrectNote;

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
                        onTap: () => _toggleNote(note),
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
                                fontSize: 18,
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

              // Submit button
              Container(
                margin: const EdgeInsets.all(20),
                width: double.infinity,
                child: ElevatedButton(
                  onPressed:
                      selectedNotes.length == 3 && submittedAnswer == null
                          ? _submitAnswer
                          : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.pink,
                    disabledBackgroundColor: Colors.grey.withOpacity(0.3),
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
              ),
            ],
          ),
        ),
      ),
    );
  }
}
