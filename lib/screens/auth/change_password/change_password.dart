import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iu_auditor/app_theme/colors.dart';
import 'package:iu_auditor/components/app_button.dart';
import 'package:iu_auditor/components/app_container.dart';
import 'package:iu_auditor/components/app_icon_button.dart';
import 'package:iu_auditor/components/app_image.dart';
import 'package:iu_auditor/components/app_svg.dart';
import 'package:iu_auditor/components/app_text.dart';
import 'package:iu_auditor/components/app_text_field.dart';
import 'package:iu_auditor/const/assets.dart';
import 'package:iu_auditor/const/enums.dart';
import 'change_password_controller.dart';

class ChangePasswordScreen extends StatelessWidget {
  final String email;
  final String oldPassword;
  const ChangePasswordScreen({
    required this.email,
    required this.oldPassword,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ChangePasswordController(
      email: email,
      oldPassword: oldPassword,
    ));

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

// ── Mobile ────────────────────────────────────────────────────
class _MobileLayout extends StatelessWidget {
  final ChangePasswordController controller;
  const _MobileLayout({required this.controller});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const ClampingScrollPhysics(),
      child: Column(
        children: [
          _BrandingPanel(),
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
                        text: 'Set Your Password',
                        color: navyBlueColor,
                        fontSize: 22,
                        fontFamily: FontFamily.inter,
                      ),
                      const SizedBox(height: 4),
                      AppTextRegular(
                        text: 'Please set a new password to continue.',
                        color: descriptiveColor,
                        fontSize: 13,
                      ),
                      const SizedBox(height: 24),
                      _ChangePasswordForm(controller: controller),
                    ],
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 28),
        ],
      ),
    );
  }
}

// ── Desktop ───────────────────────────────────────────────────
class _DesktopLayout extends StatelessWidget {
  final ChangePasswordController controller;
  const _DesktopLayout({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Left branding panel
        Expanded(
          flex: 5,
          child: AppContainer(
            bgColor: navyBlueColor,
            child: Stack(
              children: [
                Positioned(
                  top: -60, left: -60,
                  child: AppContainer(
                    width: 300, height: 300, shape: BoxShape.circle,
                    bgColor: primaryColor.withValues(alpha: 0.15),
                  ),
                ),
                Positioned(
                  bottom: -80, right: -80,
                  child: AppContainer(
                    width: 380, height: 380, shape: BoxShape.circle,
                    bgColor: primaryColor.withValues(alpha: 0.1),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(52),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(children: [
                        AppContainer(
                          bgColor: primaryColor,
                          borderRadius: BorderRadius.circular(12),
                          padding: const EdgeInsets.all(10),
                          child: const Icon(Icons.school_rounded,
                              color: whiteColor, size: 22),
                        ),
                        const SizedBox(width: 12),
                        AppTextBold(text: 'IU Auditor',
                            color: whiteColor, fontSize: 18,
                            fontFamily: FontFamily.inter),
                      ]),
                      const Spacer(),
                      AppAssetImage(
                          imagePath: logo, height: 52, fit: BoxFit.contain),
                      const SizedBox(height: 28),
                      AppTextBold(
                        text: 'Welcome\nAboard!',
                        color: whiteColor,
                        fontSize: 44,
                        fontFamily: FontFamily.inter,
                      ),
                      const SizedBox(height: 16),
                      AppTextRegular(
                        text:
                            'This is your first login.\nPlease set a secure password\nto protect your account.',
                        color: whiteColor.withValues(alpha: 0.6),
                        fontSize: 14,
                      ),
                      const Spacer(),
                      Row(children: [
                        AppContainer(
                          width: 32, height: 2, bgColor: primaryColor,
                          borderRadius: BorderRadius.circular(2),
                        ),
                        const SizedBox(width: 10),
                        AppTextRegular(
                          text: 'One-time password setup',
                          color: whiteColor.withValues(alpha: 0.4),
                          fontSize: 12,
                        ),
                      ]),
                      const SizedBox(height: 32),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        // Right form panel
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
                      text: 'Set Your Password',
                      color: navyBlueColor,
                      fontSize: 28,
                      fontFamily: FontFamily.inter,
                    ),
                    const SizedBox(height: 6),
                    AppTextRegular(
                      text: 'Choose a strong password for your account.',
                      color: descriptiveColor,
                      fontSize: 14,
                    ),
                    const SizedBox(height: 12),
                    // First login info banner
                    AppContainer(
                      bgColor: const Color(0xFFEFF6FF),
                      borderRadius: BorderRadius.circular(10),
                      padding: const EdgeInsets.all(14),
                      child: Row(children: [
                        const Icon(Icons.info_outline,
                            color: primaryColor, size: 18),
                        const SizedBox(width: 10),
                        Expanded(
                          child: AppTextRegular(
                            text:
                                'Your admin has set a temporary password. Please create a new one to continue.',
                            color: primaryColor,
                            fontSize: 12,
                          ),
                        ),
                      ]),
                    ),
                    const SizedBox(height: 28),
                    _ChangePasswordForm(controller: controller),
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

// ── Branding Panel (Mobile) ───────────────────────────────────
class _BrandingPanel extends StatelessWidget {
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
            width: 60, height: 60,
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 59, 122, 216)
                  .withValues(alpha: 0.25),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Icon(Icons.lock_reset_rounded,
                color: whiteColor, size: 30),
          ),
          const SizedBox(height: 20),
          AppAssetImage(imagePath: logo, height: 44, fit: BoxFit.contain),
          const SizedBox(height: 14),
          AppTextBold(text: 'Auditor Portal', color: whiteColor,
              fontSize: 22, fontFamily: FontFamily.inter),
          const SizedBox(height: 6),
          AppTextRegular(
            text: 'Set up your new password',
            color: whiteColor.withValues(alpha: 0.65),
            fontSize: 13,
          ),
        ],
      ),
    );
  }
}

// ── Form ──────────────────────────────────────────────────────
class _ChangePasswordForm extends StatelessWidget {
  final ChangePasswordController controller;
  const _ChangePasswordForm({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppTextSemiBold(text: 'New Password',
            color: navyBlueColor, fontSize: 13, fontFamily: FontFamily.inter),
        const SizedBox(height: 6),
        Obx(() => AppTextField(
          textController: controller.newPasswordController,
          placeholder: '••••••••',
          obscureText: controller.isNewPasswordHidden.value,
          prefixIcon: AppSvg(assetPath: lock, height: 10, width: 10,
              fit: BoxFit.scaleDown),
          suffixIcon: AppIconButton(
            icon: controller.isNewPasswordHidden.value
                ? Icons.visibility_off : Icons.visibility,
            onPressed: () => controller.isNewPasswordHidden.toggle(),
          ),
          onChanged: (_) => controller.newPasswordError.value = '',
          isError: controller.newPasswordError.value.isNotEmpty,
          errorText: controller.newPasswordError.value,
        )),
        const SizedBox(height: 20),
        AppTextSemiBold(text: 'Confirm Password',
            color: navyBlueColor, fontSize: 13, fontFamily: FontFamily.inter),
        const SizedBox(height: 6),
        Obx(() => AppTextField(
          textController: controller.confirmPasswordController,
          placeholder: '••••••••',
          obscureText: controller.isConfirmPasswordHidden.value,
          prefixIcon: AppSvg(assetPath: lock, height: 10, width: 10,
              fit: BoxFit.scaleDown),
          suffixIcon: AppIconButton(
            icon: controller.isConfirmPasswordHidden.value
                ? Icons.visibility_off : Icons.visibility,
            onPressed: () => controller.isConfirmPasswordHidden.toggle(),
          ),
          onChanged: (_) => controller.confirmPasswordError.value = '',
          isError: controller.confirmPasswordError.value.isNotEmpty,
          errorText: controller.confirmPasswordError.value,
        )),
        const SizedBox(height: 30),
        SizedBox(
          width: double.infinity,
          child: Obx(() => AppButton(
            txt: controller.isLoading.value
                ? 'Saving...' : 'Set Password  →',
            padding: const EdgeInsets.symmetric(vertical: 15),
            onPress: controller.isLoading.value
                ? null : () => controller.changePassword(),
            alignment: Alignment.center,
            borderRadius: BorderRadius.circular(10),
          )),
        ),
      ],
    );
  }
}