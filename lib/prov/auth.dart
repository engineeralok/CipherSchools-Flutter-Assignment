import 'package:flutter/material.dart';

class SignUpProvider extends ChangeNotifier {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool isPasswordVisible = false;
  bool isChecked = false;

  SignUpProvider() {
    nameController.addListener(_updateButtonState);
    emailController.addListener(_updateButtonState);
    passwordController.addListener(_updateButtonState);
  }

  void togglePasswordVisibility() {
    isPasswordVisible = !isPasswordVisible;
    notifyListeners();
  }

  void toggleCheckbox(bool? value) {
    isChecked = value ?? false;
    notifyListeners();
  }

  bool get isButtonEnabled {
    return nameController.text.trim().isNotEmpty &&
        emailController.text.trim().isNotEmpty &&
        passwordController.text.trim().isNotEmpty &&
        isChecked;
  }

  void _updateButtonState() {
    notifyListeners();
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}
