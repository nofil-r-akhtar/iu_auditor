import 'package:shared_preferences/shared_preferences.dart';

/// Persists the auth token between app sessions so the user
/// stays logged in after a reload or re-open.
class StorageService {
  StorageService._();
  static final StorageService _instance = StorageService._();
  factory StorageService() => _instance;

  static const String _kAuthToken = 'auth_token';
  static const String _kSavedAt   = 'auth_token_saved_at';

  // Tokens issued by the backend last 60 minutes by default.
  // We treat them as expired after 55 minutes to give a buffer.
  static const Duration _tokenLifetime = Duration(minutes: 55);

  SharedPreferences? _prefs;

  /// Must be called once before runApp().
  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  Future<void> saveToken(String token) async {
    await _prefs?.setString(_kAuthToken, token);
    await _prefs?.setInt(_kSavedAt,
        DateTime.now().millisecondsSinceEpoch);
  }

  String? get token => _prefs?.getString(_kAuthToken);

  /// True when a non-empty token exists AND it's within the lifetime window.
  bool get hasValidToken {
    final t = token;
    if (t == null || t.isEmpty) return false;

    final savedAt = _prefs?.getInt(_kSavedAt);
    if (savedAt == null) return false;

    final age = DateTime.now().millisecondsSinceEpoch - savedAt;
    return age < _tokenLifetime.inMilliseconds;
  }

  Future<void> clearToken() async {
    await _prefs?.remove(_kAuthToken);
    await _prefs?.remove(_kSavedAt);
  }
}