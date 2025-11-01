import 'package:flutter/material.dart';
import 'package:pianist_vip_pro/models/user_model.dart';
import 'package:pianist_vip_pro/screen/home/widgets/app_theme.dart' as theme;

typedef AppColors = theme.AppColors;
typedef AppSpacing = theme.AppSpacing;
typedef AppRadius = theme.AppRadius;
typedef AppTextStyles = theme.AppTextStyles;

class UserDetailScreen extends StatelessWidget {
  final User user;

  const UserDetailScreen({Key? key, required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryBlack,
      appBar: AppBar(
        backgroundColor: AppColors.primaryBlack,
        elevation: 0,
        title: const Text(
          'Thông tin cá nhân',
          style: TextStyle(
            color: AppColors.primaryWhite,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.primaryWhite),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: AppColors.mainBackgroundGradient,
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Avatar Section
                Center(
                  child: Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        colors: [
                          AppColors.coursesBlue,
                          AppColors.coursesBlueDark,
                        ],
                      ),
                    ),
                    child: user.avatarUrl != null
                        ? ClipOval(
                            child: Image.network(
                              user.avatarUrl!,
                              fit: BoxFit.cover,
                            ),
                          )
                        : Center(
                            child: Text(
                              user.fullName[0].toUpperCase(),
                              style: const TextStyle(
                                fontSize: 48,
                                fontWeight: FontWeight.bold,
                                color: AppColors.primaryWhite,
                              ),
                            ),
                          ),
                  ),
                ),
                const SizedBox(height: 24),

                // User Basic Info
                Center(
                  child: Column(
                    children: [
                      Text(
                        user.fullName,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primaryWhite,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        user.email,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.white.withOpacity(0.6),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.lg,
                          vertical: AppSpacing.sm,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.coursesBlue,
                          borderRadius: AppRadius.round,
                        ),
                        child: Text(
                          user.levelName,
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: AppColors.primaryWhite,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 40),

                // Statistics Section
                _buildSectionTitle('Thống kê học tập'),
                const SizedBox(height: 16),
                _buildStatRow(
                  icon: Icons.school,
                  label: 'Bài học hoàn thành',
                  value:
                      '${user.totalLessonsCompleted}/${user.totalLessonsTaken}',
                  color: AppColors.coursesBlue,
                ),
                const SizedBox(height: 12),
                _buildStatRow(
                  icon: Icons.timer,
                  label: 'Thời gian học',
                  value: '${user.totalLearningTimeMinutes} phút',
                  color: AppColors.songsPurple,
                ),
                const SizedBox(height: 12),
                _buildStatRow(
                  icon: Icons.percent,
                  label: 'Tỉ lệ hoàn thành',
                  value:
                      '${user.averageCompletionPercentage.toStringAsFixed(1)}%',
                  color: AppColors.tutorGreen,
                ),
                const SizedBox(height: 12),
                _buildStatRow(
                  icon: Icons.local_fire_department,
                  label: 'Streak hôm nay',
                  value: '${user.streakDays} ngày',
                  color: AppColors.practiceOrange,
                ),
                const SizedBox(height: 12),
                _buildStatRow(
                  icon: Icons.star,
                  label: 'Thành tích mở khóa',
                  value: '${user.totalAchievementsUnlocked}',
                  color: AppColors.achievementGold,
                ),

                const SizedBox(height: 40),

                // Experience Section
                _buildSectionTitle('Kinh nghiệm'),
                const SizedBox(height: 16),
                _buildExperienceCard(),

                const SizedBox(height: 40),

                // Account Info Section
                _buildSectionTitle('Thông tin tài khoản'),
                const SizedBox(height: 16),
                _buildInfoCard(
                  icon: Icons.calendar_today,
                  label: 'Ngày tạo tài khoản',
                  value: _formatDate(user.createdAt),
                ),
                const SizedBox(height: 12),
                if (user.lastLogin != null)
                  _buildInfoCard(
                    icon: Icons.login,
                    label: 'Đăng nhập lần cuối',
                    value: _formatDate(user.lastLogin!),
                  ),
                if (user.lastLogin != null) const SizedBox(height: 12),
                if (user.lastPracticeDate != null)
                  _buildInfoCard(
                    icon: Icons.brush,
                    label: 'Lần luyện tập cuối',
                    value: _formatDate(user.lastPracticeDate!),
                  ),

                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: AppColors.primaryWhite,
      ),
    );
  }

  Widget _buildStatRow({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: AppRadius.round,
        border: Border.all(
          color: color.withOpacity(0.3),
          width: 1,
        ),
      ),
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: color.withOpacity(0.2),
              borderRadius: AppRadius.round,
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.white.withOpacity(0.6),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primaryWhite,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExperienceCard() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: AppRadius.round,
        border: Border.all(
          color: AppColors.achievementGold.withOpacity(0.3),
          width: 1,
        ),
      ),
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Kinh nghiệm tích lũy',
            style: TextStyle(
              fontSize: 12,
              color: Colors.white.withOpacity(0.6),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: AppColors.achievementGold.withOpacity(0.2),
                  borderRadius: AppRadius.round,
                ),
                child: Icon(
                  Icons.emoji_events,
                  color: AppColors.achievementGold,
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${user.totalExp} EXP',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primaryWhite,
                      ),
                    ),
                    Text(
                      'Từ ${user.totalAchievementExpGain} thành tích',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.white.withOpacity(0.6),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: AppRadius.round,
        border: Border.all(
          color: Colors.white.withOpacity(0.1),
          width: 1,
        ),
      ),
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              borderRadius: AppRadius.round,
            ),
            child: Icon(
              icon,
              color: AppColors.primaryWhite.withOpacity(0.6),
              size: 20,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.white.withOpacity(0.6),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: AppColors.primaryWhite,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}
