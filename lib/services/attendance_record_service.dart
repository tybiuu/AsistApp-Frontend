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
