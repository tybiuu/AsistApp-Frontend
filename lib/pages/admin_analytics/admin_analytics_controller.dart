// lib/pages/admin_analytics/admin_analytics_controller.dart

import 'package:asist_app/configs/theme.dart';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../models/user.dart';

class MemberAnalytic {
  final String name;
  final int hoursLogged;
  final int attendancePercent;
  final int minutesLateSum;
  final int daysMissed;

  MemberAnalytic({
    required this.name,
    required this.hoursLogged,
    required this.attendancePercent,
    required this.minutesLateSum,
    required this.daysMissed,
  });

  String get initials => name
      .split(' ')
      .take(2)
      .map((w) => w[0])
      .join()
      .toUpperCase();

  String get firstName => name.split(' ').first;
  String get lastName => name.split(' ').last;
  String get shortName => '${firstName[0]}. $lastName';

  factory MemberAnalytic.fromJson(Map<String, dynamic> json) {
    return MemberAnalytic(
      name:              json['name'],
      hoursLogged:       json['hoursLogged'],
      attendancePercent: json['attendancePercent'],
      minutesLateSum:    json['minutesLateSum'],
      daysMissed:        json['daysMissed'],
    );
  }

  User toUser() {
    final parts = name.trim().split(' ');
    final first = parts.isNotEmpty ? parts.first : name;
    final last  = parts.length > 1 ? parts.sublist(1).join(' ') : '';
    final now   = DateTime.now();
    return User(
      id:                 'analytic-${name.hashCode.abs()}',
      firstName:          first,
      lastName:           last,
      institutionalEmail: '',
      phoneNumber:        '',
      role:               UserRole.trainee,
      status:             UserStatus.active,
      createdAt:          now,
      updatedAt:          now,
    );
  }
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
    final String raw = await rootBundle.loadString('assets/jsons/mock_analytics.json');
    final Map<String, dynamic> json = jsonDecode(raw);

    members.value = (json['members'] as List)
        .map((e) => MemberAnalytic.fromJson(e))
        .toList();

    summary.value = MonthSummary.fromJson(json['summary']);
    isLoading.value = false;
  }

  static Color percentColor(int percent) {
    if (percent >= 90) return AppColors.success;
    if (percent >= 60) return AppColors.chart1;
    return AppColors.error;
  }
}