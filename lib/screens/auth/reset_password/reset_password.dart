import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iu_auditor/app_theme/colors.dart';
import 'package:iu_auditor/components/app_icon_button.dart';
import 'package:iu_auditor/components/app_svg.dart';
import 'package:iu_auditor/components/app_text.dart';
import 'package:iu_auditor/components/app_text_field.dart';
import 'package:iu_auditor/components/auth_box.dart';
import 'package:iu_auditor/const/assets.dart';
import 'package:iu_auditor/const/enums.dart';
import 'package:iu_auditor/screens/auth/reset_password/reset_password_controller.dart';

class ResetPassword extends StatelessWidget {
  final String email;
  final String otp;
  const ResetPassword({required this.email, required this.otp, super.key});

  @override
  Widget build(BuildContext context) {
    final ResetPasswordController controller = Get.put(
      ResetPasswordController(email: email, otp: otp),
    ); // <-- pass otp

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back),
        ),
      ),
      body: SafeArea(
        child: Center(
          child: AuthBox(
            headerTxt: "Reset your Password",
            descriptionTxt:
                "Please enter your new password and confirm it to continue.",
            isFrom: AuthScreen.resetPassword,
            onPress: () => controller.resetPassword(), // <-- hook up button
            components: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 10),
                const AppTextSemiBold(text: "New Password"),
                const SizedBox(height: 3),
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
                    placeholderColor: hintTextColor,
                    isError: controller.newPasswordError.value.isNotEmpty,
                    errorText: controller.newPasswordError.value,
                  ),
                ),
                const SizedBox(height: 25),
                const AppTextSemiBold(text: "Confirm New Password"),
                const SizedBox(height: 3),
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
                      onPressed: () =>
                          controller.isConfirmNewPasswordHidden.toggle(),
                    ),
                    placeholder: "••••••••",
                    placeholderColor: hintTextColor,
                    isError: controller.confirmPasswordError.value.isNotEmpty,
                    errorText: controller.confirmPasswordError.value,
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
