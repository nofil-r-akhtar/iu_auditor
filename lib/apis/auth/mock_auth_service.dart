import 'package:flutter/material.dart';
import 'package:iu_auditor/apis/api_config.dart';
import 'package:iu_auditor/apis/auth/i_auth_service.dart';
import 'package:iu_auditor/modal_class/user/user_profile.dart';

class MockAuthService implements IAuthService {
  static const String _validEmail    = 'auditor@iqra.edu.pk';
  static const String _validPassword = '123456';
  static const String _validOtp      = '1234';

  final Map<String, String> _pendingOtps = {};

  Future<void> _delay() => Future.delayed(ApiConfig.mockDelay);

  @override
  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    await _delay();
    if (email == _validEmail && password == _validPassword) {
      return {
        'success':            true,
        'message':            'Login successful',
        'token':              'mock_jwt_token_xyz_123',
        'mustChangePassword': false,
        'user': UserProfile(
          id:         '1',
          name:       'Dr. Sarah Ahmed',
          email:      email,
          role:       'senior_lecturer',
          department: 'Computer Science',
        ),
      };
    }
    return {'success': false, 'message': 'Invalid email or password.'};
  }

  @override
  Future<Map<String, dynamic>> forgotPassword({required String email}) async {
    await _delay();
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
    final expected = _pendingOtps[email];
    if (expected != null && otp == expected) {
      return {'success': true, 'message': 'OTP verified successfully.'};
    }
    return {'success': false, 'message': 'Invalid or expired OTP.'};
  }

  @override
  Future<Map<String, dynamic>> resendOtp({required String email}) async {
    await _delay();
    if (email == _validEmail) {
      _pendingOtps[email] = _validOtp;
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
    final expected = _pendingOtps[email];
    if (expected != null && otp == expected) {
      _pendingOtps.remove(email);
      return {'success': true, 'message': 'Password reset successfully.'};
    }
    return {'success': false, 'message': 'OTP is invalid or has expired.'};
  }

  @override
  Future<UserProfile?> fetchProfile() async {
    await _delay();
    return UserProfile(
      id:         '1',
      name:       'Dr. Sarah Ahmed',
      email:      _validEmail,
      role:       'senior_lecturer',
      department: 'Computer Science',
    );
  }

  @override
  Future<Map<String, dynamic>> firstLoginChangePassword({
    required String email,
    required String oldPassword,
    required String newPassword,
  }) async {
    await _delay();
    return {'success': true, 'message': 'Password changed successfully.'};
  }
}