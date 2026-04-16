/// ─────────────────────────────────────────────────────────────
/// AUTH SERVICE INTERFACE
/// ─────────────────────────────────────────────────────────────
/// This is the CONTRACT. Both [MockAuthService] and [RealAuthService]
/// must implement every method here.
///
/// Controllers depend ONLY on this interface — never on the
/// concrete implementations.
/// ─────────────────────────────────────────────────────────────
abstract class IAuthService {
  /// Logs in with [email] and [password].
  ///
  /// Returns a map containing at minimum:
  ///   - `success` (bool)
  ///   - `token` (String) — on success
  ///   - `message` (String) — on failure
  ///   - `user` (Map) — on success, contains name, role, etc.
  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  });

  /// Sends a password-reset OTP to [email].
  ///
  /// Returns a map containing at minimum:
  ///   - `success` (bool)
  ///   - `message` (String)
  Future<Map<String, dynamic>> forgotPassword({required String email});

  /// Verifies the [otp] sent to [email].
  ///
  /// Returns a map containing at minimum:
  ///   - `success` (bool)
  ///   - `message` (String)
  Future<Map<String, dynamic>> verifyOtp({
    required String email,
    required String otp,
  });

  /// Re-sends OTP to [email].
  ///
  /// Returns a map containing at minimum:
  ///   - `success` (bool)
  ///   - `message` (String)
  Future<Map<String, dynamic>> resendOtp({required String email});

  /// Resets the password using a verified [otp].
  ///
  /// Returns a map containing at minimum:
  ///   - `success` (bool)
  ///   - `message` (String)
  Future<Map<String, dynamic>> resetPassword({
    required String email,
    required String otp,
    required String newPassword,
  });
}
