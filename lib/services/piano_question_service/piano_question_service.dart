import 'package:http/http.dart' as http;
import 'package:pianist_vip_pro/api/api_endpoint.dart';
import 'package:pianist_vip_pro/auth/auth_process/token_storage.dart';
import 'package:pianist_vip_pro/models/piano_question_model.dart';
import 'dart:convert';

class PianoQuestionService {
  Future<List<PianoQuestion>> fetchPianoQuestions(int? lessonId) async {
    String? token = await TokenStorage.getToken();
    final response = await http.get(
        Uri.parse(
            "${ApiEndpoint.baseUrl}${ApiEndpoint.getPianoQuestions.replaceAll('{lessonId}', lessonId.toString())}"),
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
        });
    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((json) => PianoQuestion.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load lessons');
    }
  }
}
