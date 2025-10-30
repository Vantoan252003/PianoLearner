import 'package:flutter/material.dart';
import 'package:pianist_vip_pro/screen/lessons/lesson_screen.dart';
import 'package:pianist_vip_pro/screen/main_note_screen/note_detection_test_screen.dart';
import 'package:pianist_vip_pro/screen/practice/practice_screen.dart';
import 'package:pianist_vip_pro/screen/profile_settings/settings_screen.dart';
import 'package:pianist_vip_pro/screen/achievements/achievements_screen.dart';
import 'package:pianist_vip_pro/services/courses_service/courses_service.dart';
import 'package:pianist_vip_pro/services/achievements/achievements_service.dart'
    as achievement_service;
import 'package:pianist_vip_pro/models/courses_model.dart';
import 'package:pianist_vip_pro/models/achievements_model.dart';
import 'package:pianist_vip_pro/models/user_model.dart';
import 'package:pianist_vip_pro/screen/home/widgets/user_header.dart';
import 'package:pianist_vip_pro/screen/home/widgets/practice_stats.dart';
import 'package:pianist_vip_pro/screen/home/widgets/quick_actions.dart';
import 'package:pianist_vip_pro/screen/home/widgets/course_section.dart';
import 'package:pianist_vip_pro/auth/auth_process/token_storage.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final CoursesService _coursesService = CoursesService();

  List<Courses> _courses = [];

  User? _user;

  bool _isLoadingCourses = true;

  String? _coursesError;

  int _lessonsCompleted = 12;
  int _totalPracticeMinutes = 450;
  int _achievementsUnlocked = 5;

  @override
  void initState() {
    super.initState();
    _loadUserData();
    _loadCourses();
  }

  Future<void> _loadUserData() async {
    // Load user from storage
    try {
      final user = await TokenStorage.getUser();
      if (user != null) {
        setState(() {
          _user = user;
        });
      }
    } catch (e) {
      print('Error loading user: $e');
    }
  }

  Future<void> _loadCourses() async {
    try {
      final courses = await _coursesService.getCourses();
      setState(() {
        _courses = courses;
        _isLoadingCourses = false;
      });
    } catch (e) {
      setState(() {
        _coursesError = e.toString();
        _isLoadingCourses = false;
      });
    }
  }

  Future<void> _refreshData() async {
    setState(() {
      _isLoadingCourses = true;
      _coursesError = null;
    });

    await Future.wait([
      _loadCourses(),
      _loadUserData(),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.black,
              Colors.grey.shade900,
              Colors.black,
            ],
          ),
        ),
        child: SafeArea(
          child: RefreshIndicator(
            onRefresh: _refreshData,
            color: Colors.white,
            backgroundColor: Colors.grey.shade900,
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Container(
                constraints: BoxConstraints(
                  minHeight: MediaQuery.of(context).size.height -
                      MediaQuery.of(context).padding.top -
                      MediaQuery.of(context).padding.bottom,
                ),
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // User Header
                    UserHeader(
                      user: _user,
                      onSettingsTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const SettingsScreen(),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 20),

                    // Quick Actions
                    QuickActions(
                      onAchievementTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    const AchievementsScreen()));
                      },
                      onSongTap: () {
                        // TODO: Navigate to songs screen
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Tính năng bài hát đang phát triển'),
                          ),
                        );
                      },
                      onTutorTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const LearningScreen(),
                          ),
                        );
                      },
                      onPracticeTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const PracticeScreen(),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 20),

                    // Practice Statistics
                    PracticeStats(
                      lessonsCompleted: _lessonsCompleted,
                      totalPracticeMinutes: _totalPracticeMinutes,
                      achievementsUnlocked: _achievementsUnlocked,
                    ),
                    const SizedBox(height: 24),

                    // Courses Section
                    CourseSection(
                      courses: _courses,
                      isLoading: _isLoadingCourses,
                      error: _coursesError,
                      onRetry: () {
                        setState(() {
                          _isLoadingCourses = true;
                          _coursesError = null;
                        });
                        _loadCourses();
                      },
                      onCourseTap: (course) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => LessonScreen(
                              courseId: course.courseId,
                            ),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
