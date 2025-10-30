import 'package:flutter/material.dart';
import 'package:pianist_vip_pro/screen/auth_screen/auth_splash_screen.dart';
import 'package:pianist_vip_pro/screen/auth_screen/login_screen.dart';
import 'package:pianist_vip_pro/screen/home/home_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();

  // Kiểm tra xem có phải lần đầu vào app
  final isFirstTime = prefs.getBool('isFirstTime') ?? true;

  // Kiểm tra token đăng nhập
  final token = prefs.getString('token');
  final isLoggedIn = token != null && token.isNotEmpty;

  runApp(PianoLearningApp(
    isFirstTime: isFirstTime,
    isLoggedIn: isLoggedIn,
  ));
}

class PianoLearningApp extends StatelessWidget {
  final bool isFirstTime;
  final bool isLoggedIn;

  const PianoLearningApp({
    super.key,
    required this.isFirstTime,
    required this.isLoggedIn,
  });

  @override
  Widget build(BuildContext context) {
    Widget home;

    if (isFirstTime) {
      // Lần đầu vào app - hiển thị splash screen hỏi "Bạn đã có khoản chưa?"
      home = const AuthSplashScreen();
    } else if (isLoggedIn) {
      // Đã đăng nhập - hiển thị home
      home = const HomeScreen();
    } else {
      // Không phải lần đầu nhưng chưa đăng nhập - hiển thị login
      home = const LoginScreen();
    }

    return MaterialApp(
      title: 'Piano Learning',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Colors.black,
        scaffoldBackgroundColor: Colors.white,
        fontFamily: 'Roboto',
      ),
      home: home,
    );
  }
}
