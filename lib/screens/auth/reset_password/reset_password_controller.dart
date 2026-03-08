import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iu_auditor/apis/auth/auth_api.dart';
import 'package:iu_auditor/screens/auth/login/login.dart';

class ResetPasswordController extends GetxController {
  final Auth authapi = Auth();
  final newPasswordController = TextEditingController();
  final confirmNewPasswordController = TextEditingController();

  var isNewPasswordHidden = true.obs;
  var isConfirmNewPasswordHidden = true.obs;
  var isLoading = false.obs;

  var newPasswordError = ''.obs;
  var confirmPasswordError = ''.obs;

  // email and otp passed from OtpView
  final String email;
  final String otp;
  ResetPasswordController({required this.email, required this.otp});

  bool validateFields() {
    bool isValid = true;

    final newPassword = newPasswordController.text.trim();
    final confirmPassword = confirmNewPasswordController.text.trim();

    if (newPassword.isEmpty) {
      newPasswordError.value = "New password is required";
      isValid = false;
    } else if (newPassword.length < 6) {
      newPasswordError.value = "Password must be at least 6 characters";
      isValid = false;
    } else {
      newPasswordError.value = '';
    }

    if (confirmPassword.isEmpty) {
      confirmPasswordError.value = "Please confirm your password";
      isValid = false;
    } else if (confirmPassword != newPassword) {
      confirmPasswordError.value = "Passwords do not match";
      isValid = false;
    } else {
      confirmPasswordError.value = '';
    }

    return isValid;
  }

  Future<void> resetPassword() async {
    if (!validateFields()) return;

    try {
      isLoading.value = true;

      final response = await authapi.resetPassword(
        email: email,
        otp: otp,
        newPassword: newPasswordController.text.trim(),
      );

      if (response['success'].toString() == 'false') {
        Get.snackbar(
          "Error",
          response['message'] ?? "Failed to reset password",
        );
        return;
      }

      // Success — go back to login and clear stack
      Get.snackbar("Success", "Password reset successfully");
      Get.offAll(() => const Login());
    } catch (e) {
      debugPrint('Reset password error: $e');
      Get.snackbar("Error", e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    newPasswordController.dispose();
    confirmNewPasswordController.dispose();
    super.onClose();
  }
}
