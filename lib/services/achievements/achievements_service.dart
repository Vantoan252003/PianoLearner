import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:pianist_vip_pro/api/api_endpoint.dart';
import 'package:pianist_vip_pro/auth/auth_process/token_storage.dart';
import 'package:pianist_vip_pro/models/achievements_model.dart';

class CoursesService {
  Future<List<Achievement>> getAchievements([String? token]) async {
    token ??= await TokenStorage.getToken();
    final response = await http.get(
        Uri.parse("${ApiEndpoint.baseUrl}${ApiEndpoint.achievements}"),
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
        });

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => Achievement.fromJson(json)).toList();
    } else {
      throw Exception("Loi ${response.statusCode}");
    }
  }
}
