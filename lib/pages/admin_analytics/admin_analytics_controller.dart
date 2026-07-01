// lib/pages/admin_analytics/admin_analytics_controller.dart

import 'package:asist_app/configs/theme.dart';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../models/user.dart';
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

  factory MonthSummary.fromJson(Map<String, dynamic> json) {
    return MonthSummary(
      confirmedAttendances: json['confirmedAttendances'],
      punctualityPercent:   json['punctualityPercent'],
      totalLates:           json['totalLates'],
      totalAbsences:        json['totalAbsences'],
      totalPending:      json['totalPending'],
    );
  }
}

class AdminAnalyticsController extends GetxController {
  final TraineeService _traineeService = Get.find();

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

    members.value = activeTrainees
        .map((u) => MemberAnalytic(
              user: u,
              hoursLogged: 0,
              attendancePercent: 0,
              minutesLateSum: 0,
              daysMissed: 0,
            ))
        .toList();

    final String raw = await rootBundle.loadString('assets/jsons/mock_analytics.json');
    final Map<String, dynamic> json = jsonDecode(raw);
    summary.value = MonthSummary.fromJson(json['summary']);
    isLoading.value = false;
  }

  static Color percentColor(int percent) {
    if (percent >= 90) return AppColors.success;
    if (percent >= 60) return AppColors.chart1;
    return AppColors.error;
  }
}