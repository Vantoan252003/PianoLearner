class ApiEndpoint {
  static const String baseUrl = "http://192.168.31.58:8080/api";
  //auth process
  static const String login = '/auth/login';
  static const String register = '/auth/register';
  //courses
  static const String getCourses = '/auth/courses';
  static const String getLessons = '/auth/course/lesson/{courseId}';
}
