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

class OrganizationService {
  final PreferencesService _prefs = PreferencesService();
  ApiService get _api => Get.find<ApiService>();

  Future<GenericResponse<Organization>> fetchCurrent({String? organizationId}) async {
    if (organizationId == null || organizationId.isEmpty) {
      try {
        final String jsonString = await rootBundle.loadString(
          'assets/jsons/mock_organization.json',
        );
        final Map<String, dynamic> jsonMap = json.decode(jsonString);
        final Organization organization = Organization.fromJson(
          jsonMap['organization'] ?? <String, dynamic>{},
        );

        return GenericResponse(
          success: true,
          data: organization,
          message: 'Organización actual',
          error: null,
        );
      } catch (e, stackTrace) {
        return GenericResponse(
          success: false,
          data: null,
          message: 'Ocurrió un error no esperado',
          error: stackTrace.toString(),
        );
      }
    }

    try {
      final String baseURL = Constants.baseUrl;
      final url = Uri.parse('${baseURL}organizations/$organizationId');
      final String? token = await _prefs.getToken();

      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );
      final Map<String, dynamic> body = jsonDecode(response.body);

      if (response.statusCode == 200) {
        final organization = Organization.fromJson(body);
        return GenericResponse(
          success: true,
          data: organization,
          message: 'Organización obtenida con éxito.',
          error: null,
        );
      } else {
        final String errorMessage = body['error'] as String? ?? 'Error al obtener la organización.';
        return GenericResponse(
          success: false,
          data: null,
          message: errorMessage,
        );
      }
    } catch (e, stackTrace) {
      return GenericResponse(
        success: false,
        data: null,
        message: 'No se pudo conectar con el servidor.',
        error: stackTrace.toString(),
      );
    }
  }

  Future<Organization> createOrganization({
    required String name,
    required String code,
    required int lateTimeLimit,
    String? description,
  }) async {
    final Map<String, dynamic> body = {
      'name': name,
      'code': code,
      'lateTimeLimit': lateTimeLimit,
      if (description != null && description.isNotEmpty) 'description': description,
    };
    final Map<String, dynamic> data = await _api.post('organizations', body);
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
