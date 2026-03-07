import 'package:flutter/material.dart';
import 'package:iu_auditor/apis/api_request.dart';
import 'package:iu_auditor/apis/apis_end_points.dart';
import 'package:iu_auditor/const/enums.dart';

class Auth {

  ApiRequest request = ApiRequest();
  ApisEndPoints api = ApisEndPoints();

  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    try {
      
      final response = await request.makeRequest(
        url: api.login,
        method: Request.post,
        params: {
          'email': email,
          'password': password,
        },
      );
      debugPrint("API Executed");
      return response;
    } catch (e) {
      throw Exception('Login failed: $e');
    }
  }

  Future<Map<String, dynamic>> forgetPassword({
    required String email,
  }) async {
    try {
      final response = await request.makeRequest(
        url: api.forgotPassword,
        method: Request.post,
        params: {
          'email': email,
        },
      );
      return response;
    } catch (e) {
      throw Exception('Forget password failed: $e');
    }
  }

  Future<Map<String, dynamic>> verifyOtp({
    required String email,
    required String otp,
  }) async {
    try {
      final response = await request.makeRequest(
        url: api.verifyOtp,
        method: Request.post,
        params: {
          'email': email,
          'otp_code': otp,
        },
      );
      return response;
    } catch (e) {
      throw Exception('OTP verification failed: $e');
    }
  }

  Future<Map<String, dynamic>> resendOtp({
    required String email,
  }) async {
    try {
      final response = await request.makeRequest(
        url: api.resendOtp,
        method: Request.post,
        params: {
          'email': email,
        },
      );
      return response;
    } catch (e) {
      throw Exception('Resend OTP failed: $e');
    }
  }

  Future<Map<String, dynamic>> resetPassword({
    required String email,
    required String otp,
    required String newPassword,
  }) async {
    try {
      final response = await request.makeRequest(
        url: api.changePassword,
        method: Request.post,
        params: {
          'email': email,
          'otp_code': otp,
          'new_password': newPassword,
        },
      );
      return response;
    } catch (e) {
      throw Exception('Reset password failed: $e');
    }
  }
}