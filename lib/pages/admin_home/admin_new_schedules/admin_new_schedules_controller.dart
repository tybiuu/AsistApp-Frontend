import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../configs/theme.dart';
import '../../../models/schedule.dart';
import '../../../models/user.dart';
import '../../../services/schedule_service.dart';
import '../../../services/trainee_service.dart';

class PendingScheduleRequest {
  final Schedule schedule;
  final User? trainee;

  const PendingScheduleRequest({required this.schedule, this.trainee});
}

class AdminNewSchedulesController extends GetxController {
  final ScheduleService _scheduleService = Get.find();
  final TraineeService _traineeService = Get.find();

  final isLoading = true.obs;
  final message = ''.obs;
  final pendingRequests = <PendingScheduleRequest>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadPendingSchedules();
  }

  Future<void> loadPendingSchedules() async {
    isLoading.value = true;

    final schedulesResponse = await _scheduleService.fetchPendingSchedules();
    final traineesResponse = await _traineeService.fetchAll();

    if (schedulesResponse.success) {
      final Map<String, User> traineesById = {
        for (final trainee in traineesResponse.data ?? <User>[]) trainee.id: trainee,
      };
      pendingRequests.assignAll(
        (schedulesResponse.data ?? <Schedule>[])
            .map((schedule) => PendingScheduleRequest(
                  schedule: schedule,
                  trainee: traineesById[schedule.userId],
                ))
            .toList(),
      );
      message.value = '';
    } else {
      message.value = 'No se pudieron cargar los horarios pendientes';
    }

    isLoading.value = false;
  }

  Future<void> approve(Schedule schedule) async {
    final response = await _scheduleService.setStatus(schedule.id, 'approved');
    if (response.success) {
      pendingRequests.removeWhere((r) => r.schedule.id == schedule.id);
      Get.snackbar(
        'Horario aprobado',
        'El horario fue activado.',
        backgroundColor: AppColors.success,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(16),
      );
    } else {
      Get.snackbar(
        'Error',
        'No se pudo aprobar el horario.',
        backgroundColor: AppColors.error,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(16),
      );
    }
  }

  Future<void> reject(Schedule schedule) async {
    final response = await _scheduleService.setStatus(schedule.id, 'rejected');
    if (response.success) {
      pendingRequests.removeWhere((r) => r.schedule.id == schedule.id);
      Get.snackbar(
        'Horario rechazado',
        'Se notificará al practicante para que lo reconfigure.',
        backgroundColor: AppColors.error,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(16),
      );
    } else {
      Get.snackbar(
        'Error',
        'No se pudo rechazar el horario.',
        backgroundColor: AppColors.error,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(16),
      );
    }
  }
}
