import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iu_auditor/app_theme/colors.dart';
import 'package:iu_auditor/components/app_button.dart';
import 'package:iu_auditor/components/app_container.dart';
import 'package:iu_auditor/components/app_image.dart';
import 'package:iu_auditor/components/app_svg.dart';
import 'package:iu_auditor/components/app_text.dart';
import 'package:iu_auditor/components/app_text_field.dart';
import 'package:iu_auditor/const/assets.dart';
import 'package:iu_auditor/const/enums.dart';
import 'package:iu_auditor/screens/auth/forgot_password/forgot_password_controller.dart';

class ForgotPassword extends StatelessWidget {
  const ForgotPassword({super.key});

  @override
  Widget build(BuildContext context) {
    Get.delete<ForgotPasswordController>(force: true);
    final ForgotPasswordController controller = Get.put(
      ForgotPasswordController(),
    );

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
// MOBILE — Branding Panel + Overlapping Card
// ─────────────────────────────────────────
class _MobileLayout extends StatelessWidget {
  final ForgotPasswordController controller;
  const _MobileLayout({required this.controller});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const ClampingScrollPhysics(),
      child: Column(
        children: [
          const _MobileBrandingPanel(),
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
                        text: "Forget Your Password?",
                        color: navyBlueColor,
                        fontSize: 22,
                        fontFamily: FontFamily.inter,
                      ),
                      const SizedBox(height: 8),
                      AppTextRegular(
                        text:
                            "Enter your registered email address and we'll send you a link to reset your password.",
                        color: descriptiveColor,
                        fontSize: 13,
                      ),
                      const SizedBox(height: 24),
                      _ForgotPasswordForm(controller: controller),
                    ],
                  ),
                ),
              ),
            ),
          ),
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
// DESKTOP — Two-panel Layout Matching Login
// ─────────────────────────────────────────
class _DesktopLayout extends StatelessWidget {
  final ForgotPasswordController controller;
  const _DesktopLayout({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // ── Left Panel (Branding) ──
        Expanded(
          flex: 5,
          child: AppContainer(
            bgColor: navyBlueColor,
            child: Stack(
              children: [
                // Decorative circles
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
                // Content
                Padding(
                  padding: const EdgeInsets.all(52),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Back Button & Logo Row
                      Row(
                        children: [
                          IconButton(
                            onPressed: () => Get.back(),
                            icon: const Icon(
                              Icons.arrow_back,
                              color: whiteColor,
                              size: 24,
                            ),
                          ),
                          const SizedBox(width: 12),
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
                        text: "Recover\nAccount",
                        color: whiteColor,
                        fontSize: 44,
                        fontFamily: FontFamily.inter,
                      ),
                      const SizedBox(height: 16),
                      AppTextRegular(
                        text:
                            "Follow the steps to securely verify your identity\nand regain access to the portal.",
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
                            text: "Iqra University Security Protocol",
                            color: whiteColor.withValues(alpha: 0.4),
                            fontSize: 12,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),

        // ── Right Panel (Form) ──
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
                      text: "Forgot Password?",
                      color: navyBlueColor,
                      fontSize: 28,
                      fontFamily: FontFamily.inter,
                    ),
                    const SizedBox(height: 6),
                    AppTextRegular(
                      text:
                          "Enter your email to receive a password reset link.",
                      color: descriptiveColor,
                      fontSize: 14,
                    ),
                    const SizedBox(height: 36),
                    _ForgotPasswordForm(controller: controller),
                    const SizedBox(height: 32),
                    const Divider(color: Color(0xFFE2E8F0)),
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
// SHARED MOBILE BRANDING
// ─────────────────────────────────────────
class _MobileBrandingPanel extends StatelessWidget {
  const _MobileBrandingPanel();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: const Color.fromARGB(255, 43, 87, 151),
      child: SafeArea(
        bottom: false,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Positioned(
              top: 0,
              left: 8,
              child: IconButton(
                icon: const Icon(Icons.arrow_back, color: whiteColor),
                onPressed: () => Get.back(),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 40, bottom: 60),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(
                        255,
                        59,
                        122,
                        216,
                      ).withValues(alpha: 0.25),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Icon(
                      Icons.school_rounded,
                      color: whiteColor,
                      size: 30,
                    ),
                  ),
                  const SizedBox(height: 20),
                  AppAssetImage(
                    imagePath: logo,
                    height: 44,
                    fit: BoxFit.contain,
                  ),
                  const SizedBox(height: 14),
                  AppTextBold(
                    text: "Auditor Portal",
                    color: whiteColor,
                    fontSize: 22,
                    fontFamily: FontFamily.inter,
                  ),
                  const SizedBox(height: 6),
                  AppTextRegular(
                    text: "Account Recovery",
                    color: whiteColor.withValues(alpha: 0.65),
                    fontSize: 13,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────
// SHARED FORM
// ─────────────────────────────────────────
class _ForgotPasswordForm extends StatelessWidget {
  final ForgotPasswordController controller;
  const _ForgotPasswordForm({required this.controller});

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
            submitLabel: TextInputAction.done,
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
        const SizedBox(height: 24),
        SizedBox(
          width: double.infinity,
          child: Obx(
            () => AppButton(
              txt: controller.isLoading.value ? "Processing..." : "Next  →",
              padding: const EdgeInsets.symmetric(vertical: 15),
              onPress: controller.isLoading.value
                  ? null
                  : () => controller.forgotPassword(),
              alignment: Alignment.center,
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
      ],
    );
  }
}
