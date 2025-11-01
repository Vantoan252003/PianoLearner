import 'package:flutter/material.dart';

class QuickActions extends StatelessWidget {
  final VoidCallback onAchievementTap;
  final VoidCallback onRankingTap;
  final VoidCallback onTutorTap;
  final VoidCallback onPracticeTap;

  const QuickActions({
    Key? key,
    required this.onAchievementTap,
    required this.onRankingTap,
    required this.onTutorTap,
    required this.onPracticeTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Hành động nhanh',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _QuickActionButton(
                icon: Icons.school,
                label: 'Thanh tich',
                onTap: onAchievementTap,
                gradientColors: [Colors.blue.shade700, Colors.blue.shade900],
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _QuickActionButton(
                icon: Icons.emoji_events,
                label: 'Xếp hạng',
                onTap: onRankingTap,
                gradientColors: [
                  Colors.purple.shade700,
                  Colors.purple.shade900
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _QuickActionButton(
                icon: Icons.headphones,
                label: 'Gia sư',
                onTap: onTutorTap,
                gradientColors: [Colors.green.shade700, Colors.green.shade900],
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _QuickActionButton(
                icon: Icons.fitness_center,
                label: 'Tập luyện',
                onTap: onPracticeTap,
                gradientColors: [
                  Colors.orange.shade700,
                  Colors.orange.shade900
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _QuickActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final List<Color> gradientColors;

  const _QuickActionButton({
    required this.icon,
    required this.label,
    required this.onTap,
    required this.gradientColors,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: gradientColors,
          ),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: Colors.white.withOpacity(0.2),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: gradientColors[0].withOpacity(0.3),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: Colors.white,
              size: 24,
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
