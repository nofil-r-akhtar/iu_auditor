import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iu_auditor/app_theme/colors.dart';
import 'package:iu_auditor/components/app_button.dart';
import 'package:iu_auditor/components/app_container.dart';
import 'package:iu_auditor/components/app_text.dart';
import 'package:iu_auditor/core/app_responsive.dart';
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
      body: LayoutBuilder(
        builder: (context, constraints) {
          final r = AppResponsive(constraints.maxWidth);

          return Center(
            child: SingleChildScrollView(
              // FIX: tighter padding on mobile so content has room to breathe.
              padding: EdgeInsets.all(r.isMobile ? 20 : 40),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 520),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // ── Check circle ──
                    AppContainer(
                      // FIX: slightly smaller on mobile.
                      width: r.isMobile ? 80 : 100,
                      height: r.isMobile ? 80 : 100,
                      shape: BoxShape.circle,
                      bgColor: whiteColor.withValues(alpha: 0.2),
                      alignment: Alignment.center,
                      child: AppContainer(
                        width: r.isMobile ? 58 : 72,
                        height: r.isMobile ? 58 : 72,
                        shape: BoxShape.circle,
                        bgColor: whiteColor.withValues(alpha: 0.3),
                        alignment: Alignment.center,
                        child: Icon(
                          Icons.check_rounded,
                          color: whiteColor,
                          size: r.isMobile ? 30 : 38,
                        ),
                      ),
                    ),

                    SizedBox(height: r.isMobile ? 20 : 28),

                    AppTextBold(
                      text: "Audit Submitted!",
                      color: whiteColor,
                      fontSize: r.isMobile ? 22 : 28,
                      fontFamily: FontFamily.inter,
                    ),

                    const SizedBox(height: 10),

                    AppTextRegular(
                      text:
                          "Your feedback for ${controller.teacherName} has been\nsuccessfully recorded.",
                      color: whiteColor.withValues(alpha: 0.85),
                      fontSize: r.isMobile ? 13 : 15,
                      textAlign: TextAlign.center,
                    ),

                    SizedBox(height: r.isMobile ? 24 : 36),

                    // ── Summary card ──
                    AppContainer(
                      bgColor: whiteColor.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(16),
                      // FIX: reduced inner padding on mobile.
                      padding: EdgeInsets.all(r.isMobile ? 16 : 24),
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
                                  value:
                                      "${controller.totalQuestions} Answered",
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

                    SizedBox(height: r.isMobile ? 20 : 28),

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
                      padding: EdgeInsets.symmetric(
                        vertical: r.isMobile ? 12 : 14,
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
                      padding: EdgeInsets.symmetric(
                        vertical: r.isMobile ? 12 : 14,
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
          );
        },
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
          // FIX: value text slightly smaller to avoid overflow on mobile
          // when the teacher name or department name is long.
          fontSize: 14,
          fontFamily: FontFamily.inter,
        ),
      ],
    );
  }
}
