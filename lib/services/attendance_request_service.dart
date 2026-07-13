import 'package:get/get.dart';

import '../configs/generic_response.dart';
import '../models/attendance_request.dart';
import 'api_service.dart';

class AttendanceRequestService {
  ApiService get _api => Get.find<ApiService>();

  Future<GenericResponse<List<AttendanceRequest>>> fetchAll() async {
    try {
      final List<dynamic> data = await _api.getList('attendance-requests');
      final requests = data
          .map((j) => AttendanceRequest.fromJson(j as Map<String, dynamic>))
          .toList();

      return GenericResponse(
        success: true,
        data: requests,
        message: 'Solicitudes de asistencia',
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

  Future<GenericResponse<AttendanceRequest>> create({
    required String requestedDate,
    required String reason,
  }) async {
    try {
      final Map<String, dynamic> data = await _api.post(
        'attendance-requests',
        {
          'requestedDate': requestedDate,
          'reason': reason,
        },
        auth: true,
      );
      return GenericResponse(
        success: true,
        data: AttendanceRequest.fromJson(data),
        message: 'Solicitud enviada',
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

  Future<GenericResponse<AttendanceRequest>> setStatus(String id, String status) async {
    try {
      final Map<String, dynamic> data = await _api.put(
        'attendance-requests/$id',
        {'status': status},
      );
      return GenericResponse(
        success: true,
        data: AttendanceRequest.fromJson(data),
        message: 'Solicitud actualizada',
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

  int countByStatus(List<AttendanceRequest> requests, String status) =>
      requests.where((r) => r.status.name == status).length;
}
