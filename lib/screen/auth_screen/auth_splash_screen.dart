import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:pianist_vip_pro/screen/home/widgets/app_theme.dart' as theme;
import 'login_screen.dart';
import 'multi_step_register_screen.dart';

// Sử dụng alias để tránh xung đột
typedef AppColors = theme.AppColors;
typedef AppSpacing = theme.AppSpacing;
typedef AppRadius = theme.AppRadius;

class AuthSplashScreen extends StatefulWidget {
  const AuthSplashScreen({Key? key}) : super(key: key);

  @override
  State<AuthSplashScreen> createState() => _AuthSplashScreenState();
}

class _AuthSplashScreenState extends State<AuthSplashScreen> {
  Future<void> _markAppAsNotFirstTime() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isFirstTime', false);
  }

  void _handleHasAccount() async {
    await _markAppAsNotFirstTime();
    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );
    }
  }

  void _handleNoAccount() async {
    await _markAppAsNotFirstTime();
    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => const MultiStepRegisterScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: AppColors.mainBackgroundGradient,
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Logo và tiêu đề
                Column(
                  children: [
                    const SizedBox(height: 60),
                    Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                          colors: [
                            AppColors.primaryBlack,
                            AppColors.primaryGrey800,
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                      ),
                      child: const Icon(
                        Icons.piano,
                        size: 80,
                        color: AppColors.primaryWhite,
                      ),
                    ),
                    const SizedBox(height: 40),
                    ShaderMask(
                      shaderCallback: (bounds) => LinearGradient(
                        colors: [
                          AppColors.primaryGrey700,
                          AppColors.primaryBlack,
                          AppColors.primaryGrey700,
                        ],
                      ).createShader(bounds),
                      child: const Text(
                        'Piano Learning',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 36,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primaryWhite,
                          letterSpacing: 1.5,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Bắt đầu hành trình âm nhạc của bạn',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white.withOpacity(0.6),
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
                // Các nút
                Column(
                  children: [
                    // Nút: Bạn đã có khoản
                    SizedBox(
                      height: 56,
                      child: ElevatedButton(
                        onPressed: _handleHasAccount,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryBlack,
                          shape: RoundedRectangleBorder(
                            borderRadius: AppRadius.round,
                          ),
                          elevation: 0,
                        ),
                        child: const Text(
                          'Bạn đã có khoản',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: AppColors.primaryWhite,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Nút: Tạo khoản mới
                    SizedBox(
                      height: 56,
                      child: ElevatedButton(
                        onPressed: _handleNoAccount,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryWhite,
                          side: const BorderSide(
                            color: AppColors.primaryBlack,
                            width: 2,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: AppRadius.round,
                          ),
                          elevation: 0,
                        ),
                        child: const Text(
                          'Tạo khoản mới',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: AppColors.primaryBlack,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
