class RegisterFormData {
  String? fullName;
  String? email;
  String? password;
  String? levelName;

  RegisterFormData({
    this.fullName,
    this.email,
    this.password,
    this.levelName,
  });

  Map<String, dynamic> toJson() {
    return {
      'fullname': fullName,
      'email': email,
      'password': password,
      'levelName': levelName,
    };
  }

  @override
  String toString() {
    return 'RegisterFormData(fullName: $fullName, email: $email, password: $password, levelName: $levelName)';
  }
}
