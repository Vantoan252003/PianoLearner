import 'package:flutter/material.dart';
import 'package:pianist_vip_pro/screen/courses/course_screen.dart';
import 'package:pianist_vip_pro/screen/lessons/lesson_screen.dart';
import 'package:pianist_vip_pro/screen/main_note_screen/learning_screen.dart';
import 'package:pianist_vip_pro/screen/practice/practice_screen.dart';
import 'package:pianist_vip_pro/screen/profile_settings/settings_screen.dart';
import 'package:pianist_vip_pro/services/courses_service/courses_service.dart';
import 'package:pianist_vip_pro/models/courses_model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final CoursesService _coursesService = CoursesService();
  List<Courses> _courses = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadCourses();
  }

  Future<void> _loadCourses() async {
    try {
      final courses = await _coursesService.getCourses();
      setState(() {
        _courses = courses;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.grey.shade900,
              Colors.black,
              Colors.grey.shade800,
            ],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Học Piano',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Colors.grey.shade700, Colors.grey.shade600],
                        ),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Text("Piano"),
                    ),
                  ],
                ),
                const SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildNavButton(context, Icons.school, 'Khóa học'),
                    _buildNavButton(context, Icons.music_note, 'Bài hát'),
                    _buildNavButton(context, Icons.headphones, 'Gia Su'),
                    _buildNavButton(context, Icons.fitness_center, 'Tập luyện'),
                  ],
                ),
                const SizedBox(height: 30),
                Expanded(
                  child: _isLoading
                      ? const Center(
                          child: CircularProgressIndicator(
                            color: Colors.white,
                          ),
                        )
                      : _error != null
                          ? Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(
                                    Icons.error_outline,
                                    color: Colors.white,
                                    size: 48,
                                  ),
                                  const SizedBox(height: 16),
                                  Text(
                                    'Không thể tải khóa học',
                                    style: TextStyle(
                                      color: Colors.grey.shade400,
                                      fontSize: 16,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  TextButton.icon(
                                    onPressed: () {
                                      setState(() {
                                        _isLoading = true;
                                        _error = null;
                                      });
                                      _loadCourses();
                                    },
                                    icon: const Icon(Icons.refresh),
                                    label: const Text('Thử lại'),
                                    style: TextButton.styleFrom(
                                      foregroundColor: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            )
                          : _courses.isEmpty
                              ? Center(
                                  child: Text(
                                    'Chưa có khóa học nào',
                                    style: TextStyle(
                                      color: Colors.grey.shade400,
                                      fontSize: 16,
                                    ),
                                  ),
                                )
                              : ListView.separated(
                                  itemCount: _courses.length,
                                  separatorBuilder: (context, index) =>
                                      const SizedBox(height: 16),
                                  itemBuilder: (context, index) {
                                    final course = _courses[index];
                                    final gradientColors =
                                        _getGradientColors(index);

                                    return BuildCourseCard(
                                      title: course.courseName,
                                      description: course.description,
                                      progress:
                                          '0%', // TODO: Lấy progress thực tế từ API
                                      gradientColors: gradientColors,
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => LessonScreen(
                                                courseId: course.courseId),
                                          ),
                                        );
                                      },
                                    );
                                  },
                                ),
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const SettingsScreen()),
          );
        },
        backgroundColor: Colors.white.withOpacity(0.1),
        child: const Icon(Icons.settings, color: Colors.white),
      ),
    );
  }

  List<Color> _getGradientColors(int index) {
    final colors = [
      [Colors.grey.shade800, Colors.grey.shade900],
      [Colors.grey.shade700, Colors.grey.shade900],
      [Colors.grey.shade800, Colors.black],
      [Colors.grey.shade600, Colors.grey.shade800],
    ];
    return colors[index % colors.length];
  }

  Widget _buildNavButton(BuildContext context, IconData icon, String label) {
    return GestureDetector(
      onTap: () {
        if (label == 'Tập luyện') {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const PracticeScreen(),
            ),
          );
        } else if (label == 'Gia Su') {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const LearningScreen()));
        }
      },
      child: Container(
        width: 80,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: Colors.white.withOpacity(0.1),
            width: 1,
          ),
        ),
        child: Column(
          children: [
            Icon(icon, color: Colors.white, size: 28),
            const SizedBox(height: 8),
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
