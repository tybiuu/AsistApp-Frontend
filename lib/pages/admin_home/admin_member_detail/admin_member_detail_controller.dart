// lib/pages/admin_home/admin_member_detail/admin_member_detail_controller.dart

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../../models/schedule.dart';
import '../../../models/user.dart';

class MemberMetric {
  final String label;
  final String value;
  final String subtitle;
  final Color valueColor;
  final double? progress;

  const MemberMetric({
    required this.label,
    required this.value,
    required this.subtitle,
    required this.valueColor,
    this.progress,
  });
}

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
    try {
      final String response = await rootBundle.loadString(
        'assets/jsons/mock_schedules.json',
      );
      final List<dynamic> data = jsonDecode(response);
      if (data.isEmpty) return;

      final userSchedule = data.firstWhere(
        (s) => s['user_id'] == member.id,
        orElse: () => data.first,
      );

      const dayMap = {
        'monday': 'Lunes',
        'tuesday': 'Martes',
        'wednesday': 'Miércoles',
        'thursday': 'Jueves',
        'friday': 'Viernes',
        'saturday': 'Sábado',
        'sunday': 'Domingo',
      };

      final newSchedule = Map<String, DaySchedule>.from(schedule);
      for (var d in userSchedule['days'] as List<dynamic>) {
        final dayName = dayMap[d['day']] ?? d['day'] as String;

        String? checkIn = d['check_in_time'] as String?;
        String? lunchStart = d['lunch_start_time'] as String?;
        String? lunchEnd = d['lunch_end_time'] as String?;
        String? checkOut = d['check_out_time'] as String?;

        if (checkIn != null && checkIn.length > 5) checkIn = checkIn.substring(0, 5);
        if (lunchStart != null && lunchStart.length > 5) lunchStart = lunchStart.substring(0, 5);
        if (lunchEnd != null && lunchEnd.length > 5) lunchEnd = lunchEnd.substring(0, 5);
        if (checkOut != null && checkOut.length > 5) checkOut = checkOut.substring(0, 5);

        if (checkIn != null && checkOut != null) {
          final blocks = <ScheduleBlock>[];
          if (lunchStart != null && lunchEnd != null) {
            blocks.addAll([
              ScheduleBlock(type: BlockType.work, start: checkIn, end: lunchStart),
              ScheduleBlock(type: BlockType.breakTime, start: lunchStart, end: lunchEnd),
              ScheduleBlock(type: BlockType.work, start: lunchEnd, end: checkOut),
            ]);
          } else {
            blocks.add(ScheduleBlock(type: BlockType.work, start: checkIn, end: checkOut));
          }
          if (newSchedule.containsKey(dayName)) {
            newSchedule[dayName] = DaySchedule(enabled: true, blocks: blocks);
          }
        }
      }
      schedule.assignAll(newSchedule);
    } catch (e) {
      debugPrint('Error loading member schedule: $e');
    }
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
