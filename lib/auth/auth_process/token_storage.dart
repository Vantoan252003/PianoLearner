import 'package:shared_preferences/shared_preferences.dart';

class TokenStorage {
  static const _key = "token";
  static const expiresAt = "expiresAt";
  static const _userFullName = "userFullName";
  static const _userEmail = "userEmail";

  static Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, token);
  }

  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_key);
  }

  static Future<void> clearToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_key);
    await prefs.remove(_userFullName);
    await prefs.remove(_userEmail);
    await prefs.remove(expiresAt);
  }

  static Future<void> saveExpertTime(int saveTime) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(expiresAt, saveTime);
  }

  static Future<void> saveUserInfo(String fullName, String email) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userFullName, fullName);
    await prefs.setString(_userEmail, email);
  }

  static Future<String?> getUserFullName() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_userFullName);
  }

  static Future<String?> getUserEmail() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_userEmail);
  }
}
