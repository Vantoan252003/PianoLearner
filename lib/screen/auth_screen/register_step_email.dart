import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pianist_vip_pro/providers/register_provider.dart';
import 'package:pianist_vip_pro/screen/home/widgets/app_theme.dart' as theme;
import 'package:pianist_vip_pro/services/auth_service/auth_service.dart';

typedef AppColors = theme.AppColors;
typedef AppSpacing = theme.AppSpacing;
typedef AppRadius = theme.AppRadius;

class RegisterStepEmail extends StatefulWidget {
  final Function() onNext;
  final Function() onPrevious;

  const RegisterStepEmail({
    Key? key,
    required this.onNext,
    required this.onPrevious,
  }) : super(key: key);

  @override
  State<RegisterStepEmail> createState() => _RegisterStepEmailState();
}

class _RegisterStepEmailState extends State<RegisterStepEmail> {
  late TextEditingController _emailController;
  final FocusNode _emailFocus = FocusNode();
  String? _emailErrorMessage;

  @override
  void initState() {
    super.initState();
    final provider = context.read<RegisterProvider>();
    _emailController =
        TextEditingController(text: provider.formData.email ?? '');
  }

  @override
  void dispose() {
    _emailController.dispose();
    _emailFocus.dispose();
    super.dispose();
  }

  bool _isValidEmail(String email) {
    return RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$')
        .hasMatch(email);
  }

  Future<void> _checkEmailAvailability(String email) async {
    if (!_isValidEmail(email)) {
      return;
    }

    setState(() {
      _emailErrorMessage = null;
    });

    try {
      final authService = AuthService();
      final message = await authService.checkEmailAvailability(email);

      if (mounted) {
        if (message != null && message.isNotEmpty) {
          setState(() {
            _emailErrorMessage = message;
          });
        } else {
          setState(() {
            _emailErrorMessage = null;
          });
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _emailErrorMessage = 'Lỗi kiểm tra email: ${e.toString()}';
        });
      }
    }
  }

  void _handleNext() {
    if (_emailController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Vui lòng nhập email')),
      );
      return;
    }

    if (!_isValidEmail(_emailController.text)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Vui lòng nhập email hợp lệ')),
      );
      return;
    }

    if (_emailErrorMessage != null && _emailErrorMessage!.isNotEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(_emailErrorMessage!)),
      );
      return;
    }

    context.read<RegisterProvider>().setEmail(_emailController.text);
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
                  'Email của bạn?',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primaryWhite,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Bước 2/4',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white.withOpacity(0.6),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 40),
                // Input Email
                TextField(
                  controller: _emailController,
                  focusNode: _emailFocus,
                  keyboardType: TextInputType.emailAddress,
                  style: const TextStyle(color: AppColors.primaryBlack),
                  decoration: InputDecoration(
                    hintText: 'Nhập email của bạn',
                    hintStyle: TextStyle(color: Colors.grey.shade400),
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
                    if (value.isNotEmpty && _isValidEmail(value)) {
                      _checkEmailAvailability(value);
                    } else {
                      setState(() {
                        _emailErrorMessage = null;
                      });
                    }
                  },
                ),
                if (_emailErrorMessage != null)
                  Padding(
                    padding: const EdgeInsets.only(top: AppSpacing.sm),
                    child: Text(
                      _emailErrorMessage!,
                      style: TextStyle(
                        color: AppColors.errorRed,
                        fontSize: 12,
                      ),
                    ),
                  ),
                const SizedBox(height: 60),
                // Nút Next
                SizedBox(
                  height: 56,
                  child: ElevatedButton(
                    onPressed: _emailController.text.isNotEmpty &&
                            _emailErrorMessage == null
                        ? _handleNext
                        : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _emailController.text.isNotEmpty &&
                              _emailErrorMessage == null
                          ? AppColors.songsPurple
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
                        color: _emailController.text.isNotEmpty &&
                                _emailErrorMessage == null
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
