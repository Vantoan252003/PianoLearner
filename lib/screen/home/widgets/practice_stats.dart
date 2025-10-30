import 'package:flutter/material.dart';

class PracticeStats extends StatelessWidget {
  final int lessonsCompleted;
  final int totalPracticeMinutes;
  final int achievementsUnlocked;

  const PracticeStats({
    Key? key,
    this.lessonsCompleted = 0,
    this.totalPracticeMinutes = 0,
    this.achievementsUnlocked = 0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.grey.shade900,
            Colors.black,
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.white.withOpacity(0.1),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Thống kê',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _StatItem(
                icon: Icons.check_circle_outline,
                value: lessonsCompleted.toString(),
                label: 'Bài học',
                color: Colors.green,
              ),
              Container(
                width: 1,
                height: 40,
                color: Colors.white.withOpacity(0.1),
              ),
              _StatItem(
                icon: Icons.timer_outlined,
                value: totalPracticeMinutes.toString(),
                label: 'Phút',
                color: Colors.blue,
              ),
              Container(
                width: 1,
                height: 40,
                color: Colors.white.withOpacity(0.1),
              ),
              _StatItem(
                icon: Icons.emoji_events_outlined,
                value: achievementsUnlocked.toString(),
                label: 'Huy hiệu',
                color: Colors.amber,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;
  final Color color;

  const _StatItem({
    required this.icon,
    required this.value,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(
          icon,
          color: color,
          size: 28,
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.white.withOpacity(0.6),
          ),
        ),
      ],
    );
  }
}
