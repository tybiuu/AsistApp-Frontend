import 'package:asist_app/configs/routes.dart';
import 'package:get/get.dart';
import '../../models/schedule.dart';

class ScheduleRequestModel {
  final String id;
  final String name;
  final String initials;
  final String career;
  final int ciclo;
  final String type; // 'Cambio' o 'Primer horario'
  final int targetHours;
  final int changedDaysCount;
  final String time;
  final String reason;
  final Map<String, List<ScheduleBlock>> currentSchedule;
  final Map<String, List<ScheduleBlock>> proposedSchedule;

  ScheduleRequestModel({
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
    required this.currentSchedule,
    required this.proposedSchedule,
  });
}

class AdminScheduleValidationController extends GetxController {
  final requests = <ScheduleRequestModel>[].obs;
  final selectedRequest = Rxn<ScheduleRequestModel>();

  @override
  void onInit() {
    super.onInit();
    _loadMockData();
  }

  void _loadMockData() {
    requests.assignAll([
      ScheduleRequestModel(
        id: 'REQ-01',
        name: 'Juan Pérez Torres',
        initials: 'JP',
        career: 'Ingeniería de Sistemas',
        ciclo: 7,
        type: 'Cambio',
        targetHours: 30,
        changedDaysCount: 2,
        time: 'Hoy, 08:30 AM',
        reason: 'Clases universitarias por la mañana los lunes y miércoles hasta las 8:45 AM.',
        currentSchedule: {
          'Lunes': [
            const ScheduleBlock(type: BlockType.work, start: '08:00', end: '13:00'),
            const ScheduleBlock(type: BlockType.breakTime, start: '13:00', end: '14:00'),
            const ScheduleBlock(type: BlockType.work, start: '14:00', end: '17:00'),
          ],
          'Miércoles': [
            const ScheduleBlock(type: BlockType.work, start: '08:00', end: '13:00'),
            const ScheduleBlock(type: BlockType.breakTime, start: '13:00', end: '14:00'),
            const ScheduleBlock(type: BlockType.work, start: '14:00', end: '17:00'),
          ]
        },
        proposedSchedule: {
          'Lunes': [
            const ScheduleBlock(type: BlockType.work, start: '09:00', end: '13:00'),
            const ScheduleBlock(type: BlockType.breakTime, start: '13:00', end: '14:00'),
            const ScheduleBlock(type: BlockType.work, start: '14:00', end: '18:00'),
          ],
          'Miércoles': [
            const ScheduleBlock(type: BlockType.work, start: '09:00', end: '13:00'),
            const ScheduleBlock(type: BlockType.breakTime, start: '13:00', end: '14:00'),
            const ScheduleBlock(type: BlockType.work, start: '14:00', end: '18:00'),
          ]
        },
      ),
      ScheduleRequestModel(
        id: 'REQ-02',
        name: 'María García López',
        initials: 'MG',
        career: 'Ingeniería Industrial',
        ciclo: 8,
        type: 'Cambio',
        targetHours: 25,
        changedDaysCount: 1,
        time: 'Hoy, 09:55 AM',
        reason: 'Lunes tiene exámenes parciales todo mayo.',
        currentSchedule: {},
        proposedSchedule: {},
      ),
    ]);
  }

  void viewDetails(ScheduleRequestModel request) {
    selectedRequest.value = request;
    Get.toNamed(AppRoutes.adminScheduleValidationDetail);
  }

  void actionApprove(String id) {
    requests.removeWhere((r) => r.id == id);
    if (Get.currentRoute == AppRoutes.adminScheduleValidationDetail) Get.back();
    Get.snackbar('Aprobado', 'El nuevo horario del practicante ha sido autorizado.');
  }

  void actionReject(String id) {
    requests.removeWhere((r) => r.id == id);
    if (Get.currentRoute == AppRoutes.adminScheduleValidationDetail) Get.back();
    Get.snackbar('Rechazado', 'La solicitud de horario ha sido declinada.');
  }
}