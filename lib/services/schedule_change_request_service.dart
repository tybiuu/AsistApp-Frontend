import 'package:get/get.dart';

import '../configs/generic_response.dart';
import '../models/schedule_change_request.dart';
import 'api_service.dart';

class ScheduleChangeRequestService {
  ApiService get _api => Get.find<ApiService>();

  Future<GenericResponse<List<ScheduleChangeRequest>>> fetchAll() async {
    try {
      final List<dynamic> data = await _api.getList('schedule-change-requests');
      final requests = data
          .map((j) => ScheduleChangeRequest.fromJson(j as Map<String, dynamic>))
          .toList();
      return GenericResponse(
        success: true,
        data: requests,
        message: 'Solicitudes de cambio de horario',
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

  Future<GenericResponse<ScheduleChangeRequest>> create({
    required String scheduleDayId,
    required String reason,
    String? newCheckInTime,
    String? newLunchStartTime,
    String? newLunchEndTime,
    String? newCheckOutTime,
  }) async {
    try {
      final Map<String, dynamic> data = await _api.post(
        'schedule-change-requests',
        {
          'scheduleDayId': scheduleDayId,
          'reason': reason,
          'newCheckInTime': ?newCheckInTime,
          'newLunchStartTime': ?newLunchStartTime,
          'newLunchEndTime': ?newLunchEndTime,
          'newCheckOutTime': ?newCheckOutTime,
        },
        auth: true,
      );
      return GenericResponse(
        success: true,
        data: ScheduleChangeRequest.fromJson(data),
        message: 'Solicitud enviada',
      );
    } catch (e, stackTrace) {
      return GenericResponse(
        success: false,
        data: null,
        message: 'No se pudo enviar la solicitud',
        error: stackTrace.toString(),
      );
    }
  }

  Future<GenericResponse<ScheduleChangeRequest>> setStatus(String id, String status) async {
    try {
      final Map<String, dynamic> data = await _api.put(
        'schedule-change-requests/$id',
        {'status': status},
      );
      return GenericResponse(
        success: true,
        data: ScheduleChangeRequest.fromJson(data),
        message: 'Solicitud actualizada',
      );
    } catch (e, stackTrace) {
      return GenericResponse(
        success: false,
        data: null,
        message: 'No se pudo actualizar la solicitud',
        error: stackTrace.toString(),
      );
    }
  }

  int countByStatus(List<ScheduleChangeRequest> requests, String status) =>
      requests.where((r) => r.status.name == status).length;
}
