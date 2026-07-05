import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/constants.dart';

/// Manejo de sesión (equivalente a TokenManager.kt).
class TokenManager {
  Future<void> saveSession(int userId, String token, String email) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(AppConstants.keyUserId, userId);
    await prefs.setString(AppConstants.keyAuthToken, token);
    await prefs.setString(AppConstants.keyUserEmail, email);
    await prefs.setBool(AppConstants.keyIsLoggedIn, true);
  }

  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(AppConstants.keyAuthToken);
  }

  Future<int?> getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(AppConstants.keyUserId);
  }

  Future<String?> getEmail() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(AppConstants.keyUserEmail);
  }

  Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(AppConstants.keyIsLoggedIn) ?? false;
  }

  Future<void> clear() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}

/// Excepción de API con mensaje legible.
class ApiException implements Exception {
  final int statusCode;
  final String message;
  ApiException(this.statusCode, this.message);

  @override
  String toString() => 'Error $statusCode: $message';
}

/// Cliente HTTP central. Agrega el Bearer token automáticamente
/// (equivalente al AuthInterceptor de OkHttp en el front Android).
class ApiClient {
  final TokenManager tokenManager;
  final http.Client _client = http.Client();

  ApiClient({required this.tokenManager});

  Uri _uri(String path, [Map<String, String>? query]) =>
      Uri.parse('${AppConstants.baseUrl}$path')
          .replace(queryParameters: query);

  Future<Map<String, String>> _headers() async {
    final token = await tokenManager.getToken();
    return {
      'Content-Type': 'application/json',
      if (token != null && token.isNotEmpty) 'Authorization': 'Bearer $token',
    };
  }

  dynamic _decode(http.Response res) {
    if (res.statusCode >= 200 && res.statusCode < 300) {
      if (res.body.isEmpty) return null;
      return jsonDecode(utf8.decode(res.bodyBytes));
    }
    String message = res.body;
    try {
      final body = jsonDecode(res.body);
      if (body is Map && body['message'] != null) {
        message = body['message'].toString();
      }
    } catch (_) {}
    throw ApiException(res.statusCode, message);
  }

  Future<dynamic> get(String path, {Map<String, String>? query}) async {
    final res = await _client
        .get(_uri(path, query), headers: await _headers())
        .timeout(AppConstants.connectTimeout);
    return _decode(res);
  }

  Future<dynamic> post(String path, {Object? body}) async {
    final res = await _client
        .post(_uri(path),
            headers: await _headers(),
            body: body != null ? jsonEncode(body) : null)
        .timeout(AppConstants.connectTimeout);
    return _decode(res);
  }

  Future<dynamic> put(String path, {Object? body}) async {
    final res = await _client
        .put(_uri(path),
            headers: await _headers(),
            body: body != null ? jsonEncode(body) : null)
        .timeout(AppConstants.connectTimeout);
    return _decode(res);
  }

  Future<dynamic> patch(String path, {Map<String, String>? query}) async {
    final res = await _client
        .patch(_uri(path, query), headers: await _headers())
        .timeout(AppConstants.connectTimeout);
    return _decode(res);
  }

  Future<dynamic> delete(String path) async {
    final res = await _client
        .delete(_uri(path), headers: await _headers())
        .timeout(AppConstants.connectTimeout);
    return _decode(res);
  }
}
