// lib/services/attendance_record_service.dart

import 'dart:convert';

import 'package:flutter/services.dart';

import '../configs/generic_response.dart';

class AttendanceRecordService {
  Future<GenericResponse<List<Map<String, dynamic>>>> fetchAll() async {
    try {
      final String jsonString = await rootBundle.loadString(
        'assets/jsons/mock_attendance_records.json',
      );
      final List<dynamic> jsonList = json.decode(jsonString);
      final List<Map<String, dynamic>> records = jsonList
          .map((json) => json as Map<String, dynamic>)
          .toList();

      return GenericResponse(
        success: true,
        data: records,
        message: 'Registros de asistencia',
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

  String latestDate(List<Map<String, dynamic>> records) {
    final List<String> dates =
        records
            .map((record) => record['date'] as String? ?? '')
            .where((date) => date.isNotEmpty)
            .toList()
          ..sort();

    return dates.isEmpty ? '' : dates.last;
  }

  int countByStatus(List<Map<String, dynamic>> records, String status) {
    return records.where((record) => record['status'] == status).length;
  }
}
