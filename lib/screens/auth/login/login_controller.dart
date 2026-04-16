import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iu_auditor/apis/api_request.dart';
import 'package:iu_auditor/apis/auth/i_auth_service.dart';
import 'package:iu_auditor/screens/auth/forgot_password/forgot_password.dart';
import 'package:iu_auditor/screens/home/home_screen.dart';

class LoginController extends GetxController {
  // ── Depend on the INTERFACE, not a concrete class ──
  final IAuthService _authService = Get.find<IAuthService>();

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  var isLoading = false.obs;
  var isPasswordHidden = true.obs;
  var emailError = ''.obs;
  var passwordError = ''.obs;

  bool validateFields() {
    bool isValid = true;

    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    if (email.isEmpty) {
      emailError.value = 'Email is required';
      isValid = false;
    } else if (!GetUtils.isEmail(email)) {
      emailError.value = 'Enter a valid email';
      isValid = false;
    } else {
      emailError.value = '';
    }

    if (password.isEmpty) {
      passwordError.value = 'Password is required';
      isValid = false;
    } else if (password.length < 6) {
      passwordError.value = 'Password must be at least 6 characters';
      isValid = false;
    } else {
      passwordError.value = '';
    }

    return isValid;
  }

  Future<void> login() async {
    if (!validateFields()) return;

    try {
      isLoading.value = true;

      final response = await _authService.login(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      if (response['success'] == false || response['success'] == 'false') {
        Get.snackbar('Error', response['message'] ?? 'Something went wrong');
        return;
      }

      // Store token
      final token = response['token'];
      if (token != null) ApiRequest.setAuthToken(token);

      Get.offAll(() => const HomeScreen());
    } catch (e) {
      debugPrint('Login error: $e');
      Get.snackbar('Error', e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  void goToForgotPassword() {
    Get.to(() => const ForgotPassword());
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}
