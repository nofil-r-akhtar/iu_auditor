import 'package:get/get.dart';
import 'package:iu_auditor/apis/api_config.dart';
import 'package:iu_auditor/apis/auth/i_auth_service.dart';
import 'package:iu_auditor/apis/auth/mock_auth_service.dart';
import 'package:iu_auditor/apis/auth/real_auth_service.dart';
import 'package:iu_auditor/apis/audit_reviews/i_audit_reviews_service.dart';
import 'package:iu_auditor/apis/audit_reviews/mock_audit_reviews_service.dart';
import 'package:iu_auditor/apis/audit_reviews/real_audit_reviews_service.dart';

class ServiceLocator {
  ServiceLocator._();

  static void init() {
    if (ApiConfig.useMock) {
      // ── MOCK MODE ──
      Get.put<IAuthService>(MockAuthService());
      Get.put<IAuditReviewsService>(MockAuditReviewsService());
    } else {
      // ── REAL API MODE ──
      Get.put<IAuthService>(RealAuthService());
      Get.put<IAuditReviewsService>(RealAuditReviewsService());
    }
  }
}
