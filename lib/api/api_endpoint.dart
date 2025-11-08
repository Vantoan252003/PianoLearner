class ApiEndpoint {
  static const String baseUrl = "http://157.66.100.248:9090/api";
  //auth process
  static const String login = '/auth/login';
  static const String register = '/auth/register';
  static const String checkmail = '/auth/checkmail';
  //courses
  static const String getCourses = '/auth/courses';
  static const String getLessons = '/auth/course/lesson/{courseId}';
  static const String getPianoQuestions = '/auth/piano-question/{lessonId}';
  static const String userProgress = '/auth/user-progress';
  static const String achievements = '/auth/achievements';

  //user
  static const String userInfo = '/auth/user-info';

  //ranking
  static const String ranking = '/auth/ranking';
}
