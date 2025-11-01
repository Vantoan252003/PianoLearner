import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pianist_vip_pro/providers/register_provider.dart';
import 'package:pianist_vip_pro/auth/auth_process/register_process.dart';
import 'package:pianist_vip_pro/screen/home/home_screen.dart';
import 'package:pianist_vip_pro/screen/home/widgets/app_theme.dart' as theme;

typedef AppColors = theme.AppColors;
typedef AppSpacing = theme.AppSpacing;
typedef AppRadius = theme.AppRadius;

class RegisterStepLevel extends StatefulWidget {
  final Function() onPrevious;

  const RegisterStepLevel({
    Key? key,
    required this.onPrevious,
  }) : super(key: key);

  @override
  State<RegisterStepLevel> createState() => _RegisterStepLevelState();
}

class _RegisterStepLevelState extends State<RegisterStepLevel> {
  String? _selectedLevel;
  bool _isLoading = false;

  final List<Map<String, String>> _levels = [
    {
      'name': 'Beginner',
      'title': 'Mới chơi',
      'description': 'Bắt đầu từ những bài cơ bản',
      'icon': '🎹',
    },
    {
      'name': 'Intermediate',
      'title': 'Tầm trung',
      'description': 'Đã có kiến thức nền tảng',
      'icon': '🎼',
    },
    {
      'name': 'Advanced',
      'title': 'Nâng cao',
      'description': 'Kinh nghiệm nhiều năm',
      'icon': '🎵',
    },
  ];

  Future<void> _handleRegister() async {
    if (_selectedLevel == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Vui lòng chọn cấp độ')),
      );
      return;
    }

    final provider = context.read<RegisterProvider>();
    provider.setLevelName(_selectedLevel!);

    setState(() => _isLoading = true);
    try {
      await registerProcess(
        fullName: provider.formData.fullName!,
        email: provider.formData.email!,
        password: provider.formData.password!,
        levelName: _selectedLevel!,
      );

      if (mounted) {
        provider.resetForm();
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomeScreen()),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Đăng ký thất bại: ${e.toString()}')),
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
                  'Chọn cấp độ của bạn',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primaryWhite,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Bước 4/4',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white.withOpacity(0.6),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 40),
                // Các tùy chọn cấp độ
                ..._levels.map((level) {
                  final isSelected = _selectedLevel == level['name'];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16.0),
                    child: GestureDetector(
                      onTap: () {
                        setState(() => _selectedLevel = level['name']);
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: AppRadius.round,
                          border: Border.all(
                            color: isSelected
                                ? AppColors.coursesBlue
                                : Colors.grey.shade300,
                            width: isSelected ? 2 : 1,
                          ),
                          color: isSelected
                              ? AppColors.primaryGrey800
                              : AppColors.primaryWhite,
                        ),
                        padding: const EdgeInsets.all(AppSpacing.lg),
                        child: Row(
                          children: [
                            // Icon
                            Text(
                              level['icon']!,
                              style: const TextStyle(fontSize: 40),
                            ),
                            const SizedBox(width: 16),
                            // Content
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    level['title']!,
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: isSelected
                                          ? AppColors.primaryWhite
                                          : AppColors.primaryBlack,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    level['description']!,
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: isSelected
                                          ? Colors.white.withOpacity(0.7)
                                          : Colors.grey.shade600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            // Checkbox
                            if (isSelected)
                              Container(
                                width: 24,
                                height: 24,
                                decoration: BoxDecoration(
                                  color: AppColors.coursesBlue,
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.check,
                                  color: AppColors.primaryWhite,
                                  size: 16,
                                ),
                              )
                            else
                              Container(
                                width: 24,
                                height: 24,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: Colors.grey.shade300,
                                    width: 2,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                  );
                }).toList(),
                const SizedBox(height: 60),
                // Nút Register
                SizedBox(
                  height: 56,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _handleRegister,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _selectedLevel != null
                          ? AppColors.practiceOrange
                          : Colors.grey.shade600,
                      shape: RoundedRectangleBorder(
                        borderRadius: AppRadius.round,
                      ),
                      elevation: 0,
                    ),
                    child: _isLoading
                        ? const SizedBox(
                            height: 24,
                            width: 24,
                            child: CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(
                                AppColors.primaryWhite,
                              ),
                              strokeWidth: 2,
                            ),
                          )
                        : Text(
                            'Đăng ký',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: _selectedLevel != null
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
                    onPressed: _isLoading ? null : widget.onPrevious,
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
