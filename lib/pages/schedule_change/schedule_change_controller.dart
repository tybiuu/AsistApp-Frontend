import 'package:get/get.dart';
import '../../models/schedule.dart';

class ScheduleChangeController extends GetxController {
  // Estado de envío
  final isSubmitted = false.obs;

  // Modalidad seleccionada (20, 25 o 30)
  final selectedTargetHours = 30.obs;
  final List<int> hourOptions = [20, 25, 30];

  // Horario reactivo estructurado por días
  final weeklySchedule = <String, DaySchedule>{}.obs;

  @override
  void onInit() {
    super.onInit();
    _loadInitialSchedule();
  }

  void _loadInitialSchedule() {
    weeklySchedule.addAll({
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
    });
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
      
      weeklySchedule[dayKey] = DaySchedule(enabled: currentDay.enabled, blocks: updatedBlocks);
    }
  }

  void removeBlock(String dayKey, int blockIndex) {
    final currentDay = weeklySchedule[dayKey];
    if (currentDay != null) {
      final updatedBlocks = List<ScheduleBlock>.from(currentDay.blocks)
        ..removeAt(blockIndex);
      
      weeklySchedule[dayKey] = DaySchedule(enabled: currentDay.enabled, blocks: updatedBlocks);
    }
  }

  void submitForApproval() {
    isSubmitted.value = true;
  }
}