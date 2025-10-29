import 'package:http/http.dart' as http;
import 'package:pianist_vip_pro/api/api_endpoint.dart';
import 'package:pianist_vip_pro/auth/auth_process/token_storage.dart';
import 'dart:convert';
import '../models/lesson_model.dart';

class LessonService {
  Future<List<Lesson>> fetchLessons(int? courseId) async {
    String? token = await TokenStorage.getToken();
    print('in ra token $token');
    final response = await http.get(
        Uri.parse(
            "${ApiEndpoint.baseUrl}${ApiEndpoint.getLessons.replaceAll('{courseId}', courseId.toString())}"),
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
        });
    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((json) => Lesson.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load lessons');
    }
  }
}
