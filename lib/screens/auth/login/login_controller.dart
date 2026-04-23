import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iu_auditor/apis/api_request.dart';
import 'package:iu_auditor/apis/auth/i_auth_service.dart';
import 'package:iu_auditor/modal_class/user/user_profile.dart';
import 'package:iu_auditor/screens/auth/change_password/change_password.dart';
import 'package:iu_auditor/screens/auth/forgot_password/forgot_password.dart';
import 'package:iu_auditor/screens/home/home_Screen.dart';
import 'package:iu_auditor/screens/home/home_controller.dart';

class LoginController extends GetxController {
  final IAuthService _authService = Get.find<IAuthService>();

  final emailController    = TextEditingController();
  final passwordController = TextEditingController();

  var isLoading        = false.obs;
  var isPasswordHidden = true.obs;
  var emailError       = ''.obs;
  var passwordError    = ''.obs;

  bool validateFields() {
    bool isValid = true;

    final email    = emailController.text.trim();
    final password = passwordController.text.trim();

    if (email.isEmpty) {
      emailError.value = 'Email is required'; isValid = false;
    } else if (!GetUtils.isEmail(email)) {
      emailError.value = 'Enter a valid email'; isValid = false;
    } else { emailError.value = ''; }

    if (password.isEmpty) {
      passwordError.value = 'Password is required'; isValid = false;
    } else if (password.length < 6) {
      passwordError.value = 'Password must be at least 6 characters'; isValid = false;
    } else { passwordError.value = ''; }

    return isValid;
  }

  Future<void> login() async {
    if (!validateFields()) return;

    try {
      isLoading.value = true;

      final response = await _authService.login(
        email:    emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      if (response['success'] != true) {
        Get.snackbar('Error', response['message'] ?? 'Login failed');
        return;
      }

      // ── Set auth token ────────────────────────────────────
      final token = response['token']?.toString() ?? '';
      if (token.isNotEmpty) ApiRequest.setAuthToken(token);

      // ── Fetch profile (me API) ────────────────────────────
      final UserProfile? profile = response['user'] is UserProfile
          ? response['user'] as UserProfile
          : await _authService.fetchProfile();

      if (profile != null) {
        // Pre-populate HomeController with user data so it's
        // available immediately when HomeScreen builds
        try {
          final homeCtrl = Get.find<HomeController>();
          homeCtrl.setUserProfile(profile);
        } catch (_) {
          // HomeController not yet registered — that's fine,
          // HomeScreen will call setUserProfile in its onInit
        }
      }

      // ── First login check ─────────────────────────────────
      final mustChange = response['mustChangePassword'] == true;
      if (mustChange) {
        // Redirect to change password screen — do NOT go to home
        Get.offAll(() => const ChangePasswordScreen());
        return;
      }

      // ── Normal login — go to home ─────────────────────────
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