import 'package:asist_app/configs/theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../models/attendance_record.dart';
import '../../models/schedule.dart';
import '../../services/attendance_record_service.dart';
import '../../services/schedule_service.dart';
import '../../utils/date_utils.dart' show workDayOccurrencesInMonth;

class PractitionerAnalytics {
  final String month;
  final int hoursCompleted;
  final int hoursRequired;
  final int daysAttended;
  final int totalWorkDays;
  final int daysLate;
  final int daysMissed;
  int get pendingDays => totalWorkDays - daysAttended;
  final int currentHours;
  final int totalHours;
  final String startMonth;
  final String endMonth;
  double get hoursPercent => totalHours == 0 ? 0 : (currentHours / totalHours) * 100;

  PractitionerAnalytics({
    required this.month,
    required this.hoursCompleted,
    required this.hoursRequired,
    required this.daysAttended,
    required this.totalWorkDays,
    required this.daysLate,
    required this.daysMissed,
    required this.currentHours,
    required this.totalHours,
    required this.startMonth,
    required this.endMonth,
  });

  double get attendancePercent =>
      totalWorkDays == 0 ? 0 : (daysAttended / totalWorkDays) * 100;

  double get hoursProgress => hoursRequired == 0 ? 0 : hoursCompleted / hoursRequired;

  int get hoursRemaining => hoursRequired - hoursCompleted;
}

class AnalyticsController extends GetxController {
  final ScheduleService _scheduleService = Get.find();
  final AttendanceRecordService _attendanceRecordService = Get.find();

  final allMonths = <PractitionerAnalytics>[].obs;
  final selectedIndex = 0.obs;
  final isLoading = true.obs;
  final Rxn<Schedule> schedule = Rxn<Schedule>();

  bool get hasActiveSchedule => schedule.value?.status == 'approved';

  PractitionerAnalytics? get current =>
      allMonths.isEmpty ? null : allMonths[selectedIndex.value];

  bool get canGoPrev => selectedIndex.value > 0;
  bool get canGoNext => selectedIndex.value < allMonths.length - 1;

  void prevMonth() {
    if (canGoPrev) selectedIndex.value--;
  }

  void nextMonth() {
    if (canGoNext) selectedIndex.value++;
  }

  @override
  void onInit() {
    super.onInit();
    loadData();
  }

  static const List<String> _monthNames = [
    'Enero', 'Febrero', 'Marzo', 'Abril', 'Mayo', 'Junio',
    'Julio', 'Agosto', 'Septiembre', 'Octubre', 'Noviembre', 'Diciembre',
  ];

  Future<void> loadData() async {
    isLoading.value = true;

    final scheduleResponse = await _scheduleService.fetchCurrent();
    schedule.value = scheduleResponse.data;

    if (!hasActiveSchedule) {
      isLoading.value = false;
      return;
    }

    try {
      final recordsResponse = await _attendanceRecordService.fetchAll();
      final records = recordsResponse.data ?? <AttendanceRecord>[];

      final Map<String, List<AttendanceRecord>> byMonth = {};
      for (final record in records) {
        if (record.date.length < 7) continue;
        final key = record.date.substring(0, 7); // "YYYY-MM"
        (byMonth[key] ??= <AttendanceRecord>[]).add(record);
      }

      final now = DateTime.now();
      final currentKey = '${now.year.toString().padLeft(4, '0')}-'
          '${now.month.toString().padLeft(2, '0')}';
      byMonth.putIfAbsent(currentKey, () => <AttendanceRecord>[]);

      final sortedKeys = byMonth.keys.toList()..sort();
      final activeSchedule = schedule.value!;
      final enabledDaysPerWeek =
          activeSchedule.days.values.where((d) => d.enabled).length;

      int cumulativeHours = 0;
      int cumulativeRequiredHours = 0;
      final months = <PractitionerAnalytics>[];

      for (final key in sortedKeys) {
        final year = int.parse(key.substring(0, 4));
        final month = int.parse(key.substring(5, 7));
        final monthRecords = byMonth[key]!;

        final daysAttended = monthRecords
            .where((r) => r.status == AttendanceStatus.confirmed)
            .length;
        final daysLate = monthRecords
            .where((r) => r.lateMinutes != null && r.lateMinutes! > 0)
            .length;
        final daysMissed = monthRecords
            .where((r) => r.status == AttendanceStatus.absence)
            .length;
        final hoursCompleted = monthRecords.fold<int>(
              0,
              (total, r) => total + (r.totalMinutes ?? 0),
            ) ~/
            60;

        final totalWorkDays = workDayOccurrencesInMonth(activeSchedule, year, month);
        final double weeksInMonth =
            enabledDaysPerWeek == 0 ? 0.0 : totalWorkDays / enabledDaysPerWeek;
        final hoursRequired = (activeSchedule.weeklyHours * weeksInMonth).round();

        cumulativeHours += hoursCompleted;
        cumulativeRequiredHours += hoursRequired;

        months.add(PractitionerAnalytics(
          month: '${_monthNames[month - 1]} $year',
          hoursCompleted: hoursCompleted,
          hoursRequired: hoursRequired,
          daysAttended: daysAttended,
          totalWorkDays: totalWorkDays,
          daysLate: daysLate,
          daysMissed: daysMissed,
          currentHours: cumulativeHours,
          totalHours: cumulativeRequiredHours,
          startMonth: '${_monthNames[int.parse(sortedKeys.first.substring(5, 7)) - 1]} '
              '${sortedKeys.first.substring(0, 4)}',
          endMonth: '${_monthNames[month - 1]} $year',
        ));
      }

      allMonths.value = months;
      selectedIndex.value = allMonths.length - 1;
    } catch (e) {
      debugPrint('Analytics error: $e');
    } finally {
      isLoading.value = false;
    }
  }

  static Color percentColor(double percent) {
    if (percent >= 90) return AppColors.success;
    if (percent >= 60) return AppColors.chart1;
    return AppColors.error;
  }
}
