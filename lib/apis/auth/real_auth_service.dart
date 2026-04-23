import 'package:flutter/material.dart';
import 'package:iu_auditor/apis/api_request.dart';
import 'package:iu_auditor/apis/apis_end_points.dart';
import 'package:iu_auditor/apis/auth/i_auth_service.dart';
import 'package:iu_auditor/const/enums.dart';
import 'package:iu_auditor/modal_class/user/user_profile.dart';

class RealAuthService implements IAuthService {
  final ApiRequest _request = ApiRequest();

  @override
  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    try {
      final raw = await _request.makeRequest(
        url: ApisEndPoints.login,
        method: Request.post,
        params: {'email': email, 'password': password},
      );

      // Backend returns:
      // { success, message, data: { access_token, token_type,
      //   must_change_password, user: { id, name, email, role } } }
      if (raw['success'] != true) {
        return {
          'success': false,
          'message': raw['message'] ?? 'Login failed',
        };
      }

      final data = raw['data'] as Map<String, dynamic>? ?? {};
      final user = data['user'] as Map<String, dynamic>? ?? {};

      return {
        'success':           true,
        'token':             data['access_token']?.toString() ?? '',
        'mustChangePassword': data['must_change_password'] == true,
        'user':              UserProfile.fromJson(user),
        'message':           raw['message'] ?? 'Login successful',
      };
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
        params: {
          'email':        email,
          'otp_code':     otp,
          'new_password': newPassword,
        },
      );
    } catch (e) {
      throw Exception('Reset password failed: $e');
    }
  }

  @override
  Future<UserProfile?> fetchProfile() async {
    try {
      final raw = await _request.makeRequest(
        url: ApisEndPoints.userProfile,
        method: Request.get,
      );
      if (raw['success'] != true) return null;
      final data = raw['data'] as Map<String, dynamic>? ?? raw;
      return UserProfile.fromJson(data);
    } catch (e) {
      debugPrint('fetchProfile error: $e');
      return null;
    }
  }

  @override
  Future<Map<String, dynamic>> firstLoginChangePassword({
    required String newPassword,
  }) async {
    try {
      return await _request.makeRequest(
        url: ApisEndPoints.firstLoginChangePassword,
        method: Request.post,
        params: {'new_password': newPassword},
      );
    } catch (e) {
      throw Exception('First login change password failed: $e');
    }
  }
}