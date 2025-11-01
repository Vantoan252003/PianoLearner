import 'package:flutter/material.dart';
import 'package:pianist_vip_pro/screen/home/home_screen.dart';
import 'package:pianist_vip_pro/auth/auth_process/login_process.dart';
import 'package:pianist_vip_pro/screen/home/widgets/app_theme.dart' as theme;
import 'multi_step_register_screen.dart';

typedef AppColors = theme.AppColors;
typedef AppTextStyles = theme.AppTextStyles;
typedef AppSpacing = theme.AppSpacing;
typedef AppRadius = theme.AppRadius;

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _emailFocus = FocusNode();
  final _passwordFocus = FocusNode();
  bool _obscurePassword = true;
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _emailFocus.dispose();
    _passwordFocus.dispose();
    super.dispose();
  }

  Future<void> doLogin() async {
    final email = _emailController.text;
    final password = _passwordController.text;
    setState(() => _isLoading = true);
    try {
      await loginProcess(email: email, password: password);

      if (mounted) {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const HomeScreen()));
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Đăng nhập thất bại: ${e.toString()}')),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryBlack,
      body: Container(
        decoration: BoxDecoration(
          gradient: AppColors.mainBackgroundGradient,
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 40),
                const Center(
                  child: SizedBox(
                    width: 100,
                    height: 100,
                    child: Icon(
                      Icons.piano,
                      size: 80,
                      color: AppColors.primaryWhite,
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                const Text(
                  'Piano Learning',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primaryWhite,
                    letterSpacing: 1.2,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Đăng nhập để tiếp tục',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white.withOpacity(0.6),
                  ),
                ),
                const SizedBox(height: 48),
                TextField(
                  controller: _emailController,
                  focusNode: _emailFocus,
                  style: const TextStyle(color: AppColors.primaryBlack),
                  decoration: InputDecoration(
                    labelText: 'Email',
                    labelStyle: TextStyle(color: Colors.grey.shade600),
                    prefixIcon: const Icon(Icons.email_outlined,
                        color: AppColors.primaryBlack),
                    filled: true,
                    fillColor: AppColors.primaryWhite,
                    border: OutlineInputBorder(
                      borderRadius: AppRadius.round,
                      borderSide: BorderSide.none,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: AppRadius.round,
                      borderSide: BorderSide.none,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: AppRadius.round,
                      borderSide: const BorderSide(
                          color: AppColors.primaryBlack, width: 2),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                // Password field
                TextField(
                  controller: _passwordController,
                  focusNode: _passwordFocus,
                  obscureText: _obscurePassword,
                  style: const TextStyle(color: AppColors.primaryBlack),
                  decoration: InputDecoration(
                    labelText: 'Mật khẩu',
                    labelStyle: TextStyle(color: Colors.grey.shade600),
                    prefixIcon: const Icon(Icons.lock_outline,
                        color: AppColors.primaryBlack),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscurePassword
                            ? Icons.visibility_off
                            : Icons.visibility,
                        color: AppColors.primaryBlack,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscurePassword = !_obscurePassword;
                        });
                      },
                    ),
                    filled: true,
                    fillColor: AppColors.primaryWhite,
                    border: OutlineInputBorder(
                      borderRadius: AppRadius.round,
                      borderSide: BorderSide.none,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: AppRadius.round,
                      borderSide: BorderSide.none,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: AppRadius.round,
                      borderSide: const BorderSide(
                          color: AppColors.primaryBlack, width: 2),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                // Quên mật khẩu
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {
                      // TODO: Xử lý quên mật khẩu
                    },
                    child: Text(
                      'Quên mật khẩu?',
                      style: TextStyle(color: Colors.white.withOpacity(0.6)),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                // Nút đăng nhập với gradient
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        AppColors.coursesBlue,
                        AppColors.coursesBlueDark,
                      ],
                    ),
                    borderRadius: AppRadius.round,
                    boxShadow: [
                      AppColors.cardShadow(color: AppColors.coursesBlue),
                    ],
                  ),
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : doLogin,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      foregroundColor: AppColors.primaryWhite,
                      padding:
                          const EdgeInsets.symmetric(vertical: AppSpacing.lg),
                      shape: RoundedRectangleBorder(
                        borderRadius: AppRadius.round,
                      ),
                      elevation: 0,
                      shadowColor: Colors.transparent,
                    ),
                    child: _isLoading
                        ? const SizedBox(
                            height: 24,
                            width: 24,
                            child: CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(
                                  AppColors.primaryWhite),
                              strokeWidth: 2,
                            ),
                          )
                        : const Text(
                            'Đăng nhập',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                  ),
                ),
                const SizedBox(height: 24),
                // Divider
                Row(
                  children: [
                    Expanded(
                      child: Divider(
                        color: Colors.white.withOpacity(0.2),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        'hoặc',
                        style: TextStyle(color: Colors.white.withOpacity(0.6)),
                      ),
                    ),
                    Expanded(
                      child: Divider(
                        color: Colors.white.withOpacity(0.2),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 32),
                // Chuyển sang đăng ký
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Chưa có tài khoản? ',
                      style: TextStyle(color: Colors.white.withOpacity(0.6)),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                const MultiStepRegisterScreen(),
                          ),
                        );
                      },
                      child: const Text(
                        'Đăng ký',
                        style: TextStyle(
                          color: AppColors.primaryWhite,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
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
