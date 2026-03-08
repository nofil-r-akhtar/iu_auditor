import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iu_auditor/components/app_otp_field.dart';
import 'package:iu_auditor/components/auth_box.dart';
import 'package:iu_auditor/const/enums.dart';
import 'package:iu_auditor/screens/auth/otp/otp_controller.dart';

class OtpView extends StatelessWidget {
  final String email;
  const OtpView({required this.email, super.key});

  @override
  Widget build(BuildContext context) {
    final OtpController controller = Get.put(
      OtpController(email: email),
    ); // pass email to controller

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
            isFrom: AuthScreen.otp,
            headerTxt: "OTP Verification",
            descriptionTxt:
                "Please enter the verification code sent to your registered email to continue.",
            onPress: () => controller.verifyOtp(),
            onResend: () => controller.resendOtp(), // <-- resend callback
            resendEnabled: controller.isResendEnabled, // <-- reactive bool
            secondsRemaining: controller.secondsRemaining, // <-- countdown
            components: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 40),
                Obx(
                  () => Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppOtpField(
                        controller: controller.otpController,
                        onChanged: (_) => controller.otpError.value = '',
                      ),
                      if (controller.otpError.value.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(top: 6, left: 4),
                          child: Text(
                            controller.otpError.value,
                            style: const TextStyle(
                              color: Colors.red,
                              fontSize: 11,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                const SizedBox(height: 80),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
