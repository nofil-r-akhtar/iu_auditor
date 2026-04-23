import 'package:iu_auditor/modal_class/audit/audit_review_model.dart';
import 'package:iu_auditor/modal_class/audit/audit_question_model.dart';

/// Answer payload sent when submitting a review
class AuditAnswerInput {
  final String questionId;
  final int? answerRating;
  final String? answerText;
  final String? answerMcq;
  final bool? answerYesNo;

  AuditAnswerInput({
    required this.questionId,
    this.answerRating,
    this.answerText,
    this.answerMcq,
    this.answerYesNo,
  });

  Map<String, dynamic> toJson() => {
    'question_id':   questionId,
    if (answerRating != null) 'answer_rating': answerRating,
    if (answerText   != null) 'answer_text':   answerText,
    if (answerMcq    != null) 'answer_mcq':    answerMcq,
    if (answerYesNo  != null) 'answer_yes_no': answerYesNo,
  };
}

abstract class IAuditReviewsService {
  /// GET /audit-reviews/my/reviews
  /// Returns all reviews assigned to the logged-in senior lecturer.
  Future<List<AuditReview>> getMyReviews();

  /// GET /audit-reviews/{id}
  /// Returns a single review with details.
  Future<AuditReview?> getReviewById(String id);

  /// GET /audit/forms/{form_id}/questions/
  /// Returns all questions for a given audit form.
  Future<List<AuditQuestionApi>> getFormQuestions(String formId);

  /// POST /audit-reviews/{id}/submit
  /// Submits the filled-in answers. Marks review as completed.
  Future<Map<String, dynamic>> submitReview({
    required String reviewId,
    required List<AuditAnswerInput> answers,
    String? notes,
  });
}
