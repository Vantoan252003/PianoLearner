import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:pianist_vip_pro/auth/auth_process/token_storage.dart';
import 'package:pianist_vip_pro/models/user_model.dart';
import 'package:pianist_vip_pro/api/api_endpoint.dart';

class AuthService {
  Future<User> login(String email, String password) async {
    final url = Uri.parse('${ApiEndpoint.baseUrl}${ApiEndpoint.login}');
    final response = await http.post(
      url,
      headers: {"Content-type": "application/json"},
      body: jsonEncode({
        "email": email,
        "password": password,
      }),
    );
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as Map<String, dynamic>;
      final token = data['token'];
      final expiresAt = data['expiresAt'];
      final user = data['user'];

      await TokenStorage.saveToken(token);
      if (expiresAt != null) {
        if (expiresAt is int) {
          await TokenStorage.saveExpertTime(expiresAt);
        }
      }

      final userObj = User.fromJson(user);
      await TokenStorage.saveUserInfo(userObj.fullName, userObj.email);

      return userObj;
    } else {
      throw Exception("Login failed: ${response.statusCode} ${response.body}");
    }
  }

  Future<User> register(
      String fullName, String email, String password, String levelName) async {
    final url = Uri.parse('${ApiEndpoint.baseUrl}${ApiEndpoint.register}');
    final response = await http.post(
      url,
      headers: {"Content-type": "application/json"},
      body: jsonEncode({
        "fullName": fullName,
        "email": email,
        "password": password,
        "levelName": levelName,
      }),
    );
    if (response.statusCode == 200 || response.statusCode == 201) {
      final data = jsonDecode(response.body) as Map<String, dynamic>;
      final token = data['token'];
      final expiresAt = data['expiresAt'];
      final user = data['user'];

      // Debug: Print response để kiểm tra dữ liệu
      print('Register response: $data');
      print('User data: $user');

      if (user == null) {
        throw Exception('User data is null in response');
      }

      await TokenStorage.saveToken(token);
      if (expiresAt != null) {
        if (expiresAt is int) {
          await TokenStorage.saveExpertTime(expiresAt);
        }
      }

      final userObj = User.fromJson(user as Map<String, dynamic>);
      await TokenStorage.saveUserInfo(userObj.fullName, userObj.email);

      return userObj;
    } else {
      throw Exception(
          "Register failed: ${response.statusCode} ${response.body}");
    }
  }
}
