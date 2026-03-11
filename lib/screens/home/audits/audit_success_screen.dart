import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iu_auditor/app_theme/colors.dart';
import 'package:iu_auditor/components/app_button.dart';
import 'package:iu_auditor/components/app_container.dart';
import 'package:iu_auditor/components/app_text.dart';
import 'package:iu_auditor/screens/home/audits/audit_form/audit_form_controller.dart';
import 'package:iu_auditor/screens/home/home_controller.dart';
import 'package:iu_auditor/const/enums.dart';

class AuditSuccessScreen extends StatelessWidget {
  final AuditFormController controller;
  const AuditSuccessScreen({required this.controller, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF10B981),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(40),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 520),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // ── Check circle ──
                AppContainer(
                  width: 100,
                  height: 100,
                  shape: BoxShape.circle,
                  bgColor: whiteColor.withValues(alpha: 0.2),
                  alignment: Alignment.center,
                  child: AppContainer(
                    width: 72,
                    height: 72,
                    shape: BoxShape.circle,
                    bgColor: whiteColor.withValues(alpha: 0.3),
                    alignment: Alignment.center,
                    child: const Icon(
                      Icons.check_rounded,
                      color: whiteColor,
                      size: 38,
                    ),
                  ),
                ),

                const SizedBox(height: 28),

                AppTextBold(
                  text: "Audit Submitted!",
                  color: whiteColor,
                  fontSize: 28,
                  fontFamily: FontFamily.inter,
                ),

                const SizedBox(height: 10),

                AppTextRegular(
                  text:
                      "Your feedback for ${controller.teacherName} has been\nsuccessfully recorded.",
                  color: whiteColor.withValues(alpha: 0.85),
                  fontSize: 15,
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 36),

                // ── Summary card ──
                AppContainer(
                  bgColor: whiteColor.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(16),
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: _SummaryField(
                              label: "Teacher",
                              value: controller.teacherName,
                            ),
                          ),
                          Expanded(
                            child: _SummaryField(
                              label: "Department",
                              value: controller.department,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Row(
                        children: [
                          Expanded(
                            child: _SummaryField(
                              label: "Questions",
                              value: "${controller.totalQuestions} Answered",
                            ),
                          ),
                          Expanded(
                            child: _SummaryField(
                              label: "Avg. Rating",
                              value:
                                  "${controller.averageRating.toStringAsFixed(1)} / 5",
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 28),

                // ── Audit Another Teacher ──
                AppButton(
                  txt: "  Audit Another Teacher",
                  icon: const Icon(
                    Icons.assignment_outlined,
                    color: Color(0xFF10B981),
                    size: 20,
                  ),
                  bgColor: whiteColor,
                  txtColor: const Color(0xFF10B981),
                  padding: const EdgeInsets.symmetric(
                    vertical: 14,
                    horizontal: 24,
                  ),
                  borderRadius: BorderRadius.circular(12),
                  alignment: Alignment.center,
                  onPress: () => _navigateTo(tabIndex: 1),
                ),

                const SizedBox(height: 12),

                // ── Back to Home ──
                AppButton(
                  txt: "  Back to Home",
                  icon: Icon(
                    Icons.home_outlined,
                    color: whiteColor.withValues(alpha: 0.85),
                    size: 20,
                  ),
                  bgColor: whiteColor.withValues(alpha: 0.2),
                  txtColor: whiteColor,
                  padding: const EdgeInsets.symmetric(
                    vertical: 14,
                    horizontal: 24,
                  ),
                  borderRadius: BorderRadius.circular(12),
                  alignment: Alignment.center,
                  onPress: () => _navigateTo(tabIndex: 0),
                ),

                const SizedBox(height: 24),

                AppTextRegular(
                  text: "The teacher will not see this feedback directly.",
                  color: whiteColor.withValues(alpha: 0.55),
                  fontSize: 12,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// FIX: The original code used Get.currentRoute == '/HomeScreen' which
  /// never matches because the app uses anonymous routes (Get.to with builders),
  /// not named routes. This caused Get.until to either pop everything or nothing.
  ///
  /// The correct approach:
  ///   1. Select the desired tab FIRST (before popping).
  ///   2. Pop all routes until only the root (HomeScreen) remains,
  ///      which is always the first route in the stack.
  void _navigateTo({required int tabIndex}) {
    Get.find<HomeController>().selectTab(tabIndex);
    // Pop until we reach the bottom of the stack (HomeScreen is always root).
    Get.until((route) => route.isFirst);
  }
}

class _SummaryField extends StatelessWidget {
  final String label;
  final String value;
  const _SummaryField({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppTextRegular(
          text: label,
          color: whiteColor.withValues(alpha: 0.6),
          fontSize: 12,
        ),
        const SizedBox(height: 4),
        AppTextSemiBold(
          text: value,
          color: whiteColor,
          fontSize: 16,
          fontFamily: FontFamily.inter,
        ),
      ],
    );
  }
}
