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
 final Auth isFrom;
  final String? headerTxt;
  final String? descriptionTxt;
  final Widget? components;
  final VoidCallback? onPress;
  final VoidCallback? onResend;                  // <-- new
  final RxBool? resendEnabled;                   // <-- new
  final RxInt? secondsRemaining; 
  const AuthBox({
    this.isFrom = Auth.forgotPassword,
    this.headerTxt,
    this.descriptionTxt,
    this.components,
    this.onPress,
    this.onResend,
    this.resendEnabled,
    this.secondsRemaining,
    super.key});

  @override
  Widget build(BuildContext context) {

    return LayoutBuilder(builder: (context, constraints) {
        double screenWidth = constraints.maxWidth;

        double boxWidth;
        if (screenWidth < 600) {
          
          boxWidth = screenWidth * 0.9;
        } else if (screenWidth < 1024) {
          // 📲 Tablet
          boxWidth = 500;
        } else {
          // 🖥 Desktop
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
                  /// Logo
                  Center(
                    child: AppAssetImage(
                      imagePath: logo,
                      height: 80,
                      fit: BoxFit.contain,
                    ),
                  ),
            
                  const SizedBox(height: 40),
            
                  /// Header
                  AppTextBold(text: headerTxt ?? ""),
            
                  const SizedBox(height: 8),
            
                  /// Description
                  AppTextRegular(text: descriptionTxt ?? ""),
            
                  const SizedBox(height: 30),
            
                  /// Custom Components
                  if (components != null) components!,
            
                  const SizedBox(height: 30),
            
                  /// Button
                  AppButton(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    txt: isFrom == Auth.forgotPassword || isFrom == Auth.resetPassword ? "Next" : isFrom == Auth.otp ? "Verify" : "Sign in",
                    onPress: onPress,
                    alignment: Alignment.center,
                  ),
                  Visibility(
                    visible: isFrom == Auth.otp,
                    child: SizedBox(height: 5)),
                  Visibility(
                    visible: isFrom == Auth.otp,
                    child: Center(child: Obx(() {
                      final enabled = resendEnabled?.value ?? false;
                      final seconds = secondsRemaining?.value ?? 0;
                      return AppTextButton(
                        btnText: enabled ? "Resend OTP" : "Resend OTP in ${seconds}s",
                        txtSize: 12,
                        // pass null when disabled so it looks greyed out
                        onPressed: enabled ? onResend : null,
                      );
                    }),))
                ],
              ),
            ),
          ),
        );
        });
        
  }
}