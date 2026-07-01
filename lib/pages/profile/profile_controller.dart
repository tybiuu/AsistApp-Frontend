// lib/pages/profile/profile_controller.dart

import 'package:asist_app/configs/theme.dart';
import 'package:asist_app/utils/date_utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../configs/routes.dart';
import '../../models/attendance_record.dart';
import '../../models/schedule.dart';
import '../../models/user.dart';
import '../../services/attendance_record_service.dart';
import '../../services/organization_service.dart';
import '../../services/schedule_service.dart';
import '../../services/session_service.dart';
import '../../services/user_service.dart';


class ProfileController extends GetxController {
  final OrganizationService _organizationService = Get.find();
  final ScheduleService _scheduleService = Get.find();
  final UserService _userService = Get.find();
  final AttendanceRecordService _attendanceRecordService = Get.find();

  // ── Current user — direct reference to SessionService ────────────────────
  Rx<User?> get user => SessionService.to.currentUser;

  // ── Convenience getters ───────────────────────────────────────────────────
  String get firstName => user.value?.firstName ?? '';
  String get lastName => user.value?.lastName ?? '';
  String get phone => user.value?.phoneNumber ?? '';
  String get career => user.value?.career ?? '';
  int get cycle => user.value?.cycle ?? 5;
  bool get isTrainee => user.value?.role == UserRole.trainee;

  final organizationName = ''.obs;

  // ── Edit state ────────────────────────────────────────────────────────────
  final editing = false.obs;
  final carreraOpen = false.obs;

  late final TextEditingController cFirstName;
  late final TextEditingController cLastName;
  late final TextEditingController cPhone;

  final dCarrera = ''.obs;
  final dCiclo = 5.obs;

  // ── Schedule UI state ─────────────────────────────────────────────────────
  final expandedDay = RxnInt();

  // ── Static data ───────────────────────────────────────────────────────────
  final schedule = <String, DaySchedule>{...Schedule.emptyDays()}.obs;
  final rawSchedule = Rxn<Schedule>();
  final carreras = kCarreras;

  bool get hasApprovedSchedule => rawSchedule.value?.status == 'approved';

  // ── Attendance stats ──────────────────────────────────────────────────────
  final attendancePercent = 0.obs;
  final completedHours = 0.obs;

  // ── Lifecycle ─────────────────────────────────────────────────────────────
  @override
  void onInit() {
    super.onInit();
    
    cFirstName = TextEditingController(text: firstName);
    cLastName = TextEditingController(text: lastName);
    cPhone = TextEditingController(text: phone);
    dCarrera.value = career;
    dCiclo.value = cycle;

    reloadSchedule();
    _loadOrganizationName();
    _loadAttendanceStats();
  }

  Future<void> _loadAttendanceStats() async {
    final response = await _attendanceRecordService.fetchAll();
    final List<AttendanceRecord> records = response.data ?? [];

    final int confirmedCount = _attendanceRecordService.countByStatus(records, 'confirmed');
    attendancePercent.value = records.isEmpty
        ? 0
        : ((confirmedCount / records.length) * 100).round();

    final int completedMinutes = records.fold<int>(0, (total, record) {
      final value = record.totalMinutes;
      return value != null ? total + value : total;
    });
    completedHours.value = completedMinutes ~/ 60;
  }

  Future<void> reloadSchedule() async {
    final response = await _scheduleService.fetchCurrent();
    rawSchedule.value = response.data;
    schedule.assignAll(response.data?.days ?? Schedule.emptyDays());
  }

  Future<void> _loadOrganizationName() async {
    final response = await _organizationService.fetchCurrent();
    if (response.success && response.data != null) {
      organizationName.value = response.data!.name;
    }
  }

  @override
  void onClose() {
    cFirstName.dispose();
    cLastName.dispose();
    cPhone.dispose();
    super.onClose();
  }

  // ── Computed ──────────────────────────────────────────────────────────────
  int get totalWeekMins =>
      schedule.values.fold(0, (sum, d) => sum + dayWorkMins(d));

  // ── Edit actions ──────────────────────────────────────────────────────────
  void startEdit() {
    cFirstName.text = firstName;
    cLastName.text = lastName;
    cPhone.text = phone;
    dCarrera.value = career;
    dCiclo.value = cycle;
    carreraOpen.value = false;
    editing.value = true;
  }

  void cancelEdit() {
    editing.value = false;
    carreraOpen.value = false;
  }

  /// Saves edited data into a new [User], persists it via [SessionService],
  /// and prints the updated fields.
  Future<void> saveEdit() async {
    final current = user.value;
    if (current == null) return;

    final Map<String, dynamic> updateData = {
      'firstName': cFirstName.text.trim(),
      'lastName': cLastName.text.trim(),
      'phoneNumber': cPhone.text.trim(),
      'career': dCarrera.value,
      'cycle': dCiclo.value,
    };

    final response = await _userService.updateUser(current.id, updateData);

    if (response.success && response.data != null) {
      await SessionService.to.updateUser(response.data!);
      editing.value = false;
      carreraOpen.value = false;
      Get.snackbar(
        'Éxito',
        response.message,
        backgroundColor: AppColors.success,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(16),
      );
    } else {
      Get.snackbar(
        'Error',
        response.message,
        backgroundColor: AppColors.error,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(16),
      );
    }
  }

  Future<void> logout() async {
    await SessionService.to.logout();
    Get.offAllNamed(AppRoutes.welcome);
  }

  void toggleCarreraDropdown() => carreraOpen.toggle();

  void selectCarrera(String value) {
    dCarrera.value = value;
    carreraOpen.value = false;
  }

  void decrementCiclo() {
    if (dCiclo.value > 5) dCiclo.value--;
  }

  void incrementCiclo() {
    if (dCiclo.value < 10) dCiclo.value++;
  }

  // ── Schedule actions ──────────────────────────────────────────────────────
  void toggleDay(int idx) {
    expandedDay.value = expandedDay.value == idx ? null : idx;
  }
}
