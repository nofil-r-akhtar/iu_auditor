import 'package:get/get.dart';
import 'package:iu_auditor/apis/api_config.dart';
import 'package:iu_auditor/apis/auth/i_auth_service.dart';
import 'package:iu_auditor/apis/auth/mock_auth_service.dart';
import 'package:iu_auditor/apis/auth/real_auth_service.dart';

/// ─────────────────────────────────────────────────────────────
/// SERVICE LOCATOR
/// ─────────────────────────────────────────────────────────────
/// Registers the correct service implementations based on
/// [ApiConfig.useMock].
///
/// Called ONCE in [main.dart] before [runApp].
///
/// When the backend is ready:
///   1. Set [ApiConfig.useMock] = false
///   2. That's it. No other file needs to change.
/// ─────────────────────────────────────────────────────────────
class ServiceLocator {
  ServiceLocator._();

  static void init() {
    if (ApiConfig.useMock) {
      // ── MOCK MODE ──
      Get.put<IAuthService>(MockAuthService());
    } else {
      // ── REAL API MODE ──
      Get.put<IAuthService>(RealAuthService());
    }
  }
}
