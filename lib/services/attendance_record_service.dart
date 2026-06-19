import 'dart:convert';

import 'package:flutter/services.dart';

import '../configs/generic_response.dart';
import '../models/attendance_record.dart';

class AttendanceRecordService {
  Future<GenericResponse<List<AttendanceRecord>>> fetchAll() async {
    try {
      final String jsonString = await rootBundle.loadString(
        'assets/jsons/mock_attendance_records.json',
      );
      final List<dynamic> jsonList = json.decode(jsonString);
      final records = jsonList
          .map((j) => AttendanceRecord.fromJson(j as Map<String, dynamic>))
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

  String latestDate(List<AttendanceRecord> records) {
    final dates = records
        .map((r) => r.date)
        .where((d) => d.isNotEmpty)
        .toList()
      ..sort();
    return dates.isEmpty ? '' : dates.last;
  }

  int countByStatus(List<AttendanceRecord> records, String status) =>
      records.where((r) => r.status.name == status).length;
}
