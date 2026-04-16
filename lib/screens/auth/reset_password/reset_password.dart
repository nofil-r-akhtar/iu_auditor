import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iu_auditor/app_theme/colors.dart';
import 'package:iu_auditor/components/app_button.dart';
import 'package:iu_auditor/components/app_icon_button.dart';
import 'package:iu_auditor/components/app_image.dart';
import 'package:iu_auditor/components/app_svg.dart';
import 'package:iu_auditor/components/app_text.dart';
import 'package:iu_auditor/components/app_text_field.dart';
import 'package:iu_auditor/const/assets.dart';
import 'package:iu_auditor/const/enums.dart';
import 'package:iu_auditor/screens/auth/reset_password/reset_password_controller.dart';

class ResetPassword extends StatelessWidget {
  final String email;
  final String otp;
  const ResetPassword({required this.email, required this.otp, super.key});

  @override
  Widget build(BuildContext context) {
    // Ensuring the controller is initialized with the required parameters
    final ResetPasswordController controller = Get.put(
      ResetPasswordController(email: email, otp: otp),
    );

    return Scaffold(
      backgroundColor: bgColor,
      // The AppBar is removed to match the branding panel style,
      // but you can add a back button inside the branding panel if needed.
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
  final ResetPasswordController controller;
  const _MobileLayout({required this.controller});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const ClampingScrollPhysics(),
      child: Column(
        children: [
          // Blue branding panel (identical to login)
          const _BrandingPanel(),

          // White card overlapping the blue panel
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
                        text: "Reset Your Password",
                        color: navyBlueColor,
                        fontSize: 22,
                        fontFamily: FontFamily.inter,
                      ),
                      const SizedBox(height: 4),
                      AppTextRegular(
                        text:
                            "Please enter your new password and confirm it to continue.",
                        color: descriptiveColor,
                        fontSize: 13,
                      ),
                      const SizedBox(height: 24),
                      _ResetPasswordForm(controller: controller),
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
// SHARED BRANDING PANEL
// ─────────────────────────────────────────
class _BrandingPanel extends StatelessWidget {
  const _BrandingPanel();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(top: 60, bottom: 60),
      color: const Color.fromARGB(255, 43, 87, 151),
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
// SHARED FORM
// ─────────────────────────────────────────
class _ResetPasswordForm extends StatelessWidget {
  final ResetPasswordController controller;
  const _ResetPasswordForm({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const AppTextSemiBold(text: "New Password", fontSize: 13),
        const SizedBox(height: 6),
        Obx(
          () => AppTextField(
            textController: controller.newPasswordController,
            obscureText: controller.isNewPasswordHidden.value,
            prefixIcon: AppSvg(
              assetPath: lock,
              height: 10,
              width: 10,
              fit: BoxFit.scaleDown,
            ),
            suffixIcon: AppIconButton(
              icon: controller.isNewPasswordHidden.value
                  ? Icons.visibility_off
                  : Icons.visibility,
              onPressed: () => controller.isNewPasswordHidden.toggle(),
            ),
            placeholder: "••••••••",
            isError: controller.newPasswordError.value.isNotEmpty,
            errorText: controller.newPasswordError.value,
          ),
        ),
        const SizedBox(height: 20),
        const AppTextSemiBold(text: "Confirm New Password", fontSize: 13),
        const SizedBox(height: 6),
        Obx(
          () => AppTextField(
            textController: controller.confirmNewPasswordController,
            obscureText: controller.isConfirmNewPasswordHidden.value,
            prefixIcon: AppSvg(
              assetPath: lock,
              height: 10,
              width: 10,
              fit: BoxFit.scaleDown,
            ),
            suffixIcon: AppIconButton(
              icon: controller.isConfirmNewPasswordHidden.value
                  ? Icons.visibility_off
                  : Icons.visibility,
              onPressed: () => controller.isConfirmNewPasswordHidden.toggle(),
            ),
            placeholder: "••••••••",
            isError: controller.confirmPasswordError.value.isNotEmpty,
            errorText: controller.confirmPasswordError.value,
          ),
        ),
        const SizedBox(height: 30),
        SizedBox(
          width: double.infinity,
          child: Obx(
            () => AppButton(
              txt: controller.isLoading.value ? "Processing..." : "Next  →",
              padding: const EdgeInsets.symmetric(vertical: 15),
              onPress: controller.isLoading.value
                  ? null
                  : () => controller.resetPassword(),
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
// DESKTOP LAYOUT (Fallback)
// ─────────────────────────────────────────
class _DesktopLayout extends StatelessWidget {
  final ResetPasswordController controller;
  const _DesktopLayout({required this.controller});

  @override
  Widget build(BuildContext context) {
    // You can implement a two-pane layout here similar to login.dart
    // For now, centering the mobile form for consistency
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 450),
        child: Card(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Padding(
            padding: const EdgeInsets.all(40),
            child: _ResetPasswordForm(controller: controller),
          ),
        ),
      ),
    );
  }
}
