import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iu_auditor/app_theme/colors.dart';
import 'package:iu_auditor/components/app_button.dart';
import 'package:iu_auditor/components/app_container.dart';
import 'package:iu_auditor/components/app_image.dart';
import 'package:iu_auditor/components/app_otp_field.dart';
import 'package:iu_auditor/components/app_text.dart';
import 'package:iu_auditor/components/app_text_button.dart';
import 'package:iu_auditor/const/assets.dart';
import 'package:iu_auditor/const/enums.dart';
import 'package:iu_auditor/screens/auth/otp/otp_controller.dart';

class OtpView extends StatelessWidget {
  final String email;
  const OtpView({required this.email, super.key});

  @override
  Widget build(BuildContext context) {
    Get.delete<OtpController>(force: true);
    final OtpController controller = Get.put(OtpController(email: email));

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
// MOBILE — Clean & Minimalist Card
// ─────────────────────────────────────────
class _MobileLayout extends StatelessWidget {
  final OtpController controller;
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
                        text: "OTP Verification",
                        color: navyBlueColor,
                        fontSize: 22,
                        fontFamily: FontFamily.inter,
                      ),
                      const SizedBox(height: 8),
                      AppTextRegular(
                        text: "Enter the code sent to your email to continue.",
                        color: descriptiveColor,
                        fontSize: 13,
                      ),
                      const SizedBox(height: 24),
                      // Passing isDesktop: false for mobile styling
                      _OtpForm(controller: controller, isDesktop: false),
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
// DESKTOP — High Contrast Pro Layout
// ─────────────────────────────────────────
class _DesktopLayout extends StatelessWidget {
  final OtpController controller;
  const _DesktopLayout({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Left Panel (Branding)
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
                Padding(
                  padding: const EdgeInsets.all(52),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          IconButton(
                            onPressed: () => Navigator.pop(context),
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
                        text: "Identity\nVerification",
                        color: whiteColor,
                        fontSize: 44,
                        fontFamily: FontFamily.inter,
                      ),
                      const SizedBox(height: 16),
                      AppTextRegular(
                        text:
                            "We've sent a 6-digit code to your email.\nPlease check your inbox to verify your identity.",
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
                            text: "Authorized Access Only",
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

        // Right Panel (OTP Form)
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
                      text: "Verify Your Email",
                      color: navyBlueColor,
                      fontSize: 28,
                      fontFamily: FontFamily.inter,
                    ),
                    const SizedBox(height: 6),
                    AppTextRegular(
                      text:
                          "Please enter the code sent to your registered account.",
                      color: descriptiveColor,
                      fontSize: 14,
                    ),
                    const SizedBox(height: 36),

                    // Passing isDesktop: true for darker box styling
                    _OtpForm(controller: controller, isDesktop: true),

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
// MOBILE BRANDING PANEL
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
                    text: "Secure Verification",
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
// SHARED FORM — Smart Adaptive Styling
// ─────────────────────────────────────────
class _OtpForm extends StatelessWidget {
  final OtpController controller;
  final bool isDesktop;
  const _OtpForm({required this.controller, required this.isDesktop});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Obx(
          () => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // This container conditionally applies styling only if on Desktop
              Container(
                width: double.infinity,
                padding: isDesktop
                    ? const EdgeInsets.symmetric(vertical: 24, horizontal: 16)
                    : EdgeInsets.zero,
                decoration: isDesktop
                    ? BoxDecoration(
                        color: const Color(0xFFF1F5F9),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: const Color(0xFFCBD5E1),
                          width: 1.5,
                        ),
                      )
                    : null,
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 320),
                    child: SizedBox(
                      height:
                          60, // Fixed height keeps the boxes from collapsing on Web
                      child: AppOtpField(
                        controller: controller.otpController,
                        onChanged: (_) => controller.otpError.value = '',
                      ),
                    ),
                  ),
                ),
              ),
              if (controller.otpError.value.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 12, left: 4),
                  child: AppTextRegular(
                    text: controller.otpError.value,
                    color: Colors.red,
                    fontSize: 12,
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        Align(
          alignment: Alignment.centerRight,
          child: Obx(() {
            if (controller.isResendEnabled.value) {
              return AppTextButton(
                btnText: "Resend OTP",
                txtSize: 13,
                onPressed: () => controller.resendOtp(),
              );
            } else {
              return AppTextRegular(
                text: "Resend in ${controller.secondsRemaining.value}s",
                color: iconColor,
                fontSize: 13,
              );
            }
          }),
        ),
        const SizedBox(height: 24),
        SizedBox(
          width: double.infinity,
          child: Obx(
            () => AppButton(
              txt: controller.isLoading.value
                  ? "Verifying..."
                  : "Verify & Continue  →",
              padding: const EdgeInsets.symmetric(vertical: 15),
              onPress: controller.isLoading.value
                  ? null
                  : () => controller.verifyOtp(),
              alignment: Alignment.center,
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
      ],
    );
  }
}
