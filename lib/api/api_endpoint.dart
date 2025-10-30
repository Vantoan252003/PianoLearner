class ApiEndpoint {
  static const String baseUrl = "http://192.168.1.226:8080/api";
  //auth process
  static const String login = '/auth/login';
  static const String register = '/auth/register';
  //courses
  static const String getCourses = '/auth/courses';
  static const String getLessons = '/auth/course/lesson/{courseId}';
  static const String getPianoQuestions = '/auth/piano-question/{lessonId}';
  static const String userProgress = '/auth/user-progress/update';
  static const String achievements = '/auth/achievements';
}
