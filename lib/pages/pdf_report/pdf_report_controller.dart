import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

import '../../models/attendance_record.dart' as models;
import '../../services/attendance_record_service.dart';
import '../../services/organization_service.dart';
import '../../services/schedule_service.dart';
import '../../services/session_service.dart';
import '../../utils/date_utils.dart';

class AttendanceRecord {
  final String date;
  final String checkIn;
  final String lunchStart;
  final String lunchEnd;
  final String checkOut;
  final String hoursWorked;

  AttendanceRecord({
    required this.date,
    required this.checkIn,
    required this.lunchStart,
    required this.lunchEnd,
    required this.checkOut,
    required this.hoursWorked,
  });
}

class MonthRecord {
  final String month;
  final String totalHours;
  final List<AttendanceRecord> records;

  MonthRecord({
    required this.month,
    required this.totalHours,
    required this.records,
  });
}

class TraineeInfo {
  final String name;
  final String code;
  final String dependency;
  final String career;
  final int weeklyHours;

  TraineeInfo({
    required this.name,
    required this.code,
    required this.dependency,
    required this.career,
    required this.weeklyHours,
  });
}

class PdfReportController extends GetxController {
  final months = <MonthRecord>[].obs;
  final selectedIndex = 0.obs;
  final isLoading = true.obs;
  late TraineeInfo trainee;

  MonthRecord? get current =>
      months.isEmpty ? null : months[selectedIndex.value];

  List<String> get monthNames =>
      months.map((m) => m.month).toList();

  void selectMonth(int index) => selectedIndex.value = index;

  static const List<String> _monthNames = [
    'enero', 'febrero', 'marzo', 'abril', 'mayo', 'junio',
    'julio', 'agosto', 'septiembre', 'octubre', 'noviembre', 'diciembre',
  ];

  @override
  void onInit() {
    super.onInit();
    loadData();
  }

  Future<void> loadData() async {
    try {
      final user = SessionService.to.currentUser.value;

      final recordsResponse = await Get.find<AttendanceRecordService>().fetchAll();
      final scheduleResponse = await Get.find<ScheduleService>().fetchCurrent();
      final orgResponse = await Get.find<OrganizationService>().fetchCurrent();

      trainee = TraineeInfo(
        name: user?.fullName ?? 'Practicante',
        code: user?.institutionalEmail ?? '',
        dependency: orgResponse.data?.name ?? '',
        career: user?.career ?? 'Sin carrera',
        weeklyHours: scheduleResponse.data?.weeklyHours ?? 0,
      );

      final records = recordsResponse.data ?? <models.AttendanceRecord>[];
      months.value = _groupByMonth(records);
      selectedIndex.value = months.isEmpty ? 0 : months.length - 1;
    } catch (e) {
      debugPrint('PDF report error: $e');
    } finally {
      isLoading.value = false;
    }
  }

  List<MonthRecord> _groupByMonth(List<models.AttendanceRecord> records) {
    final Map<String, List<models.AttendanceRecord>> byMonth = {};
    for (final record in records) {
      final parts = record.date.split('-');
      if (parts.length != 3) continue;
      final key = '${parts[0]}-${parts[1]}';
      byMonth.putIfAbsent(key, () => []).add(record);
    }

    final sortedKeys = byMonth.keys.toList()..sort();

    return sortedKeys.map((key) {
      final recordsForMonth = byMonth[key]!
        ..sort((a, b) => a.date.compareTo(b.date));
      final parts = key.split('-');
      final monthIndex = int.tryParse(parts[1]) ?? 1;
      final monthLabel = '${_monthNames[(monthIndex - 1).clamp(0, 11)]} ${parts[0]}';

      final totalMinutes = recordsForMonth.fold<int>(
        0,
        (sum, r) => sum + (r.totalMinutes ?? 0),
      );

      return MonthRecord(
        month: monthLabel,
        totalHours: hoursText(totalMinutes),
        records: recordsForMonth.map((r) {
          return AttendanceRecord(
            date: '${dayAbbrevFromDate(r.date)} ${formatDateShort(r.date)}',
            checkIn: formatTimeShort(r.checkIn?.toIso8601String()),
            lunchStart: formatTimeShort(r.lunchStart?.toIso8601String()),
            lunchEnd: formatTimeShort(r.lunchEnd?.toIso8601String()),
            checkOut: formatTimeShort(r.checkOut?.toIso8601String()),
            hoursWorked: hoursText(r.totalMinutes),
          );
        }).toList(),
      );
    }).toList();
  }
}
