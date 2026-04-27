import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iu_auditor/apis/api_request.dart';
import 'package:iu_auditor/apis/auth/i_auth_service.dart';
import 'package:iu_auditor/app_theme/colors.dart';
import 'package:iu_auditor/components/app_image.dart';
import 'package:iu_auditor/components/app_text.dart';
import 'package:iu_auditor/const/assets.dart';
import 'package:iu_auditor/const/enums.dart';
import 'package:iu_auditor/screens/auth/login/login.dart';
import 'package:iu_auditor/screens/home/home_Screen.dart';
import 'package:iu_auditor/services/storage_service.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Slight delay so the splash is actually visible
    Future.delayed(const Duration(milliseconds: 600), _decideRoute);
  }

  Future<void> _decideRoute() async {
    final storage = StorageService();

    // No token, or token older than 55 minutes → go to login
    if (!storage.hasValidToken) {
      await storage.clearToken();
      ApiRequest.clearAuthToken();
      Get.offAll(() => const Login());
      return;
    }

    // Token is fresh client-side — but we still verify it with the server
    // since the user might have been deleted, or password reset elsewhere.
    final token = storage.token;
    if (token != null) ApiRequest.setAuthToken(token);

    try {
      final auth = Get.find<IAuthService>();
      final profile = await auth.fetchProfile();

      if (profile == null) {
        // Server rejected the token (401, 404, etc.) → expired/invalid
        await storage.clearToken();
        ApiRequest.clearAuthToken();
        Get.offAll(() => const Login());
        return;
      }

      // All good — go straight to home
      Get.offAll(() => const HomeScreen());
    } catch (_) {
      // Network error or anything else — be safe, send to login
      await storage.clearToken();
      ApiRequest.clearAuthToken();
      Get.offAll(() => const Login());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: navyBlueColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AppAssetImage(
                imagePath: logo, height: 64, fit: BoxFit.contain),
            const SizedBox(height: 24),
            AppTextBold(
              text: 'IU Auditor',
              color: whiteColor,
              fontSize: 22,
              fontFamily: FontFamily.inter,
            ),
            const SizedBox(height: 8),
            AppTextRegular(
              text: 'Auditor Portal',
              color: whiteColor.withValues(alpha: 0.55),
              fontSize: 13,
            ),
            const SizedBox(height: 36),
            const SizedBox(
              width: 24, height: 24,
              child: CircularProgressIndicator(
                color: whiteColor,
                strokeWidth: 2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}