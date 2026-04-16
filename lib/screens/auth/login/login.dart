import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iu_auditor/app_theme/colors.dart';
import 'package:iu_auditor/components/app_button.dart';
import 'package:iu_auditor/components/app_container.dart';
import 'package:iu_auditor/components/app_icon_button.dart';
import 'package:iu_auditor/components/app_image.dart';
import 'package:iu_auditor/components/app_svg.dart';
import 'package:iu_auditor/components/app_text.dart';
import 'package:iu_auditor/components/app_text_button.dart';
import 'package:iu_auditor/components/app_text_field.dart';
import 'package:iu_auditor/const/assets.dart';
import 'package:iu_auditor/const/enums.dart';
import 'package:iu_auditor/screens/auth/login/login_controller.dart';

class Login extends StatelessWidget {
  const Login({super.key});

  @override
  Widget build(BuildContext context) {
    Get.delete<LoginController>(force: true);
    final LoginController controller = Get.put(LoginController());

    return Scaffold(
      backgroundColor: bgColor,
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isMobile = constraints.maxWidth < 600;
          return isMobile
              ? _MobileLayout(controller: controller)
              : _DesktopLayout(controller: controller);
        },
      ),
    );
  }
}

// ─────────────────────────────────────────
// MOBILE — top blue branding panel + overlapping white card
// ─────────────────────────────────────────
class _MobileLayout extends StatelessWidget {
  final LoginController controller;
  const _MobileLayout({required this.controller});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const ClampingScrollPhysics(),
      child: Column(
        children: [
          // ── Blue branding panel ──
          _MobileBrandingPanel(),

          // ── White card overlapping the blue panel ──
          Transform.translate(
            offset: const Offset(0, -28),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 480),
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.08),
                        blurRadius: 24,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.fromLTRB(24, 28, 24, 28),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      AppTextBold(
                        text: "Welcome Back",
                        color: navyBlueColor,
                        fontSize: 22,
                        fontFamily: FontFamily.inter,
                      ),
                      const SizedBox(height: 4),
                      AppTextRegular(
                        text: "Enter your credentials to access.",
                        color: descriptiveColor,
                        fontSize: 13,
                      ),
                      const SizedBox(height: 24),
                      _LoginForm(controller: controller),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // Footer note
          Transform.translate(
            offset: const Offset(0, -16),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: AppTextRegular(
                text:
                    "For auditor access only. Contact admin if you need assistance.",
                color: iconColor,
                fontSize: 11,
                textAlign: TextAlign.center,
              ),
            ),
          ),

          const SizedBox(height: 28),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────
// MOBILE — blue branding panel
// ─────────────────────────────────────────
class _MobileBrandingPanel extends StatelessWidget {
  const _MobileBrandingPanel();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(top: 60, bottom: 60),
      color: navyBlueColor,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Icon badge
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: primaryColor.withValues(alpha: 0.25),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Icon(
              Icons.school_rounded,
              color: whiteColor,
              size: 30,
            ),
          ),

          const SizedBox(height: 20),

          // University logo / wordmark image
          AppAssetImage(imagePath: logo, height: 44, fit: BoxFit.contain),

          const SizedBox(height: 14),

          AppTextBold(
            text: "Auditor Portal",
            color: whiteColor,
            fontSize: 22,
            fontFamily: FontFamily.inter,
          ),

          const SizedBox(height: 6),

          AppTextRegular(
            text: "Sign in to view and conduct faculty audits",
            color: whiteColor.withValues(alpha: 0.65),
            fontSize: 13,
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────
// DESKTOP / TABLET — two-panel layout (unchanged)
// ─────────────────────────────────────────
class _DesktopLayout extends StatelessWidget {
  final LoginController controller;
  const _DesktopLayout({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // ── Left Panel (branding) ──
        Expanded(
          flex: 5,
          child: AppContainer(
            bgColor: navyBlueColor,
            child: Stack(
              children: [
                Positioned(
                  top: -60,
                  left: -60,
                  child: AppContainer(
                    width: 300,
                    height: 300,
                    shape: BoxShape.circle,
                    bgColor: primaryColor.withValues(alpha: 0.15),
                  ),
                ),
                Positioned(
                  bottom: -80,
                  right: -80,
                  child: AppContainer(
                    width: 380,
                    height: 380,
                    shape: BoxShape.circle,
                    bgColor: primaryColor.withValues(alpha: 0.1),
                  ),
                ),
                Positioned(
                  bottom: 120,
                  left: -40,
                  child: AppContainer(
                    width: 180,
                    height: 180,
                    shape: BoxShape.circle,
                    bgColor: whiteColor.withValues(alpha: 0.03),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(52),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          AppContainer(
                            bgColor: primaryColor,
                            borderRadius: BorderRadius.circular(12),
                            padding: const EdgeInsets.all(10),
                            child: const Icon(
                              Icons.school_rounded,
                              color: whiteColor,
                              size: 22,
                            ),
                          ),
                          const SizedBox(width: 12),
                          AppTextBold(
                            text: "IU Auditor",
                            color: whiteColor,
                            fontSize: 18,
                            fontFamily: FontFamily.inter,
                          ),
                        ],
                      ),
                      const Spacer(),
                      AppAssetImage(
                        imagePath: logo,
                        height: 52,
                        fit: BoxFit.contain,
                      ),
                      const SizedBox(height: 28),
                      AppTextBold(
                        text: "Auditor\nPortal",
                        color: whiteColor,
                        fontSize: 44,
                        fontFamily: FontFamily.inter,
                      ),
                      const SizedBox(height: 16),
                      AppTextRegular(
                        text:
                            "A centralized platform to manage,\nreview and conduct faculty audits\nfor Iqra University.",
                        color: whiteColor.withValues(alpha: 0.6),
                        fontSize: 14,
                      ),
                      const Spacer(),
                      Row(
                        children: [
                          AppContainer(
                            width: 32,
                            height: 2,
                            bgColor: primaryColor,
                            borderRadius: BorderRadius.circular(2),
                          ),
                          const SizedBox(width: 10),
                          AppTextRegular(
                            text: "For authorized auditors only",
                            color: whiteColor.withValues(alpha: 0.4),
                            fontSize: 12,
                          ),
                        ],
                      ),
                      const SizedBox(height: 32),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),

        // ── Right Panel (form) ──
        Expanded(
          flex: 4,
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 52, vertical: 40),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 420),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    AppTextBold(
                      text: "Welcome Back",
                      color: navyBlueColor,
                      fontSize: 28,
                      fontFamily: FontFamily.inter,
                    ),
                    const SizedBox(height: 6),
                    AppTextRegular(
                      text: "Sign in to your account to continue",
                      color: descriptiveColor,
                      fontSize: 14,
                    ),
                    const SizedBox(height: 36),
                    _LoginForm(controller: controller),
                    const SizedBox(height: 32),
                    Row(
                      children: [
                        const Expanded(
                          child: Divider(color: Color(0xFFE2E8F0)),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          child: AppTextRegular(
                            text: "Iqra University",
                            color: iconColor,
                            fontSize: 12,
                          ),
                        ),
                        const Expanded(
                          child: Divider(color: Color(0xFFE2E8F0)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    Center(
                      child: AppTextRegular(
                        text:
                            "For auditor access only. Contact admin if you need assistance.",
                        color: iconColor,
                        fontSize: 12,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────
// SHARED FORM — used by both layouts
// ─────────────────────────────────────────
class _LoginForm extends StatelessWidget {
  final LoginController controller;
  const _LoginForm({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        AppTextSemiBold(
          text: "Email Address",
          color: navyBlueColor,
          fontSize: 13,
          fontFamily: FontFamily.inter,
        ),
        const SizedBox(height: 6),
        Obx(
          () => AppTextField(
            textController: controller.emailController,
            placeholder: "your.email@iqra.edu.pk",
            keyboardType: TextInputType.emailAddress,
            submitLabel: TextInputAction.next,
            prefixIcon: AppSvg(
              assetPath: user,
              height: 10,
              width: 10,
              fit: BoxFit.scaleDown,
            ),
            onChanged: (_) => controller.emailError.value = '',
            isError: controller.emailError.value.isNotEmpty,
            errorText: controller.emailError.value,
          ),
        ),

        const SizedBox(height: 20),

        AppTextSemiBold(
          text: "Password",
          color: navyBlueColor,
          fontSize: 13,
          fontFamily: FontFamily.inter,
        ),
        const SizedBox(height: 6),
        Obx(
          () => AppTextField(
            textController: controller.passwordController,
            placeholder: "••••••••",
            obscureText: controller.isPasswordHidden.value,
            submitLabel: TextInputAction.done,
            prefixIcon: AppSvg(
              assetPath: lock,
              height: 10,
              width: 10,
              fit: BoxFit.scaleDown,
            ),
            suffixIcon: AppIconButton(
              icon: controller.isPasswordHidden.value
                  ? Icons.visibility_off
                  : Icons.visibility,
              onPressed: () => controller.isPasswordHidden.toggle(),
            ),
            onChanged: (_) => controller.passwordError.value = '',
            onFieldSubmitted: (_) => controller.login(),
            isError: controller.passwordError.value.isNotEmpty,
            errorText: controller.passwordError.value,
          ),
        ),

        const SizedBox(height: 10),

        SizedBox(
          width: double.infinity,
          child: Align(
            alignment: Alignment.centerRight,
            child: AppTextButton(
              btnText: "Forgot Password?",
              txtSize: 13,
              onPressed: () => controller.goToForgotPassword(),
            ),
          ),
        ),

        const SizedBox(height: 24),

        SizedBox(
          width: double.infinity,
          child: Obx(
            () => AppButton(
              txt: controller.isLoading.value ? "Signing in..." : "Sign In  →",
              padding: const EdgeInsets.symmetric(vertical: 15),
              onPress: controller.isLoading.value
                  ? null
                  : () => controller.login(),
              alignment: Alignment.center,
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
      ],
    );
  }
}
