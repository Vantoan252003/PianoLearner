import 'package:flutter/material.dart';
import 'package:pianist_vip_pro/auth/auth_process/token_storage.dart';
import 'package:pianist_vip_pro/models/user_model.dart';
import 'package:pianist_vip_pro/screen/auth_screen/login_screen.dart';
import 'package:pianist_vip_pro/screen/user/change_password_screen.dart';
import 'package:pianist_vip_pro/screen/user/user_detail_screen.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  String _fullName = '';
  String _email = '';
  bool _isLoading = true;
  User? _user;
  @override
  void initState() {
    super.initState();
    _loadUserInfo();
  }

  Future<void> _loadUserInfo() async {
    final fullName = await TokenStorage.getUserFullName();
    final email = await TokenStorage.getUserEmail();
    final userInfo = await TokenStorage.getUser();

    setState(() {
      _fullName = fullName ?? 'Người dùng';
      _email = email ?? '';
      _isLoading = false;
      _user = userInfo;
    });
  }

  Future<void> _handleLogout(BuildContext context) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Xác nhận đăng xuất'),
        content: const Text('Bạn có chắc chắn muốn đăng xuất?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Hủy'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text(
              'Đăng xuất',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );

    if (confirm == true && context.mounted) {
      // Xóa token và thông tin user
      await TokenStorage.clearToken();

      if (context.mounted) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const LoginScreen()),
          (route) => false,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cài đặt'),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.grey.shade900,
              Colors.black,
              Colors.grey.shade800,
            ],
          ),
        ),
        child: _isLoading
            ? const Center(
                child: CircularProgressIndicator(color: Colors.white),
              )
            : ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  // Thông tin user
                  Card(
                    color: Colors.white.withOpacity(0.1),
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        children: [
                          CircleAvatar(
                            radius: 40,
                            backgroundColor: Colors.white.withOpacity(0.2),
                            child: _user != null && _user!.avatarUrl != null
                                ? ClipOval(
                                    child: Image.network(
                                      _user!.avatarUrl!,
                                      width: 80,
                                      height: 80,
                                      fit: BoxFit.cover,
                                      errorBuilder:
                                          (context, error, stackTrace) =>
                                              const Icon(Icons.person,
                                                  size: 40,
                                                  color: Colors.white),
                                    ),
                                  )
                                : const Icon(Icons.person,
                                    size: 40, color: Colors.white),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            _fullName,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            _email,
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey.shade400,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Phần tài khoản
                  Card(
                    color: Colors.white.withOpacity(0.1),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Tài khoản',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 16),
                          ListTile(
                            leading:
                                const Icon(Icons.person, color: Colors.white),
                            title: const Text(
                              'Thông tin cá nhân',
                              style: TextStyle(color: Colors.white),
                            ),
                            trailing: const Icon(
                              Icons.arrow_forward_ios,
                              color: Colors.white,
                              size: 16,
                            ),
                            onTap: () {
                              if (_user != null) {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        UserDetailScreen(user: _user!),
                                  ),
                                );
                              }
                            },
                          ),
                          const Divider(color: Colors.white24),
                          ListTile(
                            leading:
                                const Icon(Icons.lock, color: Colors.white),
                            title: const Text(
                              'Đổi mật khẩu',
                              style: TextStyle(color: Colors.white),
                            ),
                            trailing: const Icon(
                              Icons.arrow_forward_ios,
                              color: Colors.white,
                              size: 16,
                            ),
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const ChangePasswordScreen()));
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Phần cài đặt ứng dụng
                  Card(
                    color: Colors.white.withOpacity(0.1),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Ứng dụng',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 16),
                          ListTile(
                            leading: const Icon(Icons.notifications,
                                color: Colors.white),
                            title: const Text(
                              'Thông báo',
                              style: TextStyle(color: Colors.white),
                            ),
                            trailing: const Icon(
                              Icons.arrow_forward_ios,
                              color: Colors.white,
                              size: 16,
                            ),
                            onTap: () {
                              // TODO: Chuyển đến màn hình cài đặt thông báo
                            },
                          ),
                          const Divider(color: Colors.white24),
                          ListTile(
                            leading:
                                const Icon(Icons.language, color: Colors.white),
                            title: const Text(
                              'Ngôn ngữ',
                              style: TextStyle(color: Colors.white),
                            ),
                            trailing: const Icon(
                              Icons.arrow_forward_ios,
                              color: Colors.white,
                              size: 16,
                            ),
                            onTap: () {
                              // TODO: Chuyển đến màn hình chọn ngôn ngữ
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Phần hỗ trợ
                  Card(
                    color: Colors.white.withOpacity(0.1),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Hỗ trợ',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 16),
                          ListTile(
                            leading:
                                const Icon(Icons.help, color: Colors.white),
                            title: const Text(
                              'Trợ giúp',
                              style: TextStyle(color: Colors.white),
                            ),
                            trailing: const Icon(
                              Icons.arrow_forward_ios,
                              color: Colors.white,
                              size: 16,
                            ),
                            onTap: () {
                              // TODO: Chuyển đến màn hình trợ giúp
                            },
                          ),
                          const Divider(color: Colors.white24),
                          ListTile(
                            leading:
                                const Icon(Icons.info, color: Colors.white),
                            title: const Text(
                              'Giới thiệu',
                              style: TextStyle(color: Colors.white),
                            ),
                            trailing: const Icon(
                              Icons.arrow_forward_ios,
                              color: Colors.white,
                              size: 16,
                            ),
                            onTap: () {
                              // TODO: Chuyển đến màn hình giới thiệu
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Nút đăng xuất
                  Container(
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [
                          Colors.red,
                          Colors.redAccent,
                        ],
                      ),
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.red.withOpacity(0.3),
                          blurRadius: 15,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: ElevatedButton.icon(
                      onPressed: () => _handleLogout(context),
                      icon: const Icon(Icons.logout),
                      label: const Text(
                        'Đăng xuất',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 0,
                        shadowColor: Colors.transparent,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Phiên bản ứng dụng
                  Center(
                    child: Text(
                      'Phiên bản 1.0.0',
                      style: TextStyle(
                        color: Colors.grey.shade500,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
