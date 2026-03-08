import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iu_auditor/apis/auth/auth_api.dart';
import 'package:iu_auditor/screens/auth/otp/otp_view.dart';

class ForgotPasswordController extends GetxController {
  final Auth authapi = Auth();
  final emailController = TextEditingController();

  var isLoading = false.obs;
  var emailError = ''.obs;

  bool validateFields() {
    final email = emailController.text.trim();

    if (email.isEmpty) {
      emailError.value = "Email is required";
      return false;
    } else if (!GetUtils.isEmail(email)) {
      emailError.value = "Enter a valid email";
      return false;
    }

    emailError.value = '';
    return true;
  }

  Future<void> forgotPassword() async {
    if (!validateFields()) return;

    try {
      isLoading.value = true;

      final response = await authapi.forgetPassword(
        email: emailController.text.trim(),
      );

      if (response['success'].toString() == 'false') {
        Get.snackbar("Error", response['message'] ?? "Something went wrong");
        return;
      }

      // Success — navigate to OTP screen passing email along
      Get.to(() => OtpView(email: emailController.text));
    } catch (e) {
      debugPrint('Forgot password error: $e');
      Get.snackbar("Error", e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    emailController.dispose();
    super.onClose();
  }
}
