// lib/services/schedule_service.dart

import 'dart:convert';

import 'package:flutter/services.dart';

import '../models/schedule.dart';

class ScheduleService {
  Future<Map<String, DaySchedule>> loadMock(String? userId) async {
    try {
      final String response =
          await rootBundle.loadString('assets/jsons/mock_schedules.json');
      final List<dynamic> data = jsonDecode(response);
      if (data.isEmpty) return Schedule.emptyDays();

      final json = data.firstWhere(
        (s) => s['user_id'] == userId,
        orElse: () => data.first,
      ) as Map<String, dynamic>;

      return Schedule.fromJson(json).days;
    } catch (_) {
      return Schedule.emptyDays();
    }
  }
}
