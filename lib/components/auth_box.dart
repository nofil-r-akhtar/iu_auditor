import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iu_auditor/app_theme/colors.dart';
import 'package:iu_auditor/components/app_button.dart';
import 'package:iu_auditor/components/app_container.dart';
import 'package:iu_auditor/components/app_image.dart';
import 'package:iu_auditor/components/app_text.dart';
import 'package:iu_auditor/components/app_text_button.dart';
import 'package:iu_auditor/const/assets.dart';
import 'package:iu_auditor/const/enums.dart';

class AuthBox extends StatelessWidget {
  final AuthScreen isFrom;
  final String? headerTxt;
  final String? descriptionTxt;
  final Widget? components;
  final VoidCallback? onPress;
  final VoidCallback? onResend;
  final RxBool? resendEnabled;
  final RxInt? secondsRemaining;

  // FIX: isLoading added so all auth screens (forgot password, OTP, reset
  // password) can disable the button during an API call, preventing
  // duplicate submissions.
  final RxBool? isLoading;

  const AuthBox({
    this.isFrom = AuthScreen.forgotPassword,
    this.headerTxt,
    this.descriptionTxt,
    this.components,
    this.onPress,
    this.onResend,
    this.resendEnabled,
    this.secondsRemaining,
    this.isLoading,
    super.key,
  });

  String get _buttonLabel {
    switch (isFrom) {
      case AuthScreen.forgotPassword:
      case AuthScreen.resetPassword:
        return 'Next';
      case AuthScreen.otp:
        return 'Verify';
      case AuthScreen.login:
        return 'Sign in';
    }
  }

  String get _loadingLabel {
    switch (isFrom) {
      case AuthScreen.forgotPassword:
        return 'Sending...';
      case AuthScreen.resetPassword:
        return 'Resetting...';
      case AuthScreen.otp:
        return 'Verifying...';
      case AuthScreen.login:
        return 'Signing in...';
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        double screenWidth = constraints.maxWidth;
        double boxWidth;

        if (screenWidth < 600) {
          boxWidth = screenWidth * 0.9;
        } else if (screenWidth < 1024) {
          boxWidth = 500;
        } else {
          boxWidth = 450;
        }

        return Center(
          child: AppContainer(
            bgColor: whiteColor,
            width: boxWidth,
            borderRadius: BorderRadius.circular(12),
            child: Padding(
              padding: const EdgeInsets.all(32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Logo
                  Center(
                    child: AppAssetImage(
                      imagePath: logo,
                      height: 80,
                      fit: BoxFit.contain,
                    ),
                  ),

                  const SizedBox(height: 40),

                  AppTextBold(text: headerTxt ?? ''),
                  const SizedBox(height: 8),
                  AppTextRegular(text: descriptionTxt ?? ''),
                  const SizedBox(height: 30),

                  if (components != null) components!,

                  const SizedBox(height: 30),

                  // FIX: button is wrapped in Obx so it reacts to isLoading.
                  // When loading: shows a progress label and onPress is null
                  // (AppButton renders visually disabled when onPress is null).
                  Obx(() {
                    final loading = isLoading?.value ?? false;
                    return AppButton(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      txt: loading ? _loadingLabel : _buttonLabel,
                      onPress: loading ? null : onPress,
                      alignment: Alignment.center,
                    );
                  }),

                  // Resend row — only shown on OTP screen
                  if (isFrom == AuthScreen.otp) ...[
                    const SizedBox(height: 5),
                    Center(
                      child: Obx(() {
                        final enabled = resendEnabled?.value ?? false;
                        final seconds = secondsRemaining?.value ?? 0;
                        return AppTextButton(
                          btnText: enabled
                              ? 'Resend OTP'
                              : 'Resend OTP in ${seconds}s',
                          txtSize: 12,
                          onPressed: enabled ? onResend : null,
                        );
                      }),
                    ),
                  ],
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
