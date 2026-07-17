import 'package:get/get.dart';

import '../configs/generic_response.dart';
import '../models/attendance_record.dart';
import 'api_service.dart';

class AttendanceRecordService {
  ApiService get _api => Get.find<ApiService>();

  Future<GenericResponse<List<AttendanceRecord>>> fetchAll() async {
    try {
      final List<dynamic> data = await _api.getList('attendance-records');
      final records = data
          .map((j) => AttendanceRecord.fromJson(j as Map<String, dynamic>))
          .toList();

      return GenericResponse(
        success: true,
        data: records,
        message: 'Registros de asistencia',
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

  /// Crea el registro de asistencia del día con la marca de ingreso.
  Future<GenericResponse<AttendanceRecord>> markCheckIn({
    required String userId,
    required String organizationId,
    required String date,
    required DateTime checkIn,
    int lateMinutes = 0,
  }) async {
    try {
      final Map<String, dynamic> data = await _api.post(
        'attendance-records',
        {
          'userId': userId,
          'organizationId': organizationId,
          'date': date,
          'checkIn': checkIn.toIso8601String(),
          'autoCheckout': false,
          'lateMinutes': lateMinutes,
        },
        auth: true,
      );
      return GenericResponse(
        success: true,
        data: AttendanceRecord.fromJson(data),
        message: 'Ingreso registrado',
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

  /// Actualiza el registro del día ya existente con la siguiente marca
  /// (salida a refrigerio, retorno o salida final).
  Future<GenericResponse<AttendanceRecord>> markProgress(
    String id, {
    DateTime? lunchStart,
    DateTime? lunchEnd,
    DateTime? checkOut,
    int? totalMinutes,
  }) async {
    try {
      final Map<String, dynamic> body = {
        if (lunchStart != null) 'lunchStart': lunchStart.toIso8601String(),
        if (lunchEnd != null) 'lunchEnd': lunchEnd.toIso8601String(),
        if (checkOut != null) 'checkOut': checkOut.toIso8601String(),
        if (totalMinutes != null) 'totalMinutes': totalMinutes,
      };
      final Map<String, dynamic> data = await _api.put(
        'attendance-records/$id',
        body,
      );
      return GenericResponse(
        success: true,
        data: AttendanceRecord.fromJson(data),
        message: 'Registro actualizado',
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

  /// Busca, si existe, el registro de asistencia de una fecha ("YYYY-MM-DD").
  AttendanceRecord? findByDate(List<AttendanceRecord> records, String date) {
    for (final record in records) {
      if (record.date == date) return record;
    }
    return null;
  }

  Future<GenericResponse<AttendanceRecord>> setStatus(
    String id,
    String status, {
    String? validatedById,
  }) async {
    try {
      final Map<String, dynamic> data = await _api.put(
        'attendance-records/$id',
        {
          'status': status,
          if (validatedById != null) 'validatedById': validatedById,
        },
      );
      return GenericResponse(
        success: true,
        data: AttendanceRecord.fromJson(data),
        message: 'Registro actualizado',
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
