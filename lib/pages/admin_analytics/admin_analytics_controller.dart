// lib/pages/admin_analytics/admin_analytics_controller.dart

import 'package:asist_app/configs/theme.dart';
import 'package:get/get.dart';

import '../../models/attendance_record.dart';
import '../../models/user.dart';
import '../../services/attendance_record_service.dart';
import '../../services/trainee_service.dart';

class MemberAnalytic {
  final User user;
  final int hoursLogged;
  final int attendancePercent;
  final int minutesLateSum;
  final int daysMissed;

  MemberAnalytic({
    required this.user,
    required this.hoursLogged,
    required this.attendancePercent,
    required this.minutesLateSum,
    required this.daysMissed,
  });

  String get name => user.fullName;
  String get initials => user.initials;
  String get firstName => user.firstName;
  String get lastName => user.lastName;
  String get shortName => '${firstName[0]}. $lastName';

  User toUser() => user;
}

class MonthSummary {
  final int confirmedAttendances;
  final int punctualityPercent;
  final int totalLates;
  final int totalAbsences;
  final int totalPending;

  const MonthSummary({
    required this.confirmedAttendances,
    required this.punctualityPercent,
    required this.totalLates,
    required this.totalAbsences,
    required this.totalPending,
  });
}

class AdminAnalyticsController extends GetxController {
  final TraineeService _traineeService = Get.find();
  final AttendanceRecordService _attendanceRecordService = Get.find();

  final members = <MemberAnalytic>[].obs;
  final Rxn<MonthSummary> summary = Rxn<MonthSummary>();
  final isLoading = true.obs;

  List<MemberAnalytic> get latenessRanking {
    final sorted = [...members];
    sorted.sort((a, b) => b.minutesLateSum.compareTo(a.minutesLateSum));
    return sorted;
  }

  List<MemberAnalytic> get absencesRanking {
    final sorted = [...members];
    sorted.sort((a, b) => b.daysMissed.compareTo(a.daysMissed));
    return sorted;
  }

  @override
  void onInit() {
    super.onInit();
    loadData();
  }

  Future<void> loadData() async {
    final traineesResponse = await _traineeService.fetchAll();
    final activeTrainees = (traineesResponse.data ?? <User>[])
        .where((u) => u.status == UserStatus.active)
        .toList();

    final recordsResponse = await _attendanceRecordService.fetchAll();
    final records = recordsResponse.data ?? <AttendanceRecord>[];

    final Map<String, List<AttendanceRecord>> recordsByUser = {};
    for (final record in records) {
      (recordsByUser[record.userId] ??= <AttendanceRecord>[]).add(record);
    }

    members.value = activeTrainees.map((u) {
      final userRecords = recordsByUser[u.id] ?? const <AttendanceRecord>[];
      final confirmedCount =
          userRecords.where((r) => r.status == AttendanceStatus.confirmed).length;
      final hoursLogged = userRecords.fold<int>(
            0,
            (total, r) => total + (r.totalMinutes ?? 0),
          ) ~/
          60;
      final attendancePercent = userRecords.isEmpty
          ? 0
          : ((confirmedCount / userRecords.length) * 100).round();
      final minutesLateSum = userRecords.fold<int>(
        0,
        (total, r) => total + (r.lateMinutes != null && r.lateMinutes! > 0 ? r.lateMinutes! : 0),
      );
      final daysMissed =
          userRecords.where((r) => r.status == AttendanceStatus.absence).length;

      return MemberAnalytic(
        user: u,
        hoursLogged: hoursLogged,
        attendancePercent: attendancePercent,
        minutesLateSum: minutesLateSum,
        daysMissed: daysMissed,
      );
    }).toList();

    summary.value = _buildSummary(records);
    isLoading.value = false;
  }

  MonthSummary _buildSummary(List<AttendanceRecord> records) {
    int confirmedAttendances = 0;
    int onTimeConfirmed = 0;
    int totalLates = 0;
    int totalAbsences = 0;
    int totalPending = 0;

    for (final record in records) {
      final isLate = record.lateMinutes != null && record.lateMinutes! > 0;
      if (isLate) totalLates++;

      switch (record.status) {
        case AttendanceStatus.confirmed:
          confirmedAttendances++;
          if (!isLate) onTimeConfirmed++;
          break;
        case AttendanceStatus.absence:
          totalAbsences++;
          break;
        case AttendanceStatus.pending:
          totalPending++;
          break;
      }
    }

    final punctualityPercent = confirmedAttendances == 0
        ? 0
        : ((onTimeConfirmed / confirmedAttendances) * 100).round();

    return MonthSummary(
      confirmedAttendances: confirmedAttendances,
      punctualityPercent: punctualityPercent,
      totalLates: totalLates,
      totalAbsences: totalAbsences,
      totalPending: totalPending,
    );
  }

  static Color percentColor(int percent) {
    if (percent >= 90) return AppColors.success;
    if (percent >= 60) return AppColors.chart1;
    return AppColors.error;
  }
}