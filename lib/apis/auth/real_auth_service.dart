import 'package:flutter/material.dart';
import 'package:iu_auditor/apis/api_request.dart';
import 'package:iu_auditor/apis/apis_end_points.dart';
import 'package:iu_auditor/apis/auth/i_auth_service.dart';
import 'package:iu_auditor/const/enums.dart';

/// ─────────────────────────────────────────────────────────────
/// REAL AUTH SERVICE
/// ─────────────────────────────────────────────────────────────
/// Implements [IAuthService] using the real HTTP backend.
///
/// The backend developer fills this file in.
/// Controllers are completely unaware of this class — they only
/// talk to [IAuthService] via the service locator.
/// ─────────────────────────────────────────────────────────────
class RealAuthService implements IAuthService {
  final ApiRequest _request = ApiRequest();

  @override
  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _request.makeRequest(
        url: ApisEndPoints.login,
        method: Request.post,
        params: {'email': email, 'password': password},
      );
      debugPrint('[RealAuthService] login executed');
      return response;
    } catch (e) {
      throw Exception('Login failed: $e');
    }
  }

  @override
  Future<Map<String, dynamic>> forgotPassword({required String email}) async {
    try {
      return await _request.makeRequest(
        url: ApisEndPoints.forgotPassword,
        method: Request.post,
        params: {'email': email},
      );
    } catch (e) {
      throw Exception('Forgot password failed: $e');
    }
  }

  @override
  Future<Map<String, dynamic>> verifyOtp({
    required String email,
    required String otp,
  }) async {
    try {
      return await _request.makeRequest(
        url: ApisEndPoints.verifyOtp,
        method: Request.post,
        params: {'email': email, 'otp_code': otp},
      );
    } catch (e) {
      throw Exception('OTP verification failed: $e');
    }
  }

  @override
  Future<Map<String, dynamic>> resendOtp({required String email}) async {
    try {
      return await _request.makeRequest(
        url: ApisEndPoints.resendOtp,
        method: Request.post,
        params: {'email': email},
      );
    } catch (e) {
      throw Exception('Resend OTP failed: $e');
    }
  }

  @override
  Future<Map<String, dynamic>> resetPassword({
    required String email,
    required String otp,
    required String newPassword,
  }) async {
    try {
      return await _request.makeRequest(
        url: ApisEndPoints.changePassword,
        method: Request.post,
        params: {'email': email, 'otp_code': otp, 'new_password': newPassword},
      );
    } catch (e) {
      throw Exception('Reset password failed: $e');
    }
  }
}
