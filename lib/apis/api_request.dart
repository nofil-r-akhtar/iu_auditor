import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:iu_auditor/apis/apis_end_points.dart';
import 'package:iu_auditor/const/enums.dart';
import 'package:iu_auditor/apis/connectivity.dart';

class ApiRequest {
  final CheckConnectivity _connectivity = CheckConnectivity();

  static Map<String, String> headers = {'Content-Type': 'application/json'};

  static void setAuthToken(String token) {
    headers['Authorization'] = 'Bearer $token';
  }

  // FIX: token was never removed on logout, meaning a second user logging in
  // on the same session could briefly send the previous user's token.
  static void clearAuthToken() {
    headers.remove('Authorization');
  }

  Future<Map<String, dynamic>> makeRequest({
    required String url,
    required Request method,
    Map<String, String>? headers,
    dynamic params,
    bool includeAuth = true,
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
