import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../configs/theme.dart';
import '../../models/schedule.dart';
import '../../services/schedule_change_request_service.dart';
import '../../services/schedule_service.dart';

class ScheduleChangeController extends GetxController {
  final ScheduleService _scheduleService = Get.find();
  final ScheduleChangeRequestService _scheduleChangeRequestService = Get.find();

  final isSubmitted = false.obs;
  final isLoading = true.obs;
  final isSubmitting = false.obs;
  final selectedTargetHours = 30.obs;
  final List<int> hourOptions = [20, 25, 30];
  final expandedDay = RxnInt();
  final weeklySchedule = <String, DaySchedule>{}.obs;
  final reasonController = TextEditingController();

  final hasExistingSchedule = false.obs;
  String? _unapprovedScheduleId;
  Map<String, DaySchedule> _originalSchedule = {};

  @override
  void onInit() {
    super.onInit();
    _loadInitialSchedule();
  }

  @override
  void onClose() {
    reasonController.dispose();
    super.onClose();
  }

  Future<void> _loadInitialSchedule() async {
    isLoading.value = true;

    try {
      final response = await _scheduleService.fetchCurrent();
      final Schedule? schedule = response.data;

      hasExistingSchedule.value = schedule != null && schedule.status == 'approved';
      _unapprovedScheduleId = hasExistingSchedule.value ? null : schedule?.id;

      if (schedule != null) {
        selectedTargetHours.value = _normalizeTargetHours(schedule.weeklyHours);
        final scheduleMap = Map<String, DaySchedule>.from(Schedule.emptyDays());
        scheduleMap.addAll(schedule.days);
        weeklySchedule.assignAll(scheduleMap);
        _originalSchedule = Map<String, DaySchedule>.from(scheduleMap);
      } else {
        weeklySchedule.assignAll(Schedule.emptyDays());
        _originalSchedule = {};
      }
    } catch (_) {
      hasExistingSchedule.value = false;
      _unapprovedScheduleId = null;
      _originalSchedule = {};
      weeklySchedule.assignAll(Schedule.emptyDays());
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
    if (!ctx.mounted) return;
    final endTOD = await showTimePicker(context: ctx, initialTime: parse(block.end));
    if (endTOD == null) return;

    String fmt(TimeOfDay t) => '${t.hour.toString().padLeft(2, '0')}:${t.minute.toString().padLeft(2, '0')}';

    final updatedBlocks = List<ScheduleBlock>.from(currentDay.blocks);
    updatedBlocks[blockIndex] = ScheduleBlock(type: block.type, start: fmt(startTOD), end: fmt(endTOD));

    weeklySchedule[dayKey] = DaySchedule(enabled: currentDay.enabled, blocks: updatedBlocks);
  }

  int dayWorkMins(DaySchedule day) {
    if (!day.enabled || day.blocks.isEmpty) return 0;

    int totalMins = 0;
    for (final block in day.blocks) {
      if (block.type == BlockType.work) {
        try {
          final startParts = block.start.split(':');
          final endParts = block.end.split(':');

          final startMinutes = int.parse(startParts[0]) * 60 + int.parse(startParts[1]);
          final endMinutes = int.parse(endParts[0]) * 60 + int.parse(endParts[1]);

          if (endMinutes > startMinutes) {
            totalMins += (endMinutes - startMinutes);
          }
        } catch (_) {
          // En caso de que un string de hora venga corrupto o vacío durante la edición
          continue;
        }
      }
    }
    return totalMins;
  }

  /// Calcula el total de minutos de trabajo acumulados en la semana
  int get totalWeeklyWorkMins {
    return weeklySchedule.values.fold(0, (sum, day) => sum + dayWorkMins(day));
  }

  /// Verifica si se cumple exactamente la meta horaria
  bool get isScheduleComplete {
    return (totalWeeklyWorkMins / 60).floor() == selectedTargetHours.value;
  }

  double get currentWeeklyWorkHours {
    return totalWeeklyWorkMins / 60;
  }

  /// Obtiene las horas que faltan para completar la meta elegida
  double get missingHours {
    final missing = selectedTargetHours.value - currentWeeklyWorkHours;
    return missing > 0 ? missing : 0;
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

  void changeBlockType(String dayKey, int blockIndex, BlockType newType) {
    final currentDay = weeklySchedule[dayKey];
    if (currentDay != null) {
      if (blockIndex < 0 || blockIndex >= currentDay.blocks.length) return;

      final block = currentDay.blocks[blockIndex];
      final updatedBlocks = List<ScheduleBlock>.from(currentDay.blocks);
      updatedBlocks[blockIndex] = ScheduleBlock(
        type: newType,
        start: block.start,
        end: block.end,
      );

      weeklySchedule[dayKey] = DaySchedule(
        enabled: currentDay.enabled,
        blocks: updatedBlocks,
      );
    }
  }

  bool _dayChanged(DaySchedule original, DaySchedule edited) {
    if (original.enabled != edited.enabled) return true;
    if (original.blocks.length != edited.blocks.length) return true;
    for (int i = 0; i < original.blocks.length; i++) {
      final a = original.blocks[i];
      final b = edited.blocks[i];
      if (a.type != b.type || a.start != b.start || a.end != b.end) return true;
    }
    return false;
  }

  Future<void> _submitChangeRequests() async {
    final reason = reasonController.text.trim();
    if (reason.isEmpty) {
      Get.snackbar(
        'Falta el motivo',
        'Cuéntanos brevemente por qué necesitas este cambio.',
        backgroundColor: AppColors.error,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(16),
      );
      return;
    }

    final changedDays = _originalSchedule.entries.where((entry) {
      final edited = weeklySchedule[entry.key];
      return edited != null && entry.value.id != null && _dayChanged(entry.value, edited);
    }).toList();

    if (changedDays.isEmpty) {
      Get.snackbar(
        'Sin cambios',
        'No modificaste ningún día de tu horario.',
        backgroundColor: AppColors.error,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(16),
      );
      return;
    }

    isSubmitting.value = true;
    bool anyFailed = false;

    for (final entry in changedDays) {
      final edited = weeklySchedule[entry.key]!;
      final workBlocks = edited.blocks.where((b) => b.type == BlockType.work).toList();
      if (workBlocks.isEmpty) continue;
      final breakBlocks = edited.blocks.where((b) => b.type == BlockType.breakTime).toList();

      final response = await _scheduleChangeRequestService.create(
        scheduleDayId: entry.value.id!,
        reason: reason,
        newCheckInTime: workBlocks.first.start,
        newLunchStartTime: breakBlocks.isNotEmpty ? breakBlocks.first.start : null,
        newLunchEndTime: breakBlocks.isNotEmpty ? breakBlocks.first.end : null,
        newCheckOutTime: workBlocks.last.end,
      );
      if (!response.success) anyFailed = true;
    }

    isSubmitting.value = false;

    if (anyFailed) {
      Get.snackbar(
        'Error',
        'Algunas solicitudes no se pudieron enviar.',
        backgroundColor: AppColors.error,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(16),
      );
    } else {
      isSubmitted.value = true;
    }
  }

  Future<void> submitForApproval() async {
    if (hasExistingSchedule.value) {
      await _submitChangeRequests();
      return;
    }

    isSubmitting.value = true;
    final existingId = _unapprovedScheduleId;
    final response = existingId != null
        ? await _scheduleService.update(
            scheduleId: existingId,
            weeklyHours: selectedTargetHours.value,
            days: weeklySchedule,
          )
        : await _scheduleService.create(
            weeklyHours: selectedTargetHours.value,
            days: weeklySchedule,
          );
    isSubmitting.value = false;

    if (response.success) {
      _unapprovedScheduleId = response.data?.id ?? existingId;
      isSubmitted.value = true;
    } else {
      Get.snackbar(
        'Error',
        response.message.isNotEmpty
            ? response.message
            : 'No se pudo guardar tu horario.',
        backgroundColor: AppColors.error,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(16),
      );
    }
  }

  int _normalizeTargetHours(int value) {
    if (value < 20) return 20;
    if (value > 30) return 30;
    return value;
  }
}
