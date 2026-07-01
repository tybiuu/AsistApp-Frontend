// lib/services/organization_service.dart

import 'dart:convert';
import 'package:asist_app/configs/constants.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../configs/generic_response.dart';
import '../models/organization.dart';
import 'api_service.dart';
import 'preferences_service.dart';
import 'session_service.dart';

class OrganizationService {
  final PreferencesService _prefs = PreferencesService();
  ApiService get _api => Get.find<ApiService>();

  Future<GenericResponse<Organization>> fetchCurrent({String? organizationId}) async {
    final String? orgId = organizationId ?? SessionService.to.currentUser.value?.organizationId;
    if (orgId == null || orgId.isEmpty) {
      return GenericResponse(
        success: false,
        data: null,
        message: 'No tienes una organización asignada.',
      );
    }

    try {
      final Map<String, dynamic> data = await _api.get('organizations/$orgId');
      return GenericResponse(
        success: true,
        data: Organization.fromJson(data),
        message: 'Organización obtenida con éxito.',
      );
    } catch (e, stackTrace) {
      return GenericResponse(
        success: false,
        data: null,
        message: e.toString().replaceFirst('Exception: ', ''),
        error: stackTrace.toString(),
      );
    }
  }

  Future<Organization> fetchById(String id) async {
    final Map<String, dynamic> data = await _api.get('organizations/$id');
    return Organization.fromJson(data);
  }

  Future<Organization> createOrganization({
    required String name,
    required int lateTimeLimit,
    String? description,
    String? photoUrl,
  }) async {
    final Map<String, dynamic> body = {
      'name': name,
      'lateTimeLimit': lateTimeLimit,
      if (description != null && description.isNotEmpty) 'description': description,
      if (photoUrl != null && photoUrl.isNotEmpty) 'photoUrl': photoUrl,
    };
    final Map<String, dynamic> data = await _api.post('organizations', body, auth: true);
    return Organization.fromJson(data);
  }

  Future<String> uploadPhoto(Uint8List bytes, String filename) async {
    final Map<String, dynamic> data = await _api.uploadFile('uploads', bytes, filename);
    final String relativeUrl = data['url'] as String;
    return Uri.parse(Constants.baseUrl).resolve(relativeUrl).toString();
  }

  Future<Organization> fetchByCode(String code) async {
    final Map<String, dynamic> data = await _api.get(
      'organizations?code=${Uri.encodeComponent(code)}',
    );
    return Organization.fromJson(data);
  }

  Future<GenericResponse<Organization>> updateOrganization(String id, Map<String, dynamic> data) async {
    try {
      final String baseURL = Constants.baseUrl;
      final url = Uri.parse('${baseURL}organizations/$id');
      final String? token = await _prefs.getToken();

      final response = await http.put(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(data),
      );

      final Map<String, dynamic> body = jsonDecode(response.body);

      if (response.statusCode == 200) {
        final updatedOrg = Organization.fromJson(body);
        return GenericResponse<Organization>(
          success: true,
          data: updatedOrg,
          message: 'Organización actualizada exitosamente',
        );
      } else {
        final String errorMessage = body['error'] as String? ?? 'Error al actualizar la organización.';
        return GenericResponse<Organization>(
          success: false,
          data: null,
          message: errorMessage,
        );
      }
    } catch (e, stackTrace) {
      return GenericResponse<Organization>(
        success: false,
        data: null,
        message: 'No se pudo conectar con el servidor.',
        error: stackTrace.toString(),
      );
    }
  }
}
