import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:piano/piano.dart';
import '../../services/common_service/soundfont_service.dart';

/// Model để lưu trữ dữ liệu sheet nhạc
/// TODO: Thay đổi class này để map với dữ liệu từ backend
class SheetMusicData {
  final String title;
  final String difficulty;
  final List<NoteData> notes;
  final int lessonId;

  SheetMusicData({
    required this.title,
    required this.difficulty,
    required this.notes,
    required this.lessonId,
  });

  /// TODO: Implement factory constructor để parse data từ backend API
  /// Example JSON structure expected from backend:
  /// {
  ///   "lessonId": 1,
  ///   "title": "Bài tập 1",
  ///   "difficulty": "Easy",
  ///   "notes": [
  ///     {"note": "C", "octave": 4, "duration": 1.0},
  ///     {"note": "D", "octave": 4, "duration": 0.5},
  ///     ...
  ///   ]
  /// }
  factory SheetMusicData.fromJson(Map<String, dynamic> json) {
    return SheetMusicData(
      lessonId: json['lessonId'] as int,
      title: json['title'] as String,
      difficulty: json['difficulty'] as String,
      notes: (json['notes'] as List)
          .map((noteJson) => NoteData.fromJson(noteJson))
          .toList(),
    );
  }
}

/// Model cho từng nốt nhạc
class NoteData {
  final Note note; // C, D, E, F, G, A, B
  final int octave; // 1-7
  final double
      duration; // Độ dài nốt nhạc (1.0 = whole note, 0.5 = half note, etc.)
  final bool isAccidental; // Có phải là nốt # hay b không

  NoteData({
    required this.note,
    required this.octave,
    this.duration = 1.0,
    this.isAccidental = false,
  });

  NotePosition get position => NotePosition(note: note, octave: octave);

  /// TODO: Parse note data từ backend
  factory NoteData.fromJson(Map<String, dynamic> json) {
    // Map string note name từ backend sang Note enum
    Note noteEnum = _parseNoteFromString(json['note'] as String);

    return NoteData(
      note: noteEnum,
      octave: json['octave'] as int,
      duration: (json['duration'] as num?)?.toDouble() ?? 1.0,
      isAccidental: json['isAccidental'] as bool? ?? false,
    );
  }

  static Note _parseNoteFromString(String noteStr) {
    // Note: piano package only supports natural notes (C, D, E, F, G, A, B)
    // For sharps/flats, map to the nearest natural note
    switch (noteStr.toUpperCase()) {
      case 'C':
      case 'C#':
      case 'Db':
        return Note.C;
      case 'D':
      case 'D#':
      case 'Eb':
        return Note.D;
      case 'E':
      case 'Fb':
        return Note.E;
      case 'F':
      case 'F#':
      case 'Gb':
        return Note.F;
      case 'G':
      case 'G#':
      case 'Ab':
        return Note.G;
      case 'A':
      case 'A#':
      case 'Bb':
        return Note.A;
      case 'B':
      case 'Cb':
      case 'B#':
        return Note.B;
      default:
        return Note.C;
    }
  }
}

class SheetQuestionScreen extends StatefulWidget {
  final int lessonId;

  const SheetQuestionScreen({
    Key? key,
    required this.lessonId,
  }) : super(key: key);

  @override
  State<SheetQuestionScreen> createState() => _SheetQuestionScreenState();
}

class _SheetQuestionScreenState extends State<SheetQuestionScreen> {
  // State variables
  int currentNoteIndex = 0;
  int score = 0;
  int totalAttempts = 0;
  bool isLoading = true;
  SheetMusicData? sheetData;
  Set<NotePosition> highlightedNotes = {};
  String feedback = '';
  Color feedbackColor = Colors.white;

  @override
  void initState() {
    super.initState();
    // Set landscape orientation
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);

    SoundfontService.loadSoundfont();
    _loadSheetMusic();
  }

  @override
  void dispose() {
    // Reset orientation
    SystemChrome.setPreferredOrientations(DeviceOrientation.values);
    SoundfontService.dispose();
    super.dispose();
  }

  /// TODO: Replace this with actual API call to fetch sheet music from backend
  /// Example API endpoint: GET /api/lessons/{lessonId}/sheet-music
  Future<void> _loadSheetMusic() async {
    setState(() => isLoading = true);

    try {
      // TODO: Uncomment and implement actual API call
      // final response = await http.get(
      //   Uri.parse('${ApiEndpoint.baseUrl}/lessons/${widget.lessonId}/sheet-music'),
      //   headers: {'Authorization': 'Bearer $token'},
      // );
      //
      // if (response.statusCode == 200) {
      //   final jsonData = json.decode(response.body);
      //   sheetData = SheetMusicData.fromJson(jsonData);
      // }

      // MOCK DATA - Thay thế bằng dữ liệu từ backend
      await Future.delayed(
          const Duration(seconds: 1)); // Simulate network delay

      sheetData = SheetMusicData(
        lessonId: widget.lessonId,
        title: 'Bài tập nhận diện nốt nhạc ${widget.lessonId}',
        difficulty: 'Easy',
        notes: [
          NoteData(note: Note.C, octave: 4),
          NoteData(note: Note.D, octave: 4),
          NoteData(note: Note.E, octave: 4),
          NoteData(note: Note.F, octave: 4),
          NoteData(note: Note.G, octave: 4),
          NoteData(note: Note.A, octave: 4),
          NoteData(note: Note.B, octave: 4),
          NoteData(note: Note.C, octave: 5),
        ],
      );

      if (sheetData != null && sheetData!.notes.isNotEmpty) {
        _highlightCurrentNote();
      }
    } catch (e) {
      print('Error loading sheet music: $e');
      // TODO: Show error dialog to user
    } finally {
      setState(() => isLoading = false);
    }
  }

  /// Highlight the current note that user needs to play
  void _highlightCurrentNote() {
    if (sheetData == null || currentNoteIndex >= sheetData!.notes.length) {
      return;
    }

    setState(() {
      final currentNote = sheetData!.notes[currentNoteIndex];
      highlightedNotes = {currentNote.position};
      feedback = 'Hãy bấm nốt được highlight!';
      feedbackColor = Colors.blue;
    });
  }

  /// Handle piano key tap
  void _onNoteTapped(NotePosition tappedPosition) {
    if (sheetData == null || currentNoteIndex >= sheetData!.notes.length) {
      return;
    }

    final currentNote = sheetData!.notes[currentNoteIndex];
    final isCorrect = tappedPosition.note == currentNote.note &&
        tappedPosition.octave == currentNote.octave;

    setState(() {
      totalAttempts++;

      if (isCorrect) {
        score++;
        feedback = '✓ Chính xác! (+1 điểm)';
        feedbackColor = Colors.green;

        // Play sound
        _playNote(tappedPosition);

        // Move to next note after delay
        Future.delayed(const Duration(milliseconds: 800), () {
          if (mounted) {
            currentNoteIndex++;
            if (currentNoteIndex < sheetData!.notes.length) {
              _highlightCurrentNote();
            } else {
              _showCompletionDialog();
            }
          }
        });
      } else {
        feedback = '✗ Sai rồi! Thử lại!';
        feedbackColor = Colors.red;

        // Play the tapped note anyway so user can hear
        _playNote(tappedPosition);
      }
    });
  }

  /// Play MIDI note
  void _playNote(NotePosition position) {
    try {
      // Convert NotePosition to MIDI number
      int midiNote = _notePositionToMidi(position);
      SoundfontService.playNote(midiNote);
    } catch (e) {
      print('Error playing note: $e');
    }
  }

  /// Convert NotePosition to MIDI number
  int _notePositionToMidi(NotePosition position) {
    final noteOffsets = {
      Note.C: 0,
      Note.D: 2,
      Note.E: 4,
      Note.F: 5,
      Note.G: 7,
      Note.A: 9,
      Note.B: 11,
    };

    int offset = noteOffsets[position.note] ?? 0;
    return (position.octave + 1) * 12 + offset;
  }

  /// Show completion dialog when all notes are played
  void _showCompletionDialog() {
    double accuracy = totalAttempts > 0 ? (score / totalAttempts * 100) : 0;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('🎉 Hoàn thành!'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Điểm số: $score/${sheetData!.notes.length}'),
            const SizedBox(height: 8),
            Text('Độ chính xác: ${accuracy.toStringAsFixed(1)}%'),
            const SizedBox(height: 8),
            Text(
              accuracy >= 80
                  ? 'Xuất sắc! 🌟'
                  : accuracy >= 60
                      ? 'Tốt! 👍'
                      : 'Cần cố gắng thêm! 💪',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).pop(); // Return to previous screen
            },
            child: const Text('Thoát'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              _resetPractice();
            },
            child: const Text('Chơi lại'),
          ),
        ],
      ),
    );
  }

  /// Reset practice session
  void _resetPractice() {
    setState(() {
      currentNoteIndex = 0;
      score = 0;
      totalAttempts = 0;
      feedback = '';
      _highlightCurrentNote();
    });
  }

  /// Get display name for note
  String _getNoteDisplayName(NoteData noteData) {
    const noteNames = {
      Note.C: 'C',
      Note.D: 'D',
      Note.E: 'E',
      Note.F: 'F',
      Note.G: 'G',
      Note.A: 'A',
      Note.B: 'B',
    };
    String noteName = noteNames[noteData.note] ?? 'C';
    return '$noteName${noteData.octave}';
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Colors.grey.shade900, Colors.black],
            ),
          ),
          child: const Center(
            child: CircularProgressIndicator(color: Colors.white),
          ),
        ),
      );
    }

    if (sheetData == null || sheetData!.notes.isEmpty) {
      return Scaffold(
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Colors.grey.shade900, Colors.black],
            ),
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, color: Colors.red, size: 64),
                const SizedBox(height: 16),
                const Text(
                  'Không thể tải dữ liệu sheet nhạc',
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Quay lại'),
                ),
              ],
            ),
          ),
        ),
      );
    }

    double progress = sheetData!.notes.isEmpty
        ? 0
        : currentNoteIndex / sheetData!.notes.length;
    double accuracy = totalAttempts > 0 ? (score / totalAttempts * 100) : 0;

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
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () => Navigator.pop(context),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        sheetData!.title,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.green.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.green),
                      ),
                      child: Text(
                        'Điểm: $score/${sheetData!.notes.length}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 8),

              // Progress bar
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Tiến độ: ${currentNoteIndex}/${sheetData!.notes.length}',
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 14,
                          ),
                        ),
                        Text(
                          'Độ chính xác: ${accuracy.toStringAsFixed(1)}%',
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    LinearProgressIndicator(
                      value: progress,
                      backgroundColor: Colors.white24,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        progress == 1.0 ? Colors.green : Colors.blue,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // Feedback message
              if (feedback.isNotEmpty)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: feedbackColor.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: feedbackColor, width: 2),
                  ),
                  child: Text(
                    feedback,
                    style: TextStyle(
                      color: feedbackColor,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),

              const SizedBox(height: 16),

              // Sheet music display with clef
              Expanded(
                flex: 2,
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.3),
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Text(
                        'Sheet nhạc - Treble Clef',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey.shade800,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Expanded(
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              // Display clef

                              const SizedBox(height: 16),
                              // Display current note to play
                              // if (currentNoteIndex < sheetData!.notes.length)
                              //   Container(
                              //     padding: const EdgeInsets.all(16),
                              //     decoration: BoxDecoration(
                              //       color: Colors.blue.shade50,
                              //       borderRadius: BorderRadius.circular(8),
                              //       border: Border.all(
                              //         color: Colors.blue,
                              //         width: 2,
                              //       ),
                              //     ),
                              //     child: Text(
                              //       'Nốt cần chơi: ${_getNoteDisplayName(sheetData!.notes[currentNoteIndex])}',
                              //       style: TextStyle(
                              //         fontSize: 24,
                              //         fontWeight: FontWeight.bold,
                              //         color: Colors.blue.shade900,
                              //       ),
                              //     ),
                              //   ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Interactive Piano
              Expanded(
                flex: 3,
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  child: InteractivePiano(
                    highlightedNotes: highlightedNotes.toList(),
                    naturalColor: Colors.white,
                    accidentalColor: Colors.black,
                    keyWidth: 60,
                    noteRange: NoteRange.forClefs([
                      Clef.Treble,
                    ]),
                    onNotePositionTapped: _onNoteTapped,
                  ),
                ),
              ),

              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
