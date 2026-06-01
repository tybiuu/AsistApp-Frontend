// lib/pages/admin_analytics/admin_analytics_controller.dart

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

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
    return sorted; //add .take(5).toList() to show only the first 5
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
    if (percent >= 90) return const Color(0xff16a34a);
    if (percent >= 60) return const Color(0xffe15d27);
    return const Color(0xffef4444);
  }
}