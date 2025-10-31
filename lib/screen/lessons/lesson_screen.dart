import 'package:flutter/material.dart';
import 'package:pianist_vip_pro/screen/courses/course_screen.dart';
import 'package:pianist_vip_pro/services/lesson_service/lesson_service.dart';
import 'package:pianist_vip_pro/models/lesson_model.dart';
import 'package:pianist_vip_pro/screen/piano_question/piano_question_screen.dart';
import 'package:pianist_vip_pro/screen/piano_question/sheet_question_screen.dart';
import 'package:pianist_vip_pro/services/user_progress_service/user_progress_service.dart';
import 'package:pianist_vip_pro/models/user_progress_model.dart';
import 'package:pianist_vip_pro/screen/home/widgets/app_theme.dart';

class LessonScreen extends StatefulWidget {
  final int courseId;

  const LessonScreen({Key? key, required this.courseId}) : super(key: key);

  @override
  State<LessonScreen> createState() => _LessonScreenState();
}

class _LessonScreenState extends State<LessonScreen> {
  final LessonService _lessonService = LessonService();
  final CoursesService _coursesService = CoursesService();
  List<Lesson> _lessons = [];
  bool _isLoading = true;
  String? _error;
  Map<int, UserProgress> _progressMap = {};

  @override
  void initState() {
    super.initState();
    _loadLessons();
  }

  Future<void> _loadLessons() async {
    try {
      final lessons = await _lessonService.fetchLessons(widget.courseId);
      setState(() {
        _lessons = lessons;
        _isLoading = false;
      });
      await _loadProgress();
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  Future<void> _loadProgress() async {
    try {
      final progresses = await _coursesService.userProgress();
      setState(() {
        _progressMap = {for (var p in progresses) p.lessonId: p};
      });
    } catch (e) {
      // Handle error if needed, but since progress is optional, ignore
    }
  }

  void _navigateToLesson(Lesson lesson) {
    Widget lessonScreen;

    if (lesson.isSheetMusicLesson()) {
      lessonScreen = NoteGuessingScreen(lessonId: lesson.lessonId);
    } else {
      lessonScreen = PianoQuestionScreen(lessonId: lesson.lessonId);
    }
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => lessonScreen),
    ).then((_) => _loadProgress());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: AppColors.mainBackgroundGradient,
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
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                    ),
                    const Text(
                      'Bài học',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
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
                                    'Không thể tải bài học',
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
                                      _loadLessons();
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
                          : _lessons.isEmpty
                              ? Center(
                                  child: Text(
                                    'Chưa có bài học nào',
                                    style: TextStyle(
                                      color: Colors.grey.shade400,
                                      fontSize: 16,
                                    ),
                                  ),
                                )
                              : ListView.separated(
                                  itemCount: _lessons.length,
                                  separatorBuilder: (context, index) =>
                                      const SizedBox(height: 16),
                                  itemBuilder: (context, index) {
                                    final lesson = _lessons[index];
                                    final gradientColors = _getGradientColors(
                                        index,
                                        _progressMap[lesson.lessonId]
                                            ?.completionPercentage);
                                    return BuildCourseCard(
                                      title: lesson.lessonTitle,
                                      description: lesson.description,
                                      progress: 'Bài ${lesson.lessonOrder}',
                                      gradientColors: gradientColors,
                                      completionPercentage:
                                          _progressMap[lesson.lessonId]
                                              ?.completionPercentage,
                                      onTap: () {
                                        _navigateToLesson(lesson);
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
    );
  }

  List<Color> _getGradientColors(int index, int? completionPercentage) {
    if (completionPercentage == 100) {
      return AppColors
          .courseGradients[index % AppColors.courseGradients.length];
    } else {
      return [Colors.grey.shade800, Colors.grey.shade900];
    }
  }
}
