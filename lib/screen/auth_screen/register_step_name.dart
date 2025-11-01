import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pianist_vip_pro/providers/register_provider.dart';
import 'package:pianist_vip_pro/screen/home/widgets/app_theme.dart' as theme;

typedef AppColors = theme.AppColors;
typedef AppSpacing = theme.AppSpacing;
typedef AppRadius = theme.AppRadius;

class RegisterStepName extends StatefulWidget {
  final Function() onNext;

  const RegisterStepName({
    Key? key,
    required this.onNext,
  }) : super(key: key);

  @override
  State<RegisterStepName> createState() => _RegisterStepNameState();
}

class _RegisterStepNameState extends State<RegisterStepName> {
  late TextEditingController _nameController;
  final FocusNode _nameFocus = FocusNode();

  @override
  void initState() {
    super.initState();
    final provider = context.read<RegisterProvider>();
    _nameController =
        TextEditingController(text: provider.formData.fullName ?? '');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _nameFocus.dispose();
    super.dispose();
  }

  void _handleNext() {
    if (_nameController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Vui lòng nhập tên của bạn')),
      );
      return;
    }

    if (_nameController.text.trim().length < 2) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Tên phải có ít nhất 2 ký tự')),
      );
      return;
    }

    context.read<RegisterProvider>().setFullName(_nameController.text);
    widget.onNext();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryBlack,
      appBar: AppBar(
        backgroundColor: AppColors.primaryBlack,
        elevation: 0,
        leading: const SizedBox.shrink(),
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
                  'Tên của bạn?',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primaryWhite,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Bước 1/4',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white.withOpacity(0.6),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 40),
                // Input Name
                TextField(
                  controller: _nameController,
                  focusNode: _nameFocus,
                  style: const TextStyle(color: AppColors.primaryBlack),
                  decoration: InputDecoration(
                    hintText: 'Nhập tên đầy đủ',
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
                    setState(() {});
                  },
                ),
                const SizedBox(height: 60),
                // Nút Next
                SizedBox(
                  height: 56,
                  child: ElevatedButton(
                    onPressed:
                        _nameController.text.isNotEmpty ? _handleNext : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _nameController.text.isNotEmpty
                          ? AppColors.coursesBlue
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
                        color: _nameController.text.isNotEmpty
                            ? AppColors.primaryWhite
                            : Colors.white.withOpacity(0.6),
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
