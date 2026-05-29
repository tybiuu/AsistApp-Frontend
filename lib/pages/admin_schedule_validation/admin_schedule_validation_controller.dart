import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../configs/routes.dart';
import '../../models/schedule.dart';
import '../../models/user.dart';
import '../../services/schedule_change_request_service.dart';
import '../../services/trainee_service.dart';

class ScheduleRequestModel {
  final String id;
  final String name;
  final String initials;
  final String career;
  final int ciclo;
  final String type;
  final int targetHours;
  final int changedDaysCount;
  final String time;
  final String reason;
  final String status;
  final Map<String, List<ScheduleBlock>> currentSchedule;
  final Map<String, List<ScheduleBlock>> proposedSchedule;

  const ScheduleRequestModel({
    required this.id,
    required this.name,
    required this.initials,
    required this.career,
    required this.ciclo,
    required this.type,
    required this.targetHours,
    required this.changedDaysCount,
    required this.time,
    required this.reason,
    required this.status,
    required this.currentSchedule,
    required this.proposedSchedule,
  });
}

class AdminScheduleValidationController extends GetxController {
  final TraineeService _traineeService = TraineeService();
  final ScheduleChangeRequestService _scheduleChangeRequestService =
      ScheduleChangeRequestService();

  final requests = <ScheduleRequestModel>[].obs;
  final selectedRequest = Rxn<ScheduleRequestModel>();
  final isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    _loadMockData();
  }

  Future<void> _loadMockData() async {
    isLoading.value = true;

    try {
      final traineesResponse = await _traineeService.fetchAll();
      final scheduleChangeRequestsResponse =
          await _scheduleChangeRequestService.fetchAll();
      final String schedulePayload = await rootBundle.loadString(
        'assets/jsons/mock_schedules.json',
      );

      final List<dynamic> scheduleRows = jsonDecode(schedulePayload);
      final Map<String, Map<String, dynamic>> scheduleByUser = {};

      for (final rawSchedule in scheduleRows) {
        final String userId = rawSchedule['user_id'] as String? ?? '';
        final Map<String, dynamic> dayIndex = {};

        for (final rawDay in rawSchedule['days'] as List<dynamic>) {
          final String dayId = rawDay['id'] as String? ?? '';
          dayIndex[dayId] = rawDay as Map<String, dynamic>;
        }

        scheduleByUser[userId] = {
          'weekly_hours': rawSchedule['weekly_hours'] as int? ?? 30,
          'days': dayIndex,
        };
      }

      if (traineesResponse.success && scheduleChangeRequestsResponse.success) {
        final List<User> trainees = traineesResponse.data ?? [];
        final Map<String, User> traineesById = {
          for (final trainee in trainees) trainee.id: trainee,
        };

        final List<ScheduleRequestModel> loadedRequests = [];

        for (final rawRequest in scheduleChangeRequestsResponse.data ?? []) {
          final String userId = rawRequest['user_id'] as String? ?? '';
          final User? trainee = traineesById[userId];
          final Map<String, dynamic>? userSchedule = scheduleByUser[userId];

          final String dayId = rawRequest['schedule_day_id'] as String? ?? '';
          final Map<String, dynamic>? dayRecord =
              (userSchedule?['days'] as Map<String, dynamic>?)?[dayId];

          final String dayKey = _dayLabel(
            dayRecord?['day'] as String? ?? _dayLabelFromId(dayId),
          );
          final List<ScheduleBlock> currentBlocks = dayRecord != null
              ? _scheduleBlocksFromDay(dayRecord)
              : _fallbackScheduleBlocks();
          final List<ScheduleBlock> proposedBlocks =
              _scheduleBlocksFromChangeRequest(rawRequest);

          loadedRequests.add(
            ScheduleRequestModel(
              id: rawRequest['id'] as String? ?? '',
              name: trainee?.fullName ?? 'Practicante sin nombre',
              initials: trainee?.initials ?? 'PS',
              career: trainee?.career ?? 'Sin carrera',
              ciclo: trainee?.cycle ?? 5,
              type: 'Cambio',
              targetHours: userSchedule?['weekly_hours'] as int? ?? 30,
              changedDaysCount: proposedBlocks.isEmpty ? 0 : 1,
              time: _formatRequestTime(rawRequest['created_at'] as String?),
              reason: rawRequest['reason'] as String? ?? 'Solicitud de ajuste de horario',
              status: rawRequest['status'] as String? ?? 'pending',
              currentSchedule: {dayKey: currentBlocks},
              proposedSchedule: {dayKey: proposedBlocks},
            ),
          );
        }

        requests.assignAll(loadedRequests);
      }
    } catch (_) {
      requests.assignAll([]);
    } finally {
      isLoading.value = false;
    }
  }

  String _dayLabel(String dayKey) {
    switch (dayKey.toLowerCase()) {
      case 'monday':
        return 'Lunes';
      case 'tuesday':
        return 'Martes';
      case 'wednesday':
        return 'Miércoles';
      case 'thursday':
        return 'Jueves';
      case 'friday':
        return 'Viernes';
      case 'saturday':
        return 'Sábado';
      case 'sunday':
        return 'Domingo';
      default:
        return dayKey;
    }
  }

  String _dayLabelFromId(String dayId) {
    switch (dayId) {
      case 'sd-001':
        return 'Lunes';
      case 'sd-002':
        return 'Martes';
      case 'sd-003':
        return 'Miércoles';
      case 'sd-004':
        return 'Jueves';
      case 'sd-005':
        return 'Viernes';
      default:
        return 'Lunes';
    }
  }

  List<ScheduleBlock> _fallbackScheduleBlocks() {
    return [
      const ScheduleBlock(type: BlockType.work, start: '08:00', end: '13:00'),
      const ScheduleBlock(type: BlockType.breakTime, start: '13:00', end: '14:00'),
      const ScheduleBlock(type: BlockType.work, start: '14:00', end: '17:00'),
    ];
  }

  List<ScheduleBlock> _scheduleBlocksFromDay(Map<String, dynamic> dayRecord) {
    final String checkIn = _normalizeTime(dayRecord['check_in_time']);
    final String lunchStart = _normalizeTime(dayRecord['lunch_start_time']);
    final String lunchEnd = _normalizeTime(dayRecord['lunch_end_time']);
    final String checkOut = _normalizeTime(dayRecord['check_out_time']);

    final List<ScheduleBlock> blocks = [];

    if (lunchStart.isNotEmpty && lunchEnd.isNotEmpty) {
      blocks.add(
        ScheduleBlock(type: BlockType.work, start: checkIn, end: lunchStart),
      );
      blocks.add(
        ScheduleBlock(type: BlockType.breakTime, start: lunchStart, end: lunchEnd),
      );
      blocks.add(
        ScheduleBlock(type: BlockType.work, start: lunchEnd, end: checkOut),
      );
      return blocks;
    }

    blocks.add(ScheduleBlock(type: BlockType.work, start: checkIn, end: checkOut));
    return blocks;
  }

  List<ScheduleBlock> _scheduleBlocksFromChangeRequest(
    Map<String, dynamic> rawRequest,
  ) {
    final String checkIn = _normalizeTime(rawRequest['new_check_in_time']);
    final String lunchStart = _normalizeTime(rawRequest['new_lunch_start_time']);
    final String lunchEnd = _normalizeTime(rawRequest['new_lunch_end_time']);
    final String checkOut = _normalizeTime(rawRequest['new_check_out_time']);

    final List<ScheduleBlock> blocks = [];

    if (lunchStart.isNotEmpty && lunchEnd.isNotEmpty) {
      blocks.add(
        ScheduleBlock(type: BlockType.work, start: checkIn, end: lunchStart),
      );
      blocks.add(
        ScheduleBlock(type: BlockType.breakTime, start: lunchStart, end: lunchEnd),
      );
      blocks.add(
        ScheduleBlock(type: BlockType.work, start: lunchEnd, end: checkOut),
      );
      return blocks;
    }

    blocks.add(ScheduleBlock(type: BlockType.work, start: checkIn, end: checkOut));
    return blocks;
  }

  String _normalizeTime(dynamic value) {
    if (value == null) return '';
    final String rawValue = value.toString();
    return rawValue.length > 5 ? rawValue.substring(0, 5) : rawValue;
  }

  String _formatRequestTime(String? rawValue) {
    if (rawValue == null || rawValue.isEmpty) return 'Sin fecha';

    try {
      final DateTime createdAt = DateTime.parse(rawValue);
      return '${createdAt.day.toString().padLeft(2, '0')}/${createdAt.month.toString().padLeft(2, '0')} ${createdAt.hour.toString().padLeft(2, '0')}:${createdAt.minute.toString().padLeft(2, '0')}';
    } catch (_) {
      return rawValue;
    }
  }

  void viewDetails(ScheduleRequestModel request) {
    selectedRequest.value = request;
    Get.toNamed(AppRoutes.adminScheduleValidationDetail);
  }

  void actionApprove(String id) {
    requests.removeWhere((r) => r.id == id);
    if (Get.currentRoute == AppRoutes.adminScheduleValidationDetail) Get.back();
    Get.snackbar('Aprobado', 'El nuevo horario del practicante ha sido autorizado.');
  }

  void actionReject(String id) {
    requests.removeWhere((r) => r.id == id);
    if (Get.currentRoute == AppRoutes.adminScheduleValidationDetail) Get.back();
    Get.snackbar('Rechazado', 'La solicitud de horario ha sido declinada.');
  }
}