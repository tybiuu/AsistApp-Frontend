// lib/pages/admin_home/admin_member_detail/admin_member_detail_controller.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../models/schedule.dart';
import '../../../models/user.dart';
import '../../../services/schedule_service.dart';
import '../admin_home_models.dart';

class AdminMemberDetailController extends GetxController {
  late final User member;

  final RxMap<String, DaySchedule> schedule = <String, DaySchedule>{
    'Lunes': const DaySchedule(enabled: false, blocks: []),
    'Martes': const DaySchedule(enabled: false, blocks: []),
    'Miércoles': const DaySchedule(enabled: false, blocks: []),
    'Jueves': const DaySchedule(enabled: false, blocks: []),
    'Viernes': const DaySchedule(enabled: false, blocks: []),
    'Sábado': const DaySchedule(enabled: false, blocks: []),
  }.obs;

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
        valueColor: const Color(0xffe15d27),
        progress: 102 / 120,
      ),
      const MemberMetric(
        label: '% Asistencia',
        value: '82%',
        subtitle: 'este mes',
        valueColor: Color(0xff16a34a),
      ),
      const MemberMetric(
        label: 'Tardanzas',
        value: '2',
        subtitle: 'este mes',
        valueColor: Color(0xffe15d27),
      ),
      const MemberMetric(
        label: 'Inasistencias',
        value: '0',
        subtitle: 'este mes',
        valueColor: Color(0xff16a34a),
      ),
    ];
  }

  Future<void> _loadSchedule() async {
    schedule.assignAll(await ScheduleService.loadMock(member.id));
  }

  void toggleDay(int idx) {
    expandedDay.value = expandedDay.value == idx ? null : idx;
  }

  void deleteMember() {
    Get.back();
    Get.snackbar(
      'Miembro eliminado',
      '${member.fullName} fue eliminado de la organización.',
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 3),
    );
  }

  String get currentMonthLabel {
    const months = [
      'ENERO', 'FEBRERO', 'MARZO', 'ABRIL', 'MAYO', 'JUNIO',
      'JULIO', 'AGOSTO', 'SEPTIEMBRE', 'OCTUBRE', 'NOVIEMBRE', 'DICIEMBRE',
    ];
    return months[DateTime.now().month - 1];
  }
}
