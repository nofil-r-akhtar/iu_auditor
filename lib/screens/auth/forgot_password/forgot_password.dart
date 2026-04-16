import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iu_auditor/app_theme/colors.dart';
import 'package:iu_auditor/components/app_button.dart';
import 'package:iu_auditor/components/app_image.dart';
import 'package:iu_auditor/components/app_svg.dart';
import 'package:iu_auditor/components/app_text.dart';
import 'package:iu_auditor/components/app_text_field.dart';
import 'package:iu_auditor/components/auth_box.dart';
import 'package:iu_auditor/const/assets.dart';
import 'package:iu_auditor/const/enums.dart';
import 'package:iu_auditor/screens/auth/forgot_password/forgot_password_controller.dart';

class ForgotPassword extends StatelessWidget {
  const ForgotPassword({super.key});

  @override
  Widget build(BuildContext context) {
    // Delete any stale instance before creating a fresh one,
    // same pattern as OtpView — prevents conflict on back + re-entry.
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
// MOBILE — top blue branding panel + overlapping white card
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
          // ── Blue branding panel ──
          const _MobileBrandingPanel(),

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
                onPressed: () => Navigator.pop(context),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 40, bottom: 60),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Icon badge
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

                  // University logo / wordmark image
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
                    text: "Sign in to view and conduct faculty audits",
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
// MOBILE FORM CONTENT
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
              txt: controller.isLoading.value ? "Please wait..." : "Next  →",
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

// ─────────────────────────────────────────
// DESKTOP / TABLET — Original Centered Layout
// ─────────────────────────────────────────
class _DesktopLayout extends StatelessWidget {
  final ForgotPasswordController controller;
  const _DesktopLayout({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Align(
          alignment: Alignment.topLeft,
          child: SafeArea(
            child: IconButton(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.arrow_back),
            ),
          ),
        ),
        Expanded(
          child: Center(
            child: AuthBox(
              isFrom: AuthScreen.forgotPassword,
              headerTxt: "Forgot Your Password?",
              descriptionTxt:
                  "Enter your registered email address and we'll send you a link to reset your password.",
              onPress: () => controller.forgotPassword(),
              isLoading: controller.isLoading,
              components: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 10),
                  const AppTextSemiBold(text: "Email"),
                  const SizedBox(height: 3),
                  Obx(
                    () => AppTextField(
                      textController: controller.emailController,
                      prefixIcon: AppSvg(
                        assetPath: user,
                        height: 10,
                        width: 10,
                        fit: BoxFit.scaleDown,
                      ),
                      placeholder: "admin@iqra.edu.pk",
                      placeholderColor: hintTextColor,
                      isError: controller.emailError.value.isNotEmpty,
                      errorText: controller.emailError.value,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
