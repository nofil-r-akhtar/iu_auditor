import 'package:flutter/material.dart';
import 'package:get/get.dart';

enum QuestionType { rating, text }

class AuditQuestion {
  final String category;
  final String question;
  final QuestionType type;

  const AuditQuestion({
    required this.category,
    required this.question,
    required this.type,
  });
}

class AuditFormController extends GetxController {
  final String teacherName;
  final String department;
  final String specialization;
  final String initials;

  AuditFormController({
    required this.teacherName,
    required this.department,
    required this.specialization,
    required this.initials,
  });

  final List<AuditQuestion> questions = const [
    AuditQuestion(
      category: 'Teaching Methodology',
      question: 'How effectively does the teacher explain complex concepts?',
      type: QuestionType.rating,
    ),
    AuditQuestion(
      category: 'Teaching Methodology',
      question: 'How well does the teacher engage students during lectures?',
      type: QuestionType.rating,
    ),
    AuditQuestion(
      category: 'Course Management',
      question: 'How organized is the teacher in delivering course content?',
      type: QuestionType.rating,
    ),
    AuditQuestion(
      category: 'Course Management',
      question: 'How timely and fair is the teacher in grading assignments?',
      type: QuestionType.rating,
    ),
    AuditQuestion(
      category: 'Student Interaction',
      question: 'How approachable and supportive is the teacher outside class?',
      type: QuestionType.rating,
    ),
    AuditQuestion(
      category: 'Feedback',
      question: 'Provide specific examples of strengths observed.',
      type: QuestionType.text,
    ),
    AuditQuestion(
      category: 'Feedback',
      question: 'Provide specific areas for improvement.',
      type: QuestionType.text,
    ),
  ];

  int currentIndex = 0;
  final Map<int, dynamic> answers = {};
  final Map<int, TextEditingController> textControllers = {};

  // FIX: canProceed is now observable so the Next/Submit buttons
  // react instantly when the user selects a rating or types text.
  final RxBool canProceedObs = false.obs;

  @override
  void onInit() {
    super.onInit();
    for (int i = 0; i < questions.length; i++) {
      if (questions[i].type == QuestionType.text) {
        textControllers[i] = TextEditingController()
          ..addListener(_refreshCanProceed);
      }
    }
    _refreshCanProceed();
  }

  void _refreshCanProceed() {
    canProceedObs.value = _computeCanProceed();
  }

  bool _computeCanProceed() {
    final q = currentQuestion;
    if (q.type == QuestionType.rating) {
      return answers[currentIndex] != null;
    } else {
      return (textControllers[currentIndex]?.text.trim().isNotEmpty) ?? false;
    }
  }

  AuditQuestion get currentQuestion => questions[currentIndex];
  int get totalQuestions => questions.length;
  bool get isLastQuestion => currentIndex == totalQuestions - 1;
  bool get isFirstQuestion => currentIndex == 0;
  double get progressPercent => (currentIndex + 1) / totalQuestions;

  void setRating(int rating) {
    answers[currentIndex] = rating;
    _refreshCanProceed();
    update();
  }

  int? getRating() => answers[currentIndex] as int?;

  void goNext() {
    if (!_computeCanProceed()) return; // guard — should not happen via UI
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

  double get averageRating {
    final ratingAnswers = <int>[];
    for (int i = 0; i < questions.length; i++) {
      if (questions[i].type == QuestionType.rating && answers[i] != null) {
        ratingAnswers.add(answers[i] as int);
      }
    }
    if (ratingAnswers.isEmpty) return 0;
    return ratingAnswers.reduce((a, b) => a + b) / ratingAnswers.length;
  }

  // Callback wired by AuditFormScreen to navigate to the success screen.
  // Kept here to avoid circular imports between screen and controller.
  void Function()? onSubmit;

  void submitAudit() {
    if (!_computeCanProceed()) return; // guard for last question
    onSubmit?.call();
  }

  @override
  void onClose() {
    for (final ctrl in textControllers.values) {
      ctrl.removeListener(_refreshCanProceed);
      ctrl.dispose();
    }
    // FIX: delete this controller from GetX registry on close so
    // repeated taps on different teachers don't accumulate instances.
    Get.delete<AuditFormController>(tag: teacherName, force: true);
    super.onClose();
  }
}
