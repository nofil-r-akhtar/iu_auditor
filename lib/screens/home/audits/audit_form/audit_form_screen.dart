import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iu_auditor/app_theme/colors.dart';
import 'package:iu_auditor/components/app_button.dart';
import 'package:iu_auditor/components/app_container.dart';
import 'package:iu_auditor/components/app_text.dart';
import 'package:iu_auditor/const/enums.dart';
import 'package:iu_auditor/core/app_responsive.dart';
import 'package:iu_auditor/modal_class/audit/audit_question_model.dart';
import 'package:iu_auditor/screens/home/audits/audit_form/audit_form_controller.dart';
import 'package:iu_auditor/screens/home/audits/audit_success_screen.dart';

class AuditFormScreen extends StatelessWidget {
  final AuditFormController controller;
  const AuditFormScreen({required this.controller, super.key});

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.onSubmit ??= () {
        Get.off(() => AuditSuccessScreen(controller: controller));
      };
    });

    return Scaffold(
      backgroundColor: bgColor,
      body: LayoutBuilder(
        builder: (context, constraints) {
          final r = AppResponsive(constraints.maxWidth);

          return GetBuilder<AuditFormController>(
            tag: controller.teacherName,
            builder: (ctrl) {
              // ── Loading ──
              if (ctrl.isLoadingQuestions) {
                return const Center(child: CircularProgressIndicator());
              }

              // ── Error ──
              if (ctrl.loadError != null) {
                return _ErrorView(
                  message: ctrl.loadError!,
                  onRetry: () => ctrl.fetchQuestions(),
                );
              }

              // ── No questions in this form ──
              if (ctrl.questions.isEmpty) {
                return _ErrorView(
                  message: 'No questions found for this audit form.',
                  onRetry: () => Get.back(),
                  retryLabel: 'Go Back',
                );
              }

              // ── Main form ──
              return Row(
                children: [
                  if (!r.isMobile) _LeftPanel(controller: ctrl),
                  Expanded(
                    child: Column(
                      children: [
                        _ProgressHeader(controller: ctrl, responsive: r),
                        Expanded(
                          child: Center(
                            child: SingleChildScrollView(
                              padding: EdgeInsets.all(r.isMobile ? 16 : 40),
                              child: ConstrainedBox(
                                constraints: const BoxConstraints(maxWidth: 680),
                                child: AppContainer(
                                  bgColor: whiteColor,
                                  borderRadius: BorderRadius.circular(16),
                                  padding: EdgeInsets.all(r.isMobile ? 20 : 36),
                                  child: _QuestionBody(controller: ctrl, responsive: r),
                                ),
                              ),
                            ),
                          ),
                        ),
                        _NavigationBar(controller: ctrl, responsive: r),
                      ],
                    ),
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }
}

// ── Error View ────────────────────────────────────────────────
class _ErrorView extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;
  final String retryLabel;
  const _ErrorView({
    required this.message,
    required this.onRetry,
    this.retryLabel = 'Retry',
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline_rounded,
                color: descriptiveColor, size: 48),
            const SizedBox(height: 16),
            AppTextRegular(
              text: message,
              color: descriptiveColor,
              fontSize: 14,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            AppButton(
              txt: retryLabel,
              padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 12),
              borderRadius: BorderRadius.circular(10),
              onPress: onRetry,
            ),
          ],
        ),
      ),
    );
  }
}

// ── Question Body — switches by type ──────────────────────────
class _QuestionBody extends StatelessWidget {
  final AuditFormController controller;
  final AppResponsive responsive;
  const _QuestionBody({required this.controller, required this.responsive});

  @override
  Widget build(BuildContext context) {
    final q = controller.currentQuestion;
    switch (q.type) {
      case ApiQuestionType.rating:
        return _RatingQuestion(controller: controller, responsive: responsive);
      case ApiQuestionType.paragraph:
        return _TextQuestion(controller: controller, responsive: responsive);
      case ApiQuestionType.mcq:
        return _McqQuestion(controller: controller, responsive: responsive);
      case ApiQuestionType.yesNo:
        return _YesNoQuestion(controller: controller, responsive: responsive);
    }
  }
}

// ── Question Header (category chip + question text) ──────────
Widget _questionHeader({
  required Color chipBg,
  required Color chipFg,
  required String chipText,
  required String question,
  required bool isMobile,
}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      AppContainer(
        bgColor: chipBg,
        borderRadius: BorderRadius.circular(20),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        child: AppTextRegular(text: chipText, color: chipFg, fontSize: 12),
      ),
      const SizedBox(height: 24),
      AppTextBold(
        text: question,
        color: navyBlueColor,
        fontSize: isMobile ? 17 : 20,
        fontFamily: FontFamily.inter,
      ),
    ],
  );
}

// ── RATING QUESTION ──────────────────────────────────────────
class _RatingQuestion extends StatelessWidget {
  final AuditFormController controller;
  final AppResponsive responsive;
  const _RatingQuestion({required this.controller, required this.responsive});

  @override
  Widget build(BuildContext context) {
    final starSize = responsive.isMobile ? 36.0 : 48.0;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _questionHeader(
          chipBg: primaryColor.withValues(alpha: 0.1),
          chipFg: primaryColor,
          chipText: 'Rating',
          question: controller.currentQuestion.questionText,
          isMobile: responsive.isMobile,
        ),
        SizedBox(height: responsive.isMobile ? 28 : 40),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            AppTextRegular(text: 'Poor', color: descriptiveColor, fontSize: 13),
            AppTextRegular(text: 'Excellent', color: descriptiveColor, fontSize: 13),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: List.generate(5, (i) {
            final value = i + 1;
            final selected = (controller.getRating() ?? 0) >= value;
            return GestureDetector(
              onTap: () => controller.setRating(value),
              child: Column(
                children: [
                  Icon(
                    selected ? Icons.star_rounded : Icons.star_border_rounded,
                    color: selected
                        ? const Color(0xFFF59E0B)
                        : const Color(0xFFCBD5E1),
                    size: starSize,
                  ),
                  const SizedBox(height: 6),
                  AppTextRegular(
                    text: '$value',
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

// ── TEXT (paragraph) QUESTION ────────────────────────────────
class _TextQuestion extends StatelessWidget {
  final AuditFormController controller;
  final AppResponsive responsive;
  const _TextQuestion({required this.controller, required this.responsive});

  @override
  Widget build(BuildContext context) {
    final textCtrl = controller.textControllers[controller.currentQuestion.id]!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _questionHeader(
          chipBg: const Color(0xFFD1FAE5),
          chipFg: const Color(0xFF10B981),
          chipText: 'Feedback',
          question: controller.currentQuestion.questionText,
          isMobile: responsive.isMobile,
        ),
        const SizedBox(height: 24),
        TextField(
          controller: textCtrl,
          maxLines: 6,
          style: const TextStyle(
              fontSize: 14, color: navyBlueColor, fontFamily: 'inter'),
          decoration: InputDecoration(
            hintText: 'Enter your detailed feedback here...',
            hintStyle: TextStyle(
                color: iconColor.withValues(alpha: 0.6),
                fontSize: 14, fontFamily: 'inter'),
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
          text: 'Minimum 20 characters recommended',
          color: iconColor, fontSize: 11,
        ),
        const SizedBox(height: 24),
        _DotIndicator(controller: controller),
      ],
    );
  }
}

// ── MCQ QUESTION ─────────────────────────────────────────────
class _McqQuestion extends StatelessWidget {
  final AuditFormController controller;
  final AppResponsive responsive;
  const _McqQuestion({required this.controller, required this.responsive});

  @override
  Widget build(BuildContext context) {
    final q = controller.currentQuestion;
    final selected = controller.getMcq();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _questionHeader(
          chipBg: const Color(0xFFEDE9FE),
          chipFg: const Color(0xFF7C3AED),
          chipText: 'Multiple Choice',
          question: q.questionText,
          isMobile: responsive.isMobile,
        ),
        const SizedBox(height: 24),
        ...q.options.map((opt) {
          final isSelected = selected == opt;
          return Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: GestureDetector(
              onTap: () => controller.setMcq(opt),
              child: AppContainer(
                bgColor: isSelected
                    ? primaryColor.withValues(alpha: 0.08)
                    : bgColor,
                borderRadius: BorderRadius.circular(12),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                child: Row(children: [
                  AppContainer(
                    width: 22, height: 22,
                    shape: BoxShape.circle,
                    bgColor: isSelected ? primaryColor : Colors.transparent,
                    child: isSelected
                        ? const Icon(Icons.check_rounded,
                            color: whiteColor, size: 14)
                        : null,
                    alignment: Alignment.center,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: AppTextMedium(
                      text: opt,
                      color: isSelected ? navyBlueColor : descriptiveColor,
                      fontSize: 14,
                    ),
                  ),
                ]),
              ),
            ),
          );
        }),
        const SizedBox(height: 16),
        _DotIndicator(controller: controller),
      ],
    );
  }
}

// ── YES/NO QUESTION ──────────────────────────────────────────
class _YesNoQuestion extends StatelessWidget {
  final AuditFormController controller;
  final AppResponsive responsive;
  const _YesNoQuestion({required this.controller, required this.responsive});

  @override
  Widget build(BuildContext context) {
    final v = controller.getYesNo();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _questionHeader(
          chipBg: const Color(0xFFFEF3C7),
          chipFg: const Color(0xFFD97706),
          chipText: 'Yes / No',
          question: controller.currentQuestion.questionText,
          isMobile: responsive.isMobile,
        ),
        const SizedBox(height: 28),
        Row(children: [
          Expanded(child: _YesNoButton(
            label: 'Yes',
            icon: Icons.check_circle_outline_rounded,
            selectedColor: const Color(0xFF10B981),
            isSelected: v == true,
            onTap: () => controller.setYesNo(true),
          )),
          const SizedBox(width: 14),
          Expanded(child: _YesNoButton(
            label: 'No',
            icon: Icons.cancel_outlined,
            selectedColor: const Color(0xFFDC2626),
            isSelected: v == false,
            onTap: () => controller.setYesNo(false),
          )),
        ]),
        const SizedBox(height: 32),
        _DotIndicator(controller: controller),
      ],
    );
  }
}

class _YesNoButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color selectedColor;
  final bool isSelected;
  final VoidCallback onTap;
  const _YesNoButton({
    required this.label, required this.icon,
    required this.selectedColor, required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AppContainer(
        bgColor: isSelected ? selectedColor.withValues(alpha: 0.1) : bgColor,
        borderRadius: BorderRadius.circular(14),
        padding: const EdgeInsets.symmetric(vertical: 18),
        child: Column(children: [
          Icon(icon,
              color: isSelected ? selectedColor : descriptiveColor, size: 32),
          const SizedBox(height: 8),
          AppTextSemiBold(
            text: label,
            color: isSelected ? selectedColor : descriptiveColor,
            fontSize: 15,
            fontFamily: FontFamily.inter,
          ),
        ]),
      ),
    );
  }
}

// ── LEFT PANEL ───────────────────────────────────────────────
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
              child: Row(children: [
                const Icon(Icons.arrow_back_ios_rounded,
                    color: whiteColor, size: 14),
                const SizedBox(width: 6),
                AppTextRegular(
                  text: 'Back to Audits',
                  color: whiteColor.withValues(alpha: 0.7),
                  fontSize: 13,
                ),
              ]),
            ),
            const SizedBox(height: 40),
            AppContainer(
              width: 64, height: 64,
              bgColor: primaryColor,
              borderRadius: BorderRadius.circular(14),
              alignment: Alignment.center,
              child: AppTextBold(
                text: controller.initials,
                color: whiteColor, fontSize: 18,
                fontFamily: FontFamily.inter,
              ),
            ),
            const SizedBox(height: 16),
            AppTextBold(
              text: 'Auditing',
              color: whiteColor.withValues(alpha: 0.5),
              fontSize: 13, fontFamily: FontFamily.inter,
            ),
            const SizedBox(height: 4),
            AppTextBold(
              text: controller.teacherName,
              color: whiteColor, fontSize: 20,
              fontFamily: FontFamily.inter,
            ),
            const SizedBox(height: 6),
            AppTextRegular(
              text: '${controller.department} • ${controller.specialization}',
              color: whiteColor.withValues(alpha: 0.55),
              fontSize: 13,
            ),
            const SizedBox(height: 40),
            const Divider(color: Colors.white12),
            const SizedBox(height: 24),
            AppTextSemiBold(
              text: 'Questions',
              color: whiteColor.withValues(alpha: 0.6),
              fontSize: 12, fontFamily: FontFamily.inter,
            ),
            const SizedBox(height: 12),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: List.generate(controller.totalQuestions, (i) {
                    final q = controller.questions[i];
                    final isAnswered = _isAnswered(controller, i);
                    final isCurrent  = controller.currentIndex == i;
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Row(children: [
                        AppContainer(
                          width: 24, height: 24,
                          shape: BoxShape.circle,
                          bgColor: isCurrent
                              ? primaryColor
                              : isAnswered
                                  ? const Color(0xFF10B981)
                                  : Colors.white12,
                          alignment: Alignment.center,
                          child: isAnswered && !isCurrent
                              ? const Icon(Icons.check_rounded,
                                  color: whiteColor, size: 13)
                              : AppTextRegular(
                                  text: '${i + 1}',
                                  color: whiteColor, fontSize: 11),
                        ),
                        const SizedBox(width: 10),
                        Flexible(
                          child: AppTextRegular(
                            text: q.questionText,
                            color: isCurrent
                                ? whiteColor
                                : whiteColor.withValues(alpha: 0.45),
                            fontSize: 12,
                          ),
                        ),
                      ]),
                    );
                  }),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  bool _isAnswered(AuditFormController c, int i) {
    if (i >= c.questions.length) return false;
    final q = c.questions[i];
    switch (q.type) {
      case ApiQuestionType.rating:    return c.answers[q.id] is int;
      case ApiQuestionType.paragraph:
        return (c.textControllers[q.id]?.text.trim().isNotEmpty) ?? false;
      case ApiQuestionType.mcq:
        return c.answers[q.id] is String &&
               (c.answers[q.id] as String).isNotEmpty;
      case ApiQuestionType.yesNo:     return c.answers[q.id] is bool;
    }
  }
}

// ── PROGRESS HEADER ──────────────────────────────────────────
class _ProgressHeader extends StatelessWidget {
  final AuditFormController controller;
  final AppResponsive responsive;
  const _ProgressHeader({required this.controller, required this.responsive});

  @override
  Widget build(BuildContext context) {
    return AppContainer(
      bgColor: whiteColor,
      padding: EdgeInsets.symmetric(
        horizontal: responsive.isMobile ? 16 : 40,
        vertical: 18,
      ),
      child: Row(children: [
        if (responsive.isMobile)
          GestureDetector(
            onTap: () => Get.back(),
            child: const Padding(
              padding: EdgeInsets.only(right: 10),
              child: Icon(Icons.arrow_back_ios_rounded,
                  color: navyBlueColor, size: 18),
            ),
          ),
        AppTextSemiBold(
          text: responsive.isMobile
              ? 'Q ${controller.currentIndex + 1}/${controller.totalQuestions}'
              : 'Question ${controller.currentIndex + 1} of ${controller.totalQuestions}',
          color: navyBlueColor,
          fontSize: 14, fontFamily: FontFamily.inter,
        ),
        SizedBox(width: responsive.isMobile ? 10 : 20),
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
        if (!responsive.isMobile) ...[
          const SizedBox(width: 16),
          AppTextRegular(
            text: '${(controller.progressPercent * 100).toInt()}% Complete',
            color: descriptiveColor, fontSize: 13,
          ),
        ],
      ]),
    );
  }
}

// ── DOT INDICATOR ────────────────────────────────────────────
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

// ── NAVIGATION BAR ───────────────────────────────────────────
class _NavigationBar extends StatelessWidget {
  final AuditFormController controller;
  final AppResponsive responsive;
  const _NavigationBar({required this.controller, required this.responsive});

  @override
  Widget build(BuildContext context) {
    return AppContainer(
      bgColor: whiteColor,
      padding: EdgeInsets.symmetric(
        horizontal: responsive.isMobile ? 16 : 40,
        vertical: 16,
      ),
      child: Row(children: [
        AppButton(
          txt: 'Back',
          bgColor: bgColor,
          txtColor: navyBlueColor,
          icon: const Icon(Icons.arrow_back_ios_rounded,
              color: navyBlueColor, size: 14),
          padding: EdgeInsets.symmetric(
              horizontal: responsive.isMobile ? 16 : 24, vertical: 12),
          borderRadius: BorderRadius.circular(10),
          onPress: controller.isFirstQuestion ? null : () => controller.goBack(),
        ),
        const Spacer(),
        Obx(() {
          final canGo     = controller.canProceedObs.value;
          final submitting = controller.isSubmitting.value;

          if (controller.isLastQuestion) {
            return AppButton(
              txt: submitting
                  ? 'Submitting...'
                  : (responsive.isMobile ? 'Submit' : '  Submit Audit'),
              icon: submitting
                  ? null
                  : const Icon(Icons.send_rounded,
                      color: whiteColor, size: 16),
              bgColor: (canGo && !submitting)
                  ? const Color(0xFF10B981)
                  : const Color(0xFFCBD5E1),
              padding: EdgeInsets.symmetric(
                  horizontal: responsive.isMobile ? 20 : 28, vertical: 12),
              borderRadius: BorderRadius.circular(10),
              onPress: (canGo && !submitting)
                  ? () => controller.submitAudit()
                  : null,
            );
          }
          return AppButton(
            txt: 'Next',
            icon: const Icon(Icons.arrow_forward_ios_rounded,
                color: whiteColor, size: 14),
            bgColor: canGo ? primaryColor : const Color(0xFFCBD5E1),
            padding: EdgeInsets.symmetric(
                horizontal: responsive.isMobile ? 20 : 28, vertical: 12),
            borderRadius: BorderRadius.circular(10),
            onPress: canGo ? () => controller.goNext() : null,
          );
        }),
      ]),
    );
  }
}
