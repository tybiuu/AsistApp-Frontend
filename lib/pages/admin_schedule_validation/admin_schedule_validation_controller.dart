import 'package:get/get.dart';

import '../../models/attendance_request.dart';
import '../../models/schedule.dart';
import '../../models/schedule_change_request.dart';
import '../../models/user.dart';
import '../../services/schedule_change_request_service.dart';
import '../../services/schedule_service.dart';
import '../../services/trainee_service.dart';

class ScheduleRequestModel {
  final String id;
  final String name;
  final String initials;
  final String career;
  final int ciclo;
  final String type;
  final int targetHours;
  final int changedDaysCount;
  final String time;
  final String reason;
  final String status;
  final Map<String, List<ScheduleBlock>> currentSchedule;
  final Map<String, List<ScheduleBlock>> proposedSchedule;

  const ScheduleRequestModel({
    required this.id,
    required this.name,
    required this.initials,
    required this.career,
    required this.ciclo,
    required this.type,
    required this.targetHours,
    required this.changedDaysCount,
    required this.time,
    required this.reason,
    required this.status,
    required this.currentSchedule,
    required this.proposedSchedule,
  });
}

class AdminScheduleValidationController extends GetxController {
  final TraineeService _traineeService = Get.find();
  final ScheduleChangeRequestService _scheduleChangeRequestService = Get.find();
  final ScheduleService _scheduleService = Get.find();

  final requests = <ScheduleRequestModel>[].obs;
  final isLoading = true.obs;

  static const Map<String, String> _dayLabels = {
    'monday': 'Lunes',
    'tuesday': 'Martes',
    'wednesday': 'Miércoles',
    'thursday': 'Jueves',
    'friday': 'Viernes',
    'saturday': 'Sábado',
  };

  @override
  void onInit() {
    super.onInit();
    reload();
  }

  Future<void> reload() async {
    isLoading.value = true;

    try {
      final traineesResponse = await _traineeService.fetchAll();
      final changeRequestsResponse = await _scheduleChangeRequestService.fetchAll();

      if (traineesResponse.success && changeRequestsResponse.success) {
        final Map<String, User> traineesById = {
          for (final trainee in traineesResponse.data ?? <User>[]) trainee.id: trainee,
        };

        final pending = (changeRequestsResponse.data ?? <ScheduleChangeRequest>[])
            .where((request) => request.status == RequestStatus.pending)
            .toList();

        final Map<String, int> weeklyHoursByUser = {};
        for (final userId in pending.map((r) => r.userId).toSet()) {
          final scheduleResponse = await _scheduleService.fetchForUser(userId);
          weeklyHoursByUser[userId] = scheduleResponse.data?.weeklyHours ?? 0;
        }

        requests.assignAll(
          pending
              .map((request) => _toModel(
                    request,
                    traineesById[request.userId],
                    weeklyHoursByUser[request.userId] ?? 0,
                  ))
              .toList(),
        );
      } else {
        requests.assignAll([]);
      }
    } catch (_) {
      requests.assignAll([]);
    } finally {
      isLoading.value = false;
    }
  }

  ScheduleRequestModel _toModel(ScheduleChangeRequest request, User? trainee, int weeklyHours) {
    final day = request.scheduleDay;
    final String dayKey = _dayLabels[day?.day] ?? 'Lunes';

    return ScheduleRequestModel(
      id: request.id,
      name: trainee?.fullName ?? 'Practicante sin nombre',
      initials: trainee?.initials ?? 'PS',
      career: trainee?.career ?? 'Sin carrera',
      ciclo: trainee?.cycle ?? 5,
      type: 'Cambio',
      targetHours: weeklyHours,
      changedDaysCount: 1,
      time: _formatDateTime(request.createdAt),
      reason: request.reason,
      status: request.status.name,
      currentSchedule: {
        dayKey: _blocksFromTimes(
          checkIn: day?.checkInTime,
          lunchStart: day?.lunchStartTime,
          lunchEnd: day?.lunchEndTime,
          checkOut: day?.checkOutTime,
        ),
      },
      proposedSchedule: {
        dayKey: _blocksFromTimes(
          checkIn: request.newCheckInTime,
          lunchStart: request.newLunchStartTime,
          lunchEnd: request.newLunchEndTime,
          checkOut: request.newCheckOutTime,
        ),
      },
    );
  }

  List<ScheduleBlock> _blocksFromTimes({
    String? checkIn,
    String? lunchStart,
    String? lunchEnd,
    String? checkOut,
  }) {
    if (checkIn == null || checkOut == null) return [];

    if (lunchStart != null && lunchEnd != null) {
      return [
        ScheduleBlock(type: BlockType.work, start: checkIn, end: lunchStart),
        ScheduleBlock(type: BlockType.breakTime, start: lunchStart, end: lunchEnd),
        ScheduleBlock(type: BlockType.work, start: lunchEnd, end: checkOut),
      ];
    }

    return [ScheduleBlock(type: BlockType.work, start: checkIn, end: checkOut)];
  }

  String _formatDateTime(DateTime dt) {
    return '${dt.day.toString().padLeft(2, '0')}/${dt.month.toString().padLeft(2, '0')} '
        '${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
  }

  Future<void> actionApprove(String id) async {
    final response = await _scheduleChangeRequestService.setStatus(id, 'approved');
    if (response.success) {
      requests.removeWhere((r) => r.id == id);
      Get.snackbar(
        'Aprobado',
        'El cambio de horario ha sido autorizado.',
      );
    } else {
      Get.snackbar('Error', 'No se pudo aprobar la solicitud.');
    }
  }

  Future<void> actionReject(String id) async {
    final response = await _scheduleChangeRequestService.setStatus(id, 'rejected');
    if (response.success) {
      requests.removeWhere((r) => r.id == id);
      Get.snackbar('Rechazado', 'La solicitud de horario ha sido declinada.');
    } else {
      Get.snackbar('Error', 'No se pudo rechazar la solicitud.');
    }
  }
}
