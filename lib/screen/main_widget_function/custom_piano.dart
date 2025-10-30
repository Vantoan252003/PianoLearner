import 'package:flutter/material.dart';
import 'package:flutter_piano_pro/flutter_piano_pro.dart';
import 'package:flutter_piano_pro/note_model.dart';

class CustomPiano extends StatelessWidget {
  final Map<int, Color> buttonColors;
  final Function(NoteModel?) onNotePressed;
  final double whiteHeight;
  final int noteCount;
  final double blackHeight;

  const CustomPiano({
    Key? key,
    required this.buttonColors,
    required this.onNotePressed,
    this.whiteHeight = 200,
    this.noteCount = 7,
    this.blackHeight = 50,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PianoPro(
      noteCount: noteCount,
      whiteHeight: whiteHeight,
      blackWidthRatio: 1.3,
      showNames: false,
      showOctave: false,
      buttonColors: buttonColors,
      onTapDown: (NoteModel? note, int tapId) {
        onNotePressed(note);
      },
      onTapUpdate: (NoteModel? note, int tapId) {},
      onTapUp: (int tapId) {},
    );
  }
}
