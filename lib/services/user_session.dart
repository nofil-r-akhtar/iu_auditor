import 'package:iu_auditor/apis/auth/i_auth_service.dart';
import 'package:iu_auditor/modal_class/user/user_profile.dart';

/// Holds the current user's profile in memory so we never fetch /auth/me
/// more than once per session.
///
/// Pattern: Login (or Splash) calls fetchProfile() once and stores the result
/// here. Other controllers (Home, Audits) read from the cache instead of
/// firing their own duplicate /auth/me requests.
class UserSession {
  UserSession._();

  static UserProfile? _cached;

  /// True when a profile is already loaded.
  static bool get hasProfile => _cached != null;

  /// Read the cached profile (may be null if not loaded yet).
  static UserProfile? get profile => _cached;

  /// Get the profile — uses cache if present, fetches and caches if not.
  /// Pass [forceRefresh: true] after profile-changing actions
  /// (e.g. password change).
  static Future<UserProfile?> get(
    IAuthService auth, {
    bool forceRefresh = false,
  }) async {
    if (!forceRefresh && _cached != null) return _cached;
    final fresh = await auth.fetchProfile();
    if (fresh != null) _cached = fresh;
    return _cached;
  }

  /// Set the profile directly (e.g. when login already returned the user).
  static void set(UserProfile profile) {
    _cached = profile;
  }

  /// Clear on logout / token expiry.
  static void clear() {
    _cached = null;
  }
}