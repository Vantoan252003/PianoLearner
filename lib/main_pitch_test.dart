import 'package:flutter/material.dart';
import 'package:pianist_vip_pro/screen/main_note_screen/learning_screen.dart';

void main() {
  runApp(const PitchDetectionTestApp());
}

class PitchDetectionTestApp extends StatelessWidget {
  const PitchDetectionTestApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pitch Detection Test',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Colors.deepPurple,
        scaffoldBackgroundColor: Colors.white,
        fontFamily: 'Roboto',
      ),
      home: const LearningScreen(),
    );
  }
}
