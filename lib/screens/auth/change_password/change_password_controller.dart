import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iu_auditor/apis/auth/i_auth_service.dart';
import 'package:iu_auditor/screens/home/home_screen.dart';

class ChangePasswordController extends GetxController {
  final IAuthService _authService = Get.find<IAuthService>();

  final newPasswordController     = TextEditingController();
  final confirmPasswordController = TextEditingController();

  var isNewPasswordHidden     = true.obs;
  var isConfirmPasswordHidden = true.obs;
  var isLoading               = false.obs;

  var newPasswordError     = ''.obs;
  var confirmPasswordError = ''.obs;

  bool _validate() {
    bool valid = true;

    final pw  = newPasswordController.text.trim();
    final cpw = confirmPasswordController.text.trim();

    if (pw.isEmpty) {
      newPasswordError.value = 'Password is required'; valid = false;
    } else if (pw.length < 6) {
      newPasswordError.value = 'Password must be at least 6 characters'; valid = false;
    } else {
      newPasswordError.value = '';
    }

    if (cpw.isEmpty) {
      confirmPasswordError.value = 'Please confirm your password'; valid = false;
    } else if (cpw != pw) {
      confirmPasswordError.value = 'Passwords do not match'; valid = false;
    } else {
      confirmPasswordError.value = '';
    }

    return valid;
  }

  Future<void> changePassword() async {
    if (!_validate()) return;
    try {
      isLoading.value = true;

      final res = await _authService.firstLoginChangePassword(
        newPassword: newPasswordController.text.trim(),
      );

      if (res['success'] != true) {
        Get.snackbar('Error', res['message'] ?? 'Failed to change password');
        return;
      }

      Get.snackbar(
        'Password Set',
        'Your password has been updated. Welcome!',
        snackPosition: SnackPosition.BOTTOM,
      );

      Get.offAll(() => const HomeScreen());
    } catch (e) {
      debugPrint('Change password error: $e');
      Get.snackbar('Error', e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }
}