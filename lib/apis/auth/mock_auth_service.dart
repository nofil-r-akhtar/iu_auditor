import 'package:flutter/material.dart';
import 'package:iu_auditor/apis/auth/i_auth_service.dart';
import 'package:iu_auditor/apis/api_config.dart';

/// ─────────────────────────────────────────────────────────────
/// MOCK AUTH SERVICE
/// ─────────────────────────────────────────────────────────────
/// Simulates the real API with fake data and realistic delays.
/// All mock credentials and OTP codes are documented below.
///
/// MOCK CREDENTIALS:
///   Email    : admin@iqra.edu.pk
///   Password : 123456
///   OTP      : 1234  (any email)
///
/// This file is NEVER touched once the real API is ready.
/// ─────────────────────────────────────────────────────────────
class MockAuthService implements IAuthService {
  // The only valid mock credentials
  static const String _validEmail = 'admin@iqra.edu.pk';
  static const String _validPassword = '123456';
  static const String _validOtp = '1234';

  // Tracks OTP request state per email (simulates server-side OTP)
  final Map<String, String> _pendingOtps = {};

  /// Simulates network latency
  Future<void> _delay() => Future.delayed(ApiConfig.mockDelay);

  @override
  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    await _delay();
    debugPrint('[MockAuthService] login(email: $email)');

    if (email == _validEmail && password == _validPassword) {
      return {
        'success': true,
        'message': 'Login successful',
        'token': 'mock_jwt_token_xyz_123',
        'user': {
          'id': 1,
          'name': 'Dr. Sarah Ahmed',
          'email': email,
          'role': 'Auditor',
          'initials': 'S',
        },
      };
    }

    return {'success': false, 'message': 'Invalid email or password.'};
  }

  @override
  Future<Map<String, dynamic>> forgotPassword({required String email}) async {
    await _delay();
    debugPrint('[MockAuthService] forgotPassword(email: $email)');

    // Simulate: only registered emails get an OTP
    if (email == _validEmail) {
      _pendingOtps[email] = _validOtp;
      return {'success': true, 'message': 'OTP sent to $email'};
    }

    return {'success': false, 'message': 'No account found with this email.'};
  }

  @override
  Future<Map<String, dynamic>> verifyOtp({
    required String email,
    required String otp,
  }) async {
    await _delay();
    debugPrint('[MockAuthService] verifyOtp(email: $email, otp: $otp)');

    final expected = _pendingOtps[email];

    if (expected != null && otp == expected) {
      return {'success': true, 'message': 'OTP verified successfully.'};
    }

    return {'success': false, 'message': 'Invalid or expired OTP.'};
  }

  @override
  Future<Map<String, dynamic>> resendOtp({required String email}) async {
    await _delay();
    debugPrint('[MockAuthService] resendOtp(email: $email)');

    if (email == _validEmail) {
      _pendingOtps[email] = _validOtp; // refresh the OTP
      return {'success': true, 'message': 'OTP resent to $email'};
    }

    return {'success': false, 'message': 'No account found with this email.'};
  }

  @override
  Future<Map<String, dynamic>> resetPassword({
    required String email,
    required String otp,
    required String newPassword,
  }) async {
    await _delay();
    debugPrint('[MockAuthService] resetPassword(email: $email)');

    final expected = _pendingOtps[email];

    if (expected != null && otp == expected) {
      _pendingOtps.remove(email); // OTP consumed
      return {'success': true, 'message': 'Password reset successfully.'};
    }

    return {'success': false, 'message': 'OTP is invalid or has expired.'};
  }
}
