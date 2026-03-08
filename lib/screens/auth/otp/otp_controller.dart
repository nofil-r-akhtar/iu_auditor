import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iu_auditor/apis/auth/auth_api.dart';
import 'package:iu_auditor/screens/auth/reset_password/reset_password.dart';

class OtpController extends GetxController {
  final Auth authapi = Auth();
  final otpController = TextEditingController();

  var isLoading = false.obs;
  var isResendLoading = false.obs;
  var otpError = ''.obs;

  // Timer
  var secondsRemaining = 15.obs; // starts at 15
  var isResendEnabled = false.obs;
  var resendCount = 0; // tracks how many times resend was tapped
  Timer? _timer;

  final String email;
  OtpController({required this.email});

  @override
  void onInit() {
    super.onInit();
    _startTimer(15); // start 15s countdown on screen open
  }

  void _startTimer(int seconds) {
    isResendEnabled.value = false;
    secondsRemaining.value = seconds;
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (secondsRemaining.value == 0) {
        timer.cancel();
        isResendEnabled.value = true;
      } else {
        secondsRemaining.value--;
      }
    });
  }

  bool validateOtp() {
    if (otpController.text.trim().length < 4) {
      otpError.value = "Please enter the complete OTP";
      return false;
    }
    otpError.value = '';
    return true;
  }

  Future<void> verifyOtp() async {
    if (!validateOtp()) return;

    try {
      isLoading.value = true;

      final response = await authapi.verifyOtp(
        email: email,
        otp: otpController.text.trim(),
      );

      if (response['success'].toString() == 'false') {
        otpError.value = response['message'] ?? "Invalid OTP";
        return;
      }

      // Success — go to reset password, pass email along
      Get.off(() => ResetPassword(email: email, otp: otpController.text));
    } catch (e) {
      debugPrint('Verify OTP error: $e');
      Get.snackbar("Error", e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> resendOtp() async {
    if (!isResendEnabled.value) return;

    try {
      isResendLoading.value = true;

      final response = await authapi.resendOtp(email: email);

      if (response['success'].toString() == 'false') {
        Get.snackbar("Error", response['message'] ?? "Failed to resend OTP");
        return;
      }

      resendCount++;
      // 15s first time, 30s every time after
      _startTimer(resendCount == 1 ? 15 : 30);
      otpController.clear();
      Get.snackbar("Success", "OTP resent successfully");
    } catch (e) {
      debugPrint('Resend OTP error: $e');
      Get.snackbar("Error", e.toString());
    } finally {
      isResendLoading.value = false;
    }
  }

  @override
  void onClose() {
    _timer?.cancel();
    otpController.dispose();
    super.onClose();
  }
}
