import 'package:flutter/material.dart';

class NavigationGrid extends StatelessWidget {
  const NavigationGrid({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Khám phá',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          GridView.count(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            crossAxisCount: 4,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            children: [
              _NavItem(
                  icon: Icons.school, label: 'Khóa học', route: '/courses'),
              _NavItem(
                  icon: Icons.music_note, label: 'Bài hát', route: '/songs'),
              _NavItem(
                  icon: Icons.emoji_events,
                  label: 'Thành tựu',
                  route: '/achievements'),
              _NavItem(
                  icon: Icons.fitness_center,
                  label: 'Luyện tập',
                  route: '/practice'),
              _NavItem(
                  icon: Icons.headphones, label: 'Gia sư', route: '/tutor'),
              _NavItem(
                  icon: Icons.favorite,
                  label: 'Yêu thích',
                  route: '/favorites'),
              _NavItem(
                  icon: Icons.bar_chart,
                  label: 'Thống kê',
                  route: '/statistics'),
              _NavItem(
                  icon: Icons.history, label: 'Lịch sử', route: '/history'),
            ],
          ),
        ],
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String route;

  const _NavItem({
    Key? key,
    required this.icon,
    required this.label,
    required this.route,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Navigator.pushNamed(context, route);
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey.shade900,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: Colors.grey.shade800,
            width: 1,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.white, size: 24),
            SizedBox(height: 6),
            Text(
              label,
              style: const TextStyle(
                fontSize: 10,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
