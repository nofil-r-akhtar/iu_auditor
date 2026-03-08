import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iu_auditor/apis/api_request.dart';
import 'package:iu_auditor/apis/auth/auth_api.dart';
import 'package:iu_auditor/screens/auth/forgot_password/forgot_password.dart';
import 'package:iu_auditor/screens/home/home_Screen.dart';

class LoginController extends GetxController {
  final Auth authapi = Auth();
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
      emailError.value = "Email is required";
      isValid = false;
    } else if (!GetUtils.isEmail(email)) {
      emailError.value = "Enter a valid email";
      isValid = false;
    } else {
      emailError.value = '';
    }

    if (password.isEmpty) {
      passwordError.value = "Password is required";
      isValid = false;
    } else if (password.length < 6) {
      passwordError.value = "Password must be at least 6 characters";
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

      // ── Temporary hardcoded login (remove when API is ready) ──
      final email = emailController.text.trim();
      final password = passwordController.text.trim();

      if (email == 'admin@iqra.edu.pk' && password == '123456') {
        await Future.delayed(const Duration(seconds: 1)); // simulate network
        Get.offAll(() => const HomeScreen());
      } else {
        Get.snackbar("Error", "Invalid email or password");
      }

      // ── Uncomment below and remove above when API is ready ──
      // final response = await authapi.login(email: email, password: password);
      // if (response['success'].toString() == 'false') {
      //   Get.snackbar("Error", response['message'] ?? "Something went wrong");
      //   return;
      // }
      // final token = response['token'];
      // if (token != null) ApiRequest.setAuthToken(token);
      // Get.offAll(() => const HomeScreen());
    } catch (e) {
      debugPrint('Login error: $e');
      Get.snackbar("Error", e.toString());
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
