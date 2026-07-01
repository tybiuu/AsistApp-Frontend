// lib/services/api_service.dart

import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

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

  Map<String, dynamic> _parse(http.Response response, String method, Uri uri) {
    debugPrint('[$method] ${uri.toString()} → ${response.statusCode}');
    debugPrint('  body: ${response.body}');
    final dynamic decoded = response.body.isNotEmpty ? jsonDecode(response.body) : {};
    final Map<String, dynamic> body = decoded is Map<String, dynamic> ? decoded : {};
    if (response.statusCode >= 200 && response.statusCode < 300) return body;
    throw Exception(
      body['error'] ?? 'Error del servidor (${response.statusCode})',
    );
  }

  Future<Map<String, dynamic>> get(String path, {bool auth = true}) async {
    final uri = _uri(path);
    debugPrint('[GET] → $uri');
    final response = await http.get(uri, headers: await _headers(auth: auth));
    return _parse(response, 'GET', uri);
  }

  Future<List<dynamic>> getList(String path, {bool auth = true}) async {
    final uri = _uri(path);
    debugPrint('[GET] → $uri');
    final response = await http.get(uri, headers: await _headers(auth: auth));
    debugPrint('[GET] $uri → ${response.statusCode}');
    debugPrint('  body: ${response.body}');
    final dynamic decoded = response.body.isNotEmpty ? jsonDecode(response.body) : [];
    if (response.statusCode >= 200 && response.statusCode < 300) {
      return decoded is List ? decoded : [];
    }
    final Map<String, dynamic> body = decoded is Map<String, dynamic> ? decoded : {};
    throw Exception(body['error'] ?? 'Error del servidor (${response.statusCode})');
  }

  Future<Map<String, dynamic>> post(
    String path,
    Map<String, dynamic> body, {
    bool auth = false,
  }) async {
    final uri = _uri(path);
    debugPrint('[POST] → $uri | body: ${jsonEncode(body)}');
    final response = await http.post(
      uri,
      headers: await _headers(auth: auth),
      body: jsonEncode(body),
    );
    return _parse(response, 'POST', uri);
  }

  Future<Map<String, dynamic>> put(
    String path,
    Map<String, dynamic> body, {
    bool auth = true,
  }) async {
    final uri = _uri(path);
    debugPrint('[PUT] → $uri | body: ${jsonEncode(body)}');
    final response = await http.put(
      uri,
      headers: await _headers(auth: auth),
      body: jsonEncode(body),
    );
    return _parse(response, 'PUT', uri);
  }

  Future<Map<String, dynamic>> uploadFile(
    String path,
    Uint8List bytes,
    String filename, {
    bool auth = true,
  }) async {
    final uri = _uri(path);
    debugPrint('[UPLOAD] → $uri | file: $filename (${bytes.length} bytes)');

    final request = http.MultipartRequest('POST', uri);
    final String? token = auth ? await _prefs.getToken() : null;
    if (token != null) request.headers['Authorization'] = 'Bearer $token';
    request.files.add(http.MultipartFile.fromBytes(
      'file',
      bytes,
      filename: filename,
      contentType: MediaType('image', _extensionOf(filename)),
    ));

    final streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);
    return _parse(response, 'UPLOAD', uri);
  }

  String _extensionOf(String filename) {
    final String ext = filename.split('.').last.toLowerCase();
    return ext == 'jpg' ? 'jpeg' : ext;
  }

  Future<void> delete(String path, {bool auth = true}) async {
    final uri = _uri(path);
    debugPrint('[DELETE] → $uri');
    final response = await http.delete(uri, headers: await _headers(auth: auth));
    if (response.statusCode < 200 || response.statusCode >= 300) {
      _parse(response, 'DELETE', uri);
    } else {
      debugPrint('[DELETE] $uri → ${response.statusCode}');
    }
  }
}
