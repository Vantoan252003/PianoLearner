import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pianist_vip_pro/providers/register_provider.dart';
import 'package:pianist_vip_pro/screen/home/widgets/app_theme.dart' as theme;

typedef AppColors = theme.AppColors;
typedef AppSpacing = theme.AppSpacing;
typedef AppRadius = theme.AppRadius;

class RegisterStepPassword extends StatefulWidget {
  final Function() onNext;
  final Function() onPrevious;

  const RegisterStepPassword({
    Key? key,
    required this.onNext,
    required this.onPrevious,
  }) : super(key: key);

  @override
  State<RegisterStepPassword> createState() => _RegisterStepPasswordState();
}

class _RegisterStepPasswordState extends State<RegisterStepPassword> {
  late TextEditingController _passwordController;
  late TextEditingController _confirmPasswordController;
  final FocusNode _passwordFocus = FocusNode();
  final FocusNode _confirmPasswordFocus = FocusNode();
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  @override
  void initState() {
    super.initState();
    final provider = context.read<RegisterProvider>();
    _passwordController =
        TextEditingController(text: provider.formData.password ?? '');
    _confirmPasswordController = TextEditingController();
  }

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _passwordFocus.dispose();
    _confirmPasswordFocus.dispose();
    super.dispose();
  }

  bool _isValidPassword(String password) {
    // Kiểm tra mật khẩu phải có ít nhất 8 ký tự, 1 chữ hoa, 1 chữ thường, 1 số
    return RegExp(
            r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$')
        .hasMatch(password);
  }

  void _handleNext() {
    if (_passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Vui lòng nhập mật khẩu')),
      );
      return;
    }

    if (_passwordController.text.length < 8) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Mật khẩu phải có ít nhất 8 ký tự')),
      );
      return;
    }

    if (_confirmPasswordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Vui lòng xác nhận mật khẩu')),
      );
      return;
    }

    if (_passwordController.text != _confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Mật khẩu xác nhận không khớp')),
      );
      return;
    }

    context.read<RegisterProvider>().setPassword(_passwordController.text);
    widget.onNext();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryBlack,
      appBar: AppBar(
        backgroundColor: AppColors.primaryBlack,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.primaryWhite),
          onPressed: widget.onPrevious,
        ),
        centerTitle: false,
      ),
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
                const SizedBox(height: 20),
                // Tiêu đề
                const Text(
                  'Mật khẩu của bạn?',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primaryWhite,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Bước 3/4',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white.withOpacity(0.6),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'Mật khẩu phải có ít nhất 8 ký tự',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.white.withOpacity(0.6),
                  ),
                ),
                const SizedBox(height: 40),
                // Input Password
                TextField(
                  controller: _passwordController,
                  focusNode: _passwordFocus,
                  obscureText: _obscurePassword,
                  style: const TextStyle(color: AppColors.primaryBlack),
                  decoration: InputDecoration(
                    hintText: 'Nhập mật khẩu',
                    hintStyle: TextStyle(color: Colors.grey.shade400),
                    filled: true,
                    fillColor: AppColors.primaryWhite,
                    suffixIcon: GestureDetector(
                      onTap: () {
                        setState(() => _obscurePassword = !_obscurePassword);
                      },
                      child: Icon(
                        _obscurePassword
                            ? Icons.visibility_off
                            : Icons.visibility,
                        color: Colors.grey,
                      ),
                    ),
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
                        color: AppColors.primaryBlack,
                        width: 2,
                      ),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.lg,
                      vertical: 18,
                    ),
                  ),
                  onChanged: (value) {
                    setState(() {});
                  },
                ),
                const SizedBox(height: 20),
                // Input Confirm Password
                TextField(
                  controller: _confirmPasswordController,
                  focusNode: _confirmPasswordFocus,
                  obscureText: _obscureConfirmPassword,
                  style: const TextStyle(color: AppColors.primaryBlack),
                  decoration: InputDecoration(
                    hintText: 'Xác nhận mật khẩu',
                    hintStyle: TextStyle(color: Colors.grey.shade400),
                    filled: true,
                    fillColor: AppColors.primaryWhite,
                    suffixIcon: GestureDetector(
                      onTap: () {
                        setState(() =>
                            _obscureConfirmPassword = !_obscureConfirmPassword);
                      },
                      child: Icon(
                        _obscureConfirmPassword
                            ? Icons.visibility_off
                            : Icons.visibility,
                        color: Colors.grey,
                      ),
                    ),
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
                        color: AppColors.primaryBlack,
                        width: 2,
                      ),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.lg,
                      vertical: 18,
                    ),
                  ),
                  onChanged: (value) {
                    setState(() {});
                  },
                ),
                const SizedBox(height: 60),
                // Nút Next
                SizedBox(
                  height: 56,
                  child: ElevatedButton(
                    onPressed: _passwordController.text.isNotEmpty &&
                            _confirmPasswordController.text.isNotEmpty
                        ? _handleNext
                        : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _passwordController.text.isNotEmpty &&
                              _confirmPasswordController.text.isNotEmpty
                          ? AppColors.tutorGreen
                          : Colors.grey.shade600,
                      shape: RoundedRectangleBorder(
                        borderRadius: AppRadius.round,
                      ),
                      elevation: 0,
                    ),
                    child: Text(
                      'Tiếp theo',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: _passwordController.text.isNotEmpty &&
                                _confirmPasswordController.text.isNotEmpty
                            ? AppColors.primaryWhite
                            : Colors.white.withOpacity(0.6),
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                // Nút Previous
                SizedBox(
                  height: 56,
                  child: ElevatedButton(
                    onPressed: widget.onPrevious,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryWhite,
                      side: const BorderSide(
                        color: AppColors.primaryBlack,
                        width: 1,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: AppRadius.round,
                      ),
                      elevation: 0,
                    ),
                    child: const Text(
                      'Quay lại',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: AppColors.primaryBlack,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
