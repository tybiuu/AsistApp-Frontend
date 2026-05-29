import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../models/schedule.dart';

class ScheduleChangeController extends GetxController {
  final isSubmitted = false.obs;
  final isLoading = true.obs;
  final selectedTargetHours = 30.obs;
  final List<int> hourOptions = [20, 25, 30];
  final expandedDay = RxnInt();
  final weeklySchedule = <String, DaySchedule>{}.obs;

  @override
  void onInit() {
    super.onInit();
    _loadInitialSchedule();
  }

  Future<void> _loadInitialSchedule() async {
    isLoading.value = true;

    try {
      final String response = await rootBundle.loadString(
        'assets/jsons/mock_schedules.json',
      );
      final List<dynamic> data = jsonDecode(response);

      final defaultSchedule = _defaultSchedule();
      final userSchedule = data.isNotEmpty
          ? data.firstWhere(
              (schedule) => schedule['user_id'] == 'usr-trainee-001',
              orElse: () => data.first,
            )
          : null;

      if (userSchedule != null) {
        selectedTargetHours.value = _normalizeTargetHours(
          userSchedule['weekly_hours'] as int? ?? 30,
        );

        final scheduleMap = Map<String, DaySchedule>.from(defaultSchedule);

        for (final dayRecord in userSchedule['days'] as List<dynamic>) {
          final String dayLabel = _dayLabel(dayRecord['day']);
          final List<ScheduleBlock> blocks = _buildBlocksFromDay(dayRecord);

          scheduleMap[dayLabel] = DaySchedule(
            enabled: blocks.isNotEmpty,
            blocks: blocks,
          );
        }

        weeklySchedule.assignAll(scheduleMap);
      } else {
        weeklySchedule.assignAll(defaultSchedule);
      }
    } catch (_) {
      weeklySchedule.assignAll(_defaultSchedule());
    } finally {
      isLoading.value = false;
    }
  }

  /// Edita un bloque existente mostrando selectores de hora.
  Future<void> editBlockTime(String dayKey, int blockIndex) async {
    final currentDay = weeklySchedule[dayKey];
    if (currentDay == null) return;
    if (blockIndex < 0 || blockIndex >= currentDay.blocks.length) return;

    final block = currentDay.blocks[blockIndex];

    // Parse current times to TimeOfDay
    TimeOfDay parse(String t) {
      final parts = t.split(':');
      return TimeOfDay(hour: int.parse(parts[0]), minute: int.parse(parts[1]));
    }

    final ctx = Get.context;
    if (ctx == null) return;

    final startTOD = await showTimePicker(context: ctx, initialTime: parse(block.start));
    if (startTOD == null) return;
    final endTOD = await showTimePicker(context: ctx, initialTime: parse(block.end));
    if (endTOD == null) return;

    String fmt(TimeOfDay t) => t.hour.toString().padLeft(2, '0') + ':' + t.minute.toString().padLeft(2, '0');

    final updatedBlocks = List<ScheduleBlock>.from(currentDay.blocks);
    updatedBlocks[blockIndex] = ScheduleBlock(type: block.type, start: fmt(startTOD), end: fmt(endTOD));

    weeklySchedule[dayKey] = DaySchedule(enabled: currentDay.enabled, blocks: updatedBlocks);
  }

  Map<String, DaySchedule> _defaultSchedule() {
    return {
      'Lunes': const DaySchedule(
        enabled: true,
        blocks: [
          ScheduleBlock(type: BlockType.work, start: '09:30', end: '14:30'),
          ScheduleBlock(type: BlockType.breakTime, start: '12:00', end: '19:15'),
          ScheduleBlock(type: BlockType.work, start: '07:00', end: '20:15'),
        ],
      ),
      'Martes': const DaySchedule(
        enabled: true,
        blocks: [
          ScheduleBlock(type: BlockType.work, start: '11:30', end: '13:30'),
        ],
      ),
      'Miércoles': const DaySchedule(enabled: true, blocks: []),
      'Jueves': const DaySchedule(enabled: true, blocks: []),
      'Viernes': const DaySchedule(enabled: true, blocks: []),
      'Sábado': const DaySchedule(enabled: false, blocks: []),
    };
  }

  String _dayLabel(dynamic dayValue) {
    switch (dayValue.toString().toLowerCase()) {
      case 'monday':
        return 'Lunes';
      case 'tuesday':
        return 'Martes';
      case 'wednesday':
        return 'Miércoles';
      case 'thursday':
        return 'Jueves';
      case 'friday':
        return 'Viernes';
      case 'saturday':
        return 'Sábado';
      case 'sunday':
        return 'Domingo';
      default:
        return dayValue.toString();
    }
  }

  List<ScheduleBlock> _buildBlocksFromDay(Map<String, dynamic> dayRecord) {
    final String checkIn = _normalizeTime(dayRecord['check_in_time']);
    final String lunchStart = _normalizeTime(dayRecord['lunch_start_time']);
    final String lunchEnd = _normalizeTime(dayRecord['lunch_end_time']);
    final String checkOut = _normalizeTime(dayRecord['check_out_time']);

    final List<ScheduleBlock> blocks = [];

    if (lunchStart.isNotEmpty && lunchEnd.isNotEmpty) {
      blocks.add(
        ScheduleBlock(type: BlockType.work, start: checkIn, end: lunchStart),
      );
      blocks.add(
        ScheduleBlock(type: BlockType.breakTime, start: lunchStart, end: lunchEnd),
      );
      blocks.add(
        ScheduleBlock(type: BlockType.work, start: lunchEnd, end: checkOut),
      );
      return blocks;
    }

    blocks.add(ScheduleBlock(type: BlockType.work, start: checkIn, end: checkOut));
    return blocks;
  }

  String _normalizeTime(dynamic value) {
    if (value == null) return '';
    final String rawValue = value.toString();
    return rawValue.length > 5 ? rawValue.substring(0, 5) : rawValue;
  }

  int _normalizeTargetHours(int value) {
    if (value < 20) return 20;
    if (value > 30) return 30;
    return value;
  }

  /// Calcula el total de minutos de trabajo acumulados en la semana
  int get totalWeeklyWorkMins {
    return weeklySchedule.values.fold(0, (sum, day) => sum + dayWorkMins(day));
  }

  /// Verifica si se cumple exactamente la meta horaria
  bool get isScheduleComplete {
    return (totalWeeklyWorkMins / 60).floor() == selectedTargetHours.value;
  }

  void toggleDay(String dayKey, bool enabled) {
    final currentDay = weeklySchedule[dayKey];
    if (currentDay != null) {
      weeklySchedule[dayKey] = DaySchedule(
        enabled: enabled,
        blocks: currentDay.blocks,
      );
    }
  }

  void addBlock(String dayKey) {
    final currentDay = weeklySchedule[dayKey];
    if (currentDay != null) {
      final updatedBlocks = List<ScheduleBlock>.from(currentDay.blocks)
        ..add(const ScheduleBlock(type: BlockType.work, start: '08:00', end: '12:00'));

      weeklySchedule[dayKey] = DaySchedule(
        enabled: currentDay.enabled,
        blocks: updatedBlocks,
      );
    }
  }

  void removeBlock(String dayKey, int blockIndex) {
    final currentDay = weeklySchedule[dayKey];
    if (currentDay != null) {
      final updatedBlocks = List<ScheduleBlock>.from(currentDay.blocks)
        ..removeAt(blockIndex);

      weeklySchedule[dayKey] = DaySchedule(
        enabled: currentDay.enabled,
        blocks: updatedBlocks,
      );
    }
  }

  void submitForApproval() {
    // Build a lightweight request object with full week snapshot
    final request = {
      'id': 'scr-local-' + DateTime.now().millisecondsSinceEpoch.toString(),
      'user_id': 'usr-trainee-001',
      'status': 'pending',
      'created_at': DateTime.now().toUtc().toIso8601String(),
      'payload': weeklySchedule.map((k, v) => MapEntry(k, {
            'enabled': v.enabled,
            'blocks': v.blocks
                .map((b) => {'type': b.type.toString().split('.').last, 'start': b.start, 'end': b.end})
                .toList()
          })),
    };

    // Persist locally in SharedPreferences (merged with mock file when listing)
    SharedPreferences.getInstance().then((prefs) {
      final raw = prefs.getString('local_schedule_change_requests');
      final List<dynamic> existing = raw == null ? [] : jsonDecode(raw) as List<dynamic>;
      existing.add(request);
      prefs.setString('local_schedule_change_requests', jsonEncode(existing));
      isSubmitted.value = true;
    });
  }
}