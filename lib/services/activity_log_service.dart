// lib/services/activity_log_service.dart

import 'package:get/get.dart';

import '../configs/generic_response.dart';
import '../models/activity_log.dart';
import 'api_service.dart';

class ActivityLogService {
  ApiService get _api => Get.find<ApiService>();

  Future<GenericResponse<List<ActivityLog>>> fetchAll() async {
    try {
      final List<dynamic> data = await _api.getList('activity-logs');
      final logs = data
          .map((j) => ActivityLog.fromJson(j as Map<String, dynamic>))
          .toList();

      return GenericResponse(
        success: true,
        data: logs,
        message: 'Registros de actividad',
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
}
