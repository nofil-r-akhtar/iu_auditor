import 'dart:convert';
import 'package:get/get.dart';
import 'package:iu_auditor/screens/auth/login/login.dart';
import 'package:http/http.dart' as http;
import 'package:iu_auditor/apis/apis_end_points.dart';
import 'package:iu_auditor/const/enums.dart';
import 'package:iu_auditor/apis/connectivity.dart';
import 'package:iu_auditor/services/storage_service.dart';
import 'package:iu_auditor/services/user_session.dart';

class ApiRequest {
  final CheckConnectivity _connectivity = CheckConnectivity();

  static Map<String, String> headers = {'Content-Type': 'application/json'};

  static void setAuthToken(String token) {
    headers['Authorization'] = 'Bearer $token';
    // Persist for next app session — fire and forget
    StorageService().saveToken(token);
  }

  // FIX: token was never removed on logout, meaning a second user logging in
  // on the same session could briefly send the previous user's token.
  static void clearAuthToken() {
    headers.remove('Authorization');
    StorageService().clearToken();
    UserSession.clear();   // 🔑 also wipe cached profile
  }

  Future<Map<String, dynamic>> makeRequest({
    required String url,
    required Request method,
    Map<String, String>? headers,
    dynamic params,
    bool includeAuth = true,
  }) async {
    // Retry up to 2 times for network failures / timeouts.
    // This handles Render free-tier cold-starts where the first request
    // sometimes times out while the server is waking up.
    Object? lastError;
    for (int attempt = 0; attempt < 2; attempt++) {
      try {
        return await _attemptRequest(
          url: url, method: method,
          headers: headers, params: params,
        );
      } catch (e) {
        lastError = e;
        // Don't retry on 401/403 (session expired — already redirected)
        // or 400 (bad request — won't change on retry)
        final s = e.toString().toLowerCase();
        if (s.contains('session expired') ||
            s.contains('400')) {
          rethrow;
        }
        // Brief backoff before retry — gives server time to wake up
        if (attempt == 0) {
          await Future.delayed(const Duration(seconds: 2));
        }
      }
    }
    throw Exception('Error: $lastError');
  }

  Future<Map<String, dynamic>> _attemptRequest({
    required String url,
    required Request method,
    Map<String, String>? headers,
    dynamic params,
  }) async {
    try {
      bool isConnected = await _connectivity.isConnected();
      if (!isConnected) {
        throw Exception('No internet connection. Please check your network.');
      }

      Map<String, String> defaultHeaders = Map.from(ApiRequest.headers);

      if (headers != null) {
        defaultHeaders.addAll(headers);
      }

      http.Response response;

      switch (method) {
        case Request.get:
          Uri uri = params != null
              ? Uri.parse(
                  ApisEndPoints.startUrl + url,
                ).replace(queryParameters: params)
              : Uri.parse(ApisEndPoints.startUrl + url);
          response = await http.get(uri, headers: defaultHeaders);
          break;

        case Request.post:
          response = await http.post(
            Uri.parse(ApisEndPoints.startUrl + url),
            headers: defaultHeaders,
            body: jsonEncode(params),
          );
          break;

        case Request.put:
          response = await http.put(
            Uri.parse(ApisEndPoints.startUrl + url),
            headers: defaultHeaders,
            body: jsonEncode(params),
          );
          break;

        case Request.del:
          response = await http.delete(
            Uri.parse(ApisEndPoints.startUrl + url),
            headers: defaultHeaders,
          );
          break;
      }

      final responseBody = jsonDecode(response.body) as Map<String, dynamic>;

      if (response.statusCode == 200 || response.statusCode == 201) {
        return responseBody;
      } else if (response.statusCode == 401 || response.statusCode == 403) {
        // Token expired or invalid — clear it and bounce to login
        ApiRequest.clearAuthToken();
        // Avoid double-redirect if we're already on login page
        if (Get.currentRoute != '/Login' &&
            !(Get.currentRoute.toLowerCase().contains('login'))) {
          Get.offAll(() => const Login());
          Get.snackbar(
            'Session expired',
            'Please log in again.',
            snackPosition: SnackPosition.BOTTOM,
          );
        }
        throw Exception('Session expired');
      } else if (response.statusCode == 400) {
        if (responseBody.containsKey('message')) {
          return {'error': responseBody['message']};
        } else {
          throw Exception(
            'Error: Invalid response format for status code 400.',
          );
        }
      } else {
        throw Exception(
          'Error: ${response.statusCode}, Response: ${response.body}',
        );
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }
}