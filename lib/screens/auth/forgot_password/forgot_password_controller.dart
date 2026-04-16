import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iu_auditor/apis/auth/i_auth_service.dart';
import 'package:iu_auditor/screens/auth/otp/otp_view.dart';

class ForgotPasswordController extends GetxController {
  final IAuthService _authService = Get.find<IAuthService>();

  final emailController = TextEditingController();

  var isLoading = false.obs;
  var emailError = ''.obs;

  bool validateFields() {
    final email = emailController.text.trim();

    if (email.isEmpty) {
      emailError.value = 'Email is required';
      return false;
    } else if (!GetUtils.isEmail(email)) {
      emailError.value = 'Enter a valid email';
      return false;
    }

    emailError.value = '';
    return true;
  }

  Future<void> forgotPassword() async {
    if (!validateFields()) return;

    try {
      isLoading.value = true;

      final response = await _authService.forgotPassword(
        email: emailController.text.trim(),
      );

      if (response['success'] == false || response['success'] == 'false') {
        Get.snackbar('Error', response['message'] ?? 'Something went wrong');
        return;
      }

      Get.to(() => OtpView(email: emailController.text.trim()));
    } catch (e) {
      debugPrint('Forgot password error: $e');
      Get.snackbar('Error', e.toString());
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
