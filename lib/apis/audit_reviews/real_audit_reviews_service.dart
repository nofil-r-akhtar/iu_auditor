import 'package:flutter/material.dart';
import 'package:iu_auditor/apis/api_request.dart';
import 'package:iu_auditor/apis/apis_end_points.dart';
import 'package:iu_auditor/apis/audit_reviews/i_audit_reviews_service.dart';
import 'package:iu_auditor/const/enums.dart';
import 'package:iu_auditor/modal_class/audit/audit_review_model.dart';
import 'package:iu_auditor/modal_class/audit/audit_question_model.dart';

class RealAuditReviewsService implements IAuditReviewsService {
  final ApiRequest _request = ApiRequest();

  @override
  Future<List<AuditReview>> getMyReviews() async {
    try {
      final raw = await _request.makeRequest(
        url: ApisEndPoints.myReviews,
        method: Request.get,
      );
      if (raw['success'] != true) return [];
      final list = raw['data'] as List<dynamic>? ?? [];
      return list
          .map((e) => AuditReview.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (e) {
      debugPrint('getMyReviews error: $e');
      return [];
    }
  }

  @override
  Future<AuditReview?> getReviewById(String id) async {
    try {
      final raw = await _request.makeRequest(
        url: ApisEndPoints.reviewById(id),
        method: Request.get,
      );
      if (raw['success'] != true) return null;
      final data = raw['data'] as Map<String, dynamic>?;
      if (data == null) return null;
      return AuditReview.fromJson(data);
    } catch (e) {
      debugPrint('getReviewById error: $e');
      return null;
    }
  }

  @override
  Future<List<AuditQuestionApi>> getFormQuestions(String formId) async {
    try {
      final raw = await _request.makeRequest(
        url: ApisEndPoints.formQuestions(formId),
        method: Request.get,
      );
      if (raw['success'] != true) return [];
      final list = raw['data'] as List<dynamic>? ?? [];
      return list
          .map((e) => AuditQuestionApi.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (e) {
      debugPrint('getFormQuestions error: $e');
      return [];
    }
  }

  @override
  Future<Map<String, dynamic>> submitReview({
    required String reviewId,
    required List<AuditAnswerInput> answers,
    String? notes,
  }) async {
    try {
      return await _request.makeRequest(
        url: ApisEndPoints.submitReview(reviewId),
        method: Request.post,
        params: {
          if (notes != null && notes.isNotEmpty) 'notes': notes,
          'answers': answers.map((a) => a.toJson()).toList(),
        },
      );
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }
}
