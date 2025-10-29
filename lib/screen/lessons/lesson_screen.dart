import 'package:flutter/material.dart';
import 'package:pianist_vip_pro/screen/courses/course_screen.dart';
import 'package:pianist_vip_pro/services/lesson_service/lesson_service.dart';
import 'package:pianist_vip_pro/models/lesson_model.dart';
import 'package:pianist_vip_pro/screen/piano_question/piano_question_screen.dart';

class LessonScreen extends StatefulWidget {
  final int courseId;

  const LessonScreen({Key? key, required this.courseId}) : super(key: key);

  @override
  State<LessonScreen> createState() => _LessonScreenState();
}

class _LessonScreenState extends State<LessonScreen> {
  final LessonService _lessonService = LessonService();
  List<Lesson> _lessons = [];
  bool _isLoading = true;
  String? _error;

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
                                    final gradientColors =
                                        _getGradientColors(index);

                                    return BuildCourseCard(
                                      title: lesson.lessonTitle,
                                      description: lesson.description,
                                      progress: 'Bài ${lesson.lessonOrder}',
                                      gradientColors: gradientColors,
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                PianoQuestionScreen(
                                                    lessonId: lesson.lessonId),
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
}
