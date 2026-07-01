// lib/pages/admin_home/admin_member_detail/admin_member_detail_controller.dart

import 'package:asist_app/configs/theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../models/schedule.dart';
import '../../../models/user.dart';
import '../../../services/schedule_service.dart';
import '../../../services/user_service.dart';
import '../admin_home_controller.dart';
import '../admin_home_models.dart';

class AdminMemberDetailController extends GetxController {
  final ScheduleService _scheduleService = Get.find();
  final UserService _userService = Get.find();

  final RxBool isDeleting = false.obs;

  late final User member;

  final RxMap<String, DaySchedule> schedule = <String, DaySchedule>{
    ...Schedule.emptyDays(),
  }.obs;
  final Rxn<Schedule> rawSchedule = Rxn<Schedule>();

  bool get hasApprovedSchedule => rawSchedule.value?.status == 'approved';

  final RxnInt expandedDay = RxnInt();

  late final List<MemberMetric> metrics;

  @override
  void onInit() {
    super.onInit();
    member = Get.arguments as User;
    _buildMockMetrics();
    _loadSchedule();
  }

  void _buildMockMetrics() {
    metrics = [
      MemberMetric(
        label: 'Horas completadas',
        value: '102h',
        subtitle: 'de 120h',
        valueColor: AppColors.primary,
        progress: 102 / 120,
      ),
      const MemberMetric(
        label: '% Asistencia',
        value: '82%',
        subtitle: 'este mes',
        valueColor: AppColors.success,
      ),
      const MemberMetric(
        label: 'Tardanzas',
        value: '2',
        subtitle: 'este mes',
        valueColor: AppColors.primary,
      ),
      const MemberMetric(
        label: 'Inasistencias',
        value: '0',
        subtitle: 'este mes',
        valueColor: AppColors.success,
      ),
    ];
  }

  Future<void> _loadSchedule() async {
    final response = await _scheduleService.fetchForUser(member.id);
    rawSchedule.value = response.data;
    schedule.assignAll(response.data?.days ?? Schedule.emptyDays());
  }

  void toggleDay(int idx) {
    expandedDay.value = expandedDay.value == idx ? null : idx;
  }

  Future<void> deleteMember() async {
    if (isDeleting.value) return;
    isDeleting.value = true;

    final response = await _userService.deleteUser(member.id);

    isDeleting.value = false;

    if (response.success) {
      if (Get.isRegistered<AdminHomeController>()) {
        Get.find<AdminHomeController>().loadAdminHome();
      }
      Get.back();
      Get.snackbar(
        'Miembro eliminado',
        '${member.fullName} fue eliminado de la organización.',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 3),
      );
    } else {
      Get.snackbar(
        'Error',
        response.message.isNotEmpty ? response.message : 'No se pudo eliminar al miembro.',
        backgroundColor: AppColors.error,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(16),
      );
    }
  }

  String get currentMonthLabel {
    const months = [
      'ENERO', 'FEBRERO', 'MARZO', 'ABRIL', 'MAYO', 'JUNIO',
      'JULIO', 'AGOSTO', 'SEPTIEMBRE', 'OCTUBRE', 'NOVIEMBRE', 'DICIEMBRE',
    ];
    return months[DateTime.now().month - 1];
  }
}
