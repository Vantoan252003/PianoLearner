import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:pianist_vip_pro/models/user_model.dart';

class TokenStorage {
  static const _key = "token";
  static const expiresAt = "expiresAt";
  static const _userFullName = "userFullName";
  static const _userEmail = "userEmail";
  static const _userData = "userData"; // Store full user object

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
    await prefs.remove(_userData);
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

  // Save full user object
  static Future<void> saveUser(User user) async {
    final prefs = await SharedPreferences.getInstance();
    final userJson = jsonEncode(user.toJson());
    await prefs.setString(_userData, userJson);
    // Also save basic info for backward compatibility
    await prefs.setString(_userFullName, user.fullName);
    await prefs.setString(_userEmail, user.email);
  }

  // Get full user object
  static Future<User?> getUser() async {
    final prefs = await SharedPreferences.getInstance();
    final userJson = prefs.getString(_userData);
    if (userJson != null) {
      try {
        final userMap = jsonDecode(userJson) as Map<String, dynamic>;
        return User.fromJson(userMap);
      } catch (e) {
        print('Error parsing user data: $e');
        return null;
      }
    }
    return null;
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
