import 'package:pianist_vip_pro/services/auth_service/auth_service.dart';
import 'package:pianist_vip_pro/models/user_model.dart';

/// Thực hiện validate đơn giản rồi gọi AuthService.register.
/// Ném Exception với message thân thiện khi có lỗi.
Future<User> registerProcess({
  required String fullName,
  required String email,
  required String password,
  required String levelName,
}) async {
  final trimmedEmail = email.trim();
  final trimmedFullName = fullName.trim();

  if (trimmedFullName.isEmpty) {
    throw Exception('Vui lòng nhập họ tên');
  }

  if (trimmedEmail.isEmpty || password.isEmpty) {
    throw Exception('Vui lòng nhập đầy đủ thông tin');
  }

  final emailRegex = RegExp(r'^[\w\-.]+@([\w\-]+\.)+[\w\-]{2,4}$');
  if (!emailRegex.hasMatch(trimmedEmail)) {
    throw Exception('Email không hợp lệ');
  }

  if (password.length < 6) {
    throw Exception('Mật khẩu phải có ít nhất 6 ký tự');
  }

  if (levelName.isEmpty) {
    throw Exception('Vui lòng chọn cấp độ');
  }

  final auth = AuthService();
  // AuthService.register sẽ ném exception khi thất bại
  final user =
      await auth.register(trimmedFullName, trimmedEmail, password, levelName);
  return user;
}
