import 'package:flutter/material.dart';
import 'level_section.dart';
import 'level_data.dart';

class PracticeScreen extends StatelessWidget {
  const PracticeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.grey.shade900, Colors.black, Colors.grey.shade800],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: ListView(
            padding: const EdgeInsets.all(20),
            children: [
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () => Navigator.pop(context),
                  ),
                  const SizedBox(width: 12),
                  const Text(
                    'Luyện Tập',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),

              // Các cấp độ
              LevelSection(title: '🌱 Cơ bản', items: basicLevel),
              const SizedBox(height: 20),
              LevelSection(title: '🎵 Trung cấp', items: intermediateLevel),
              const SizedBox(height: 20),
              LevelSection(title: '🔥 Nâng cao', items: advancedLevel),
            ],
          ),
        ),
      ),
    );
  }
}
