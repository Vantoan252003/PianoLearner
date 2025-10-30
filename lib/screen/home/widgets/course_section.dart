import 'package:flutter/material.dart';
import 'package:pianist_vip_pro/models/courses_model.dart';

class CourseSection extends StatelessWidget {
  final List<Courses> courses;
  final bool isLoading;
  final String? error;
  final VoidCallback onRetry;
  final Function(Courses) onCourseTap;

  const CourseSection({
    Key? key,
    required this.courses,
    this.isLoading = false,
    this.error,
    required this.onRetry,
    required this.onCourseTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Khóa học của bạn',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            if (courses.isNotEmpty)
              TextButton(
                onPressed: () {
                  // TODO: Navigate to all courses page
                },
                child: Text(
                  'Xem tất cả',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.7),
                    fontSize: 14,
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: 12),
        if (isLoading)
          const Center(
            child: Padding(
              padding: EdgeInsets.all(40),
              child: CircularProgressIndicator(color: Colors.white),
            ),
          )
        else if (error != null)
          Container(
            padding: const EdgeInsets.all(30),
            decoration: BoxDecoration(
              color: Colors.red.withOpacity(0.1),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: Colors.red.withOpacity(0.3),
                width: 1,
              ),
            ),
            child: Center(
              child: Column(
                children: [
                  Icon(
                    Icons.error_outline,
                    color: Colors.red.shade300,
                    size: 48,
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Không thể tải khóa học',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextButton.icon(
                    onPressed: onRetry,
                    icon: const Icon(Icons.refresh, color: Colors.white),
                    label: const Text(
                      'Thử lại',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          )
        else if (courses.isEmpty)
          Container(
            padding: const EdgeInsets.all(30),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.05),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: Colors.white.withOpacity(0.1),
                width: 1,
              ),
            ),
            child: Center(
              child: Column(
                children: [
                  Icon(
                    Icons.school_outlined,
                    color: Colors.white.withOpacity(0.3),
                    size: 48,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Chưa có khóa học nào',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.5),
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
          )
        else
          SizedBox(
            height: 180,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: courses.length > 5 ? 5 : courses.length,
              separatorBuilder: (context, index) => const SizedBox(width: 12),
              itemBuilder: (context, index) {
                final course = courses[index];
                return _CourseCard(
                  course: course,
                  onTap: () => onCourseTap(course),
                  gradientColors: _getGradientColors(index),
                );
              },
            ),
          ),
      ],
    );
  }

  List<Color> _getGradientColors(int index) {
    final colors = [
      [Colors.indigo.shade700, Colors.indigo.shade900],
      [Colors.teal.shade700, Colors.teal.shade900],
      [Colors.deepPurple.shade700, Colors.deepPurple.shade900],
      [Colors.cyan.shade700, Colors.cyan.shade900],
      [Colors.pink.shade700, Colors.pink.shade900],
    ];
    return colors[index % colors.length];
  }
}

class _CourseCard extends StatelessWidget {
  final Courses course;
  final VoidCallback onTap;
  final List<Color> gradientColors;

  const _CourseCard({
    required this.course,
    required this.onTap,
    required this.gradientColors,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 280,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: gradientColors,
          ),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: Colors.white.withOpacity(0.2),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: gradientColors[0].withOpacity(0.3),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(
                    Icons.school,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    course.difficultyLevel,
                    style: const TextStyle(
                      fontSize: 11,
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              course.courseName,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                height: 1.2,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              course.description,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 13,
                color: Colors.white.withOpacity(0.8),
                height: 1.3,
              ),
            ),
            const Spacer(),
            Row(
              children: [
                Icon(
                  Icons.book_outlined,
                  color: Colors.white.withOpacity(0.8),
                  size: 16,
                ),
                const SizedBox(width: 4),
                Text(
                  '${course.totalLessons} bài học',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.white.withOpacity(0.8),
                  ),
                ),
                const SizedBox(width: 12),
                Icon(
                  Icons.access_time,
                  color: Colors.white.withOpacity(0.8),
                  size: 16,
                ),
                const SizedBox(width: 4),
                Text(
                  '${course.durationWeeks} tuần',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.white.withOpacity(0.8),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
