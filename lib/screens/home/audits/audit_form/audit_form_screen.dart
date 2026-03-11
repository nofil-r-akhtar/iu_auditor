import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iu_auditor/app_theme/colors.dart';
import 'package:iu_auditor/components/app_button.dart';
import 'package:iu_auditor/components/app_container.dart';
import 'package:iu_auditor/components/app_text.dart';
import 'package:iu_auditor/screens/home/audits/audit_form/audit_form_controller.dart';
import 'package:iu_auditor/screens/home/audits/audit_success_screen.dart';
import 'package:iu_auditor/const/enums.dart';

class AuditFormScreen extends StatelessWidget {
  final AuditFormController controller;
  const AuditFormScreen({required this.controller, super.key});

  @override
  Widget build(BuildContext context) {
    // FIX: onSubmit was re-assigned on every rebuild inside build().
    // Using addPostFrameCallback ensures it is wired exactly once,
    // after the first frame, without polluting build().
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.onSubmit ??= () {
        Get.to(() => AuditSuccessScreen(controller: controller));
      };
    });

    return Scaffold(
      backgroundColor: bgColor,
      body: Row(
        children: [
          _LeftPanel(controller: controller),
          Expanded(
            child: GetBuilder<AuditFormController>(
              tag: controller.teacherName,
              builder: (ctrl) => Column(
                children: [
                  _ProgressHeader(controller: ctrl),
                  Expanded(
                    child: Center(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.all(40),
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 680),
                          child: AppContainer(
                            bgColor: whiteColor,
                            borderRadius: BorderRadius.circular(16),
                            padding: const EdgeInsets.all(36),
                            child:
                                ctrl.currentQuestion.type == QuestionType.rating
                                ? _RatingQuestion(controller: ctrl)
                                : _TextQuestion(controller: ctrl),
                          ),
                        ),
                      ),
                    ),
                  ),
                  _NavigationBar(controller: ctrl),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────
// LEFT PANEL
// ─────────────────────────────────────────
class _LeftPanel extends StatelessWidget {
  final AuditFormController controller;
  const _LeftPanel({required this.controller});

  @override
  Widget build(BuildContext context) {
    return AppContainer(
      width: 280,
      bgColor: navyBlueColor,
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: () => Get.back(),
              child: Row(
                children: [
                  const Icon(
                    Icons.arrow_back_ios_rounded,
                    color: whiteColor,
                    size: 14,
                  ),
                  const SizedBox(width: 6),
                  AppTextRegular(
                    text: "Back to Audits",
                    color: whiteColor.withValues(alpha: 0.7),
                    fontSize: 13,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 40),

            AppContainer(
              width: 64,
              height: 64,
              bgColor: primaryColor,
              borderRadius: BorderRadius.circular(14),
              alignment: Alignment.center,
              child: AppTextBold(
                text: controller.initials,
                color: whiteColor,
                fontSize: 18,
                fontFamily: FontFamily.inter,
              ),
            ),

            const SizedBox(height: 16),

            AppTextBold(
              text: "Auditing",
              color: whiteColor.withValues(alpha: 0.5),
              fontSize: 13,
              fontFamily: FontFamily.inter,
            ),
            const SizedBox(height: 4),
            AppTextBold(
              text: controller.teacherName,
              color: whiteColor,
              fontSize: 20,
              fontFamily: FontFamily.inter,
            ),
            const SizedBox(height: 6),
            AppTextRegular(
              text: "${controller.department} • ${controller.specialization}",
              color: whiteColor.withValues(alpha: 0.55),
              fontSize: 13,
            ),

            const SizedBox(height: 40),
            const Divider(color: Colors.white12),
            const SizedBox(height: 24),

            AppTextSemiBold(
              text: "Questions",
              color: whiteColor.withValues(alpha: 0.6),
              fontSize: 12,
              fontFamily: FontFamily.inter,
            ),
            const SizedBox(height: 12),

            GetBuilder<AuditFormController>(
              tag: controller.teacherName,
              builder: (ctrl) => Column(
                children: List.generate(ctrl.totalQuestions, (i) {
                  final isAnswered =
                      ctrl.answers.containsKey(i) ||
                      (ctrl.questions[i].type == QuestionType.text &&
                          (ctrl.textControllers[i]?.text.trim().isNotEmpty ??
                              false));
                  final isCurrent = ctrl.currentIndex == i;
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Row(
                      children: [
                        AppContainer(
                          width: 24,
                          height: 24,
                          shape: BoxShape.circle,
                          bgColor: isCurrent
                              ? primaryColor
                              : isAnswered
                              ? const Color(0xFF10B981)
                              : Colors.white12,
                          alignment: Alignment.center,
                          child: isAnswered && !isCurrent
                              ? const Icon(
                                  Icons.check_rounded,
                                  color: whiteColor,
                                  size: 13,
                                )
                              : AppTextRegular(
                                  text: '${i + 1}',
                                  color: whiteColor,
                                  fontSize: 11,
                                ),
                        ),
                        const SizedBox(width: 10),
                        Flexible(
                          child: AppTextRegular(
                            text: ctrl.questions[i].category,
                            color: isCurrent
                                ? whiteColor
                                : whiteColor.withValues(alpha: 0.45),
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  );
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────
// PROGRESS HEADER
// ─────────────────────────────────────────
class _ProgressHeader extends StatelessWidget {
  final AuditFormController controller;
  const _ProgressHeader({required this.controller});

  @override
  Widget build(BuildContext context) {
    return AppContainer(
      bgColor: whiteColor,
      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 18),
      child: Row(
        children: [
          AppTextSemiBold(
            text:
                "Question ${controller.currentIndex + 1} of ${controller.totalQuestions}",
            color: navyBlueColor,
            fontSize: 14,
            fontFamily: FontFamily.inter,
          ),
          const SizedBox(width: 20),
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: controller.progressPercent,
                backgroundColor: bgColor,
                color: primaryColor,
                minHeight: 6,
              ),
            ),
          ),
          const SizedBox(width: 16),
          AppTextRegular(
            text: "${(controller.progressPercent * 100).toInt()}% Complete",
            color: descriptiveColor,
            fontSize: 13,
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────
// RATING QUESTION
// ─────────────────────────────────────────
class _RatingQuestion extends StatelessWidget {
  final AuditFormController controller;
  const _RatingQuestion({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppContainer(
          bgColor: primaryColor.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(20),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
          child: AppTextRegular(
            text: controller.currentQuestion.category,
            color: primaryColor,
            fontSize: 12,
          ),
        ),

        const SizedBox(height: 24),

        AppTextBold(
          text: controller.currentQuestion.question,
          color: navyBlueColor,
          fontSize: 20,
          fontFamily: FontFamily.inter,
        ),

        const SizedBox(height: 40),

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            AppTextRegular(text: "Poor", color: descriptiveColor, fontSize: 13),
            AppTextRegular(
              text: "Excellent",
              color: descriptiveColor,
              fontSize: 13,
            ),
          ],
        ),

        const SizedBox(height: 12),

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: List.generate(5, (i) {
            final starValue = i + 1;
            final selected = (controller.getRating() ?? 0) >= starValue;
            return GestureDetector(
              onTap: () => controller.setRating(starValue),
              child: Column(
                children: [
                  Icon(
                    selected ? Icons.star_rounded : Icons.star_border_rounded,
                    color: selected
                        ? const Color(0xFFF59E0B)
                        : const Color(0xFFCBD5E1),
                    size: 48,
                  ),
                  const SizedBox(height: 6),
                  AppTextRegular(
                    text: '$starValue',
                    color: selected ? navyBlueColor : descriptiveColor,
                    fontSize: 13,
                  ),
                ],
              ),
            );
          }),
        ),

        const SizedBox(height: 32),
        _DotIndicator(controller: controller),
      ],
    );
  }
}

// ─────────────────────────────────────────
// TEXT QUESTION
// ─────────────────────────────────────────
class _TextQuestion extends StatelessWidget {
  final AuditFormController controller;
  const _TextQuestion({required this.controller});

  @override
  Widget build(BuildContext context) {
    final textCtrl = controller.textControllers[controller.currentIndex]!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppContainer(
          bgColor: const Color(0xFFD1FAE5),
          borderRadius: BorderRadius.circular(20),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
          child: AppTextRegular(
            text: controller.currentQuestion.category,
            color: const Color(0xFF10B981),
            fontSize: 12,
          ),
        ),

        const SizedBox(height: 24),

        AppTextBold(
          text: controller.currentQuestion.question,
          color: navyBlueColor,
          fontSize: 20,
          fontFamily: FontFamily.inter,
        ),

        const SizedBox(height: 24),

        TextField(
          controller: textCtrl,
          maxLines: 6,
          // No need for onChanged here — the listener in the controller handles it
          style: const TextStyle(
            fontSize: 14,
            color: navyBlueColor,
            fontFamily: 'inter',
          ),
          decoration: InputDecoration(
            hintText: "Enter your detailed feedback here...",
            hintStyle: TextStyle(
              color: iconColor.withValues(alpha: 0.6),
              fontSize: 14,
              fontFamily: 'inter',
            ),
            filled: true,
            fillColor: bgColor,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            contentPadding: const EdgeInsets.all(16),
          ),
        ),

        const SizedBox(height: 8),

        AppTextRegular(
          text: "Minimum 20 characters recommended",
          color: iconColor,
          fontSize: 11,
        ),

        const SizedBox(height: 24),
        _DotIndicator(controller: controller),
      ],
    );
  }
}

// ─────────────────────────────────────────
// DOT INDICATOR
// ─────────────────────────────────────────
class _DotIndicator extends StatelessWidget {
  final AuditFormController controller;
  const _DotIndicator({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(controller.totalQuestions, (i) {
        final isCurrent = i == controller.currentIndex;
        return AppContainer(
          width: isCurrent ? 24 : 8,
          height: 8,
          bgColor: isCurrent ? primaryColor : const Color(0xFFCBD5E1),
          borderRadius: BorderRadius.circular(4),
          margin: const EdgeInsets.symmetric(horizontal: 3),
        );
      }),
    );
  }
}

// ─────────────────────────────────────────
// NAVIGATION BAR
// ─────────────────────────────────────────
class _NavigationBar extends StatelessWidget {
  final AuditFormController controller;
  const _NavigationBar({required this.controller});

  @override
  Widget build(BuildContext context) {
    return AppContainer(
      bgColor: whiteColor,
      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
      child: Row(
        children: [
          // Back button — disabled on first question
          AppButton(
            txt: "Back",
            bgColor: bgColor,
            txtColor: navyBlueColor,
            icon: const Icon(
              Icons.arrow_back_ios_rounded,
              color: navyBlueColor,
              size: 14,
            ),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            borderRadius: BorderRadius.circular(10),
            onPress: controller.isFirstQuestion
                ? null
                : () => controller.goBack(),
          ),

          const Spacer(),

          // FIX: Next / Submit are now gated by canProceedObs.
          // The button is visually disabled (onPress: null) until the
          // current question is answered. Obx rebuilds the button reactively.
          Obx(() {
            final canGo = controller.canProceedObs.value;

            if (controller.isLastQuestion) {
              return AppButton(
                txt: "  Submit Audit",
                icon: const Icon(
                  Icons.send_rounded,
                  color: whiteColor,
                  size: 16,
                ),
                bgColor: canGo
                    ? const Color(0xFF10B981)
                    : const Color(0xFFCBD5E1),
                padding: const EdgeInsets.symmetric(
                  horizontal: 28,
                  vertical: 12,
                ),
                borderRadius: BorderRadius.circular(10),
                onPress: canGo ? () => controller.submitAudit() : null,
              );
            }

            return AppButton(
              txt: "Next",
              icon: const Icon(
                Icons.arrow_forward_ios_rounded,
                color: whiteColor,
                size: 14,
              ),
              bgColor: canGo ? primaryColor : const Color(0xFFCBD5E1),
              padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 12),
              borderRadius: BorderRadius.circular(10),
              onPress: canGo ? () => controller.goNext() : null,
            );
          }),
        ],
      ),
    );
  }
}
