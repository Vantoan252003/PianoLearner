import 'package:pianist_vip_pro/services/auth_service/auth_service.dart';
import 'package:pianist_vip_pro/models/user_model.dart';

/// Thực hiện validate đơn giản rồi gọi AuthService.login.
/// Ném Exception với message thân thiện khi có lỗi.
Future<User> loginProcess({
  required String email,
  required String password,
}) async {
  final trimmedEmail = email.trim();
  if (trimmedEmail.isEmpty || password.isEmpty) {
    throw Exception('Vui lòng nhập email và mật khẩu');
  }

  final emailRegex = RegExp(r'^[\w\-.]+@([\w\-]+\.)+[\w\-]{2,4}$');
  if (!emailRegex.hasMatch(trimmedEmail)) {
    throw Exception('Email không hợp lệ');
  }

  final auth = AuthService();
  // AuthService.login sẽ ném exception khi thất bại
  final user = await auth.login(trimmedEmail, password);
  return user;
}