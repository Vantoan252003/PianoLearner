import 'package:flutter/material.dart';
import 'package:pianist_vip_pro/models/user_model.dart';

class UserHeader extends StatelessWidget {
  final User? user;
  final VoidCallback onSettingsTap;

  const UserHeader({
    Key? key,
    required this.user,
    required this.onSettingsTap,
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
      child: Row(
        children: [
          // Avatar
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [Colors.white.withOpacity(0.3), Colors.grey.shade700],
              ),
              border: Border.all(
                color: Colors.white.withOpacity(0.3),
                width: 2,
              ),
            ),
            child: user?.avatarUrl != null && user!.avatarUrl!.isNotEmpty
                ? ClipOval(
                    child: Image.network(
                      user!.avatarUrl!,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Icon(
                        Icons.person,
                        color: Colors.white,
                        size: 30,
                      ),
                    ),
                  )
                : Icon(
                    Icons.person,
                    color: Colors.white,
                    size: 30,
                  ),
          ),
          const SizedBox(width: 16),
          // User Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  user?.fullName ?? 'Loading...',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        user?.levelName ?? 'Beginner',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.white.withOpacity(0.9),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Icon(
                      Icons.stars,
                      color: Colors.amber,
                      size: 16,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${user?.totalExp ?? 0} EXP',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.amber.shade200,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          // Settings Button
          IconButton(
            onPressed: onSettingsTap,
            icon: const Icon(
              Icons.settings_outlined,
              color: Colors.white,
              size: 28,
            ),
          ),
        ],
      ),
    );
  }
}
