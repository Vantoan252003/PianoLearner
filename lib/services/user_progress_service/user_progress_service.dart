import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:pianist_vip_pro/api/api_endpoint.dart';
import 'package:pianist_vip_pro/auth/auth_process/token_storage.dart';
import 'package:pianist_vip_pro/models/user_progress_model.dart';

class CoursesService {
  Future<List<UserProgress>> userProgress([String? token]) async {
    token ??= await TokenStorage.getToken();
    final response = await http.get(
        Uri.parse("${ApiEndpoint.baseUrl}${ApiEndpoint.userProgress}"),
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
        });

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => UserProgress.fromJson(json)).toList();
    } else {
      throw Exception("Loi ${response.statusCode}");
    }
  }

  Future<bool> updateUserProgress({
    required int lessonId,
    required int completionPercentage,
    required int timeSpentMinutes,
    required bool isCompleted,
    String? token,
  }) async {
    token ??= await TokenStorage.getToken();

    final body = {
      "lessonId": lessonId.toString(),
      "completionPercentage": completionPercentage.toString(),
      "timeSpentMinutes": timeSpentMinutes.toString(),
      "isCompleted": isCompleted.toString(),
    };

    final response = await http.post(
      Uri.parse("${ApiEndpoint.baseUrl}${ApiEndpoint.userProgress}"),
      headers: {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json",
      },
      body: jsonEncode(body),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return true;
    } else {
      throw Exception("Loi ${response.statusCode}: ${response.body}");
    }
  }
}
