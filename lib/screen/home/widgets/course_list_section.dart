import 'package:flutter/material.dart';
import 'package:pianist_vip_pro/models/courses_model.dart';

class CourseListSection extends StatelessWidget {
  final List<Courses> courses;
  final bool isLoading;
  final String? error;
  final VoidCallback onRetry;

  const CourseListSection({
    Key? key,
    required this.courses,
    required this.isLoading,
    required this.error,
    required this.onRetry,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Khóa học',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                TextButton(
                  onPressed: () {},
                  child: Text(
                    'Xem tất cả',
                    style: TextStyle(
                      color: Colors.grey.shade400,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 12),
            if (isLoading)
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(40.0),
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 2,
                  ),
                ),
              )
            else if (error != null)
              _buildErrorState()
            else if (courses.isEmpty)
              _buildEmptyState()
            else
              _buildCourseList(),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40.0),
        child: Column(
          children: [
            Icon(Icons.error_outline, color: Colors.grey.shade600, size: 40),
            SizedBox(height: 12),
            Text(
              'Không thể tải khóa học',
              style: TextStyle(color: Colors.grey.shade500, fontSize: 14),
            ),
            SizedBox(height: 8),
            TextButton(
              onPressed: onRetry,
              child: Text('Thử lại', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40.0),
        child: Text(
          'Chưa có khóa học',
          style: TextStyle(color: Colors.grey.shade500, fontSize: 14),
        ),
      ),
    );
  }

  Widget _buildCourseList() {
    return Column(
      children: courses.asMap().entries.map((entry) {
        final index = entry.key;
        final course = entry.value;
        return Padding(
          padding: const EdgeInsets.only(bottom: 12.0),
          child: _CourseCard(
            course: course,
            index: index,
          ),
        );
      }).toList(),
    );
  }
}

class _CourseCard extends StatelessWidget {
  final Courses course;
  final int index;

  const _CourseCard({
    Key? key,
    required this.course,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Navigator.push to lesson screen
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.grey.shade900,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: Colors.grey.shade800,
            width: 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: Colors.grey.shade800,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(Icons.book, color: Colors.white, size: 24),
            ),
            SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    course.courseName,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    course.description,
                    style: TextStyle(
                      fontSize: 11,
                      color: Colors.grey.shade500,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            Icon(Icons.chevron_right, color: Colors.grey.shade600),
          ],
        ),
      ),
    );
  }
}
