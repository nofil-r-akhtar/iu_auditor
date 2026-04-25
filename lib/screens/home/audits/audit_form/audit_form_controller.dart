import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iu_auditor/apis/audit_reviews/i_audit_reviews_service.dart';
import 'package:iu_auditor/modal_class/audit/audit_question_model.dart';
import 'package:iu_auditor/screens/home/audits/audits_controller.dart';

class AuditFormController extends GetxController {
  final IAuditReviewsService _service = Get.find<IAuditReviewsService>();

  // ── Passed in on creation ────────────────────────────────
  final String reviewId;
  final String formId;
  final String teacherName;
  final String department;
  final String specialization;
  final String initials;

  AuditFormController({
    required this.reviewId,
    required this.formId,
    required this.teacherName,
    required this.department,
    required this.specialization,
    required this.initials,
  });

  // ── Questions loaded from API ────────────────────────────
  List<AuditQuestionApi> questions = [];
  bool isLoadingQuestions = false;
  String? loadError;

  int currentIndex = 0;

  /// Answers by question id:
  ///   rating    → int (1-5)
  ///   paragraph → String
  ///   mcq       → String (selected option)
  ///   yes_no    → bool
  final Map<String, dynamic> answers = {};
  final Map<String, TextEditingController> textControllers = {};

  final RxBool  canProceedObs = false.obs;
  final RxBool  isSubmitting  = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchQuestions();
  }

  Future<void> fetchQuestions() async {
    try {
      isLoadingQuestions = true;
      loadError = null;
      update();

      final qs = await _service.getFormQuestions(formId);

      // Init text controllers for paragraph questions
      for (final q in qs) {
        if (q.type == ApiQuestionType.paragraph) {
          textControllers[q.id] = TextEditingController()
            ..addListener(_refreshCanProceed);
        }
      }

      questions = qs;
      _refreshCanProceed();
    } catch (e) {
      loadError = e.toString();
    } finally {
      isLoadingQuestions = false;
      update();
    }
  }

  // ── Derived getters ──────────────────────────────────────
  AuditQuestionApi get currentQuestion => questions[currentIndex];
  int get totalQuestions => questions.length;
  bool get isLastQuestion  => currentIndex == totalQuestions - 1;
  bool get isFirstQuestion => currentIndex == 0;
  double get progressPercent =>
      totalQuestions == 0 ? 0 : (currentIndex + 1) / totalQuestions;

  // ── Answer setters ───────────────────────────────────────
  void setRating(int rating) {
    answers[currentQuestion.id] = rating;
    _refreshCanProceed(); update();
  }

  int? getRating() {
    if (questions.isEmpty) return null;
    final v = answers[currentQuestion.id];
    return v is int ? v : null;
  }

  void setMcq(String option) {
    answers[currentQuestion.id] = option;
    _refreshCanProceed(); update();
  }

  String? getMcq() {
    if (questions.isEmpty) return null;
    final v = answers[currentQuestion.id];
    return v is String ? v : null;
  }

  void setYesNo(bool yes) {
    answers[currentQuestion.id] = yes;
    _refreshCanProceed(); update();
  }

  bool? getYesNo() {
    if (questions.isEmpty) return null;
    final v = answers[currentQuestion.id];
    return v is bool ? v : null;
  }

  // ── Navigation ───────────────────────────────────────────
  void _refreshCanProceed() {
    canProceedObs.value = _computeCanProceed();
  }

  bool _computeCanProceed() {
    if (questions.isEmpty) return false;
    final q = currentQuestion;
    if (!q.isRequired) return true;

    switch (q.type) {
      case ApiQuestionType.rating:
        return answers[q.id] is int;
      case ApiQuestionType.paragraph:
        return textControllers[q.id]?.text.trim().isNotEmpty ?? false;
      case ApiQuestionType.mcq:
        return answers[q.id] is String &&
               (answers[q.id] as String).isNotEmpty;
      case ApiQuestionType.yesNo:
        return answers[q.id] is bool;
    }
  }

  void goNext() {
    if (!_computeCanProceed()) return;
    if (currentIndex < totalQuestions - 1) {
      currentIndex++;
      _refreshCanProceed();
      update();
    }
  }

  void goBack() {
    if (currentIndex > 0) {
      currentIndex--;
      _refreshCanProceed();
      update();
    }
  }

  // ── Submit ───────────────────────────────────────────────
  void Function()? onSubmit;

  Future<void> submitAudit() async {
    if (!_computeCanProceed()) return;
    if (isSubmitting.value) return;

    try {
      isSubmitting.value = true;

      // Build answers payload
      final payload = <AuditAnswerInput>[];
      for (final q in questions) {
        final v = answers[q.id];
        final txt = textControllers[q.id]?.text.trim() ?? '';

        switch (q.type) {
          case ApiQuestionType.rating:
            if (v is int) payload.add(AuditAnswerInput(
                questionId: q.id, answerRating: v));
            break;
          case ApiQuestionType.paragraph:
            if (txt.isNotEmpty) payload.add(AuditAnswerInput(
                questionId: q.id, answerText: txt));
            break;
          case ApiQuestionType.mcq:
            if (v is String && v.isNotEmpty) payload.add(AuditAnswerInput(
                questionId: q.id, answerMcq: v));
            break;
          case ApiQuestionType.yesNo:
            if (v is bool) payload.add(AuditAnswerInput(
                questionId: q.id, answerYesNo: v));
            break;
        }
      }

      final res = await _service.submitReview(
        reviewId: reviewId,
        answers:  payload,
      );

      if (res['success'] != true) {
        Get.snackbar('Error', res['message']?.toString() ?? 'Submit failed');
        return;
      }

      // ── Refresh audits list so the submitted review flips to 'completed' ──
      // 1. Instant local update — no API wait, UI feels snappy
      try {
        final auditsCtrl = Get.find<AuditsController>();
        auditsCtrl.markCompletedLocally(reviewId);
        // 2. Background refetch to sync with server state
        auditsCtrl.fetchReviews();
      } catch (_) {
        // AuditsController not registered — safe to ignore
      }

      // Success — trigger navigation to success screen
      onSubmit?.call();
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      isSubmitting.value = false;
    }
  }

  // ── Helpers for success screen ──────────────────────────
  double get averageRating {
    final ratings = <int>[];
    for (final q in questions) {
      if (q.type == ApiQuestionType.rating && answers[q.id] is int) {
        ratings.add(answers[q.id] as int);
      }
    }
    if (ratings.isEmpty) return 0;
    return ratings.reduce((a, b) => a + b) / ratings.length;
  }

  @override
  void onClose() {
    for (final ctrl in textControllers.values) {
      ctrl.removeListener(_refreshCanProceed);
      ctrl.dispose();
    }
    Get.delete<AuditFormController>(tag: teacherName, force: true);
    super.onClose();
  }
}