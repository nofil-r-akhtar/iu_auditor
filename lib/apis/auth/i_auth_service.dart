import 'package:iu_auditor/modal_class/user/user_profile.dart';

abstract class IAuthService {
  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  });

  Future<Map<String, dynamic>> forgotPassword({required String email});

  Future<Map<String, dynamic>> verifyOtp({
    required String email,
    required String otp,
  });

  Future<Map<String, dynamic>> resendOtp({required String email});

  Future<Map<String, dynamic>> resetPassword({
    required String email,
    required String otp,
    required String newPassword,
  });

  Future<UserProfile?> fetchProfile();

  /// Change password on first login.
  /// Backend requires the email + old (temporary) password
  /// in addition to the new one.
  Future<Map<String, dynamic>> firstLoginChangePassword({
    required String email,
    required String oldPassword,
    required String newPassword,
  });
}