import 'dart:convert';

import 'package:flutter/services.dart';

import '../configs/generic_response.dart';
import '../models/attendance_request.dart';

class AttendanceRequestService {
  Future<GenericResponse<List<AttendanceRequest>>> fetchAll() async {
    try {
      final String jsonString = await rootBundle.loadString(
        'assets/jsons/mock_attendance_requests.json',
      );
      final List<dynamic> jsonList = json.decode(jsonString);
      final requests = jsonList
          .map((j) => AttendanceRequest.fromJson(j as Map<String, dynamic>))
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

  int countByStatus(List<AttendanceRequest> requests, String status) =>
      requests.where((r) => r.status.name == status).length;
}
