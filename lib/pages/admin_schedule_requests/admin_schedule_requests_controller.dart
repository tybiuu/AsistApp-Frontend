import 'package:get/get.dart';

import '../../configs/routes.dart';
import '../../models/schedule.dart';
import '../admin_home/admin_home_controller.dart';
import '../admin_home/admin_new_schedules/admin_new_schedules_controller.dart';
import '../admin_schedule_validation/admin_schedule_validation_controller.dart';

enum ScheduleRequestKind { newSchedule, change }

enum ScheduleRequestFilter { all, newOnly, changeOnly }

class UnifiedScheduleRequest {
  final String id;
  final ScheduleRequestKind kind;
  final String name;
  final String initials;
  final String career;
  final int ciclo;
  final int targetHours;
  final int daysCount;
  final String time;
  final String status;
  final String? reason;
  final Map<String, List<ScheduleBlock>> currentSchedule;
  final Map<String, List<ScheduleBlock>> proposedSchedule;

  final Schedule? rawSchedule;
  final ScheduleRequestModel? rawChangeRequest;

  const UnifiedScheduleRequest({
    required this.id,
    required this.kind,
    required this.name,
    required this.initials,
    required this.career,
    required this.ciclo,
    required this.targetHours,
    required this.daysCount,
    required this.time,
    required this.status,
    this.reason,
    required this.currentSchedule,
    required this.proposedSchedule,
    this.rawSchedule,
    this.rawChangeRequest,
  });
}

class AdminScheduleRequestsController extends GetxController {
  final AdminNewSchedulesController newSchedulesController =
      Get.put(AdminNewSchedulesController());
  final AdminScheduleValidationController changeRequestsController =
      Get.put(AdminScheduleValidationController());

  static const List<String> _dayOrder = [
    'Lunes', 'Martes', 'Miércoles', 'Jueves', 'Viernes', 'Sábado',
  ];

  final selectedFilter = ScheduleRequestFilter.all.obs;
  final selectedItem = Rxn<UnifiedScheduleRequest>();
  final isProcessing = false.obs;

  bool get isLoading =>
      newSchedulesController.isLoading.value ||
      changeRequestsController.isLoading.value;

  List<UnifiedScheduleRequest> get _allItems => [
        ...newSchedulesController.pendingRequests.map(_fromNewSchedule),
        ...changeRequestsController.requests.map(_fromChangeRequest),
      ];

  List<UnifiedScheduleRequest> get filteredItems {
    switch (selectedFilter.value) {
      case ScheduleRequestFilter.newOnly:
        return _allItems.where((i) => i.kind == ScheduleRequestKind.newSchedule).toList();
      case ScheduleRequestFilter.changeOnly:
        return _allItems.where((i) => i.kind == ScheduleRequestKind.change).toList();
      case ScheduleRequestFilter.all:
        return _allItems;
    }
  }

  int get newCount => newSchedulesController.pendingRequests.length;
  int get changeCount => changeRequestsController.requests.length;

  Future<void> reloadAll() async {
    await Future.wait([
      newSchedulesController.loadPendingSchedules(),
      changeRequestsController.reload(),
    ]);
  }

  void setFilter(ScheduleRequestFilter filter) => selectedFilter.value = filter;

  void viewDetails(UnifiedScheduleRequest item) {
    selectedItem.value = item;
    Get.toNamed(AppRoutes.adminScheduleRequestDetail);
  }

  Future<void> approve(UnifiedScheduleRequest item) async {
    if (isProcessing.value) return;
    isProcessing.value = true;
    try {
      if (item.kind == ScheduleRequestKind.newSchedule) {
        await newSchedulesController.approve(item.rawSchedule!);
      } else {
        await changeRequestsController.actionApprove(item.id);
      }
      _refreshHomeCount();
    } finally {
      isProcessing.value = false;
    }
  }

  Future<void> reject(UnifiedScheduleRequest item) async {
    if (isProcessing.value) return;
    isProcessing.value = true;
    try {
      if (item.kind == ScheduleRequestKind.newSchedule) {
        await newSchedulesController.reject(item.rawSchedule!);
      } else {
        await changeRequestsController.actionReject(item.id);
      }
      _refreshHomeCount();
    } finally {
      isProcessing.value = false;
    }
  }

  void _refreshHomeCount() {
    if (Get.isRegistered<AdminHomeController>()) {
      Get.find<AdminHomeController>().loadAdminHome();
    }
  }

  UnifiedScheduleRequest _fromNewSchedule(PendingScheduleRequest request) {
    final Schedule schedule = request.schedule;
    final Map<String, List<ScheduleBlock>> proposed = {
      for (final day in _dayOrder)
        if ((schedule.days[day]?.enabled ?? false) &&
            (schedule.days[day]?.blocks.isNotEmpty ?? false))
          day: schedule.days[day]!.blocks,
    };

    return UnifiedScheduleRequest(
      id: schedule.id,
      kind: ScheduleRequestKind.newSchedule,
      name: request.trainee?.fullName ?? 'Practicante sin nombre',
      initials: request.trainee?.initials ?? 'PS',
      career: request.trainee?.career ?? 'Sin carrera',
      ciclo: request.trainee?.cycle ?? 5,
      targetHours: schedule.weeklyHours,
      daysCount: proposed.length,
      time: _formatDateTime(schedule.createdAt),
      status: schedule.status,
      currentSchedule: const {},
      proposedSchedule: proposed,
      rawSchedule: schedule,
    );
  }

  UnifiedScheduleRequest _fromChangeRequest(ScheduleRequestModel request) {
    return UnifiedScheduleRequest(
      id: request.id,
      kind: ScheduleRequestKind.change,
      name: request.name,
      initials: request.initials,
      career: request.career,
      ciclo: request.ciclo,
      targetHours: request.targetHours,
      daysCount: request.changedDaysCount,
      time: request.time,
      status: request.status,
      reason: request.reason,
      currentSchedule: request.currentSchedule,
      proposedSchedule: request.proposedSchedule,
      rawChangeRequest: request,
    );
  }

  String _formatDateTime(DateTime dt) {
    return '${dt.day.toString().padLeft(2, '0')}/${dt.month.toString().padLeft(2, '0')} '
        '${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
  }
}
