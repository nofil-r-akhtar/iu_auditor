import 'package:iu_auditor/apis/api_config.dart';
import 'package:iu_auditor/apis/audit_reviews/i_audit_reviews_service.dart';
import 'package:iu_auditor/modal_class/audit/audit_review_model.dart';
import 'package:iu_auditor/modal_class/audit/audit_question_model.dart';

class MockAuditReviewsService implements IAuditReviewsService {
  Future<void> _delay() => Future.delayed(ApiConfig.mockDelay);

  @override
  Future<List<AuditReview>> getMyReviews() async {
    await _delay();
    return [];
  }

  @override
  Future<AuditReview?> getReviewById(String id) async {
    await _delay();
    return null;
  }

  @override
  Future<List<AuditQuestionApi>> getFormQuestions(String formId) async {
    await _delay();
    return [];
  }

  @override
  Future<Map<String, dynamic>> submitReview({
    required String reviewId,
    required List<AuditAnswerInput> answers,
    String? notes,
  }) async {
    await _delay();
    return {'success': true, 'message': 'Review submitted (mock)'};
  }
}
