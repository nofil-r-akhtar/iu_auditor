/// ─────────────────────────────────────────────────────────────
/// API CONFIG
/// ─────────────────────────────────────────────────────────────
/// Set [useMock] to false when the real backend is ready.
/// That is the ONLY change needed to switch the entire app.
/// ─────────────────────────────────────────────────────────────
class ApiConfig {
  ApiConfig._();

  /// Toggle this to switch between mock and real API.
  static const bool useMock = true;

  /// Simulated network delay for mock responses.
  static const Duration mockDelay = Duration(milliseconds: 800);
}
