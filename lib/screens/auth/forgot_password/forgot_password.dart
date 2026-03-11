import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iu_auditor/app_theme/colors.dart';
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
            isFrom: AuthScreen.forgotPassword,
            headerTxt: "Forgot Your Password?",
            descriptionTxt:
                "Enter your registered email address and we'll send you a link to reset your password.",
            onPress: () => controller.forgotPassword(),
            // FIX: pass isLoading so the button disables during the API call
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
    );
  }
}
