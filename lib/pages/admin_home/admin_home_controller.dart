// lib/pages/admin_home/admin_home_controller.dart

import 'package:get/get.dart';

import '../../configs/routes.dart';
import '../../models/organization.dart';
import '../../models/user.dart';
import '../../services/attendance_record_service.dart';
import '../../services/attendance_request_service.dart';
import '../../services/organization_service.dart';
import '../../services/schedule_change_request_service.dart';
import '../../services/trainee_service.dart';
import 'admin_home_models.dart';

class AdminHomeController extends GetxController {
  final OrganizationService _organizationService = OrganizationService();
  final TraineeService _traineeService = TraineeService();
  final AttendanceRecordService _attendanceRecordService =
      AttendanceRecordService();
  final ScheduleChangeRequestService _scheduleChangeRequestService =
      ScheduleChangeRequestService();
  final AttendanceRequestService _attendanceRequestService =
      AttendanceRequestService();

  final RxBool isLoading = false.obs;
  final RxString message = ''.obs;
  final Rxn<Organization> organization = Rxn<Organization>();
  final RxList<AdminSummaryStat> stats = <AdminSummaryStat>[].obs;
  final RxList<AdminRequestSummary> requests = <AdminRequestSummary>[].obs;
  final RxList<User> activeMembers = <User>[].obs;

  String get currentDateLabel {
    final DateTime now = DateTime.now();
    const List<String> weekdays = [
      'lunes',
      'martes',
      'miércoles',
      'jueves',
      'viernes',
      'sábado',
      'domingo',
    ];
    const List<String> months = [
      'enero',
      'febrero',
      'marzo',
      'abril',
      'mayo',
      'junio',
      'julio',
      'agosto',
      'septiembre',
      'octubre',
      'noviembre',
      'diciembre',
    ];

    final String weekday = weekdays[now.weekday - 1];
    final String capitalizedWeekday =
        '${weekday[0].toUpperCase()}${weekday.substring(1)}';

    return '$capitalizedWeekday ${now.day} de ${months[now.month - 1]}';
  }

  @override
  void onInit() {
    super.onInit();
    loadAdminHome();
  }

  Future<void> loadAdminHome() async {
    isLoading.value = true;

    final organizationResponse = await _organizationService.fetchCurrent();
    final traineesResponse = await _traineeService.fetchAll();
    final attendanceRecordsResponse = await _attendanceRecordService.fetchAll();
    final scheduleChangeRequestsResponse = await _scheduleChangeRequestService
        .fetchAll();
    final attendanceRequestsResponse = await _attendanceRequestService
        .fetchAll();

    if (organizationResponse.success &&
        organizationResponse.data != null &&
        traineesResponse.success &&
        attendanceRecordsResponse.success &&
        scheduleChangeRequestsResponse.success &&
        attendanceRequestsResponse.success) {
      _assignHomeState(
        organization: organizationResponse.data!,
        trainees: traineesResponse.data ?? [],
        attendanceRecords: attendanceRecordsResponse.data ?? [],
        scheduleChangeRequests: scheduleChangeRequestsResponse.data ?? [],
        attendanceRequests: attendanceRequestsResponse.data ?? [],
      );
      message.value = '';
    } else {
      message.value = 'No se pudo cargar el resumen del administrador';
    }

    isLoading.value = false;
  }

  void _assignHomeState({
    required Organization organization,
    required List<User> trainees,
    required List<Map<String, dynamic>> attendanceRecords,
    required List<Map<String, dynamic>> scheduleChangeRequests,
    required List<Map<String, dynamic>> attendanceRequests,
  }) {
    final String summaryDate = _attendanceRecordService.latestDate(
      attendanceRecords,
    );
    final List<Map<String, dynamic>> todayAttendanceRecords = attendanceRecords
        .where((record) => record['date'] == summaryDate)
        .toList();

    this.organization.value = organization;
    stats.assignAll([
      AdminSummaryStat(
        label: 'Pendientes',
        value: _attendanceRecordService.countByStatus(
          todayAttendanceRecords,
          'pending',
        ),
        type: 'pending',
      ),
      AdminSummaryStat(
        label: 'Confirmados',
        value: _attendanceRecordService.countByStatus(
          todayAttendanceRecords,
          'confirmed',
        ),
        type: 'confirmed',
      ),
      AdminSummaryStat(
        label: 'Inasistencias',
        value: _attendanceRecordService.countByStatus(
          todayAttendanceRecords,
          'absence',
        ),
        type: 'absences',
      ),
    ]);
    requests.assignAll([
      AdminRequestSummary(
        title: 'Nuevos miembros',
        count: trainees
            .where((user) => user.status == UserStatus.pending)
            .length,
        type: 'members',
      ),
      AdminRequestSummary(
        title: 'Cambios de horario',
        count: _scheduleChangeRequestService.countByStatus(
          scheduleChangeRequests,
          'pending',
        ),
        type: 'schedule',
      ),
      AdminRequestSummary(
        title: 'Asistencias faltantes',
        count: _attendanceRequestService.countByStatus(
          attendanceRequests,
          'pending',
        ),
        type: 'attendance',
      ),
    ]);
    activeMembers.assignAll(
      trainees.where((user) => user.status == UserStatus.active),
    );
  }

  void goToPendingRequests() {}

  void openRequest(AdminRequestSummary request) {
    if (request.type == 'members') {
      Get.toNamed(AppRoutes.adminNewMembers);
    }
  }

  void openMember(User member) {
    Get.toNamed(AppRoutes.adminMemberDetail, arguments: member);
  }
}
