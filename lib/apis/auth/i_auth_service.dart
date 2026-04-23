import 'package:iu_auditor/modal_class/user/user_profile.dart';

abstract class IAuthService {
  /// Login — returns normalized map:
  ///   success, token, mustChangePassword, user (UserProfile)
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

  /// Fetch logged-in user's profile — requires token already set
  Future<UserProfile?> fetchProfile();

  /// Change password on first login (no OTP required — uses Bearer token)
  Future<Map<String, dynamic>> firstLoginChangePassword({
    required String newPassword,
  });
}