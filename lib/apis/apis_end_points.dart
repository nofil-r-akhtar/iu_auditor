class ApisEndPoints {
  static const String startUrl =
      "https://iu-auditor-admin-backend.onrender.com/api/";

  // ── AUTH ─────────────────────────────────────────────
  static const String login                    = "auth/login";
  static const String forgotPassword           = "auth/forgot-password";
  static const String verifyOtp                = "auth/verify-otp";
  static const String resendOtp                = "auth/resend-otp";
  static const String changePassword           = "auth/change-password";
  static const String userProfile              = "auth/me";
  static const String firstLoginChangePassword = "auth/first-login-change-password";

  // ── AUDIT REVIEWS (senior lecturer) ──────────────────
  static const String myReviews                = "audit-reviews/my/reviews";
  static String reviewById(String id)          => "audit-reviews/$id";
  static String submitReview(String id)        => "audit-reviews/$id/submit";

  // ── AUDIT FORMS (questions) ──────────────────────────
  static String formQuestions(String formId)   => "audit/forms/$formId/questions/";
}
