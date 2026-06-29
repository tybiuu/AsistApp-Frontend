// lib/services/api_service.dart

import 'dart:convert';
import 'package:http/http.dart' as http;

import '../configs/constants.dart';
import 'preferences_service.dart';

class ApiService {
  final PreferencesService _prefs = PreferencesService();
  final String _base = Constants.baseUrl;

  Uri _uri(String path) => Uri.parse('$_base$path');

  Future<Map<String, String>> _headers({bool auth = false}) async {
    final Map<String, String> headers = {'Content-Type': 'application/json'};
    if (auth) {
      final String? token = await _prefs.getToken();
      if (token != null) headers['Authorization'] = 'Bearer $token';
    }
    return headers;
  }

  Map<String, dynamic> _parse(http.Response response) {
    final dynamic decoded = response.body.isNotEmpty ? jsonDecode(response.body) : {};
    final Map<String, dynamic> body = decoded is Map<String, dynamic> ? decoded : {};
    if (response.statusCode >= 200 && response.statusCode < 300) return body;
    throw Exception(
      body['error'] ?? 'Error del servidor (${response.statusCode})',
    );
  }

  Future<Map<String, dynamic>> get(String path, {bool auth = true}) async {
    final response = await http.get(
      _uri(path),
      headers: await _headers(auth: auth),
    );
    return _parse(response);
  }

  Future<Map<String, dynamic>> post(
    String path,
    Map<String, dynamic> body, {
    bool auth = false,
  }) async {
    final response = await http.post(
      _uri(path),
      headers: await _headers(auth: auth),
      body: jsonEncode(body),
    );
    return _parse(response);
  }

  Future<Map<String, dynamic>> put(
    String path,
    Map<String, dynamic> body, {
    bool auth = true,
  }) async {
    final response = await http.put(
      _uri(path),
      headers: await _headers(auth: auth),
      body: jsonEncode(body),
    );
    return _parse(response);
  }

  Future<void> delete(String path, {bool auth = true}) async {
    final response = await http.delete(
      _uri(path),
      headers: await _headers(auth: auth),
    );
    if (response.statusCode < 200 || response.statusCode >= 300) {
      _parse(response);
    }
  }
}
