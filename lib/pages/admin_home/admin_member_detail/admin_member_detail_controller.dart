// lib/pages/admin_home/admin_member_detail/admin_member_detail_controller.dart

import 'package:asist_app/configs/theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../models/attendance_record.dart';
import '../../../models/schedule.dart';
import '../../../models/user.dart';
import '../../../services/attendance_record_service.dart';
import '../../../services/schedule_service.dart';
import '../../../services/user_service.dart';
import '../../../utils/date_utils.dart';
import '../../admin_analytics/admin_analytics_controller.dart' show AdminAnalyticsController;
import '../admin_home_controller.dart';
import '../admin_home_models.dart';

class AdminMemberDetailController extends GetxController {
  final ScheduleService _scheduleService = Get.find();
  final UserService _userService = Get.find();
  final AttendanceRecordService _attendanceRecordService = Get.find();

  final RxBool isDeleting = false.obs;

  late final User member;

  final RxMap<String, DaySchedule> schedule = <String, DaySchedule>{
    ...Schedule.emptyDays(),
  }.obs;
  final Rxn<Schedule> rawSchedule = Rxn<Schedule>();

  bool get hasApprovedSchedule => rawSchedule.value?.status == 'approved';

  final RxnInt expandedDay = RxnInt();

  final RxList<MemberMetric> metrics = <MemberMetric>[].obs;
  final RxBool isLoadingMetrics = true.obs;

  @override
  void onInit() {
    super.onInit();
    member = Get.arguments as User;
    _init();
  }

  Future<void> _init() async {
    await _loadSchedule();
    await _loadMetrics();
  }

  Future<void> _loadSchedule() async {
    final response = await _scheduleService.fetchForUser(member.id);
    rawSchedule.value = response.data;
    schedule.assignAll(response.data?.days ?? Schedule.emptyDays());
  }

  /// Calcula las métricas del mes en curso a partir de los registros de
  /// asistencia reales del miembro (antes eran valores fijos de ejemplo).
  Future<void> _loadMetrics() async {
    isLoadingMetrics.value = true;

    final now = DateTime.now();
    final recordsResponse = await _attendanceRecordService.fetchAll();
    final allRecords = recordsResponse.data ?? <AttendanceRecord>[];

    final monthRecords = allRecords.where((r) {
      if (r.userId != member.id || r.date.length < 7) return false;
      final year = int.tryParse(r.date.substring(0, 4));
      final month = int.tryParse(r.date.substring(5, 7));
      return year == now.year && month == now.month;
    }).toList();

    final confirmedCount =
        monthRecords.where((r) => r.status == AttendanceStatus.confirmed).length;
    final hoursCompleted = monthRecords.fold<int>(
          0,
          (total, r) => total + (r.totalMinutes ?? 0),
        ) ~/
        60;
    final attendancePercent = monthRecords.isEmpty
        ? 0
        : ((confirmedCount / monthRecords.length) * 100).round();
    final latenessCount = monthRecords
        .where((r) => r.lateMinutes != null && r.lateMinutes! > 0)
        .length;
    final daysMissed =
        monthRecords.where((r) => r.status == AttendanceStatus.absence).length;

    int hoursRequired = 0;
    final activeSchedule = rawSchedule.value;
    if (activeSchedule != null && hasApprovedSchedule) {
      hoursRequired = hoursRequiredInMonth(activeSchedule, now.year, now.month);
    }

    metrics.assignAll([
      MemberMetric(
        label: 'Horas completadas',
        value: '${hoursCompleted}h',
        subtitle: hoursRequired > 0 ? 'de ${hoursRequired}h' : 'este mes',
        valueColor: AppColors.primary,
        progress: hoursRequired > 0 ? hoursCompleted / hoursRequired : null,
      ),
      MemberMetric(
        label: '% Asistencia',
        value: '$attendancePercent%',
        subtitle: 'este mes',
        valueColor: AdminAnalyticsController.percentColor(attendancePercent),
      ),
      MemberMetric(
        label: 'Tardanzas',
        value: '$latenessCount',
        subtitle: 'este mes',
        valueColor: latenessCount > 0 ? AppColors.primary : AppColors.success,
      ),
      MemberMetric(
        label: 'Inasistencias',
        value: '$daysMissed',
        subtitle: 'este mes',
        valueColor: daysMissed > 0 ? AppColors.error : AppColors.success,
      ),
    ]);

    isLoadingMetrics.value = false;
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
