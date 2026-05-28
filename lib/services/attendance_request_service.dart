// lib/services/attendance_request_service.dart

import 'dart:convert';

import 'package:flutter/services.dart';

import '../configs/generic_response.dart';

class AttendanceRequestService {
  Future<GenericResponse<List<Map<String, dynamic>>>> fetchAll() async {
    try {
      final String jsonString = await rootBundle.loadString(
        'assets/jsons/mock_attendance_requests.json',
      );
      final List<dynamic> jsonList = json.decode(jsonString);
      final List<Map<String, dynamic>> requests = jsonList
          .map((json) => json as Map<String, dynamic>)
          .toList();

      return GenericResponse(
        success: true,
        data: requests,
        message: 'Solicitudes de asistencia',
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

  int countByStatus(List<Map<String, dynamic>> requests, String status) {
    return requests.where((request) => request['status'] == status).length;
  }
}
