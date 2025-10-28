import 'package:flutter/foundation.dart';
import 'package:pianist_vip_pro/models/register_model.dart';

class RegisterProvider extends ChangeNotifier {
  final RegisterFormData _formData = RegisterFormData();

  RegisterFormData get formData => _formData;

  void setFullName(String fullName) {
    _formData.fullName = fullName;
    notifyListeners();
  }

  void setEmail(String email) {
    _formData.email = email;
    notifyListeners();
  }

  void setPassword(String password) {
    _formData.password = password;
    notifyListeners();
  }

  void setLevelName(String levelName) {
    _formData.levelName = levelName;
    notifyListeners();
  }

  void resetForm() {
    _formData.fullName = null;
    _formData.email = null;
    _formData.password = null;
    _formData.levelName = null;
    notifyListeners();
  }

  bool get isFormComplete =>
      _formData.fullName != null &&
      _formData.email != null &&
      _formData.password != null &&
      _formData.levelName != null;
}
