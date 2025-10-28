import 'package:flutter/material.dart';
import 'package:pianist_vip_pro/screen/practice/advanced_level/chord_listening_screen.dart';
import 'package:pianist_vip_pro/screen/practice/advanced_level/chord_recognition_screen.dart';
import 'package:pianist_vip_pro/screen/practice/advanced_level/note_guessing_screen.dart';
import 'package:pianist_vip_pro/screen/practice/advanced_level/scale_recognition_screen.dart';
import 'package:pianist_vip_pro/screen/practice/beginner_level/key_recognition_screen.dart';
import 'package:pianist_vip_pro/screen/practice/general_level/virtual_piano_screen.dart';
import 'package:pianist_vip_pro/screen/practice/medium_level/note_reflex_screen.dart';

class PracticeItem {
  final IconData icon;
  final String title;
  final String description;
  final Color color;
  final Widget screen;

  PracticeItem({
    required this.icon,
    required this.title,
    required this.description,
    required this.color,
    required this.screen,
  });
}

final List<PracticeItem> basicLevel = [
  PracticeItem(
    icon: Icons.piano,
    title: 'Nhận diện phím',
    description: 'Học và nhận biết các phím piano',
    color: Colors.blue,
    screen: const KeyRecognitionScreen(),
  ),
  PracticeItem(
    icon: Icons.keyboard,
    title: 'Piano ảo',
    description: 'Chơi piano trực tiếp trên điện thoại',
    color: Colors.purple,
    screen: const VirtualPianoScreen(),
  ),
];

final List<PracticeItem> intermediateLevel = [
  PracticeItem(
    icon: Icons.graphic_eq,
    title: 'Nhận diện giai điệu',
    description: 'Luyện tập nhận biết các giai điệu',
    color: Colors.green,
    screen: const ScaleRecognitionScreen(),
  ),
  PracticeItem(
    icon: Icons.quiz,
    title: 'Đoán nốt',
    description: 'Trò chơi đoán nốt nhạc',
    color: Colors.orange,
    screen: const NoteGuessingScreen(),
  ),
];

final List<PracticeItem> advancedLevel = [
  PracticeItem(
    icon: Icons.hearing,
    title: 'Luyện nghe hợp âm',
    description: 'Phát triển khả năng nghe hợp âm',
    color: Colors.teal,
    screen: const ChordListeningScreen(),
  ),
  PracticeItem(
    icon: Icons.music_note,
    title: 'Nhận diện hợp âm',
    description: 'Nhận biết các hợp âm cơ bản',
    color: Colors.pink,
    screen: const ChordRecognitionScreen(),
  ),
  PracticeItem(
    icon: Icons.flash_on,
    title: 'Phản xạ nốt',
    description: 'Luyện tốc độ phản xạ với nốt nhạc',
    color: Colors.amber,
    screen: const NoteReflexScreen(),
  ),
];
