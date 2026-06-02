import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

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

  factory AttendanceRecord.fromJson(Map<String, dynamic> json) {
    return AttendanceRecord(
      date:        json['date'],
      checkIn:     json['checkIn'],
      lunchStart:  json['lunchStart'],
      lunchEnd:    json['lunchEnd'],
      checkOut:    json['checkOut'],
      hoursWorked: json['hoursWorked'],
    );
  }
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

  factory MonthRecord.fromJson(Map<String, dynamic> json) {
    return MonthRecord(
      month:      json['month'],
      totalHours: json['totalHours'],
      records:    (json['records'] as List)
          .map((e) => AttendanceRecord.fromJson(e))
          .toList(),
    );
  }
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

  factory TraineeInfo.fromJson(Map<String, dynamic> json) {
    return TraineeInfo(
      name:        json['name'],
      code:        json['code'],
      dependency:  json['dependency'],
      career:      json['career'],
      weeklyHours: json['weeklyHours'],
    );
  }
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

  @override
  void onInit() {
    super.onInit();
    loadData();
  }

  Future<void> loadData() async {
    try {
      final String raw = await rootBundle
          .loadString('assets/jsons/mock_pdf_attendance_records.json');
      final Map<String, dynamic> json = jsonDecode(raw);
      trainee = TraineeInfo.fromJson(json['trainee']);
      months.value = (json['months'] as List)
          .map((e) => MonthRecord.fromJson(e))
          .toList();
      selectedIndex.value = months.length - 1;
    } catch (e) {
      print('PDF report error: $e');
    } finally {
      isLoading.value = false;
    }
  }
}