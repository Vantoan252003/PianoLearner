import 'package:flutter/material.dart';

Map<int, Color> getPianoColors(
    int? currentTargetMidi, Set<int> pressedKeys, bool isAnswered) {
  Map<int, Color> colors = {};
  final targetNoteIndex = currentTargetMidi! % 12;
  final pressed = pressedKeys.isNotEmpty ? pressedKeys.first : null;
  final pressedNoteIndex = pressed != null ? pressed % 12 : null;

  for (int midi = 48; midi <= 83; midi++) {
    bool isWhite = ![1, 3, 6, 8, 10].contains(midi % 12);
    Color color = isWhite ? Colors.white : Colors.black;

    if (isAnswered) {
      if (midi % 12 == targetNoteIndex) color = Colors.green;
      if (pressed != null &&
          midi == pressed &&
          pressedNoteIndex != targetNoteIndex) color = Colors.red;
    }
    colors[midi] = color;
  }
  return colors;
}

Map<int, Color> getVirtualPianoColors(int noteCount, Set<int> pressedKeys) {
  Map<int, Color> colors = {};
  int startMidi = 48; // Bắt đầu từ C3
  int fullOctaves = (noteCount / 7).floor();
  int remainingWhiteKeys = noteCount % 7;
  int totalKeys = fullOctaves * 12;
  if (remainingWhiteKeys > 0) {
    List<int> whiteKeyPositions = [0, 2, 4, 5, 7, 9, 11];
    for (int i = 0; i < remainingWhiteKeys; i++) {
      totalKeys += whiteKeyPositions[i] + 1;
    }
  }
  int endMidi = startMidi + totalKeys - 1;

  for (int midi = startMidi; midi <= endMidi; midi++) {
    bool isWhiteKey = ![1, 3, 6, 8, 10].contains(midi % 12);
    bool isPressed = pressedKeys.contains(midi);
    colors[midi] = isWhiteKey
        ? (isPressed ? Colors.grey[400]! : Colors.white)
        : (isPressed ? Colors.grey[800]! : Colors.black);
  }
  return colors;
}
