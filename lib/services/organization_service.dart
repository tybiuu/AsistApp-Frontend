// lib/services/organization_service.dart

import 'dart:convert';

import 'package:flutter/services.dart';

import '../configs/generic_response.dart';
import '../models/organization.dart';

class OrganizationService {
  Future<GenericResponse<Organization>> fetchCurrent() async {
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
}
