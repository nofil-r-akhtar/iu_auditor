class ApiConfig {
  ApiConfig._();

  /// false = real API, true = mock data
  static const bool useMock = false;

  static const Duration mockDelay = Duration(milliseconds: 800);
}