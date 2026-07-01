// lib/services/schedule_service.dart

import 'package:get/get.dart';

import '../configs/generic_response.dart';
import '../models/schedule.dart';
import 'api_service.dart';

class ScheduleService {
  ApiService get _api => Get.find<ApiService>();

  static const Map<String, String> _dayKeyToBackend = {
    'Lunes': 'monday',
    'Martes': 'tuesday',
    'Miércoles': 'wednesday',
    'Jueves': 'thursday',
    'Viernes': 'friday',
    'Sábado': 'saturday',
  };

  Future<GenericResponse<Schedule?>> fetchCurrent() async {
    try {
      final List<dynamic> data = await _api.getList('schedules');
      if (data.isEmpty) {
        return GenericResponse(
          success: true,
          data: null,
          message: 'Aún no tienes un horario asignado',
        );
      }
      final schedule = Schedule.fromJson(data.first as Map<String, dynamic>);
      return GenericResponse(
        success: true,
        data: schedule,
        message: 'Horario actual',
      );
    } catch (e, stackTrace) {
      return GenericResponse(
        success: false,
        data: null,
        message: 'No se pudo obtener el horario',
        error: stackTrace.toString(),
      );
    }
  }

  Future<GenericResponse<Schedule?>> fetchForUser(String userId) async {
    try {
      final List<dynamic> data = await _api.getList('schedules');
      final match = data
          .cast<Map<String, dynamic>>()
          .where((json) => json['userId'] == userId);

      if (match.isEmpty) {
        return GenericResponse(
          success: true,
          data: null,
          message: 'El practicante aún no tiene un horario asignado',
        );
      }
      return GenericResponse(
        success: true,
        data: Schedule.fromJson(match.first),
        message: 'Horario del practicante',
      );
    } catch (e, stackTrace) {
      return GenericResponse(
        success: false,
        data: null,
        message: 'No se pudo obtener el horario',
        error: stackTrace.toString(),
      );
    }
  }

  Future<GenericResponse<List<Schedule>>> fetchPendingSchedules() async {
    try {
      final List<dynamic> data = await _api.getList('schedules');
      final pending = data
          .cast<Map<String, dynamic>>()
          .where((json) => json['status'] == 'pending')
          .map(Schedule.fromJson)
          .toList();
      return GenericResponse(
        success: true,
        data: pending,
        message: 'Horarios pendientes',
      );
    } catch (e, stackTrace) {
      return GenericResponse(
        success: false,
        data: null,
        message: 'No se pudieron obtener los horarios pendientes',
        error: stackTrace.toString(),
      );
    }
  }

  Future<GenericResponse<Schedule>> setStatus(String scheduleId, String status) async {
    try {
      final Map<String, dynamic> data = await _api.put(
        'schedules/$scheduleId',
        {'status': status},
      );
      return GenericResponse(
        success: true,
        data: Schedule.fromJson(data),
        message: 'Horario actualizado',
      );
    } catch (e, stackTrace) {
      return GenericResponse(
        success: false,
        data: null,
        message: 'No se pudo actualizar el horario',
        error: stackTrace.toString(),
      );
    }
  }

  Future<GenericResponse<Schedule>> create({
    required int weeklyHours,
    required Map<String, DaySchedule> days,
  }) async {
    try {
      final payload = {
        'weeklyHours': weeklyHours,
        'status': 'pending',
        'days': _daysToPayload(days),
      };
      final Map<String, dynamic> data = await _api.post(
        'schedules',
        payload,
        auth: true,
      );
      return GenericResponse(
        success: true,
        data: Schedule.fromJson(data),
        message: 'Horario creado',
      );
    } catch (e, stackTrace) {
      return GenericResponse(
        success: false,
        data: null,
        message: 'No se pudo crear el horario',
        error: stackTrace.toString(),
      );
    }
  }

  Future<GenericResponse<Schedule>> update({
    required String scheduleId,
    required int weeklyHours,
    required Map<String, DaySchedule> days,
  }) async {
    try {
      final payload = {
        'weeklyHours': weeklyHours,
        'days': _daysToPayload(days),
      };
      final Map<String, dynamic> data = await _api.put(
        'schedules/$scheduleId',
        payload,
      );
      return GenericResponse(
        success: true,
        data: Schedule.fromJson(data),
        message: 'Horario actualizado',
      );
    } catch (e, stackTrace) {
      return GenericResponse(
        success: false,
        data: null,
        message: 'No se pudo actualizar tu horario',
        error: stackTrace.toString(),
      );
    }
  }

  List<Map<String, dynamic>> _daysToPayload(Map<String, DaySchedule> days) {
    final List<Map<String, dynamic>> result = [];

    days.forEach((label, day) {
      final backendDay = _dayKeyToBackend[label];
      if (backendDay == null || !day.enabled || day.blocks.isEmpty) return;

      final workBlocks =
          day.blocks.where((b) => b.type == BlockType.work).toList();
      if (workBlocks.isEmpty) return;
      final breakBlocks =
          day.blocks.where((b) => b.type == BlockType.breakTime).toList();

      result.add({
        'day': backendDay,
        'checkInTime': workBlocks.first.start,
        if (breakBlocks.isNotEmpty) 'lunchStartTime': breakBlocks.first.start,
        if (breakBlocks.isNotEmpty) 'lunchEndTime': breakBlocks.first.end,
        'checkOutTime': workBlocks.last.end,
      });
    });

    return result;
  }
}
