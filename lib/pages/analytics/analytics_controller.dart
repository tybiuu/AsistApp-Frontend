import 'dart:convert';
import 'package:asist_app/configs/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

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
  double get hoursPercent => (currentHours / totalHours) * 100;

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
    ((daysAttended - daysMissed) / daysAttended) * 100;

  double get hoursProgress => hoursCompleted / hoursRequired;

  int get hoursRemaining => hoursRequired - hoursCompleted;

  factory PractitionerAnalytics.fromJson(Map<String, dynamic> json) {
    return PractitionerAnalytics(
      month: json['month'],
      hoursCompleted: json['hoursCompleted'],
      hoursRequired:  json['hoursRequired'],
      daysAttended:   json['daysAttended'],
      totalWorkDays:  json['totalWorkDays'],
      daysLate:       json['daysLate'],
      daysMissed:     json['daysMissed'],
      currentHours: json['currentHours'],
      totalHours:   json['totalHours'],
      startMonth:   json['startMonth'],
      endMonth:     json['endMonth'],
    );
  }
}

class AnalyticsController extends GetxController {
  final allMonths = <PractitionerAnalytics>[].obs;
  final selectedIndex = 0.obs;
  final isLoading = true.obs;

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

  Future<void> loadData() async {
    try {
      final String raw = await rootBundle
          .loadString('assets/jsons/mock_practi_analytics.json');
      final Map<String, dynamic> json = jsonDecode(raw);
      allMonths.value = (json['months'] as List)
          .map((e) => PractitionerAnalytics.fromJson(e))
          .toList();
      selectedIndex.value = allMonths.length - 1;
      print('Loaded ${allMonths.length} months');
      print('Selected index: ${selectedIndex.value}');
      print('Current: ${current?.month}');
    } catch (e) {
      print('Analytics error: $e');
    } finally {
      isLoading.value = false;
    }
  }

  static Color percentColor(double percent) {
    if (percent >= 90) return AppColors.success;
    if (percent >= 60) return const Color(0xffe15d27);
    return AppColors.error;
  }
}
